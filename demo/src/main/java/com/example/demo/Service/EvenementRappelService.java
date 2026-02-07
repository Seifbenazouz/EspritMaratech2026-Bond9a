package com.example.demo.service;

import com.example.demo.entity.Evenement;
import com.example.demo.entity.GroupeRunning;
import com.example.demo.entity.User;
import com.example.demo.repository.EvenementRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.Instant;
import java.time.ZoneId;
import java.time.format.DateTimeFormatter;
import java.util.List;
import java.util.stream.Collectors;

/**
 * Envoie les rappels push automatiques avant les événements :
 * - Rappel 1h avant : exécuté toutes les heures pour les événements dans la prochaine heure.
 * - Rappel 24h avant : exécuté une fois par jour (20h) pour les événements du lendemain.
 */
@Service
@RequiredArgsConstructor
@Slf4j
public class EvenementRappelService {

    private final EvenementRepository evenementRepository;
    private final FcmService fcmService;

    @Value("${app.rappels.activer:true}")
    private boolean rappelsActiver;

    private static final DateTimeFormatter HEURE_FORMAT = DateTimeFormatter.ofPattern("HH'h'mm")
            .withZone(ZoneId.systemDefault());

    /** Toutes les heures à :15 (rappels 1h avant). */
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

    /** Tous les jours à 20h (rappels 24h avant). */
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

    private void envoyerRappel(Evenement e, String titlePrefix, String body) {
        GroupeRunning groupe = e.getGroupe();
        List<String> tokens = groupe.getMembres().stream()
                .map(User::getFcmToken)
                .filter(t -> t != null && !t.isBlank())
                .collect(Collectors.toList());
        if (groupe.getResponsable() != null && groupe.getResponsable().getFcmToken() != null
                && !groupe.getResponsable().getFcmToken().isBlank()
                && !tokens.contains(groupe.getResponsable().getFcmToken())) {
            tokens.add(groupe.getResponsable().getFcmToken());
        }
        if (!tokens.isEmpty()) {
            fcmService.sendToTokens(tokens, titlePrefix + " – " + e.getTitre(), body);
        }
    }

    private static String formatHeure(Instant instant) {
        return instant == null ? "" : HEURE_FORMAT.format(instant);
    }
}
