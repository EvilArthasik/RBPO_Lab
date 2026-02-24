package com.example.demo.repository;

import com.example.demo.model.Task;
import org.springframework.stereotype.Repository;
import java.util.*;
import java.util.concurrent.atomic.AtomicLong;

@Repository
public class TaskRepository {
    private final Map<Long, Task> tasks = new HashMap<>();
    private final AtomicLong counter = new AtomicLong();

    public Task save(Task task) {
        if (task.getId() == null) {
            task.setId(counter.incrementAndGet());
        }
        tasks.put(task.getId(), task);
        return task;
    }

    public Optional<Task> findById(Long id) {
        return Optional.ofNullable(tasks.get(id));
    }

    public List<Task> findAll() {
        return new ArrayList<>(tasks.values());
    }

    public void deleteById(Long id) {
        tasks.remove(id);
    }
}