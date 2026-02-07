package com.example.demo.controller;

import com.example.demo.dto.ProgrammeEntrainementRequest;
import com.example.demo.entity.ProgrammeEntrainement;
import com.example.demo.service.ProgrammeEntrainementService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.time.Instant;

@RestController
@RequestMapping("/api/programmes-entrainement")
@RequiredArgsConstructor
public class ProgrammeEntrainementController {

    private final ProgrammeEntrainementService programmeEntrainementService;

    @GetMapping
    public ResponseEntity<Page<ProgrammeEntrainement>> findAll(Pageable pageable) {
        return ResponseEntity.ok(programmeEntrainementService.findAll(pageable));
    }

    @GetMapping("/{id}")
    public ResponseEntity<ProgrammeEntrainement> findById(@PathVariable Long id) {
        return ResponseEntity.ok(programmeEntrainementService.findById(id));
    }

    @GetMapping("/groupe/{groupeId}")
    public ResponseEntity<Page<ProgrammeEntrainement>> findByGroupeId(@PathVariable Long groupeId, Pageable pageable) {
        return ResponseEntity.ok(programmeEntrainementService.findByGroupeId(groupeId, pageable));
    }

    @GetMapping("/search")
    public ResponseEntity<Page<ProgrammeEntrainement>> findByDateDebutBetween(
            @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE_TIME) Instant debut,
            @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE_TIME) Instant fin,
            Pageable pageable) {
        return ResponseEntity.ok(programmeEntrainementService.findByDateDebutBetween(debut, fin, pageable));
    }

    @PreAuthorize("hasAnyRole('ADMIN_PRINCIPAL', 'ADMIN_COACH')")
    @PostMapping
    public ResponseEntity<ProgrammeEntrainement> create(@Valid @RequestBody ProgrammeEntrainementRequest request) {
        return ResponseEntity.ok(programmeEntrainementService.create(request));
    }

    @PreAuthorize("hasAnyRole('ADMIN_PRINCIPAL', 'ADMIN_COACH')")
    @PutMapping("/{id}")
    public ResponseEntity<ProgrammeEntrainement> update(@PathVariable Long id, @Valid @RequestBody ProgrammeEntrainementRequest request) {
        return ResponseEntity.ok(programmeEntrainementService.update(id, request));
    }

    @PreAuthorize("hasAnyRole('ADMIN_PRINCIPAL', 'ADMIN_COACH')")
    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteById(@PathVariable Long id) {
        programmeEntrainementService.deleteById(id);
        return ResponseEntity.noContent().build();
    }
}
