package com.example.demo.repository;

import com.example.demo.entity.ProgrammeEntrainement;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;

import java.time.Instant;

public interface ProgrammeEntrainementRepository extends JpaRepository<ProgrammeEntrainement, Long> {

    Page<ProgrammeEntrainement> findByGroupeIdOrderByDateDebutDesc(Long groupeId, Pageable pageable);

    Page<ProgrammeEntrainement> findByDateDebutBetweenOrderByDateDebutDesc(Instant debut, Instant fin, Pageable pageable);
}
