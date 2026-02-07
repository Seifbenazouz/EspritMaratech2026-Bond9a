package com.example.demo.controller;

import com.example.demo.dto.GroupeRunningRequest;
import com.example.demo.entity.GroupeRunning;
import com.example.demo.service.GroupeRunningService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.UUID;

@RestController
@RequestMapping("/api/groupes-running")
@RequiredArgsConstructor
public class GroupeRunningController {

    private final GroupeRunningService groupeRunningService;

    @GetMapping
    public ResponseEntity<Page<GroupeRunning>> findAll(Pageable pageable) {
        return ResponseEntity.ok(groupeRunningService.findAll(pageable));
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

    @PreAuthorize("hasAnyRole('ADMIN_PRINCIPAL', 'ADMIN_GROUPE')")
    @PostMapping
    public ResponseEntity<GroupeRunning> create(@Valid @RequestBody GroupeRunningRequest request) {
        return ResponseEntity.ok(groupeRunningService.create(request));
    }

    @PreAuthorize("hasAnyRole('ADMIN_PRINCIPAL', 'ADMIN_GROUPE')")
    @PutMapping("/{id}")
    public ResponseEntity<GroupeRunning> update(@PathVariable Long id, @Valid @RequestBody GroupeRunningRequest request) {
        return ResponseEntity.ok(groupeRunningService.update(id, request));
    }

    @PreAuthorize("hasAnyRole('ADMIN_PRINCIPAL', 'ADMIN_GROUPE')")
    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteById(@PathVariable Long id) {
        groupeRunningService.deleteById(id);
        return ResponseEntity.noContent().build();
    }

    @PreAuthorize("hasAnyRole('ADMIN_PRINCIPAL', 'ADMIN_GROUPE')")
    @PostMapping("/{groupeId}/membres/{adherentId}")
    public ResponseEntity<GroupeRunning> addMembre(@PathVariable Long groupeId, @PathVariable UUID adherentId) {
        return ResponseEntity.ok(groupeRunningService.addMembre(groupeId, adherentId));
    }

    @PreAuthorize("hasAnyRole('ADMIN_PRINCIPAL', 'ADMIN_GROUPE')")
    @DeleteMapping("/{groupeId}/membres/{adherentId}")
    public ResponseEntity<GroupeRunning> removeMembre(@PathVariable Long groupeId, @PathVariable UUID adherentId) {
        return ResponseEntity.ok(groupeRunningService.removeMembre(groupeId, adherentId));
    }

    @PreAuthorize("hasAnyRole('ADMIN_PRINCIPAL', 'ADMIN_GROUPE')")
    @PutMapping("/{groupeId}/responsable/{responsableId}")
    public ResponseEntity<GroupeRunning> setResponsable(@PathVariable Long groupeId, @PathVariable UUID responsableId) {
        return ResponseEntity.ok(groupeRunningService.setResponsable(groupeId, responsableId));
    }
}
