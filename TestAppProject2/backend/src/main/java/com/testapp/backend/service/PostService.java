package com.testapp.backend.service;

import com.testapp.backend.dto.PostDto;
import com.testapp.backend.model.Post;
import com.testapp.backend.model.User;
import com.testapp.backend.repository.PostRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
public class PostService {

    @Autowired
    private PostRepository postRepository;

    @Autowired
    private UserService userService;

    public List<Post> getAllPosts() {
        return postRepository.findAllWithUserOrderByCreatedAtDesc();
    }

    public Optional<Post> getPostById(Long id) {
        return postRepository.findById(id);
    }

    public Post createPost(PostDto postDto, Long userId) {
        User user = userService.getUserById(userId)
                .orElseThrow(() -> new RuntimeException("User not found"));

        Post post = new Post(postDto.getTitle(), postDto.getContent(), user);
        return postRepository.save(post);
    }

    public Optional<Post> updatePost(Long id, PostDto postDto, Long userId) {
        return postRepository.findById(id)
                .filter(post -> post.getUser().getId().equals(userId))
                .map(post -> {
                    post.setTitle(postDto.getTitle());
                    post.setContent(postDto.getContent());
                    return postRepository.save(post);
                });
    }

    public boolean deletePost(Long id, Long userId) {
        return postRepository.findById(id)
                .filter(post -> post.getUser().getId().equals(userId))
                .map(post -> {
                    postRepository.delete(post);
                    return true;
                })
                .orElse(false);
    }
}