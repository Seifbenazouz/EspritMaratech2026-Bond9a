package com.example.demo.dto;

import jakarta.validation.constraints.NotBlank;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;
import java.util.UUID;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class GroupeRunningRequest {

    @NotBlank(message = "Le nom du groupe est requis")
    private String nom;

    private String niveau;

    private String description;

    private UUID responsableId;

    private List<UUID> membreIds;
}
