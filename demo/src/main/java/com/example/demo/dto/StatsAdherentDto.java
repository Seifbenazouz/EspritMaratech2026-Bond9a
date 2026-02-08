package com.example.demo.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * Statistiques de course d'un adhérent (km, pace, nombre de sorties, etc.).
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class StatsAdherentDto {

    /** Distance totale parcourue en km. */
    private Double totalDistanceKm;

    /** Nombre de sorties enregistrées. */
    private Integer nbSorties;

    /** Pace moyen en min/km (null si aucune distance). */
    private Double paceMoyenMinPerKm;

    /** Nombre d'événements participés. */
    private Integer nbEvenements;

    /** Plus longue sortie en km (null si aucune). */
    private Double plusLongueSortieKm;

    /** Meilleur pace en min/km (null si aucune sortie avec distance > 0). */
    private Double meilleurPaceMinPerKm;
}
