package com.example.demo.controller;

import com.example.demo.dto.FcmTokenRequest;
import com.example.demo.dto.LoginRequest;
import com.example.demo.dto.LoginResponse;
import com.example.demo.dto.RegisterRequest;
import com.example.demo.service.AuthService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/auth")
@RequiredArgsConstructor
@Slf4j
public class AuthController {

    private final AuthService authService;

    /**
     * Connexion : nom + mot de passe (3 derniers chiffres du numéro CIN).
     * Exemple body : { "nom": "Dupont", "password": "123" }
     */
    @PostMapping("/login")
    public ResponseEntity<LoginResponse> login(@Valid @RequestBody LoginRequest request) {
        return ResponseEntity.ok(authService.login(request));
    }

    /**
     * Inscription d'un nouvel utilisateur.
     * Le mot de passe initial est automatiquement les 3 derniers chiffres du CIN.
     */
    @PostMapping("/register")
    public ResponseEntity<LoginResponse> register(@Valid @RequestBody RegisterRequest request) {
        return ResponseEntity.ok(authService.register(request));
    }

    /**
     * Enregistre le token FCM pour les notifications push (utilisateur connecté).
     */
    @PostMapping("/fcm-token")
    public ResponseEntity<Void> registerFcmToken(
            @AuthenticationPrincipal UserDetails user,
            @Valid @RequestBody FcmTokenRequest request) {
        log.info("FCM: requête reçue pour utilisateur \"{}\" (enregistrement du token)", user.getUsername());
        authService.registerFcmToken(user.getUsername(), request.getToken());
        return ResponseEntity.ok().build();
    }
}
