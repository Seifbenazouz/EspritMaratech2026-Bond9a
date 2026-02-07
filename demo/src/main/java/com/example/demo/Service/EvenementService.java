package com.example.demo.service;

import com.example.demo.dto.EvenementRequest;
import com.example.demo.entity.Evenement;
import com.example.demo.entity.GroupeRunning;
import com.example.demo.entity.User;
import com.example.demo.exception.ResourceNotFoundException;
import com.example.demo.repository.EvenementRepository;
import com.example.demo.repository.GroupeRunningRepository;
import com.example.demo.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.Instant;
import java.util.ArrayList;
import java.util.List;

@Service
@RequiredArgsConstructor
@Slf4j
public class EvenementService {

    private final EvenementRepository evenementRepository;
    private final GroupeRunningRepository groupeRunningRepository;
    private final UserRepository userRepository;
    private final FcmService fcmService;

    public Page<Evenement> findAll(Pageable pageable) {
        return evenementRepository.findAll(pageable);
    }

    public Evenement findById(Long id) {
        return evenementRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Événement", id));
    }

    public Page<Evenement> findByGroupeId(Long groupeId, Pageable pageable) {
        return evenementRepository.findByGroupeIdOrderByDateDesc(groupeId, pageable);
    }

    public Page<Evenement> findByDateBetween(Instant debut, Instant fin, Pageable pageable) {
        return evenementRepository.findByDateBetweenOrderByDateDesc(debut, fin, pageable);
    }

    public Page<Evenement> findByType(String type, Pageable pageable) {
        return evenementRepository.findByTypeOrderByDateDesc(type, pageable);
    }

    @Transactional
    public Evenement create(EvenementRequest request) {
        GroupeRunning groupe = groupeRunningRepository.findByIdWithMembres(request.getGroupeId())
                .orElseThrow(() -> new ResourceNotFoundException("Groupe", request.getGroupeId()));
        Evenement evenement = Evenement.builder()
                .titre(request.getTitre())
                .description(request.getDescription())
                .date(request.getDate())
                .type(request.getType())
                .lieu(request.getLieu())
                .latitude(request.getLatitude())
                .longitude(request.getLongitude())
                .groupe(groupe)
                .build();
        evenement = evenementRepository.save(evenement);

        // Notifications push aux membres du groupe et au responsable (lors de l'ajout d'un événement)
        // Recharger chaque utilisateur depuis la DB pour avoir le fcmToken à jour (enregistré à la connexion sur l'app)
        List<String> tokens = new ArrayList<>();
        for (User m : groupe.getMembres()) {
            userRepository.findById(m.getId()).ifPresent(u -> {
                String t = u.getFcmToken();
                if (t != null && !t.isBlank() && !tokens.contains(t)) {
                    tokens.add(t);
                }
            });
        }
        if (groupe.getResponsable() != null) {
            userRepository.findById(groupe.getResponsable().getId()).ifPresent(resp -> {
                String t = resp.getFcmToken();
                if (t != null && !t.isBlank() && !tokens.contains(t)) {
                    tokens.add(t);
                }
            });
        }
        if (!tokens.isEmpty()) {
            String title = "Un admin a ajouté un événement: " + request.getTitre();
            String body = request.getDescription() != null && !request.getDescription().isBlank()
                    ? request.getDescription()
                    : "Nouvel événement pour le groupe " + groupe.getNom();
            fcmService.sendToTokens(tokens, title, body);
            log.info("FCM: notification \"{}\" envoyée à {} membre(s) du groupe \"{}\"", title, tokens.size(), groupe.getNom());
        } else {
            log.warn("FCM: aucun token FCM pour les membres du groupe \"{}\" - pas de notification (les membres doivent se connecter sur l'app Android)", groupe.getNom());
            for (User m : groupe.getMembres()) {
                boolean hasToken = userRepository.findById(m.getId())
                        .map(u -> u.getFcmToken() != null && !u.getFcmToken().isBlank())
                        .orElse(false);
                log.info("FCM diagnostic: membre id={} nom=\"{}\" fcmToken présent={}", m.getId(), m.getNom(), hasToken);
            }
        }

        return evenement;
    }

    @Transactional
    public Evenement update(Long id, EvenementRequest request) {
        Evenement evenement = findById(id);
        if (!evenement.getGroupe().getId().equals(request.getGroupeId())) {
            GroupeRunning groupe = groupeRunningRepository.findById(request.getGroupeId())
                    .orElseThrow(() -> new ResourceNotFoundException("Groupe", request.getGroupeId()));
            evenement.setGroupe(groupe);
        }
        evenement.setTitre(request.getTitre());
        evenement.setDescription(request.getDescription());
        evenement.setDate(request.getDate());
        evenement.setType(request.getType());
        evenement.setLieu(request.getLieu());
        evenement.setLatitude(request.getLatitude());
        evenement.setLongitude(request.getLongitude());
        return evenementRepository.save(evenement);
    }

    @Transactional
    public void deleteById(Long id) {
        if (!evenementRepository.existsById(id)) {
            throw new ResourceNotFoundException("Événement", id);
        }
        evenementRepository.deleteById(id);
    }
}
