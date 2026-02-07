package com.example.demo.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.Instant;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class EvenementRequest {

    @NotBlank(message = "Le titre est requis")
    private String titre;

    private String description;

    private Instant date;

    private String type;

    /** Lieu de rencontre / localisation (adresse ou nom du lieu). */
    private String lieu;

    private Double latitude;
    private Double longitude;

    @NotNull(message = "L'identifiant du groupe est requis")
    private Long groupeId;
}
