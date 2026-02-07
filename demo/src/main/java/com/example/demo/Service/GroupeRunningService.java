package com.example.demo.service;

import com.example.demo.dto.GroupeRunningRequest;
import com.example.demo.entity.GroupeRunning;
import com.example.demo.entity.User;
import com.example.demo.exception.ResourceNotFoundException;
import com.example.demo.repository.GroupeRunningRepository;
import com.example.demo.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

@Service
@RequiredArgsConstructor
@Slf4j
public class GroupeRunningService {

    private final GroupeRunningRepository groupeRunningRepository;
    private final UserRepository userRepository;
    private final FcmService fcmService;

    public Page<GroupeRunning> findAll(Pageable pageable) {
        return groupeRunningRepository.findByOrderByNomAsc(pageable);
    }

    public GroupeRunning findById(Long id) {
        return groupeRunningRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Groupe", id));
    }

    public Page<GroupeRunning> findByNiveau(String niveau, Pageable pageable) {
        return groupeRunningRepository.findByNiveau(niveau, pageable);
    }

    public Page<GroupeRunning> findByMembreId(UUID adherentId, Pageable pageable) {
        return groupeRunningRepository.findByMembreId(adherentId, pageable);
    }

    @Transactional
    public GroupeRunning create(GroupeRunningRequest request) {
        User responsable = request.getResponsableId() != null
                ? userRepository.findById(request.getResponsableId())
                .orElseThrow(() -> new ResourceNotFoundException("Utilisateur", request.getResponsableId()))
                : null;
        List<User> membres = new ArrayList<>();
        if (request.getMembreIds() != null) {
            for (UUID id : request.getMembreIds()) {
                userRepository.findById(id).ifPresent(membres::add);
            }
        }
        GroupeRunning groupe = GroupeRunning.builder()
                .nom(request.getNom())
                .niveau(request.getNiveau())
                .description(request.getDescription())
                .responsable(responsable)
                .membres(membres)
                .build();
        return groupeRunningRepository.save(groupe);
    }

    @Transactional
    public GroupeRunning update(Long id, GroupeRunningRequest request) {
        GroupeRunning groupe = findById(id);
        groupe.setNom(request.getNom());
        groupe.setNiveau(request.getNiveau());
        groupe.setDescription(request.getDescription());
        if (request.getResponsableId() != null) {
            User responsable = userRepository.findById(request.getResponsableId())
                    .orElseThrow(() -> new ResourceNotFoundException("Utilisateur", request.getResponsableId()));
            groupe.setResponsable(responsable);
        } else {
            groupe.setResponsable(null);
        }
        if (request.getMembreIds() != null) {
            List<User> membres = new ArrayList<>();
            for (UUID membreId : request.getMembreIds()) {
                userRepository.findById(membreId).ifPresent(membres::add);
            }
            groupe.setMembres(membres);
        }
        return groupeRunningRepository.save(groupe);
    }

    @Transactional
    public void deleteById(Long id) {
        if (!groupeRunningRepository.existsById(id)) {
            throw new ResourceNotFoundException("Groupe", id);
        }
        groupeRunningRepository.deleteById(id);
    }

    @Transactional
    public GroupeRunning addMembre(Long groupeId, UUID adherentId) {
        GroupeRunning groupe = findById(groupeId);
        User user = userRepository.findById(adherentId)
                .orElseThrow(() -> new ResourceNotFoundException("Utilisateur", adherentId));
        boolean added = false;
        if (!groupe.getMembres().contains(user)) {
            groupe.getMembres().add(user);
            groupe = groupeRunningRepository.save(groupe);
            added = true;
        }
        if (added) {
            if (user.getFcmToken() != null && !user.getFcmToken().isBlank()) {
                String titre = "Affectation à un groupe";
                String body = "Vous avez été affecté au groupe \"" + groupe.getNom() + "\" par un administrateur.";
                fcmService.sendToTokens(List.of(user.getFcmToken()), titre, body);
                log.info("FCM: notification d'affectation au groupe \"{}\" envoyée à l'utilisateur {}", groupe.getNom(), adherentId);
            } else {
                log.warn("FCM: utilisateur {} n'a pas de token FCM enregistré - pas de notification (il doit se connecter sur l'app au moins une fois)", adherentId);
            }
        }
        return groupe;
    }

    @Transactional
    public GroupeRunning removeMembre(Long groupeId, UUID adherentId) {
        GroupeRunning groupe = findById(groupeId);
        groupe.getMembres().removeIf(u -> u.getId().equals(adherentId));
        return groupeRunningRepository.save(groupe);
    }

    @Transactional
    public GroupeRunning setResponsable(Long groupeId, UUID responsableId) {
        GroupeRunning groupe = findById(groupeId);
        User user = userRepository.findById(responsableId)
                .orElseThrow(() -> new ResourceNotFoundException("Utilisateur", responsableId));
        groupe.setResponsable(user);
        return groupeRunningRepository.save(groupe);
    }
}
