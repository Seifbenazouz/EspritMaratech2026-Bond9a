package com.example.demo.controller;

import com.example.demo.dto.NotificationRequest;
import com.example.demo.entity.Notification;
import com.example.demo.service.NotificationService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.UUID;

@RestController
@RequestMapping("/api/notifications")
@RequiredArgsConstructor
public class NotificationController {

    private final NotificationService notificationService;

    @GetMapping
    public ResponseEntity<Page<Notification>> findAll(Pageable pageable) {
        return ResponseEntity.ok(notificationService.findAll(pageable));
    }

    @GetMapping("/{id}")
    public ResponseEntity<Notification> findById(@PathVariable Long id) {
        return ResponseEntity.ok(notificationService.findById(id));
    }

    @GetMapping("/utilisateur/{utilisateurId}")
    public ResponseEntity<Page<Notification>> findByUtilisateurId(@PathVariable UUID utilisateurId, Pageable pageable) {
        return ResponseEntity.ok(notificationService.findByUtilisateurId(utilisateurId, pageable));
    }

    @GetMapping("/utilisateur/{utilisateurId}/type/{type}")
    public ResponseEntity<Page<Notification>> findByUtilisateurIdAndType(
            @PathVariable UUID utilisateurId,
            @PathVariable String type,
            Pageable pageable) {
        return ResponseEntity.ok(notificationService.findByUtilisateurIdAndType(utilisateurId, type, pageable));
    }

    @PostMapping
    public ResponseEntity<Notification> create(@Valid @RequestBody NotificationRequest request) {
        return ResponseEntity.ok(notificationService.create(request));
    }

    @PutMapping("/{id}")
    public ResponseEntity<Notification> update(@PathVariable Long id, @Valid @RequestBody NotificationRequest request) {
        return ResponseEntity.ok(notificationService.update(id, request));
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteById(@PathVariable Long id) {
        notificationService.deleteById(id);
        return ResponseEntity.noContent().build();
    }
}
