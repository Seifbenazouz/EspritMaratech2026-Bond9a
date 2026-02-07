package com.example.demo.service;

import com.example.demo.dto.ActualiteRequest;
import com.example.demo.entity.Actualite;
import com.example.demo.exception.ResourceNotFoundException;
import com.example.demo.repository.ActualiteRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.Instant;

@Service
@RequiredArgsConstructor
public class ActualiteService {

    private final ActualiteRepository actualiteRepository;

    public Page<Actualite> findAll(Pageable pageable) {
        return actualiteRepository.findByOrderByDatePublicationDesc(pageable);
    }

    public Actualite findById(Long id) {
        return actualiteRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Actualité", id));
    }

    @Transactional
    public Actualite create(ActualiteRequest request) {
        Actualite actualite = Actualite.builder()
                .titre(request.getTitre())
                .contenu(request.getContenu())
                .datePublication(request.getDatePublication() != null ? request.getDatePublication() : Instant.now())
                .build();
        return actualiteRepository.save(actualite);
    }

    @Transactional
    public Actualite update(Long id, ActualiteRequest request) {
        Actualite actualite = findById(id);
        actualite.setTitre(request.getTitre());
        actualite.setContenu(request.getContenu());
        if (request.getDatePublication() != null) {
            actualite.setDatePublication(request.getDatePublication());
        }
        return actualiteRepository.save(actualite);
    }

    @Transactional
    public void deleteById(Long id) {
        if (!actualiteRepository.existsById(id)) {
            throw new ResourceNotFoundException("Actualité", id);
        }
        actualiteRepository.deleteById(id);
    }

    public Page<Actualite> findByDateBetween(Instant debut, Instant fin, Pageable pageable) {
        return actualiteRepository.findByDatePublicationBetweenOrderByDatePublicationDesc(debut, fin, pageable);
    }
}
