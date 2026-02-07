package com.example.demo.controller;

import com.example.demo.dto.ParticipationRequest;
import com.example.demo.entity.Participation;
import com.example.demo.service.ParticipationService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.UUID;

@RestController
@RequestMapping("/api/participations")
@RequiredArgsConstructor
public class ParticipationController {

    private final ParticipationService participationService;

    @GetMapping
    public ResponseEntity<Page<Participation>> findAll(Pageable pageable) {
        return ResponseEntity.ok(participationService.findAll(pageable));
    }

    @GetMapping("/{id}")
    public ResponseEntity<Participation> findById(@PathVariable Long id) {
        return ResponseEntity.ok(participationService.findById(id));
    }

    @GetMapping("/adherent/{adherentId}")
    public ResponseEntity<Page<Participation>> findByAdherentId(@PathVariable UUID adherentId, Pageable pageable) {
        return ResponseEntity.ok(participationService.findByAdherentId(adherentId, pageable));
    }

    @GetMapping("/evenement/{evenementId}")
    public ResponseEntity<Page<Participation>> findByEvenementId(@PathVariable Long evenementId, Pageable pageable) {
        return ResponseEntity.ok(participationService.findByEvenementId(evenementId, pageable));
    }

    @PostMapping
    public ResponseEntity<Participation> create(@Valid @RequestBody ParticipationRequest request) {
        return ResponseEntity.ok(participationService.create(request));
    }

    @PostMapping("/inscrire")
    public ResponseEntity<Participation> inscrire(
            @RequestParam UUID adherentId,
            @RequestParam Long evenementId) {
        return ResponseEntity.ok(participationService.inscrire(adherentId, evenementId));
    }

    @DeleteMapping("/annuler")
    public ResponseEntity<Void> annuler(
            @RequestParam UUID adherentId,
            @RequestParam Long evenementId) {
        participationService.annuler(adherentId, evenementId);
        return ResponseEntity.noContent().build();
    }

    @PutMapping("/{id}")
    public ResponseEntity<Participation> update(@PathVariable Long id, @Valid @RequestBody ParticipationRequest request) {
        return ResponseEntity.ok(participationService.update(id, request));
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteById(@PathVariable Long id) {
        participationService.deleteById(id);
        return ResponseEntity.noContent().build();
    }
}
