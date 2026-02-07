package com.example.demo.entity;

import com.fasterxml.jackson.annotation.JsonIgnore;
import jakarta.persistence.*;
import lombok.*;
import org.hibernate.annotations.BatchSize;

import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

@Entity
@Table(name = "groupes_running")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class GroupeRunning {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false)
    private String nom;

    private String niveau;

    @Column(columnDefinition = "TEXT")
    private String description;

    /** Responsable du groupe (AdminGroupe) - relation 1-1. */
    @OneToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "responsable_id", unique = true)
    private User responsable;

    /** Adhérents du groupe - relation N-N (contient). BatchSize réduit le N+1 quand plusieurs groupes sont chargés. */
    @BatchSize(size = 20)
    @ManyToMany(fetch = FetchType.LAZY)
    @JoinTable(
            name = "groupe_adherents",
            joinColumns = @JoinColumn(name = "groupe_id"),
            inverseJoinColumns = @JoinColumn(name = "adherent_id")
    )
    @Builder.Default
    private List<User> membres = new ArrayList<>();

    @OneToMany(mappedBy = "groupe")
    @Builder.Default
    @JsonIgnore
    private List<Evenement> evenements = new ArrayList<>();

    @OneToMany(mappedBy = "groupe")
    @Builder.Default
    @JsonIgnore
    private List<ProgrammeEntrainement> programmes = new ArrayList<>();
}
