package com.example.demo.service;

import com.example.demo.dto.PartnerMatchDto;
import com.example.demo.entity.*;
import com.example.demo.exception.ResourceNotFoundException;
import com.example.demo.repository.*;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.PageRequest;
import org.springframework.stereotype.Service;

import java.time.DayOfWeek;
import java.time.Instant;
import java.time.ZoneId;
import java.util.*;
import java.util.stream.Collectors;

/**
 * Service de matching IA : trouve les meilleurs partenaires de running pour un adhérent.
 * Score = similarité pace + même groupe + disponibilités communes.
 */
@Service
@RequiredArgsConstructor
@Slf4j
public class MatchingService {

    private final GroupeRunningRepository groupeRunningRepository;
    private final SessionCourseRepository sessionCourseRepository;
    private final ParticipationRepository participationRepository;
    private final UserRepository userRepository;

    private static final int MIN_SCORE_MATCH = 25;
    private static final int MAX_RESULTS = 15;

    /**
     * Retourne les meilleurs partenaires de running pour l'adhérent donné.
     */
    public List<PartnerMatchDto> findPartners(UUID adherentId) {
        User adherent = userRepository.findById(adherentId)
                .orElseThrow(() -> new ResourceNotFoundException("Utilisateur", adherentId));

        if (adherent.getRole() != Role.ADHERENT) {
            return List.of();
        }

        // Groupes de l'adhérent (avec membres chargés)
        List<GroupeRunning> mesGroupes = groupeRunningRepository.findByMembreIdWithMembres(adherentId);

        if (mesGroupes.isEmpty()) {
            return List.of();
        }

        // Pace moyen de l'adhérent (dernières 20 sessions)
        Double monPace = computeAveragePace(adherentId);

        // Jours où l'adhérent participe habituellement (depuis participations)
        Set<DayOfWeek> mesJours = computePreferredDays(adherentId);

        // Candidats : autres adhérents des mêmes groupes
        Set<UUID> candidatIds = new HashSet<>();
        for (GroupeRunning g : mesGroupes) {
            for (User m : g.getMembres()) {
                if (!m.getId().equals(adherentId) && m.getRole() == Role.ADHERENT) {
                    candidatIds.add(m.getId());
                }
            }
        }

        List<PartnerMatchDto> matches = new ArrayList<>();
        for (UUID candidateId : candidatIds) {
            User candidate = userRepository.findById(candidateId).orElse(null);
            if (candidate == null) continue;

            PartnerMatchDto dto = computeMatch(adherent, candidate, mesGroupes, monPace, mesJours);
            if (dto != null && dto.getScore() >= MIN_SCORE_MATCH) {
                matches.add(dto);
            }
        }

        if (matches.isEmpty() && !candidatIds.isEmpty()) {
            log.info("Matching: {} candidats mais aucun n'atteint le score {}. Affichage de tous.", candidatIds.size(), MIN_SCORE_MATCH);
            for (UUID candidateId : candidatIds) {
                User candidate = userRepository.findById(candidateId).orElse(null);
                if (candidate == null) continue;
                PartnerMatchDto dto = computeMatch(adherent, candidate, mesGroupes, monPace, mesJours);
                if (dto != null) matches.add(dto);
            }
        }

        matches.sort((a, b) -> Integer.compare(b.getScore(), a.getScore()));
        return matches.stream().limit(MAX_RESULTS).collect(Collectors.toList());
    }

    private Double computeAveragePace(UUID adherentId) {
        List<SessionCourse> sessions = sessionCourseRepository
                .findByAdherentIdOrderByStartedAtDesc(adherentId, PageRequest.of(0, 20))
                .getContent();

        if (sessions.isEmpty()) return null;

        double totalMinPerKm = 0;
        int count = 0;
        for (SessionCourse s : sessions) {
            if (s.getDistanceKm() != null && s.getDistanceKm() > 0.1
                    && s.getDurationSeconds() != null && s.getDurationSeconds() > 0) {
                double pace = (s.getDurationSeconds() / 60.0) / s.getDistanceKm();
                if (pace > 2 && pace < 15) { // plage réaliste 2-15 min/km
                    totalMinPerKm += pace;
                    count++;
                }
            }
        }
        return count > 0 ? totalMinPerKm / count : null;
    }

    private Set<DayOfWeek> computePreferredDays(UUID adherentId) {
        List<Participation> participations = participationRepository
                .findByAdherentIdOrderByDateInscriptionDesc(adherentId, PageRequest.of(0, 50))
                .getContent();

        Map<DayOfWeek, Long> countByDay = new EnumMap<>(DayOfWeek.class);
        for (Participation p : participations) {
            if (p.getEvenement() != null && p.getEvenement().getDate() != null) {
                DayOfWeek day = p.getEvenement().getDate().atZone(ZoneId.systemDefault()).getDayOfWeek();
                countByDay.merge(day, 1L, Long::sum);
            }
        }
        // Jours avec au moins 2 participations
        return countByDay.entrySet().stream()
                .filter(e -> e.getValue() >= 2)
                .map(Map.Entry::getKey)
                .collect(Collectors.toSet());
    }

    private PartnerMatchDto computeMatch(User adherent, User candidate, List<GroupeRunning> mesGroupes,
                                         Double monPace, Set<DayOfWeek> mesJours) {
        StringBuilder detail = new StringBuilder();
        int score = 0;

        // Même groupe : +30 pts
        Optional<GroupeRunning> groupeCommun = mesGroupes.stream()
                .filter(g -> g.getMembres().stream().anyMatch(m -> m.getId().equals(candidate.getId())))
                .findFirst();

        String groupeNom = null;
        String groupeNiveau = null;
        if (groupeCommun.isPresent()) {
            score += 30;
            groupeNom = groupeCommun.get().getNom();
            groupeNiveau = groupeCommun.get().getNiveau();
            detail.append("Même groupe (").append(groupeNom).append("). ");
        }

        // Similarité pace : max 40 pts
        Double candidatePace = computeAveragePace(candidate.getId());
        if (monPace != null && candidatePace != null) {
            double diff = Math.abs(monPace - candidatePace);
            if (diff < 0.25) score += 40;
            else if (diff < 0.5) score += 30;
            else if (diff < 1.0) score += 20;
            else if (diff < 2.0) score += 10;
            detail.append(String.format("Pace similaire (vous %.1f, lui %.1f min/km). ", monPace, candidatePace));
        } else if (candidatePace != null) {
            detail.append(String.format("Pace moyen %.1f min/km. ", candidatePace));
        }

        // Disponibilités communes : +20 pts
        Set<DayOfWeek> candidateJours = computePreferredDays(candidate.getId());
        long commonDays = mesJours.stream().filter(candidateJours::contains).count();
        if (commonDays > 0) {
            score += 20;
            detail.append("Disponibilités compatibles. ");
        }

        String displayName = (candidate.getPrenom() != null ? candidate.getPrenom() + " " : "") + candidate.getNom();

        return PartnerMatchDto.builder()
                .id(candidate.getId())
                .nom(candidate.getNom())
                .prenom(candidate.getPrenom())
                .email(candidate.getEmail())
                .paceMoyenMinPerKm(candidatePace)
                .groupeNom(groupeNom)
                .groupeNiveau(groupeNiveau)
                .score(score)
                .scoreDetail(detail.length() > 0 ? detail.toString().trim() : "Même club")
                .build();
    }
}
