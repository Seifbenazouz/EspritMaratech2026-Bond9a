package com.example.demo.dto;

import jakarta.validation.constraints.NotNull;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.UUID;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class ParticipationRequest {

    private String statut;

    @NotNull(message = "L'identifiant de l'adhérent est requis")
    private UUID adherentId;

    @NotNull(message = "L'identifiant de l'événement est requis")
    private Long evenementId;
}
