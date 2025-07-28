import 'package:dio/dio.dart';
import 'package:get/get.dart' as getx;
import 'package:shared_preferences/shared_preferences.dart';
import '../config/api_config.dart';
import '../config/environment_config.dart';
import '../models/user_model.dart';
import '../models/message_model.dart';
import '../controllers/auth_controller.dart';

class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  late Dio _dio;
  String? _accessToken;
  String? _refreshToken;

  void initialize() {
    _dio = Dio(BaseOptions(
      baseUrl: ApiConfig.baseUrl,
      connectTimeout: Duration(milliseconds: EnvironmentConfig.connectionTimeout),
      receiveTimeout: Duration(milliseconds: EnvironmentConfig.receiveTimeout),
      sendTimeout: Duration(milliseconds: EnvironmentConfig.sendTimeout),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ));

    // Add interceptors
    _dio.interceptors.add(_AuthInterceptor());
    _dio.interceptors.add(_ErrorInterceptor());
    
    // Add logging interceptor only in development
    if (EnvironmentConfig.enableNetworkLogs) {
      _dio.interceptors.add(_LoggingInterceptor());
    }
  }

  // Token management
  Future<void> setTokens(String accessToken, String refreshToken) async {
    _accessToken = accessToken;
    _refreshToken = refreshToken;
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('access_token', accessToken);
    await prefs.setString('refresh_token', refreshToken);
  }

  Future<void> loadTokens() async {
    final prefs = await SharedPreferences.getInstance();
    _accessToken = prefs.getString('access_token');
    _refreshToken = prefs.getString('refresh_token');
  }

  Future<void> clearTokens() async {
    _accessToken = null;
    _refreshToken = null;
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('access_token');
    await prefs.remove('refresh_token');
  }

  // Authentication APIs
  Future<ApiResponse<AuthResponse>> login(String email, String password) async {
    try {
      final response = await _dio.post(ApiConfig.login, data: {
        'email': email,
        'password': password,
      });
      
      final authResponse = AuthResponse.fromJson(response.data);
      await setTokens(authResponse.accessToken, authResponse.refreshToken);
      
      return ApiResponse.success(authResponse);
    } catch (e) {
      return ApiResponse.error(_handleError(e));
    }
  }

  Future<ApiResponse<AuthResponse>> register(String name, String email, String password) async {
    try {
      final response = await _dio.post(ApiConfig.register, data: {
        'name': name,
        'email': email,
        'password': password,
      });
      
      final authResponse = AuthResponse.fromJson(response.data);
      await setTokens(authResponse.accessToken, authResponse.refreshToken);
      
      return ApiResponse.success(authResponse);
    } catch (e) {
      return ApiResponse.error(_handleError(e));
    }
  }

  Future<ApiResponse<void>> logout() async {
    try {
      await _dio.post(ApiConfig.logout);
      await clearTokens();
      return ApiResponse.success(null);
    } catch (e) {
      return ApiResponse.error(_handleError(e));
    }
  }

  Future<ApiResponse<void>> forgotPassword(String email) async {
    try {
      await _dio.post(ApiConfig.forgotPassword, data: {'email': email});
      return ApiResponse.success(null);
    } catch (e) {
      return ApiResponse.error(_handleError(e));
    }
  }

  // User APIs
  Future<ApiResponse<UserModel>> getProfile() async {
    try {
      final response = await _dio.get(ApiConfig.profile);
      final user = UserModel.fromJson(response.data['user']);
      return ApiResponse.success(user);
    } catch (e) {
      return ApiResponse.error(_handleError(e));
    }
  }

  Future<ApiResponse<UserModel>> updateProfile(Map<String, dynamic> data) async {
    try {
      final response = await _dio.put(ApiConfig.updateProfile, data: data);
      final user = UserModel.fromJson(response.data['user']);
      return ApiResponse.success(user);
    } catch (e) {
      return ApiResponse.error(_handleError(e));
    }
  }

  Future<ApiResponse<String>> uploadAvatar(String filePath) async {
    try {
      final formData = FormData.fromMap({
        'avatar': await MultipartFile.fromFile(filePath),
      });
      
      final response = await _dio.post(ApiConfig.uploadAvatar, data: formData);
      return ApiResponse.success(response.data['avatar_url']);
    } catch (e) {
      return ApiResponse.error(_handleError(e));
    }
  }

  Future<ApiResponse<List<UserModel>>> searchUsers(String query) async {
    try {
      final response = await _dio.get(ApiConfig.searchUsers, queryParameters: {
        'q': query,
        'limit': ApiConfig.defaultPageSize,
      });
      
      final users = (response.data['users'] as List)
          .map((json) => UserModel.fromJson(json))
          .toList();
      
      return ApiResponse.success(users);
    } catch (e) {
      return ApiResponse.error(_handleError(e));
    }
  }

  // Chat APIs
  Future<ApiResponse<List<Conversation>>> getConversations({int page = 1}) async {
    try {
      final response = await _dio.get(ApiConfig.conversations, queryParameters: {
        'page': page,
        'limit': ApiConfig.defaultPageSize,
      });
      
      final conversations = (response.data['conversations'] as List)
          .map((json) => Conversation.fromJson(json))
          .toList();
      
      return ApiResponse.success(conversations);
    } catch (e) {
      return ApiResponse.error(_handleError(e));
    }
  }

  Future<ApiResponse<List<MessageModel>>> getMessages(String conversationId, {int page = 1}) async {
    try {
      final response = await _dio.get(ApiConfig.messages, queryParameters: {
        'conversation_id': conversationId,
        'page': page,
        'limit': ApiConfig.defaultPageSize,
      });
      
      final messages = (response.data['messages'] as List)
          .map((json) => MessageModel.fromJson(json))
          .toList();
      
      return ApiResponse.success(messages);
    } catch (e) {
      return ApiResponse.error(_handleError(e));
    }
  }

  Future<ApiResponse<MessageModel>> sendMessage(String conversationId, String content, MessageType type) async {
    try {
      final response = await _dio.post(ApiConfig.sendMessage, data: {
        'conversation_id': conversationId,
        'content': content,
        'type': type.toString().split('.').last,
      });
      
      final message = MessageModel.fromJson(response.data['message']);
      return ApiResponse.success(message);
    } catch (e) {
      return ApiResponse.error(_handleError(e));
    }
  }

  Future<ApiResponse<void>> markAsRead(String conversationId, List<String> messageIds) async {
    try {
      await _dio.post(ApiConfig.markAsRead, data: {
        'conversation_id': conversationId,
        'message_ids': messageIds,
      });
      return ApiResponse.success(null);
    } catch (e) {
      return ApiResponse.error(_handleError(e));
    }
  }

  // File upload APIs
  Future<ApiResponse<FileUploadResponse>> uploadFile(String filePath, String fileName) async {
    try {
      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(filePath, filename: fileName),
      });
      
      final response = await _dio.post(ApiConfig.uploadFile, data: formData);
      final fileResponse = FileUploadResponse.fromJson(response.data);
      return ApiResponse.success(fileResponse);
    } catch (e) {
      return ApiResponse.error(_handleError(e));
    }
  }

  // Token refresh
  Future<bool> refreshAccessToken() async {
    if (_refreshToken == null) return false;
    
    try {
      final response = await _dio.post(ApiConfig.refreshToken, data: {
        'refresh_token': _refreshToken,
      });
      
      final newAccessToken = response.data['access_token'];
      final newRefreshToken = response.data['refresh_token'];
      
      await setTokens(newAccessToken, newRefreshToken);
      return true;
    } catch (e) {
      await clearTokens();
      return false;
    }
  }

  String _handleError(dynamic error) {
    if (error is DioException) {
      switch (error.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
          return 'Connection timeout. Please check your internet connection.';
        case DioExceptionType.badResponse:
          final statusCode = error.response?.statusCode;
          final message = error.response?.data['message'] ?? 'An error occurred';
          return '$message (Code: $statusCode)';
        case DioExceptionType.cancel:
          return 'Request was cancelled';
        case DioExceptionType.unknown:
          return 'Network error. Please check your internet connection.';
        default:
          return 'An unexpected error occurred';
      }
    }
    return error.toString();
  }
}

