package com.testapp.backend.service;

import com.testapp.backend.dto.UserDto;
import com.testapp.backend.model.User;
import com.testapp.backend.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.Optional;

@Service
public class UserService {

    @Autowired
    private UserRepository userRepository;

    public User registerUser(UserDto userDto) {
        if (userRepository.existsByUsername(userDto.getUsername())) {
            throw new RuntimeException("Username already exists");
        }

        User user = new User(userDto.getUsername(), userDto.getPassword());
        return userRepository.save(user);
    }

    public Optional<User> loginUser(UserDto userDto) {
        return userRepository.findByUsername(userDto.getUsername())
                .filter(user -> user.getPassword().equals(userDto.getPassword()));
    }

    public Optional<User> getUserById(Long id) {
        return userRepository.findById(id);
    }

    public Optional<User> getUserByUsername(String username) {
        return userRepository.findByUsername(username);
    }
}