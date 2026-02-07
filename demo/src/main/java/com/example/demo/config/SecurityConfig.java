package com.example.demo.config;

import com.example.demo.security.JwtAuthFilter;
import lombok.RequiredArgsConstructor;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.http.HttpMethod;
import org.springframework.security.config.annotation.method.configuration.EnableMethodSecurity;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.annotation.web.configurers.AbstractHttpConfigurer;
import org.springframework.security.config.http.SessionCreationPolicy;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;
import org.springframework.web.cors.CorsConfiguration;
import org.springframework.web.cors.CorsConfigurationSource;
import org.springframework.web.cors.UrlBasedCorsConfigurationSource;

import jakarta.servlet.http.HttpServletResponse;
import java.util.List;

@Configuration
@EnableWebSecurity
@EnableMethodSecurity
@RequiredArgsConstructor
public class SecurityConfig {

    private final JwtAuthFilter jwtAuthFilter;

    @Bean
    public CorsConfigurationSource corsConfigurationSource() {
        CorsConfiguration config = new CorsConfiguration();
        // Flutter web / autres clients : localhost avec ports variables
        config.setAllowedOriginPatterns(List.of(
                "http://localhost:*",
                "http://127.0.0.1:*",
                "http://10.0.2.2:*",
                "http://10.*.*.*:*"
        ));
        config.setAllowedMethods(List.of("GET", "POST", "PUT", "DELETE", "OPTIONS"));
        config.setAllowedHeaders(List.of("*"));
        config.setAllowCredentials(true);
        UrlBasedCorsConfigurationSource source = new UrlBasedCorsConfigurationSource();
        source.registerCorsConfiguration("/api/**", config);
        return source;
    }

    @Bean
    public SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception {
        http
                .cors(c -> c.configurationSource(corsConfigurationSource()))
                .csrf(AbstractHttpConfigurer::disable)
                .sessionManagement(s -> s
                        .sessionCreationPolicy(SessionCreationPolicy.STATELESS))
                .authorizeHttpRequests(auth -> auth
                        // Public : visiteurs (historique, news) – pas de login
                        .requestMatchers("/api/public/**").permitAll()
                        // Auth
                        .requestMatchers("/api/auth/login").permitAll()
                        .requestMatchers("/api/auth/register").permitAll()
                        // Liste adhérents : Admin principal et Admin groupe (pour affectation aux groupes)
                        .requestMatchers(HttpMethod.GET, "/api/users/adherents").hasAnyRole("ADMIN_PRINCIPAL", "ADMIN_GROUPE")
                        // Diagnostic FCM : vérifier si un utilisateur a un token enregistré
                        .requestMatchers(HttpMethod.GET, "/api/users/*/fcm-token-registered").hasAnyRole("ADMIN_PRINCIPAL", "ADMIN_GROUPE")
                        // Envoi notification de test (admin / admin groupe)
                        .requestMatchers(HttpMethod.POST, "/api/users/*/send-test-notification").hasAnyRole("ADMIN_PRINCIPAL", "ADMIN_GROUPE")
                        // Admin principal uniquement : gestion utilisateurs et permissions
                        .requestMatchers("/api/users/**", "/api/permissions/**").hasRole("ADMIN_PRINCIPAL")
                        // Reste : tout utilisateur connecté (rôles affinés en @PreAuthorize sur les controllers)
                        .anyRequest().authenticated()
                )
                .exceptionHandling(e -> e
                        // 401 si token absent/invalide/expiré (au lieu de 403)
                        .authenticationEntryPoint((req, res, ex) -> {
                            res.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
                            res.setContentType("application/json");
                            res.getWriter().write("{\"error\":\"Unauthorized\",\"message\":\"Token manquant, invalide ou expiré. Reconnectez-vous.\"}");
                        })
                )
                .addFilterBefore(jwtAuthFilter, UsernamePasswordAuthenticationFilter.class);

        return http.build();
    }

    @Bean
    public PasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder();
    }
}
