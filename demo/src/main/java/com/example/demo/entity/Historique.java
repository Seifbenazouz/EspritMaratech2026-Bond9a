package com.example.demo.entity;

import jakarta.persistence.*;
import lombok.*;

import java.time.Instant;

@Entity
@Table(name = "historiques")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Historique {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private Instant date;

    @OneToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "evenement_id", unique = true, nullable = false)
    private Evenement evenement;
}
