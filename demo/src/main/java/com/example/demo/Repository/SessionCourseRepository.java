package com.example.demo.repository;

import com.example.demo.entity.SessionCourse;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.UUID;

public interface SessionCourseRepository extends JpaRepository<SessionCourse, Long> {

    List<SessionCourse> findAllByAdherent_IdOrderByStartedAtDesc(UUID adherentId);

    @org.springframework.data.jpa.repository.EntityGraph(attributePaths = {"evenement"})
    Page<SessionCourse> findByAdherentIdOrderByStartedAtDesc(UUID adherentId, Pageable pageable);

    Page<SessionCourse> findByEvenementIdOrderByStartedAtDesc(Long evenementId, Pageable pageable);
}
