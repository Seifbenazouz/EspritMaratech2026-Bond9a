package com.example.demo.entity;

import jakarta.persistence.*;
import lombok.*;

import java.time.Instant;
import java.util.UUID;

/**
 * Session de course enregistrée (optionnellement liée à un événement).
 * Permet le suivi GPS : distance, durée, tracé (points lat/lng en JSON).
 */
@Entity
@Table(name = "sessions_course")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class SessionCourse {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "adherent_id", nullable = false)
    private User adherent;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "evenement_id")
    private Evenement evenement;

    /** Distance parcourue en kilomètres. */
    @Column(name = "distance_km", nullable = false)
    private Double distanceKm;

    /** Durée en secondes. */
    @Column(name = "duration_seconds", nullable = false)
    private Long durationSeconds;

    @Column(name = "started_at", nullable = false)
    private Instant startedAt;

    /** Tracé GPS au format JSON : tableau de { "lat": number, "lng": number }. */
    @Column(name = "track", columnDefinition = "TEXT")
    private String track;
}
