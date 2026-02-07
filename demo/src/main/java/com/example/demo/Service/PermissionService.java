package com.example.demo.service;

import com.example.demo.dto.PermissionRequest;
import com.example.demo.entity.Permission;
import com.example.demo.exception.ResourceNotFoundException;
import com.example.demo.repository.PermissionRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@RequiredArgsConstructor
public class PermissionService {

    private final PermissionRepository permissionRepository;

    public Page<Permission> findAll(Pageable pageable) {
        return permissionRepository.findAll(pageable);
    }

    public Permission findById(Long id) {
        return permissionRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Permission", id));
    }

    public Permission findByNom(String nom) {
        return permissionRepository.findByNom(nom)
                .orElseThrow(() -> new ResourceNotFoundException("Permission avec nom " + nom));
    }

    @Transactional
    public Permission create(PermissionRequest request) {
        if (permissionRepository.existsByNom(request.getNom())) {
            throw new IllegalArgumentException("Une permission avec ce nom existe déjà");
        }
        Permission permission = Permission.builder()
                .nom(request.getNom())
                .description(request.getDescription())
                .build();
        return permissionRepository.save(permission);
    }

    @Transactional
    public Permission update(Long id, PermissionRequest request) {
        Permission permission = findById(id);
        if (!permission.getNom().equals(request.getNom()) && permissionRepository.existsByNom(request.getNom())) {
            throw new IllegalArgumentException("Une permission avec ce nom existe déjà");
        }
        permission.setNom(request.getNom());
        permission.setDescription(request.getDescription());
        return permissionRepository.save(permission);
    }

    @Transactional
    public void deleteById(Long id) {
        if (!permissionRepository.existsById(id)) {
            throw new ResourceNotFoundException("Permission", id);
        }
        permissionRepository.deleteById(id);
    }
}
