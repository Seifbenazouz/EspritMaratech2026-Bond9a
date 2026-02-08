package com.example.demo.controller;

import com.example.demo.dto.PartnerMatchDto;
import com.example.demo.entity.User;
import com.example.demo.repository.UserRepository;
import com.example.demo.service.MatchingService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.UUID;

/**
 * API de matching partenaires running (adhérents uniquement).
 */
@RestController
@RequestMapping("/api/matching")
@RequiredArgsConstructor
public class MatchingController {

    private final MatchingService matchingService;
    private final UserRepository userRepository;

    @PreAuthorize("hasRole('ADHERENT')")
    @GetMapping("/partenaires")
    public ResponseEntity<List<PartnerMatchDto>> findPartners(
            @AuthenticationPrincipal UserDetails userDetails) {
        User currentUser = userRepository.findByNom(userDetails.getUsername())
                .orElseThrow();
        return ResponseEntity.ok(matchingService.findPartners(currentUser.getId()));
    }

    @PreAuthorize("hasRole('ADHERENT')")
    @PostMapping("/inviter/{targetUserId}")
    public ResponseEntity<Void> inviterPartenaire(
            @AuthenticationPrincipal UserDetails userDetails,
            @PathVariable UUID targetUserId) {
        User currentUser = userRepository.findByNom(userDetails.getUsername())
                .orElseThrow();
        matchingService.inviterPartenaire(currentUser.getId(), targetUserId);
        return ResponseEntity.ok().build();
    }
}
