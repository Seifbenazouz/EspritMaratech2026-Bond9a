package com.example.demo.controller;

import com.example.demo.dto.EvenementRequest;
import com.example.demo.entity.Evenement;
import com.example.demo.service.EvenementService;
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
@RequestMapping("/api/evenements")
@RequiredArgsConstructor
public class EvenementController {

    private final EvenementService evenementService;

    @GetMapping
    public ResponseEntity<Page<Evenement>> findAll(Pageable pageable) {
        return ResponseEntity.ok(evenementService.findAll(pageable));
    }

    @GetMapping("/{id}")
    public ResponseEntity<Evenement> findById(@PathVariable Long id) {
        return ResponseEntity.ok(evenementService.findById(id));
    }

    @GetMapping("/groupe/{groupeId}")
    public ResponseEntity<Page<Evenement>> findByGroupeId(@PathVariable Long groupeId, Pageable pageable) {
        return ResponseEntity.ok(evenementService.findByGroupeId(groupeId, pageable));
    }

    @GetMapping("/search")
    public ResponseEntity<Page<Evenement>> findByDateBetween(
            @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE_TIME) Instant debut,
            @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE_TIME) Instant fin,
            Pageable pageable) {
        return ResponseEntity.ok(evenementService.findByDateBetween(debut, fin, pageable));
    }

    @GetMapping("/type/{type}")
    public ResponseEntity<Page<Evenement>> findByType(@PathVariable String type, Pageable pageable) {
        return ResponseEntity.ok(evenementService.findByType(type, pageable));
    }

    @PreAuthorize("hasAnyRole('ADMIN_PRINCIPAL', 'ADMIN_COACH', 'ADMIN_GROUPE')")
    @PostMapping
    public ResponseEntity<Evenement> create(@Valid @RequestBody EvenementRequest request) {
        return ResponseEntity.ok(evenementService.create(request));
    }

    @PreAuthorize("hasAnyRole('ADMIN_PRINCIPAL', 'ADMIN_COACH', 'ADMIN_GROUPE')")
    @PutMapping("/{id}")
    public ResponseEntity<Evenement> update(@PathVariable Long id, @Valid @RequestBody EvenementRequest request) {
        return ResponseEntity.ok(evenementService.update(id, request));
    }

    @PreAuthorize("hasAnyRole('ADMIN_PRINCIPAL', 'ADMIN_COACH', 'ADMIN_GROUPE')")
    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteById(@PathVariable Long id) {
        evenementService.deleteById(id);
        return ResponseEntity.noContent().build();
    }
}
