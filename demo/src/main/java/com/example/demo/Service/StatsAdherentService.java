package com.example.demo.service;

import com.example.demo.dto.StatsAdherentDto;
import com.example.demo.entity.Role;
import com.example.demo.entity.SessionCourse;
import com.example.demo.entity.User;
import com.example.demo.exception.ResourceNotFoundException;
import com.example.demo.repository.ParticipationRepository;
import com.example.demo.repository.SessionCourseRepository;
import com.example.demo.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.security.access.AccessDeniedException;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.UUID;

/**
 * Statistiques de course des adhérents (distance, pace, nombre de sorties, etc.).
 * Réservé au rôle ADHERENT.
 */
@Service
@RequiredArgsConstructor
public class StatsAdherentService {

    private final SessionCourseRepository sessionCourseRepository;
    private final ParticipationRepository participationRepository;
    private final UserRepository userRepository;

    /**
     * Récupère les statistiques de l'adhérent connecté.
     * Seuls les utilisateurs avec le rôle ADHERENT peuvent accéder à leurs stats.
     */
    public StatsAdherentDto getStatsForMe(UUID adherentId) {
        User user = userRepository.findById(adherentId)
                .orElseThrow(() -> new ResourceNotFoundException("User", adherentId));

        if (user.getRole() != Role.ADHERENT) {
            throw new AccessDeniedException("Les statistiques sont réservées aux adhérents.");
        }

        return computeStats(adherentId);
    }

    private StatsAdherentDto computeStats(UUID adherentId) {
        List<SessionCourse> sessions = sessionCourseRepository.findAllByAdherent_IdOrderByStartedAtDesc(adherentId);
        long nbEvenements = participationRepository.countByAdherent_Id(adherentId);

        double totalDistanceKm = 0;
        long totalDurationSeconds = 0;
        double plusLongueSortieKm = 0;
        Double meilleurPaceMinPerKm = null;

        for (SessionCourse s : sessions) {
            double d = s.getDistanceKm() != null ? s.getDistanceKm() : 0;
            long dur = s.getDurationSeconds() != null ? s.getDurationSeconds() : 0;

            totalDistanceKm += d;
            totalDurationSeconds += dur;

            if (d > plusLongueSortieKm) {
                plusLongueSortieKm = d;
            }

            if (d > 0 && dur > 0) {
                double pace = (dur / 60.0) / d;
                if (meilleurPaceMinPerKm == null || pace < meilleurPaceMinPerKm) {
                    meilleurPaceMinPerKm = pace;
                }
            }
        }

        Double paceMoyenMinPerKm = null;
        if (totalDistanceKm > 0 && totalDurationSeconds > 0) {
            paceMoyenMinPerKm = (totalDurationSeconds / 60.0) / totalDistanceKm;
        }

        return StatsAdherentDto.builder()
                .totalDistanceKm(totalDistanceKm)
                .nbSorties(sessions.size())
                .paceMoyenMinPerKm(paceMoyenMinPerKm)
                .nbEvenements((int) nbEvenements)
                .plusLongueSortieKm(plusLongueSortieKm > 0 ? plusLongueSortieKm : null)
                .meilleurPaceMinPerKm(meilleurPaceMinPerKm)
                .build();
    }
}
