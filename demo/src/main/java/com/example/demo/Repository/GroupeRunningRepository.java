package com.example.demo.repository;
import java.util.List;

import com.example.demo.entity.GroupeRunning;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.Optional;
import java.util.UUID;

public interface GroupeRunningRepository extends JpaRepository<GroupeRunning, Long> {

    /** Charge le groupe avec ses membres (pour les notifications FCM). */
    @Query("SELECT DISTINCT g FROM GroupeRunning g LEFT JOIN FETCH g.membres WHERE g.id = :id")
    Optional<GroupeRunning> findByIdWithMembres(@Param("id") Long id);

    Page<GroupeRunning> findByOrderByNomAsc(Pageable pageable);

    Page<GroupeRunning> findByNiveau(String niveau, Pageable pageable);

    @Query("SELECT g FROM GroupeRunning g JOIN g.membres m WHERE m.id = :adherentId")
    Page<GroupeRunning> findByMembreId(UUID adherentId, Pageable pageable);

    @Query("SELECT DISTINCT g FROM GroupeRunning g LEFT JOIN FETCH g.membres WHERE g IN (SELECT g2 FROM GroupeRunning g2 JOIN g2.membres m WHERE m.id = :adherentId)")
    List<GroupeRunning> findByMembreIdWithMembres(@Param("adherentId") UUID adherentId);

    Page<GroupeRunning> findByResponsableIdOrderByNomAsc(UUID responsableId, Pageable pageable);

    boolean existsByResponsableId(UUID responsableId);
}
