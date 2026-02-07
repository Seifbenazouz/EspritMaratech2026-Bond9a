package com.example.demo.service;

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
}
