package com.example.demo.entity;

import jakarta.persistence.*;
import lombok.*;

import java.time.Instant;

@Entity
@Table(name = "evenements")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Evenement {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false)
    private String titre;

    @Column(columnDefinition = "TEXT")
    private String description;

    private Instant date;

    private String type;

    /** Lieu de rencontre / localisation de l'événement (adresse ou nom du lieu). */
    @Column(name = "lieu")
    private String lieu;

    /** Latitude (optionnel, pour affichage carte). */
    private Double latitude;

    /** Longitude (optionnel, pour affichage carte). */
    private Double longitude;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "groupe_id", nullable = false)
    private GroupeRunning groupe;

    @OneToOne(mappedBy = "evenement", cascade = CascadeType.ALL, orphanRemoval = true)
    private Historique historique;

    /** Rappel « 1h avant » déjà envoyé (évite doublons). */
    @Column(name = "rappel_1h_envoye", nullable = false, columnDefinition = "boolean not null default false")
    private boolean rappel1hEnvoye = false;

    /** Rappel « 24h avant » déjà envoyé (évite doublons). */
    @Column(name = "rappel_24h_envoye", nullable = false, columnDefinition = "boolean not null default false")
    private boolean rappel24hEnvoye = false;
}
