package com.example.demo.service;

import com.google.auth.oauth2.GoogleCredentials;
import com.google.firebase.FirebaseApp;
import com.google.firebase.FirebaseOptions;
import com.google.firebase.messaging.FirebaseMessaging;
import com.google.firebase.messaging.FirebaseMessagingException;
import com.google.firebase.messaging.MulticastMessage;
import com.google.firebase.messaging.Notification;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import jakarta.annotation.PostConstruct;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.util.List;
import java.util.stream.Collectors;

/**
 * Service d'envoi de notifications push via Firebase Cloud Messaging.
 * Nécessite firebase.service-account-path dans application.properties
 * (fichier JSON téléchargé depuis Firebase Console > Paramètres du projet > Comptes de service).
 */
@Service
@Slf4j
public class FcmService {

    @Value("${firebase.service-account-path:}")
    private String serviceAccountPath;

    private boolean initialized = false;

    public boolean isInitialized() {
        return initialized;
    }

    @PostConstruct
    public void init() {
        if (serviceAccountPath == null || serviceAccountPath.isBlank()) {
            log.warn("FCM: firebase.service-account-path non configuré - notifications push DÉSACTIVÉES");
            return;
        }
        try {
            InputStream stream = openServiceAccountStream(serviceAccountPath);
            if (stream == null) {
                log.warn("FCM: Fichier JSON introuvable (classpath puis fichier): {} - notifications DÉSACTIVÉES", serviceAccountPath);
                return;
            }
            try (stream) {
                FirebaseOptions options = FirebaseOptions.builder()
                        .setCredentials(GoogleCredentials.fromStream(stream))
                        .build();
                FirebaseApp.initializeApp(options);
                initialized = true;
                log.info("FCM: Firebase Admin initialisé - notifications push ACTIVÉES");
            }
        } catch (IOException e) {
            log.warn("FCM: Impossible d'initialiser Firebase Admin: {} - notifications DÉSACTIVÉES", e.getMessage());
        } catch (Exception e) {
            log.warn("FCM: Fichier JSON invalide ou vide ({}). Vérifiez le fichier Firebase - notifications DÉSACTIVÉES. Erreur: {}", serviceAccountPath, e.getMessage());
        }
    }

    /** Charge le fichier JSON : d'abord depuis le classpath (src/main/resources), sinon en fichier. */
    private InputStream openServiceAccountStream(String path) throws IOException {
        InputStream fromClasspath = getClass().getClassLoader().getResourceAsStream(path);
        if (fromClasspath != null) return fromClasspath;
        File file = new File(path);
        if (file.isFile()) return new FileInputStream(file);
        return null;
    }

    /**
     * Envoie une notification push à une liste de tokens FCM.
     */
    public void sendToTokens(List<String> tokens, String title, String body) {
        if (!initialized) {
            log.warn("FCM: sendToTokens ignoré - Firebase non initialisé (vérifier firebase.service-account-path et le fichier JSON)");
            return;
        }
        if (tokens == null || tokens.isEmpty()) {
            log.warn("FCM: sendToTokens ignoré - liste de tokens vide");
            return;
        }
        List<String> validTokens = tokens.stream()
                .filter(t -> t != null && !t.isBlank())
                .collect(Collectors.toList());
        if (validTokens.isEmpty()) {
            log.warn("FCM: sendToTokens ignoré - aucun token valide après filtrage");
            return;
        }

        try {
            MulticastMessage message = MulticastMessage.builder()
                    .setNotification(Notification.builder()
                            .setTitle(title)
                            .setBody(body)
                            .build())
                    .addAllTokens(validTokens)
                    .build();

            var response = FirebaseMessaging.getInstance().sendEachForMulticast(message);
            log.info("FCM: \"{}\" -> {} envoyée(s), {} échec(s)", title, response.getSuccessCount(), response.getFailureCount());
            if (response.getFailureCount() > 0) {
                response.getResponses().forEach(r -> {
                    if (!r.isSuccessful()) {
                        log.warn("FCM échec: {}", r.getException() != null ? r.getException().getMessage() : "inconnu");
                    }
                });
            }
        } catch (FirebaseMessagingException e) {
            log.error("FCM: Erreur d'envoi: {}", e.getMessage());
        }
    }
}
