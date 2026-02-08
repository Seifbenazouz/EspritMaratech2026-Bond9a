package com.example.demo.controller;

import com.example.demo.dto.GroupeRunningRequest;
import com.example.demo.entity.GroupeRunning;
import com.example.demo.entity.User;
import com.example.demo.repository.UserRepository;
import com.example.demo.service.GroupeRunningService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.web.bind.annotation.*;

import java.util.UUID;

@RestController
@RequestMapping("/api/groupes-running")
@RequiredArgsConstructor
public class GroupeRunningController {

    private final GroupeRunningService groupeRunningService;
    private final UserRepository userRepository;

    @GetMapping
    public ResponseEntity<Page<GroupeRunning>> findAll(Pageable pageable) {
        return ResponseEntity.ok(groupeRunningService.findAll(pageable));
    }

    /**
     * Groupes accessibles par l'utilisateur connecté :
     * - ADMIN_PRINCIPAL : tous les groupes
     * - ADMIN_GROUPE : uniquement le groupe dont il est responsable
     */
    @PreAuthorize("hasAnyRole('ADMIN_PRINCIPAL', 'ADMIN_GROUPE')")
    @GetMapping("/mes-groupes")
    public ResponseEntity<Page<GroupeRunning>> findMesGroupes(
            @AuthenticationPrincipal UserDetails userDetails,
            Pageable pageable) {
        User currentUser = userRepository.findByNom(userDetails.getUsername())
                .orElseThrow();
        return ResponseEntity.ok(groupeRunningService.findMesGroupes(currentUser, pageable));
    }

    @GetMapping("/{id}")
    public ResponseEntity<GroupeRunning> findById(@PathVariable Long id) {
        return ResponseEntity.ok(groupeRunningService.findById(id));
    }

    @GetMapping("/niveau/{niveau}")
    public ResponseEntity<Page<GroupeRunning>> findByNiveau(@PathVariable String niveau, Pageable pageable) {
        return ResponseEntity.ok(groupeRunningService.findByNiveau(niveau, pageable));
    }

    @GetMapping("/membre/{adherentId}")
    public ResponseEntity<Page<GroupeRunning>> findByMembreId(@PathVariable UUID adherentId, Pageable pageable) {
        return ResponseEntity.ok(groupeRunningService.findByMembreId(adherentId, pageable));
    }

    @PreAuthorize("hasRole('ADMIN_PRINCIPAL')")
    @PostMapping
    public ResponseEntity<GroupeRunning> create(@Valid @RequestBody GroupeRunningRequest request) {
        return ResponseEntity.ok(groupeRunningService.create(request));
    }

    @PreAuthorize("hasRole('ADMIN_PRINCIPAL')")
    @PutMapping("/{id}")
    public ResponseEntity<GroupeRunning> update(@PathVariable Long id, @Valid @RequestBody GroupeRunningRequest request) {
        return ResponseEntity.ok(groupeRunningService.update(id, request));
    }

    @PreAuthorize("hasRole('ADMIN_PRINCIPAL')")
    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteById(@PathVariable Long id) {
        groupeRunningService.deleteById(id);
        return ResponseEntity.noContent().build();
    }

    @PreAuthorize("hasAnyRole('ADMIN_PRINCIPAL', 'ADMIN_GROUPE')")
    @PostMapping("/{groupeId}/membres/{adherentId}")
    public ResponseEntity<GroupeRunning> addMembre(
            @PathVariable Long groupeId,
            @PathVariable UUID adherentId,
            @AuthenticationPrincipal UserDetails userDetails) {
        User currentUser = userRepository.findByNom(userDetails.getUsername()).orElseThrow();
        return ResponseEntity.ok(groupeRunningService.addMembre(groupeId, adherentId, currentUser));
    }

    @PreAuthorize("hasAnyRole('ADMIN_PRINCIPAL', 'ADMIN_GROUPE')")
    @DeleteMapping("/{groupeId}/membres/{adherentId}")
    public ResponseEntity<GroupeRunning> removeMembre(
            @PathVariable Long groupeId,
            @PathVariable UUID adherentId,
            @AuthenticationPrincipal UserDetails userDetails) {
        User currentUser = userRepository.findByNom(userDetails.getUsername()).orElseThrow();
        return ResponseEntity.ok(groupeRunningService.removeMembre(groupeId, adherentId, currentUser));
    }

    @PreAuthorize("hasRole('ADMIN_PRINCIPAL')")
    @PutMapping("/{groupeId}/responsable/{responsableId}")
    public ResponseEntity<GroupeRunning> setResponsable(@PathVariable Long groupeId, @PathVariable UUID responsableId) {
        return ResponseEntity.ok(groupeRunningService.setResponsable(groupeId, responsableId));
    }
}
