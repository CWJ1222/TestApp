import 'dart:convert';
import 'package:dio/dio.dart';
import '../models/user.dart';
import '../models/post.dart';

class ApiService {
  static const String baseUrl = 'http://192.168.111.80:8080/api';
  final Dio _dio = Dio();

  ApiService() {
    _dio.options.baseUrl = baseUrl;
    _dio.options.headers = {
      'Content-Type': 'application/json',
    };
    
    // 400 상태 코드도 정상 응답으로 처리하도록 설정
    _dio.options.validateStatus = (status) {
      return status != null && status < 500;
    };
    
    // 디버깅을 위한 인터셉터 추가
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        print('🌐 API Request: ${options.method} ${options.path}');
        print('📤 Request Data: ${options.data}');
        handler.next(options);
      },
      onResponse: (response, handler) {
        print('✅ API Response: ${response.statusCode}');
        print('📥 Response Data: ${response.data}');
        handler.next(response);
      },
      onError: (error, handler) {
        print('❌ API Error: ${error.message}');
        print('🔍 Error Response: ${error.response?.data}');
        handler.next(error);
      },
    ));
  }

  // User API
  Future<User> register(String username, String password) async {
    try {
      print('🔄 Registering user: $username');
      final response = await _dio.post('/users/register', data: {
        'username': username,
        'password': password,
      });
      
      print('📋 Register response: ${response.data}');
      
      // 400 상태 코드인 경우 에러 처리
      if (response.statusCode == 400) {
        final data = response.data;
        if (data is Map && data.containsKey('error')) {
          throw data['error'];
        }
        throw '회원가입에 실패했습니다.';
      }
      
      // 백엔드 응답 형식에 맞게 수정
      final data = response.data;
      return User(
        id: data['userId'], // userId로 반환됨
        username: data['username'],
      );
    } catch (e) {
      print('💥 Register error: $e');
      if (e is String) {
        throw e; // 이미 처리된 에러 메시지
      }
      throw _handleError(e);
    }
  }

  Future<User> login(String username, String password) async {
    try {
      print('🔄 Logging in user: $username');
      final response = await _dio.post('/users/login', data: {
        'username': username,
        'password': password,
      });
      
      print('📋 Login response: ${response.data}');
      
      // 400 상태 코드인 경우 에러 처리
      if (response.statusCode == 400) {
        final data = response.data;
        if (data is Map && data.containsKey('error')) {
          throw data['error'];
        }
        throw '로그인에 실패했습니다.';
      }
      
      // 백엔드 응답 형식에 맞게 수정
      final data = response.data;
      return User(
        id: data['userId'], // userId로 반환됨
        username: data['username'],
      );
    } catch (e) {
      print('💥 Login error: $e');
      if (e is String) {
        throw e; // 이미 처리된 에러 메시지
      }
      throw _handleError(e);
    }
  }

  Future<User> getUser(int id) async {
    try {
      final response = await _dio.get('/users/$id');
      return User.fromJson(response.data);
    } catch (e) {
      throw _handleError(e);
    }
  }

  // Post API
  Future<List<Post>> getAllPosts() async {
    try {
      final response = await _dio.get('/posts');
      return (response.data as List)
          .map((json) => Post.fromJson(json))
          .toList();
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<Post> getPost(int id) async {
    try {
      final response = await _dio.get('/posts/$id');
      return Post.fromJson(response.data);
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<Post> createPost(String title, String content, int userId) async {
    try {
      final response = await _dio.post('/posts', data: {
        'title': title,
        'content': content,
      }, queryParameters: {
        'userId': userId,
      });
      
      // 백엔드 응답 형식에 맞게 수정
      final data = response.data;
      
      // 게시글 생성 후 전체 게시글 정보를 가져오기 위해 다시 조회
      final postId = data['postId'];
      return await getPost(postId);
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<Post> updatePost(int id, String title, String content, int userId) async {
    try {
      final response = await _dio.put('/posts/$id', data: {
        'title': title,
        'content': content,
      }, queryParameters: {
        'userId': userId,
      });
      
      // 백엔드 응답 형식에 맞게 수정
      final data = response.data;
      
      // 게시글 수정 후 전체 게시글 정보를 가져오기 위해 다시 조회
      final postId = data['postId'];
      return await getPost(postId);
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<void> deletePost(int id, int userId) async {
    try {
      await _dio.delete('/posts/$id', queryParameters: {
        'userId': userId,
      });
    } catch (e) {
      throw _handleError(e);
    }
  }

  String _handleError(dynamic error) {
    print('🔍 Error details: $error');
    if (error is DioException) {
      print('📡 DioException type: ${error.type}');
      print('📡 DioException message: ${error.message}');
      print('📡 DioException response: ${error.response?.data}');
      print('📡 DioException status: ${error.response?.statusCode}');
      
      if (error.response != null) {
        final data = error.response!.data;
        if (data is Map && data.containsKey('error')) {
          return data['error'];
        }
        return '서버 오류가 발생했습니다. (${error.response!.statusCode})';
      } else {
        return '네트워크 오류가 발생했습니다.';
      }
    }
    return '알 수 없는 오류가 발생했습니다.';
  }
} 