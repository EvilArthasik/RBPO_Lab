package com.example.demo.controller;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api")
public class HelloController {

    // Простой GET запрос
    @GetMapping("/hello")
    public String sayHello() {
        return "Привет! Spring Boot 3 работает.";
    }

    // GET запрос с параметром
    @GetMapping("/greet")
    public String greetUser(@RequestParam String name) {
        return "Привет, " + name + "!";
    }

    // POST запрос с JSON телом
    @PostMapping("/echo")
    public String echoMessage(@RequestBody String message) {
        return "Вы отправили: " + message;
    }
}