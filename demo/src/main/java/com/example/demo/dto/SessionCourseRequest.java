package com.example.demo.dto;

import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Positive;
import jakarta.validation.constraints.PositiveOrZero;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.Instant;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class SessionCourseRequest {

    @NotNull(message = "La distance est requise")
    @PositiveOrZero
    private Double distanceKm;

    @NotNull(message = "La durée est requise")
    @Positive(message = "La durée doit être positive")
    private Long durationSeconds;

    @NotNull(message = "La date de début est requise")
    private Instant startedAt;

    /** Id de l'événement si la session est liée à un événement du club. */
    private Long evenementId;

    /** Tracé GPS en JSON : tableau de { "lat": number, "lng": number }. */
    private String track;
}
