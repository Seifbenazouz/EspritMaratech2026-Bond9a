package com.example.demo.controller;

import com.example.demo.dto.SessionCourseRequest;
import com.example.demo.entity.SessionCourse;
import com.example.demo.service.SessionCourseService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/sessions-course")
@RequiredArgsConstructor
public class SessionCourseController {

    private final SessionCourseService sessionCourseService;

    /** Mes sessions (adhérent connecté). */
    @GetMapping("/me")
    public ResponseEntity<Page<SessionCourse>> getMySessions(
            @AuthenticationPrincipal UserDetails user,
            Pageable pageable) {
        if (user == null) {
            return ResponseEntity.status(401).build();
        }
        return ResponseEntity.ok(sessionCourseService.findMySessions(user.getUsername(), pageable));
    }

    @GetMapping("/{id}")
    public ResponseEntity<SessionCourse> getById(@PathVariable Long id) {
        return ResponseEntity.ok(sessionCourseService.findById(id));
    }

    /** Enregistrer une nouvelle session (GPS / sortie). */
    @PostMapping
    public ResponseEntity<SessionCourse> create(
            @AuthenticationPrincipal UserDetails user,
            @Valid @RequestBody SessionCourseRequest request) {
        if (user == null) {
            return ResponseEntity.status(401).build();
        }
        return ResponseEntity.ok(sessionCourseService.create(user.getUsername(), request));
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteById(@PathVariable Long id) {
        sessionCourseService.deleteById(id);
        return ResponseEntity.noContent().build();
    }
}