// Interceptors
class _AuthInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final apiService = ApiService();
    if (apiService._accessToken != null) {
      options.headers['Authorization'] = 'Bearer ${apiService._accessToken}';
    }
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      final apiService = ApiService();
      final refreshed = await apiService.refreshAccessToken();
      
      if (refreshed) {
        // Retry the request
        final opts = err.requestOptions;
        opts.headers['Authorization'] = 'Bearer ${apiService._accessToken}';
        
        try {
          final response = await apiService._dio.fetch(opts);
          handler.resolve(response);
          return;
        } catch (e) {
          // If retry fails, proceed with error
        }
      } else {
        // Refresh failed, logout user
        final authController = getx.Get.find<AuthController>();
        authController.logout();
      }
    }
    handler.next(err);
  }
}

class _ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // Log errors or handle specific error cases
    print('API Error: ${err.message}');
    handler.next(err);
  }
}

class _LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    print('REQUEST: ${options.method} ${options.uri}');
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    print('RESPONSE: ${response.statusCode} ${response.requestOptions.uri}');
    handler.next(response);
  }
}

// Response models
class ApiResponse<T> {
  final bool success;
  final T? data;
  final String? error;

  ApiResponse._({required this.success, this.data, this.error});

  factory ApiResponse.success(T data) {
    return ApiResponse._(success: true, data: data);
  }

