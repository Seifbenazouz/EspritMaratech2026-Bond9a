package com.example.demo.repository;

import com.example.demo.entity.Actualite;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;

import java.time.Instant;

public interface ActualiteRepository extends JpaRepository<Actualite, Long> {

    Page<Actualite> findByOrderByDatePublicationDesc(Pageable pageable);

    Page<Actualite> findByDatePublicationBetweenOrderByDatePublicationDesc(Instant debut, Instant fin, Pageable pageable);
}
