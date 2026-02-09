package com.example.demo.entity;

import com.fasterxml.jackson.annotation.JsonIgnore;
import jakarta.persistence.*;
import lombok.*;

import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

@Entity
@Table(name = "users")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class User {

    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;

    @Column(nullable = false)
    private String nom;

    @Column(nullable = false)
    private String prenom;

    @Column(unique = true, nullable = false)
    private String email;

    private Integer phone;

    @Column(nullable = false, unique = true)
    private Integer cin;

    @Column(nullable = false)
    @JsonIgnore
    private String password; // hash BCrypt des 3 derniers chiffres du CIN

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private Role role;

    /** Token FCM pour les notifications push (un par appareil, le dernier utilisé). */
    @Column(name = "fcm_token", length = 512)
    private String fcmToken;

    /** Premier login : l'utilisateur doit changer son mot de passe (créé par admin avec CIN). */
    @Column(name = "password_change_required")
    private Boolean passwordChangeRequired;

    /** Notifications reçues par l'utilisateur (relation 1-N). */
    @OneToMany(mappedBy = "utilisateur", cascade = CascadeType.ALL, orphanRemoval = true)
    @Builder.Default
    @JsonIgnore
    private List<Notification> notifications = new ArrayList<>();

    /**
     * Retourne les 3 derniers chiffres du CIN (pour validation côté métier si besoin).
     */
    public String getLastThreeDigitsOfCin() {
        if (cin == null) return "";
        return String.format("%03d", Math.abs(cin) % 1000);
    }
}
