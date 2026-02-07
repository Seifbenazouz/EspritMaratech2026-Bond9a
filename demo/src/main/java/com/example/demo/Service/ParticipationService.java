package com.example.demo.service;

import com.example.demo.dto.ParticipationRequest;
import com.example.demo.entity.Evenement;
import com.example.demo.entity.Participation;
import com.example.demo.entity.User;
import com.example.demo.exception.ResourceNotFoundException;
import com.example.demo.repository.EvenementRepository;
import com.example.demo.repository.ParticipationRepository;
import com.example.demo.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.Instant;
import java.util.List;
import java.util.UUID;

@Service
@RequiredArgsConstructor
public class ParticipationService {

    private final ParticipationRepository participationRepository;
    private final UserRepository userRepository;
    private final EvenementRepository evenementRepository;
    private final FcmService fcmService;

    public Page<Participation> findAll(Pageable pageable) {
        return participationRepository.findAll(pageable);
    }

    public Participation findById(Long id) {
        return participationRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Participation", id));
    }

    public Page<Participation> findByAdherentId(UUID adherentId, Pageable pageable) {
        return participationRepository.findByAdherentIdOrderByDateInscriptionDesc(adherentId, pageable);
    }

    public Page<Participation> findByEvenementId(Long evenementId, Pageable pageable) {
        return participationRepository.findByEvenementId(evenementId, pageable);
    }

    @Transactional
    public Participation create(ParticipationRequest request) {
        if (participationRepository.existsByAdherentIdAndEvenementId(request.getAdherentId(), request.getEvenementId())) {
            throw new IllegalArgumentException("Cet adhérent est déjà inscrit à cet événement");
        }
        User adherent = userRepository.findById(request.getAdherentId())
                .orElseThrow(() -> new ResourceNotFoundException("Utilisateur", request.getAdherentId()));
        Evenement evenement = evenementRepository.findById(request.getEvenementId())
                .orElseThrow(() -> new ResourceNotFoundException("Événement", request.getEvenementId()));
        Participation participation = Participation.builder()
                .statut(request.getStatut() != null ? request.getStatut() : "INSCRIT")
                .dateInscription(Instant.now())
                .adherent(adherent)
                .evenement(evenement)
                .build();
        participation = participationRepository.save(participation);

        // Notification push à l'utilisateur ajouté à l'événement
        if (adherent.getFcmToken() != null && !adherent.getFcmToken().isBlank()) {
            String titre = "Inscription à un événement";
            String body = "Vous avez été inscrit à : " + evenement.getTitre();
            if (evenement.getDate() != null) {
                body += " (" + evenement.getDate() + ")";
            }
            fcmService.sendToTokens(List.of(adherent.getFcmToken()), titre, body);
        }

        return participation;
    }

    @Transactional
    public Participation update(Long id, ParticipationRequest request) {
        Participation participation = findById(id);
        participation.setStatut(request.getStatut());
        if (request.getAdherentId() != null && !participation.getAdherent().getId().equals(request.getAdherentId())) {
            User adherent = userRepository.findById(request.getAdherentId())
                    .orElseThrow(() -> new ResourceNotFoundException("Utilisateur", request.getAdherentId()));
            participation.setAdherent(adherent);
        }
        if (request.getEvenementId() != null && !participation.getEvenement().getId().equals(request.getEvenementId())) {
            Evenement evenement = evenementRepository.findById(request.getEvenementId())
                    .orElseThrow(() -> new ResourceNotFoundException("Événement", request.getEvenementId()));
            participation.setEvenement(evenement);
        }
        return participationRepository.save(participation);
    }

    @Transactional
    public void deleteById(Long id) {
        if (!participationRepository.existsById(id)) {
            throw new ResourceNotFoundException("Participation", id);
        }
        participationRepository.deleteById(id);
    }

    /** Inscription d'un adhérent à un événement. */
    @Transactional
    public Participation inscrire(UUID adherentId, Long evenementId) {
        ParticipationRequest req = new ParticipationRequest("INSCRIT", adherentId, evenementId);
        return create(req);
    }

    /** Annulation / désinscription. */
    @Transactional
    public void annuler(UUID adherentId, Long evenementId) {
        Participation p = participationRepository.findByAdherentIdAndEvenementId(adherentId, evenementId)
                .orElseThrow(() -> new ResourceNotFoundException("Participation pour cet adhérent et cet événement"));
        participationRepository.delete(p);
    }
}
