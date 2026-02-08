package com.example.demo.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.UUID;

/**
 * Partenaire de running proposé par le matching IA.
 */
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class PartnerMatchDto {

    private UUID id;
    private String nom;
    private String prenom;
    private String email;
    /** Pace moyen en min/km (null si pas de sessions). */
    private Double paceMoyenMinPerKm;
    private String groupeNom;
    private String groupeNiveau;
    private int score;
    private String scoreDetail;
}
