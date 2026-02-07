package com.example.demo.controller;

import com.example.demo.entity.Actualite;
import com.example.demo.entity.Historique;
import com.example.demo.service.ActualiteService;
import com.example.demo.service.HistoriqueService;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.PageRequest;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import org.springframework.data.domain.Page;

/**
 * Endpoints publics pour les visiteurs (sans login) : historique et actualités.
 */
@RestController
@RequestMapping("/api/public")
@RequiredArgsConstructor
public class PublicController {

    private final HistoriqueService historiqueService;
    private final ActualiteService actualiteService;

    @GetMapping("/historique")
    public ResponseEntity<Page<Historique>> historique(
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "20") int size) {
        return ResponseEntity.ok(historiqueService.findAll(PageRequest.of(page, size)));
    }

    @GetMapping("/news")
    public ResponseEntity<Page<Actualite>> news(
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "20") int size) {
        return ResponseEntity.ok(actualiteService.findAll(PageRequest.of(page, size)));
    }
}
