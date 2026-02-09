package com.example.demo.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;
import lombok.Data;

@Data
public class ChangePasswordRequest {

    @NotBlank(message = "Mot de passe actuel requis")
    private String currentPassword;

    @NotBlank(message = "Nouveau mot de passe requis")
    @Size(min = 8, message = "Le mot de passe doit contenir au moins 8 caractères")
    private String newPassword;
}
