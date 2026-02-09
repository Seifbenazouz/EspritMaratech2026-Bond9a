package com.example.demo.dto;

import com.example.demo.entity.Role;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.UUID;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class LoginResponse {

    private String token;
    private String type = "Bearer";
    private UUID id;
    private String nom;
    private String prenom;
    private String email;
    private Role role;
    /** true si l'utilisateur doit changer son mot de passe (premier login après création par admin). */
    private Boolean passwordChangeRequired;
}
