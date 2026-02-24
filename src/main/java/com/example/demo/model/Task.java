package com.example.demo.model;

import lombok.Data;
import java.time.LocalDateTime;

@Data
public class Task {
    private Long id;
    private String title;
    private String description;
    private TaskStatus status;
    private Long userId;       // ID назначенного пользователя
    private Long projectId;    // ID проекта
    private LocalDateTime createdAt;

    public Task() {
        this.createdAt = LocalDateTime.now();
        this.status = TaskStatus.OPEN;
    }

    public enum TaskStatus {
        OPEN, IN_PROGRESS, DONE
    }
}