  factory ApiResponse.error(String error) {
    return ApiResponse._(success: false, error: error);
  }
}

class AuthResponse {
  final String accessToken;
  final String refreshToken;
  final UserModel user;

  AuthResponse({
    required this.accessToken,
    required this.refreshToken,
    required this.user,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      accessToken: json['access_token'],
      refreshToken: json['refresh_token'],
      user: UserModel.fromJson(json['user']),
    );
  }
}

class Conversation {
  final String id;
  final String name;
  final String? avatarUrl;
  final MessageModel? lastMessage;
  final int unreadCount;
  final DateTime updatedAt;
  final List<UserModel> participants;

  Conversation({
    required this.id,
    required this.name,
    this.avatarUrl,
    this.lastMessage,
    required this.unreadCount,
    required this.updatedAt,
    required this.participants,
  });

  factory Conversation.fromJson(Map<String, dynamic> json) {
    return Conversation(
      id: json['id'],
      name: json['name'],
      avatarUrl: json['avatar_url'],
      lastMessage: json['last_message'] != null 
          ? MessageModel.fromJson(json['last_message'])
          : null,
      unreadCount: json['unread_count'] ?? 0,
      updatedAt: DateTime.parse(json['updated_at']),
      participants: (json['participants'] as List)
          .map((p) => UserModel.fromJson(p))
          .toList(),
    );
  }
}

class FileUploadResponse {
  final String fileId;
  final String fileName;
  final String fileUrl;
  final String mimeType;
  final int fileSize;

  FileUploadResponse({
    required this.fileId,
    required this.fileName,
    required this.fileUrl,
    required this.mimeType,
    required this.fileSize,
  });

  factory FileUploadResponse.fromJson(Map<String, dynamic> json) {
    return FileUploadResponse(
      fileId: json['file_id'],
      fileName: json['file_name'],
      fileUrl: json['file_url'],
      mimeType: json['mime_type'],
      fileSize: json['file_size'],
    );
  }
}