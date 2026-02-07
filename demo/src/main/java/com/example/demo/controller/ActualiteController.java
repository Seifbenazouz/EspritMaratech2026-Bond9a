package com.example.demo.controller;

import com.example.demo.dto.ActualiteRequest;
import com.example.demo.entity.Actualite;
import com.example.demo.service.ActualiteService;
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
@RequestMapping("/api/actualites")
@RequiredArgsConstructor
public class ActualiteController {

    private final ActualiteService actualiteService;

    @GetMapping
    public ResponseEntity<Page<Actualite>> findAll(Pageable pageable) {
        return ResponseEntity.ok(actualiteService.findAll(pageable));
    }

    @GetMapping("/{id}")
    public ResponseEntity<Actualite> findById(@PathVariable Long id) {
        return ResponseEntity.ok(actualiteService.findById(id));
    }

    @GetMapping("/search")
    public ResponseEntity<Page<Actualite>> findByDateBetween(
            @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE_TIME) Instant debut,
            @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE_TIME) Instant fin,
            Pageable pageable) {
        return ResponseEntity.ok(actualiteService.findByDateBetween(debut, fin, pageable));
    }

    @PostMapping
    @PreAuthorize("hasRole('ADMIN_PRINCIPAL')")
    public ResponseEntity<Actualite> create(@Valid @RequestBody ActualiteRequest request) {
        return ResponseEntity.ok(actualiteService.create(request));
    }

    @PutMapping("/{id}")
    @PreAuthorize("hasRole('ADMIN_PRINCIPAL')")
    public ResponseEntity<Actualite> update(@PathVariable Long id, @Valid @RequestBody ActualiteRequest request) {
        return ResponseEntity.ok(actualiteService.update(id, request));
    }

    @DeleteMapping("/{id}")
    @PreAuthorize("hasRole('ADMIN_PRINCIPAL')")
    public ResponseEntity<Void> deleteById(@PathVariable Long id) {
        actualiteService.deleteById(id);
        return ResponseEntity.noContent().build();
    }
}
