package com.example.demo.repository;

import com.example.demo.entity.Notification;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.UUID;

public interface NotificationRepository extends JpaRepository<Notification, Long> {

    Page<Notification> findByUtilisateurIdOrderByDateEnvoiDesc(UUID utilisateurId, Pageable pageable);

    Page<Notification> findByUtilisateurIdAndTypeOrderByDateEnvoiDesc(UUID utilisateurId, String type, Pageable pageable);
}
