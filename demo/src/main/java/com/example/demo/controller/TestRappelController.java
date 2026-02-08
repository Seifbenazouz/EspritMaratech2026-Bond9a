package com.example.demo.controller;

import com.example.demo.service.EvenementRappelService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

/**
 * Endpoints de test pour déclencher manuellement les rappels et récaps.
 * Utile pour tester sans attendre les crons.
 */
@RestController
@RequestMapping("/api/test")
@RequiredArgsConstructor
public class TestRappelController {

    private final EvenementRappelService evenementRappelService;

    @PreAuthorize("hasAnyRole('ADMIN_PRINCIPAL', 'ADMIN_COACH', 'ADMIN_GROUPE')")
    @PostMapping("/rappels-1h")
    public ResponseEntity<Void> declencherRappels1h() {
        evenementRappelService.declencherRappels1h();
        return ResponseEntity.ok().build();
    }

    @PreAuthorize("hasAnyRole('ADMIN_PRINCIPAL', 'ADMIN_COACH', 'ADMIN_GROUPE')")
    @PostMapping("/rappels-24h")
    public ResponseEntity<Void> declencherRappels24h() {
        evenementRappelService.declencherRappels24h();
        return ResponseEntity.ok().build();
    }

    @PreAuthorize("hasAnyRole('ADMIN_PRINCIPAL', 'ADMIN_COACH', 'ADMIN_GROUPE')")
    @PostMapping("/recap-quotidien")
    public ResponseEntity<Void> declencherRecapQuotidien() {
        evenementRappelService.envoyerRecapQuotidien();
        return ResponseEntity.ok().build();
    }

    @PreAuthorize("hasAnyRole('ADMIN_PRINCIPAL', 'ADMIN_COACH', 'ADMIN_GROUPE')")
    @PostMapping("/recap-hebdomadaire")
    public ResponseEntity<Void> declencherRecapHebdomadaire() {
        evenementRappelService.envoyerRecapHebdomadaire();
        return ResponseEntity.ok().build();
    }
}
