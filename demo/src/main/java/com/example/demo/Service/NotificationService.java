package com.example.demo.service;

import com.example.demo.dto.NotificationRequest;
import com.example.demo.entity.Notification;
import com.example.demo.entity.User;
import com.example.demo.exception.ResourceNotFoundException;
import com.example.demo.repository.NotificationRepository;
import com.example.demo.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.Instant;
import java.util.UUID;

@Service
@RequiredArgsConstructor
public class NotificationService {

    private final NotificationRepository notificationRepository;
    private final UserRepository userRepository;

    public Page<Notification> findAll(Pageable pageable) {
        return notificationRepository.findAll(pageable);
    }

    public Notification findById(Long id) {
        return notificationRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Notification", id));
    }

    public Page<Notification> findByUtilisateurId(UUID utilisateurId, Pageable pageable) {
        return notificationRepository.findByUtilisateurIdOrderByDateEnvoiDesc(utilisateurId, pageable);
    }

    public Page<Notification> findByUtilisateurIdAndType(UUID utilisateurId, String type, Pageable pageable) {
        return notificationRepository.findByUtilisateurIdAndTypeOrderByDateEnvoiDesc(utilisateurId, type, pageable);
    }

    @Transactional
    public Notification create(NotificationRequest request) {
        User utilisateur = userRepository.findById(request.getUtilisateurId())
                .orElseThrow(() -> new ResourceNotFoundException("Utilisateur", request.getUtilisateurId()));
        Notification notification = Notification.builder()
                .message(request.getMessage())
                .dateEnvoi(request.getDateEnvoi() != null ? request.getDateEnvoi() : Instant.now())
                .type(request.getType())
                .utilisateur(utilisateur)
                .build();
        return notificationRepository.save(notification);
    }

    @Transactional
    public Notification update(Long id, NotificationRequest request) {
        Notification notification = findById(id);
        notification.setMessage(request.getMessage());
        if (request.getDateEnvoi() != null) {
            notification.setDateEnvoi(request.getDateEnvoi());
        }
        notification.setType(request.getType());
        if (request.getUtilisateurId() != null && !notification.getUtilisateur().getId().equals(request.getUtilisateurId())) {
            User utilisateur = userRepository.findById(request.getUtilisateurId())
                    .orElseThrow(() -> new ResourceNotFoundException("Utilisateur", request.getUtilisateurId()));
            notification.setUtilisateur(utilisateur);
        }
        return notificationRepository.save(notification);
    }

    @Transactional
    public void deleteById(Long id) {
        if (!notificationRepository.existsById(id)) {
            throw new ResourceNotFoundException("Notification", id);
        }
        notificationRepository.deleteById(id);
    }
}
