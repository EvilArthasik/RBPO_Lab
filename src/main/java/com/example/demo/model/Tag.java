package com.example.demo.model;

import lombok.Data;

@Data
public class Tag {
    private Long id;
    private String name;
    private String color; // Например, "#FF0000"
}