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
public class ProgrammeEntrainementRequest {

    @NotBlank(message = "Le titre est requis")
    private String titre;

    private String description;

    private Instant dateDebut;

    private Instant dateFin;

    @NotNull(message = "L'identifiant du groupe est requis")
    private Long groupeId;
}
