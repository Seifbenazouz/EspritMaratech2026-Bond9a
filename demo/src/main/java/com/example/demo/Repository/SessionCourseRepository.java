package com.example.demo.repository;

import com.example.demo.entity.SessionCourse;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.UUID;

public interface SessionCourseRepository extends JpaRepository<SessionCourse, Long> {

    @org.springframework.data.jpa.repository.EntityGraph(attributePaths = {"evenement"})
    Page<SessionCourse> findByAdherentIdOrderByStartedAtDesc(UUID adherentId, Pageable pageable);

    Page<SessionCourse> findByEvenementIdOrderByStartedAtDesc(Long evenementId, Pageable pageable);
}
