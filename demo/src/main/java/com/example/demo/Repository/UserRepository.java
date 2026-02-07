package com.example.demo.repository;

import com.example.demo.entity.Role;
import com.example.demo.entity.User;
import org.springframework.data.jpa.repository.JpaRepository;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

public interface UserRepository extends JpaRepository<User, UUID> {

    Optional<User> findByEmail(String email);

    /**
     * Pour la connexion : identifiant = nom (à rendre unique en base si besoin).
     */
    Optional<User> findByNom(String nom);

    boolean existsByEmail(String email);

    boolean existsByCin(Integer cin);

    List<User> findByRole(Role role);

    Page<User> findByRole(Role role, Pageable pageable);
}
