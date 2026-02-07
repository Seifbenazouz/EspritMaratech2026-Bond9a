package com.example.demo.controller;

import com.example.demo.dto.PermissionRequest;
import com.example.demo.entity.Permission;
import com.example.demo.service.PermissionService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/permissions")
@RequiredArgsConstructor
public class PermissionController {

    private final PermissionService permissionService;

    @GetMapping
    public ResponseEntity<Page<Permission>> findAll(Pageable pageable) {
        return ResponseEntity.ok(permissionService.findAll(pageable));
    }

    @GetMapping("/{id}")
    public ResponseEntity<Permission> findById(@PathVariable Long id) {
        return ResponseEntity.ok(permissionService.findById(id));
    }

    @GetMapping("/nom/{nom}")
    public ResponseEntity<Permission> findByNom(@PathVariable String nom) {
        return ResponseEntity.ok(permissionService.findByNom(nom));
    }

    @PostMapping
    public ResponseEntity<Permission> create(@Valid @RequestBody PermissionRequest request) {
        return ResponseEntity.ok(permissionService.create(request));
    }

    @PutMapping("/{id}")
    public ResponseEntity<Permission> update(@PathVariable Long id, @Valid @RequestBody PermissionRequest request) {
        return ResponseEntity.ok(permissionService.update(id, request));
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteById(@PathVariable Long id) {
        permissionService.deleteById(id);
        return ResponseEntity.noContent().build();
    }
}
