package com.example.demo.service;

import com.example.demo.entity.Evenement;
import com.example.demo.entity.GroupeRunning;
import com.example.demo.entity.User;
import com.example.demo.repository.EvenementRepository;
import com.example.demo.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.data.domain.PageRequest;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.*;
import java.time.format.DateTimeFormatter;
import java.util.*;
import java.util.stream.Collectors;

/**
 * Envoie les rappels et récaps push automatiques :
 * - Rappel 1h avant : événements dans la prochaine heure.
 * - Rappel 24h avant : événements du lendemain (exécuté à 20h).
 * - Récap quotidien : événements du jour (exécuté à 7h).
 * - Récap hebdomadaire : événements de la semaine (exécuté le lundi à 8h).
 */
@Service
@RequiredArgsConstructor
@Slf4j
public class EvenementRappelService {

    private final EvenementRepository evenementRepository;
    private final UserRepository userRepository;
    private final FcmService fcmService;

    @Value("${app.rappels.activer:true}")
    private boolean rappelsActiver;

    @Value("${app.rappels.recap-quotidien:true}")
    private boolean recapQuotidienActiver;

    @Value("${app.rappels.recap-hebdomadaire:true}")
    private boolean recapHebdomadaireActiver;

    private static final ZoneId ZONE = ZoneId.systemDefault();

    private static final DateTimeFormatter HEURE_FORMAT = DateTimeFormatter.ofPattern("HH'h'mm")
            .withZone(ZoneId.systemDefault());

    @Scheduled(cron = "${app.rappels.cron-1h:0 15 * * * *}")
    @Transactional
    public void envoyerRappels1h() {
        if (!rappelsActiver || !fcmService.isInitialized()) return;

        Instant now = Instant.now();
        Instant in1h = now.plusSeconds(3600);
        List<Evenement> events = evenementRepository.findByDateBetweenAndRappel1hEnvoyeFalseOrderByDateAsc(now, in1h);
        for (Evenement e : events) {
            envoyerRappel(e, "Dans moins d'1h", "Rappel : " + e.getTitre() + " à " + formatHeure(e.getDate()));
            e.setRappel1hEnvoye(true);
        }
        if (!events.isEmpty()) evenementRepository.saveAll(events);
        if (!events.isEmpty()) {
            log.info("Rappels 1h: {} événement(s) notifié(s)", events.size());
        }
    }

    @Scheduled(cron = "${app.rappels.cron-24h:0 0 20 * * *}")
    @Transactional
    public void envoyerRappels24h() {
        if (!rappelsActiver || !fcmService.isInitialized()) return;

        Instant now = Instant.now();
        Instant in24hMin = now.plusSeconds(23 * 3600);   // 23h
        Instant in24hMax = now.plusSeconds(25 * 3600);  // 25h
        List<Evenement> events = evenementRepository.findByDateBetweenAndRappel24hEnvoyeFalseOrderByDateAsc(in24hMin, in24hMax);
        for (Evenement e : events) {
            envoyerRappel(e, "Demain", "Rappel : " + e.getTitre() + " à " + formatHeure(e.getDate()));
            e.setRappel24hEnvoye(true);
        }
        if (!events.isEmpty()) evenementRepository.saveAll(events);
        if (!events.isEmpty()) {
            log.info("Rappels 24h: {} événement(s) notifié(s)", events.size());
        }
    }

    @Scheduled(cron = "${app.rappels.cron-recap-quotidien:0 0 7 * * *}")
    @Transactional(readOnly = true)
    public void envoyerRecapQuotidien() {
        if (!recapQuotidienActiver || !fcmService.isInitialized()) return;

        ZonedDateTime now = ZonedDateTime.now(ZONE);
        Instant debut = now.toLocalDate().atStartOfDay(ZONE).toInstant();
        Instant fin = now.toLocalDate().plusDays(1).atStartOfDay(ZONE).toInstant();
        envoyerRecap(debut, fin, "Vos événements aujourd'hui", "événement(s) aujourd'hui");
    }

    @Scheduled(cron = "${app.rappels.cron-recap-hebdomadaire:0 0 8 ? * MON}")
    @Transactional(readOnly = true)
    public void envoyerRecapHebdomadaire() {
        if (!recapHebdomadaireActiver || !fcmService.isInitialized()) return;

        ZonedDateTime now = ZonedDateTime.now(ZONE);
        LocalDate monday = now.toLocalDate().with(DayOfWeek.MONDAY);
        LocalDate nextMonday = monday.plusWeeks(1);
        Instant debut = monday.atStartOfDay(ZONE).toInstant();
        Instant fin = nextMonday.atStartOfDay(ZONE).toInstant();
        envoyerRecap(debut, fin, "Événements de la semaine", "événement(s) cette semaine");
    }

    private void envoyerRecap(Instant debut, Instant fin, String titrePrefix, String bodySuffix) {
        var page = evenementRepository.findByDateBetweenOrderByDateDesc(debut, fin, PageRequest.of(0, 200));
        List<Evenement> events = page.getContent();
        if (events.isEmpty()) return;

        Map<UUID, List<Evenement>> userToEvents = new HashMap<>();
        for (Evenement e : events) {
            GroupeRunning groupe = e.getGroupe();
            for (User m : groupe.getMembres()) {
                userToEvents.computeIfAbsent(m.getId(), k -> new ArrayList<>()).add(e);
            }
            if (groupe.getResponsable() != null) {
                userToEvents.computeIfAbsent(groupe.getResponsable().getId(), k -> new ArrayList<>()).add(e);
            }
        }

        int sent = 0;
        for (Map.Entry<UUID, List<Evenement>> entry : userToEvents.entrySet()) {
            User user = userRepository.findById(entry.getKey()).orElse(null);
            if (user == null || user.getFcmToken() == null || user.getFcmToken().isBlank()) continue;

            List<Evenement> userEvents = entry.getValue();
            String titres = userEvents.stream()
                    .map(Evenement::getTitre)
                    .distinct()
                    .limit(5)
                    .collect(Collectors.joining(", "));
            if (userEvents.size() > 5) titres += "...";

            String titre = titrePrefix;
            String body = userEvents.size() + " " + bodySuffix + " : " + titres;
            fcmService.sendToTokens(List.of(user.getFcmToken()), titre, body);
            sent++;
        }
        log.info("Récap: {} utilisateur(s) notifié(s) pour {} événement(s)", sent, events.size());
    }

    private void envoyerRappel(Evenement e, String titlePrefix, String body) {
        GroupeRunning groupe = e.getGroupe();
        List<String> tokens = new ArrayList<>();
        for (User m : groupe.getMembres()) {
            userRepository.findById(m.getId()).ifPresent(u -> {
                String t = u.getFcmToken();
                if (t != null && !t.isBlank() && !tokens.contains(t)) tokens.add(t);
            });
        }
        if (groupe.getResponsable() != null) {
            userRepository.findById(groupe.getResponsable().getId()).ifPresent(u -> {
                String t = u.getFcmToken();
                if (t != null && !t.isBlank() && !tokens.contains(t)) tokens.add(t);
            });
        }
        if (!tokens.isEmpty()) {
            fcmService.sendToTokens(tokens, titlePrefix + " – " + e.getTitre(), body);
        }
    }

    private static String formatHeure(Instant instant) {
        return instant == null ? "" : HEURE_FORMAT.withZone(ZONE).format(instant);
    }

    // --- Méthodes exposées pour les tests manuels ---
    public void declencherRappels1h() { envoyerRappels1h(); }
    public void declencherRappels24h() { envoyerRappels24h(); }
}
