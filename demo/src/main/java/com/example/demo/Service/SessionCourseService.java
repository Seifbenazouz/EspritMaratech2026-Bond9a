package com.example.demo.service;

import com.example.demo.dto.SessionCourseRequest;
import com.example.demo.entity.Evenement;
import com.example.demo.entity.SessionCourse;
import com.example.demo.entity.User;
import com.example.demo.exception.ResourceNotFoundException;
import com.example.demo.repository.EvenementRepository;
import com.example.demo.repository.SessionCourseRepository;
import com.example.demo.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.UUID;

@Service
@RequiredArgsConstructor
public class SessionCourseService {

    private final SessionCourseRepository sessionCourseRepository;
    private final UserRepository userRepository;
    private final EvenementRepository evenementRepository;

    public SessionCourse findById(Long id) {
        return sessionCourseRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("SessionCourse", id));
    }

    public Page<SessionCourse> findByAdherentId(UUID adherentId, Pageable pageable) {
        return sessionCourseRepository.findByAdherentIdOrderByStartedAtDesc(adherentId, pageable);
    }

    /** Sessions de l'adhérent connecté (par nom d'utilisateur). */
    public Page<SessionCourse> findMySessions(String username, Pageable pageable) {
        User user = userRepository.findByNom(username)
                .orElseThrow(() -> new ResourceNotFoundException("User", username));
        return sessionCourseRepository.findByAdherentIdOrderByStartedAtDesc(user.getId(), pageable);
    }

    public Page<SessionCourse> findByEvenementId(Long evenementId, Pageable pageable) {
        return sessionCourseRepository.findByEvenementIdOrderByStartedAtDesc(evenementId, pageable);
    }

    @Transactional
    public SessionCourse create(String username, SessionCourseRequest request) {
        User adherent = userRepository.findByNom(username)
                .orElseThrow(() -> new ResourceNotFoundException("User", username));

        Evenement evenement = null;
        if (request.getEvenementId() != null) {
            evenement = evenementRepository.findById(request.getEvenementId())
                    .orElse(null);
        }

        SessionCourse session = SessionCourse.builder()
                .adherent(adherent)
                .evenement(evenement)
                .distanceKm(request.getDistanceKm())
                .durationSeconds(request.getDurationSeconds())
                .startedAt(request.getStartedAt())
                .track(request.getTrack())
                .build();
        return sessionCourseRepository.save(session);
    }

    @Transactional
    public void deleteById(Long id) {
        if (!sessionCourseRepository.existsById(id)) {
            throw new ResourceNotFoundException("SessionCourse", id);
        }
        sessionCourseRepository.deleteById(id);
    }
}
