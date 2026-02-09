package com.example.demo.controller;

import com.example.demo.service.AuthService;
import lombok.RequiredArgsConstructor;
import org.springframework.context.annotation.Profile;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.Map;

/**
 * Endpoints de secours pour le développement (profil "dev" uniquement).
 * Ex: réinitialiser le mot de passe de l'admin sans passer par le flux normal.
 */
@RestController
@RequestMapping("/api/auth")
@RequiredArgsConstructor
@Profile("dev")
public class DevAuthController {

    private final AuthService authService;

    /**
     * Réinitialise le mot de passe d'un utilisateur.
     * Body: { "nom": "zorai", "newPassword": "001" }
     * Lancer le backend avec: --spring.profiles.active=dev
     */
    @PostMapping("/dev-reset-password")
    public ResponseEntity<Void> devResetPassword(@RequestBody Map<String, String> body) {
        String nom = body.get("nom");
        String newPassword = body.get("newPassword");
        if (nom == null || newPassword == null || nom.isBlank() || newPassword.isBlank()) {
            return ResponseEntity.badRequest().build();
        }
        authService.devResetPassword(nom.trim(), newPassword);
        return ResponseEntity.ok().build();
    }
}
