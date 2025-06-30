import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';
import '../services/api_service.dart';

class AuthProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  User? _currentUser;
  bool _isLoading = false;

  User? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  bool get isLoggedIn => _currentUser != null;

  Future<bool> login(String username, String password) async {
    _isLoading = true;
    notifyListeners();

    try {
      final user = await _apiService.login(username, password);
      _currentUser = user;
      
      // 로그인 정보 저장
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('userId', user.id);
      await prefs.setString('username', user.username);
      
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<bool> register(String username, String password) async {
    _isLoading = true;
    notifyListeners();

    try {
      final user = await _apiService.register(username, password);
      _currentUser = user;
      
      // 회원가입 후 자동 로그인
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('userId', user.id);
      await prefs.setString('username', user.username);
      
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> logout() async {
    _currentUser = null;
    
    // 저장된 로그인 정보 삭제
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('userId');
    await prefs.remove('username');
    
    notifyListeners();
  }

  Future<void> loadSavedUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('userId');
    final username = prefs.getString('username');
    
    if (userId != null && username != null) {
      _currentUser = User(id: userId, username: username);
      notifyListeners();
    }
  }
} 