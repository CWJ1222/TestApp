import 'package:flutter/material.dart';
import '../models/post.dart';
import '../services/api_service.dart';

class PostProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  List<Post> _posts = [];
  Post? _selectedPost;
  bool _isLoading = false;

  List<Post> get posts => _posts;
  Post? get selectedPost => _selectedPost;
  bool get isLoading => _isLoading;

  Future<void> loadPosts() async {
    _isLoading = true;
    notifyListeners();

    try {
      _posts = await _apiService.getAllPosts();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> loadPost(int id) async {
    _isLoading = true;
    notifyListeners();

    try {
      _selectedPost = await _apiService.getPost(id);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> createPost(String title, String content, int userId) async {
    _isLoading = true;
    notifyListeners();

    try {
      final newPost = await _apiService.createPost(title, content, userId);
      
      // 새 게시글을 목록 맨 앞에 추가
      _posts.insert(0, newPost);
      
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> updatePost(int id, String title, String content, int userId) async {
    _isLoading = true;
    notifyListeners();

    try {
      final updatedPost = await _apiService.updatePost(id, title, content, userId);
      
      // 목록에서 업데이트
      final index = _posts.indexWhere((post) => post.id == id);
      if (index != -1) {
        _posts[index] = updatedPost;
      }
      
      // 선택된 게시글 업데이트
      if (_selectedPost?.id == id) {
        _selectedPost = updatedPost;
      }
      
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> deletePost(int id, int userId) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _apiService.deletePost(id, userId);
      
      // 목록에서 삭제
      _posts.removeWhere((post) => post.id == id);
      
      // 선택된 게시글 삭제
      if (_selectedPost?.id == id) {
        _selectedPost = null;
      }
      
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  void clearSelectedPost() {
    _selectedPost = null;
    notifyListeners();
  }
} 