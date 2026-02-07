package com.example.demo.entity;

/**
 * Rôles du système :
 * - ADMIN_PRINCIPAL : Comité directrice - Gestion des rôles/permissions, CRUD utilisateurs et admins
 * - ADMIN_COACH : Affichage et partage des programmes aux adhérents
 * - ADMIN_GROUPE : Responsable de groupe - Affectation/suppression des utilisateurs aux groupes de running
 * - ADHERENT : Adhérent (membre)
 * Les visiteurs n'ont pas de compte (accès public historique et news).
 */
public enum Role {
    ADMIN_PRINCIPAL,
    ADMIN_COACH,
    ADMIN_GROUPE,
    ADHERENT
}
