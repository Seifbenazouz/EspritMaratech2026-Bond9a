package com.example.demo.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.Instant;
import java.util.UUID;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class NotificationRequest {

    @NotBlank(message = "Le message est requis")
    private String message;

    private Instant dateEnvoi;

    private String type;

    @NotNull(message = "L'identifiant de l'utilisateur est requis")
    private UUID utilisateurId;
}
