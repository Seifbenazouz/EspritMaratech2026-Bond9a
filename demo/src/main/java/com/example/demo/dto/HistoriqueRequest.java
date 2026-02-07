package com.example.demo.dto;

import jakarta.validation.constraints.NotNull;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.Instant;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class HistoriqueRequest {

    private Instant date;

    @NotNull(message = "L'identifiant de l'événement est requis")
    private Long evenementId;
}
