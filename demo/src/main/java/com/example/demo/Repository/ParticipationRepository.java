package com.example.demo.repository;

import com.example.demo.entity.Participation;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.EntityGraph;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;
import java.util.UUID;

public interface ParticipationRepository extends JpaRepository<Participation, Long> {

    long countByAdherent_Id(UUID adherentId);

    Optional<Participation> findByAdherentIdAndEvenementId(UUID adherentId, Long evenementId);

    boolean existsByAdherentIdAndEvenementId(UUID adherentId, Long evenementId);

    @EntityGraph(attributePaths = {"evenement"})
    Page<Participation> findByAdherentIdOrderByDateInscriptionDesc(UUID adherentId, Pageable pageable);

    Page<Participation> findByEvenementId(Long evenementId, Pageable pageable);
}
