package com.example.demo.controller;

import com.example.demo.dto.StatsAdherentDto;
import com.example.demo.service.StatsAdherentService;
import com.example.demo.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.UUID;

/**
 * API des statistiques de course des adhérents.
 * Réservé au rôle ADHERENT.
 */
@RestController
@RequestMapping("/api/stats-adherent")
@RequiredArgsConstructor
public class StatsAdherentController {

    private final StatsAdherentService statsAdherentService;
    private final UserRepository userRepository;

    /** Mes statistiques (adhérent connecté). */
    @GetMapping("/me")
    @PreAuthorize("hasRole('ADHERENT')")
    public ResponseEntity<StatsAdherentDto> getMyStats(@AuthenticationPrincipal UserDetails user) {
        if (user == null) {
            return ResponseEntity.status(401).build();
        }
        UUID adherentId = userRepository.findByNom(user.getUsername())
                .map(u -> u.getId())
                .orElseThrow(() -> new IllegalArgumentException("Utilisateur non trouvé"));
        return ResponseEntity.ok(statsAdherentService.getStatsForMe(adherentId));
    }
}
