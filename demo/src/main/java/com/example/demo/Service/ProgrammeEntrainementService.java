package com.example.demo.service;

import com.example.demo.dto.ProgrammeEntrainementRequest;
import com.example.demo.entity.GroupeRunning;
import com.example.demo.entity.ProgrammeEntrainement;
import com.example.demo.exception.ResourceNotFoundException;
import com.example.demo.repository.GroupeRunningRepository;
import com.example.demo.repository.ProgrammeEntrainementRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.Instant;

@Service
@RequiredArgsConstructor
public class ProgrammeEntrainementService {

    private final ProgrammeEntrainementRepository programmeEntrainementRepository;
    private final GroupeRunningRepository groupeRunningRepository;

    public Page<ProgrammeEntrainement> findAll(Pageable pageable) {
        return programmeEntrainementRepository.findAll(pageable);
    }

    public ProgrammeEntrainement findById(Long id) {
        return programmeEntrainementRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Programme d'entraînement", id));
    }

    public Page<ProgrammeEntrainement> findByGroupeId(Long groupeId, Pageable pageable) {
        return programmeEntrainementRepository.findByGroupeIdOrderByDateDebutDesc(groupeId, pageable);
    }

    public Page<ProgrammeEntrainement> findByDateDebutBetween(Instant debut, Instant fin, Pageable pageable) {
        return programmeEntrainementRepository.findByDateDebutBetweenOrderByDateDebutDesc(debut, fin, pageable);
    }

    @Transactional
    public ProgrammeEntrainement create(ProgrammeEntrainementRequest request) {
        GroupeRunning groupe = groupeRunningRepository.findById(request.getGroupeId())
                .orElseThrow(() -> new ResourceNotFoundException("Groupe", request.getGroupeId()));
        ProgrammeEntrainement programme = ProgrammeEntrainement.builder()
                .titre(request.getTitre())
                .description(request.getDescription())
                .dateDebut(request.getDateDebut())
                .dateFin(request.getDateFin())
                .groupe(groupe)
                .build();
        return programmeEntrainementRepository.save(programme);
    }

    @Transactional
    public ProgrammeEntrainement update(Long id, ProgrammeEntrainementRequest request) {
        ProgrammeEntrainement programme = findById(id);
        if (!programme.getGroupe().getId().equals(request.getGroupeId())) {
            GroupeRunning groupe = groupeRunningRepository.findById(request.getGroupeId())
                    .orElseThrow(() -> new ResourceNotFoundException("Groupe", request.getGroupeId()));
            programme.setGroupe(groupe);
        }
        programme.setTitre(request.getTitre());
        programme.setDescription(request.getDescription());
        programme.setDateDebut(request.getDateDebut());
        programme.setDateFin(request.getDateFin());
        return programmeEntrainementRepository.save(programme);
    }

    @Transactional
    public void deleteById(Long id) {
        if (!programmeEntrainementRepository.existsById(id)) {
            throw new ResourceNotFoundException("Programme d'entraînement", id);
        }
        programmeEntrainementRepository.deleteById(id);
    }
}
