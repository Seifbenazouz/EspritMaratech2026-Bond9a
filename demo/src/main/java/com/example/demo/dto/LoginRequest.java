package com.example.demo.dto;

import jakarta.validation.constraints.NotBlank;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class LoginRequest {

    @NotBlank(message = "Le nom est requis")
    private String nom;

    /**
     * Les 3 derniers chiffres du numéro CIN.
     */
    @NotBlank(message = "Le mot de passe (3 derniers chiffres CIN) est requis")
    private String password;
}
