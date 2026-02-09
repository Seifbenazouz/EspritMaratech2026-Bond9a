package com.example.demo.service;

import com.example.demo.dto.UserCreateRequest;
import com.example.demo.dto.UserUpdateRequest;
import com.example.demo.entity.Role;
import com.example.demo.entity.User;
import com.example.demo.exception.ResourceNotFoundException;
import com.example.demo.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.UUID;

@Service
@RequiredArgsConstructor
public class UserService {

    private final UserRepository userRepository;
    private final PasswordEncoder passwordEncoder;
    private final FcmService fcmService;

    public Page<User> findAll(Pageable pageable) {
        return userRepository.findAll(pageable);
    }

    public User findById(UUID id) {
        return userRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Utilisateur", id));
    }

    public User findByEmail(String email) {
        return userRepository.findByEmail(email)
                .orElseThrow(() -> new ResourceNotFoundException("Utilisateur avec email " + email));
    }

    /**
     * Création d'un utilisateur par l'admin principal.
     * Mot de passe initial = 3 derniers chiffres du CIN (comme l'inscription).
     */
    @Transactional
    public User create(UserCreateRequest request) {
        if (userRepository.existsByEmail(request.getEmail())) {
            throw new IllegalArgumentException("Un compte existe déjà avec cet email");
        }
        if (userRepository.existsByCin(request.getCin())) {
            throw new IllegalArgumentException("Un compte existe déjà avec ce numéro CIN");
        }
        if (request.getCin() == null || Math.abs(request.getCin()) < 100) {
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
                .passwordChangeRequired(true)
                .build();
        return userRepository.save(user);
    }

    @Transactional
    public User update(UUID id, UserUpdateRequest request) {
        User user = findById(id);
        if (!user.getEmail().equals(request.getEmail()) && userRepository.existsByEmail(request.getEmail())) {
            throw new IllegalArgumentException("Un compte existe déjà avec cet email");
        }
        user.setNom(request.getNom());
        user.setPrenom(request.getPrenom());
        user.setEmail(request.getEmail());
        user.setPhone(request.getPhone());
        user.setRole(request.getRole());
        return userRepository.save(user);
    }

    @Transactional
    public void deleteById(UUID id) {
        if (!userRepository.existsById(id)) {
            throw new ResourceNotFoundException("Utilisateur", id);
        }
        userRepository.deleteById(id);
    }

    public Page<User> findByRole(Role role, Pageable pageable) {
        return userRepository.findByRole(role, pageable);
    }

    public java.util.List<User> findAdherentsByRole(Role role) {
        return userRepository.findByRole(role);
    }

    /**
     * Indique si l'utilisateur a un token FCM enregistré (pour les notifications push).
     */
    public boolean isFcmTokenRegistered(UUID userId) {
        return userRepository.findById(userId)
                .map(u -> u.getFcmToken() != null && !u.getFcmToken().isBlank())
                .orElse(false);
    }

    /**
     * Envoie une notification push de test à l'utilisateur (pour vérifier que FCM fonctionne).
     */
    public void sendTestPushNotification(UUID userId) {
        User user = findById(userId);
        if (user.getFcmToken() == null || user.getFcmToken().isBlank()) {
            throw new IllegalArgumentException("Cet utilisateur n'a pas de token FCM enregistré. Il doit se connecter sur l'app Android.");
        }
        fcmService.sendToTokens(
                java.util.List.of(user.getFcmToken()),
                "Test notification",
                "Les notifications push fonctionnent correctement."
        );
    }
}
