package com.testapp.backend.controller;

import com.testapp.backend.dto.PostDto;
import com.testapp.backend.model.Post;
import com.testapp.backend.service.PostService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import jakarta.validation.Valid;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/posts")
@CrossOrigin(origins = "*")
public class PostController {

    @Autowired
    private PostService postService;

    @GetMapping
    public ResponseEntity<List<Post>> getAllPosts() {
        List<Post> posts = postService.getAllPosts();
        return ResponseEntity.ok(posts);
    }

    @GetMapping("/{id}")
    public ResponseEntity<?> getPostById(@PathVariable Long id) {
        return postService.getPostById(id)
                .map(post -> {
                    Map<String, Object> response = new HashMap<>();
                    response.put("id", post.getId());
                    response.put("title", post.getTitle());
                    response.put("content", post.getContent());
                    response.put("createdAt", post.getCreatedAt());
                    response.put("updatedAt", post.getUpdatedAt());
                    response.put("user", Map.of(
                            "id", post.getUser().getId(),
                            "username", post.getUser().getUsername()));
                    return ResponseEntity.ok(response);
                })
                .orElse(ResponseEntity.notFound().build());
    }

    @PostMapping
    public ResponseEntity<?> createPost(@Valid @RequestBody PostDto postDto, @RequestParam Long userId) {
        try {
            Post post = postService.createPost(postDto, userId);
            Map<String, Object> response = new HashMap<>();
            response.put("message", "Post created successfully");
            response.put("postId", post.getId());
            response.put("title", post.getTitle());
            return ResponseEntity.ok(response);
        } catch (RuntimeException e) {
            Map<String, String> error = new HashMap<>();
            error.put("error", e.getMessage());
            return ResponseEntity.badRequest().body(error);
        }
    }

    @PutMapping("/{id}")
    public ResponseEntity<?> updatePost(@PathVariable Long id, @Valid @RequestBody PostDto postDto,
            @RequestParam Long userId) {
        return postService.updatePost(id, postDto, userId)
                .map(post -> {
                    Map<String, Object> response = new HashMap<>();
                    response.put("message", "Post updated successfully");
                    response.put("postId", post.getId());
                    response.put("title", post.getTitle());
                    return ResponseEntity.ok(response);
                })
                .orElse(ResponseEntity.notFound().build());
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<?> deletePost(@PathVariable Long id, @RequestParam Long userId) {
        boolean deleted = postService.deletePost(id, userId);
        if (deleted) {
            Map<String, String> response = new HashMap<>();
            response.put("message", "Post deleted successfully");
            return ResponseEntity.ok(response);
        } else {
            return ResponseEntity.notFound().build();
        }
    }
}