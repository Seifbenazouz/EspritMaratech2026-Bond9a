package com.example.demo.repository;

import com.example.demo.entity.Evenement;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.EntityGraph;

import java.time.Instant;
import java.util.List;

public interface EvenementRepository extends JpaRepository<Evenement, Long> {

    /** Charge les événements avec groupe et historique en une requête (évite N+1). */
    @EntityGraph(attributePaths = {"groupe", "historique"})
    @Override
    Page<Evenement> findAll(Pageable pageable);

    Page<Evenement> findByGroupeIdOrderByDateDesc(Long groupeId, Pageable pageable);

    Page<Evenement> findByDateBetweenOrderByDateDesc(Instant debut, Instant fin, Pageable pageable);

    Page<Evenement> findByTypeOrderByDateDesc(String type, Pageable pageable);

    /** Événements dans la plage [debut, fin] n’ayant pas encore reçu le rappel 1h. */
    List<Evenement> findByDateBetweenAndRappel1hEnvoyeFalseOrderByDateAsc(Instant debut, Instant fin);

    /** Événements dans la plage [debut, fin] n’ayant pas encore reçu le rappel 24h. */
    List<Evenement> findByDateBetweenAndRappel24hEnvoyeFalseOrderByDateAsc(Instant debut, Instant fin);
}
