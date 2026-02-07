package com.example.demo.dto;

import jakarta.validation.constraints.NotBlank;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.Instant;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class ActualiteRequest {

    @NotBlank(message = "Le titre est requis")
    private String titre;

    private String contenu;

    private Instant datePublication;
}
