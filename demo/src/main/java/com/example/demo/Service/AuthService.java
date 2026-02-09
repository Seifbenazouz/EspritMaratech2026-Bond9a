package com.example.demo.service;

import com.example.demo.dto.ChangePasswordRequest;
import com.example.demo.dto.LoginRequest;
import com.example.demo.dto.LoginResponse;
import com.example.demo.dto.RegisterRequest;
import com.example.demo.entity.Role;
import com.example.demo.entity.User;
import com.example.demo.exception.ResourceNotFoundException;
import com.example.demo.repository.UserRepository;
import com.example.demo.security.JwtUtil;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.security.authentication.BadCredentialsException;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@RequiredArgsConstructor
@Slf4j
public class AuthService {

    private final UserRepository userRepository;
    private final PasswordEncoder passwordEncoder;
    private final JwtUtil jwtUtil;

    /**
     * Connexion : nom + mot de passe (3 derniers chiffres du CIN).
     */
    public LoginResponse login(LoginRequest request) {
        User user = userRepository.findByNom(request.getNom())
                .orElseThrow(() -> new BadCredentialsException("Nom ou mot de passe incorrect"));

        if (!passwordEncoder.matches(request.getPassword(), user.getPassword())) {
            throw new BadCredentialsException("Nom ou mot de passe incorrect");
        }

        String token = jwtUtil.generateToken(
                user.getNom(),
                user.getId(),
                user.getRole().name()
        );

        return LoginResponse.builder()
                .token(token)
                .type("Bearer")
                .id(user.getId())
                .nom(user.getNom())
                .prenom(user.getPrenom())
                .email(user.getEmail())
                .role(user.getRole())
                .passwordChangeRequired(Boolean.TRUE.equals(user.getPasswordChangeRequired()))
                .build();
    }

    /**
     * Inscription / création d'un utilisateur.
     * Le mot de passe est automatiquement dérivé des 3 derniers chiffres du CIN.
     */
    @Transactional
    public LoginResponse register(RegisterRequest request) {
        if (userRepository.existsByEmail(request.getEmail())) {
            throw new IllegalArgumentException("Un compte existe déjà avec cet email");
        }
        if (userRepository.existsByCin(request.getCin())) {
            throw new IllegalArgumentException("Un compte existe déjà avec ce numéro CIN");
        }
        if (request.getCin() < 100) {
            throw new IllegalArgumentException("Le CIN doit contenir au moins 3 chiffres");
        }

        String lastThree = String.format("%03d", Math.abs(request.getCin()) % 1000);
        String encodedPassword = passwordEncoder.encode(lastThree);

        User user = User.builder()
                .nom(request.getNom())
                .prenom(request.getPrenom())
                .email(request.getEmail())
                .phone(request.getPhone())
                .cin(request.getCin())
                .password(encodedPassword)
                .role(request.getRole())
                .build();

        user = userRepository.save(user);

        String token = jwtUtil.generateToken(user.getNom(), user.getId(), user.getRole().name());

        return LoginResponse.builder()
                .token(token)
                .type("Bearer")
                .id(user.getId())
                .nom(user.getNom())
                .prenom(user.getPrenom())
                .email(user.getEmail())
                .role(user.getRole())
                .passwordChangeRequired(Boolean.TRUE.equals(user.getPasswordChangeRequired()))
                .build();
    }

    /**
     * Enregistre le token FCM pour les notifications push.
     */
    @Transactional
    public void registerFcmToken(String nom, String fcmToken) {
        User user = userRepository.findByNom(nom)
                .orElseThrow(() -> new ResourceNotFoundException("Utilisateur", nom));
        user.setFcmToken(fcmToken);
        userRepository.save(user);
        String prefix = fcmToken != null && fcmToken.length() > 20 ? fcmToken.substring(0, 20) + "..." : fcmToken;
        log.info("FCM: token enregistré pour utilisateur \"{}\" ({}), préfixe: {}", nom, user.getId(), prefix);
    }

    private static final java.util.regex.Pattern UPPER = java.util.regex.Pattern.compile("[A-Z]");
    private static final java.util.regex.Pattern LOWER = java.util.regex.Pattern.compile("[a-z]");
    private static final java.util.regex.Pattern DIGIT = java.util.regex.Pattern.compile("[0-9]");
    private static final java.util.regex.Pattern SPECIAL = java.util.regex.Pattern.compile("[^A-Za-z0-9]");

    /**
     * Change le mot de passe (utilisateur connecté).
     * Règles : min 8 caractères, au moins 1 majuscule, 1 minuscule, 1 chiffre, 1 caractère spécial.
     */
    @Transactional
    public void changePassword(String username, ChangePasswordRequest request) {
        User user = userRepository.findByNom(username)
                .orElseThrow(() -> new ResourceNotFoundException("Utilisateur", username));

        if (!passwordEncoder.matches(request.getCurrentPassword(), user.getPassword())) {
            throw new BadCredentialsException("Mot de passe actuel incorrect");
        }

        String newPwd = request.getNewPassword();
        if (newPwd.length() < 8) {
            throw new IllegalArgumentException("Le mot de passe doit contenir au moins 8 caractères");
        }
        if (!UPPER.matcher(newPwd).find()) {
            throw new IllegalArgumentException("Le mot de passe doit contenir au moins une majuscule");
        }
        if (!LOWER.matcher(newPwd).find()) {
            throw new IllegalArgumentException("Le mot de passe doit contenir au moins une minuscule");
        }
        if (!DIGIT.matcher(newPwd).find()) {
            throw new IllegalArgumentException("Le mot de passe doit contenir au moins un chiffre");
        }
        if (!SPECIAL.matcher(newPwd).find()) {
            throw new IllegalArgumentException("Le mot de passe doit contenir au moins un caractère spécial");
        }

        user.setPassword(passwordEncoder.encode(newPwd));
        user.setPasswordChangeRequired(false);
        userRepository.save(user);
        log.info("Mot de passe changé pour l'utilisateur \"{}\"", username);
    }

    /**
     * Réinitialise le mot de passe d'un utilisateur par son nom (profil dev uniquement).
     * Utile si le mot de passe en base ne correspond plus (ex: admin zorai / 001).
     */
    @Transactional
    public void devResetPassword(String nom, String newPassword) {
        User user = userRepository.findByNom(nom)
                .orElseThrow(() -> new ResourceNotFoundException("Utilisateur", nom));
        user.setPassword(passwordEncoder.encode(newPassword));
        user.setPasswordChangeRequired(false);
        userRepository.save(user);
        log.warn("DEV: mot de passe réinitialisé pour \"{}\"", nom);
    }
}
