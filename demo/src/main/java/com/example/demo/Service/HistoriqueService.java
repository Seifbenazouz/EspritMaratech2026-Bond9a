package com.example.demo.service;

import com.example.demo.dto.HistoriqueRequest;
import com.example.demo.entity.Evenement;
import com.example.demo.entity.Historique;
import com.example.demo.exception.ResourceNotFoundException;
import com.example.demo.repository.EvenementRepository;
import com.example.demo.repository.HistoriqueRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.Instant;

@Service
@RequiredArgsConstructor
public class HistoriqueService {

    private final HistoriqueRepository historiqueRepository;
    private final EvenementRepository evenementRepository;

    public Page<Historique> findAll(Pageable pageable) {
        return historiqueRepository.findByOrderByDateDesc(pageable);
    }

    public Historique findById(Long id) {
        return historiqueRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Historique", id));
    }

    public Page<Historique> findByDateBetween(Instant debut, Instant fin, Pageable pageable) {
        return historiqueRepository.findByDateBetweenOrderByDateDesc(debut, fin, pageable);
    }

    @Transactional
    public Historique create(HistoriqueRequest request) {
        Evenement evenement = evenementRepository.findById(request.getEvenementId())
                .orElseThrow(() -> new ResourceNotFoundException("Événement", request.getEvenementId()));
        Historique historique = Historique.builder()
                .date(request.getDate() != null ? request.getDate() : Instant.now())
                .evenement(evenement)
                .build();
        return historiqueRepository.save(historique);
    }

    @Transactional
    public Historique update(Long id, HistoriqueRequest request) {
        Historique historique = findById(id);
        if (request.getDate() != null) {
            historique.setDate(request.getDate());
        }
        if (request.getEvenementId() != null && !historique.getEvenement().getId().equals(request.getEvenementId())) {
            Evenement evenement = evenementRepository.findById(request.getEvenementId())
                    .orElseThrow(() -> new ResourceNotFoundException("Événement", request.getEvenementId()));
            historique.setEvenement(evenement);
        }
        return historiqueRepository.save(historique);
    }

    @Transactional
    public void deleteById(Long id) {
        if (!historiqueRepository.existsById(id)) {
            throw new ResourceNotFoundException("Historique", id);
        }
        historiqueRepository.deleteById(id);
    }
}
