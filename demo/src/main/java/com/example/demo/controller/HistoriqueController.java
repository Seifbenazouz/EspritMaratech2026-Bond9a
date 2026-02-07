package com.example.demo.controller;

import com.example.demo.dto.HistoriqueRequest;
import com.example.demo.entity.Historique;
import com.example.demo.service.HistoriqueService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.time.Instant;

@RestController
@RequestMapping("/api/historiques")
@RequiredArgsConstructor
public class HistoriqueController {

    private final HistoriqueService historiqueService;

    @GetMapping
    public ResponseEntity<Page<Historique>> findAll(Pageable pageable) {
        return ResponseEntity.ok(historiqueService.findAll(pageable));
    }

    @GetMapping("/{id}")
    public ResponseEntity<Historique> findById(@PathVariable Long id) {
        return ResponseEntity.ok(historiqueService.findById(id));
    }

    @GetMapping("/search")
    public ResponseEntity<Page<Historique>> findByDateBetween(
            @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE_TIME) Instant debut,
            @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE_TIME) Instant fin,
            Pageable pageable) {
        return ResponseEntity.ok(historiqueService.findByDateBetween(debut, fin, pageable));
    }

    @PostMapping
    public ResponseEntity<Historique> create(@Valid @RequestBody HistoriqueRequest request) {
        return ResponseEntity.ok(historiqueService.create(request));
    }

    @PutMapping("/{id}")
    public ResponseEntity<Historique> update(@PathVariable Long id, @Valid @RequestBody HistoriqueRequest request) {
        return ResponseEntity.ok(historiqueService.update(id, request));
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteById(@PathVariable Long id) {
        historiqueService.deleteById(id);
        return ResponseEntity.noContent().build();
    }
}
