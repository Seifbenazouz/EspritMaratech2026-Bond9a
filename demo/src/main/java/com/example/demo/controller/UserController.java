package com.example.demo.controller;

import com.example.demo.dto.UserCreateRequest;
import com.example.demo.dto.UserUpdateRequest;
import com.example.demo.entity.Role;
import com.example.demo.entity.User;
import com.example.demo.service.UserService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.UUID;

@RestController
@RequestMapping("/api/users")
@RequiredArgsConstructor
public class UserController {

    private final UserService userService;

    @GetMapping
    public ResponseEntity<Page<User>> findAll(Pageable pageable) {
        return ResponseEntity.ok(userService.findAll(pageable));
    }

    @GetMapping("/{id}")
    public ResponseEntity<User> findById(@PathVariable UUID id) {
        return ResponseEntity.ok(userService.findById(id));
    }

    @GetMapping("/email/{email}")
    public ResponseEntity<User> findByEmail(@PathVariable String email) {
        return ResponseEntity.ok(userService.findByEmail(email));
    }

    @PreAuthorize("hasRole('ADMIN_PRINCIPAL')")
    @PostMapping
    public ResponseEntity<User> create(@Valid @RequestBody UserCreateRequest request) {
        return ResponseEntity.ok(userService.create(request));
    }

    @PutMapping("/{id}")
    public ResponseEntity<User> update(@PathVariable UUID id, @Valid @RequestBody UserUpdateRequest request) {
        return ResponseEntity.ok(userService.update(id, request));
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteById(@PathVariable UUID id) {
        userService.deleteById(id);
        return ResponseEntity.noContent().build();
    }

    @GetMapping("/role/{role}")
    public ResponseEntity<Page<User>> findByRole(@PathVariable Role role, Pageable pageable) {
        return ResponseEntity.ok(userService.findByRole(role, pageable));
    }

    @GetMapping("/adherents")
    public ResponseEntity<List<User>> findAdherents() {
        return ResponseEntity.ok(userService.findAdherentsByRole(Role.ADHERENT));
    }

    /**
     * Vérifie si un utilisateur a un token FCM enregistré (pour diagnostiquer les notifications).
     * Rôle : ADMIN_PRINCIPAL ou ADMIN_GROUPE.
     */
    @PreAuthorize("hasAnyRole('ADMIN_PRINCIPAL', 'ADMIN_GROUPE')")
    @GetMapping("/{id}/fcm-token-registered")
    public ResponseEntity<java.util.Map<String, Boolean>> isFcmTokenRegistered(@PathVariable UUID id) {
        boolean registered = userService.isFcmTokenRegistered(id);
        return ResponseEntity.ok(java.util.Map.of("registered", registered));
    }

    /**
     * Envoie une notification push de test à l'utilisateur (admin uniquement).
     * Pour vérifier que la chaîne FCM fonctionne à 100%.
     */
    @PreAuthorize("hasAnyRole('ADMIN_PRINCIPAL', 'ADMIN_GROUPE')")
    @PostMapping("/{id}/send-test-notification")
    public ResponseEntity<java.util.Map<String, String>> sendTestNotification(@PathVariable UUID id) {
        userService.sendTestPushNotification(id);
        return ResponseEntity.ok(java.util.Map.of("message", "Notification de test envoyée."));
    }
}
