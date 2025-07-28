import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import '../config/environment_config.dart';

class NetworkTest {
  static final Dio _dio = Dio();

  /// Test connection to the configured server
  static Future<bool> testConnection() async {
    try {
      final response = await _dio.get(
        '${EnvironmentConfig.baseUrl}/health',
        options: Options(
          sendTimeout: Duration(milliseconds: 5000),
          receiveTimeout: Duration(milliseconds: 5000),
        ),
      );
      
      if (response.statusCode == 200) {
        Get.snackbar(
          'Connection Success',
          'Connected to server at ${EnvironmentConfig.baseUrl}',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green.withOpacity(0.8),
          colorText: Colors.white,
        );
        return true;
      }
    } catch (e) {
      print('Connection test failed: $e');
      _showConnectionError(e);
    }
    return false;
  }

  /// Test multiple possible server URLs
  static Future<String?> findServerUrl(int port) async {
    final testUrls = NetworkHelper.getQuickTestUrls(port);
    
    Get.snackbar(
      'Searching for Server',
      'Testing ${testUrls.length} possible URLs...',
      snackPosition: SnackPosition.TOP,
      duration: Duration(seconds: 2),
    );

    for (String url in testUrls) {
      try {
        print('Testing: $url');
        final response = await _dio.get(
          '$url/api/v1/health',
          options: Options(
            sendTimeout: Duration(milliseconds: 2000),
            receiveTimeout: Duration(milliseconds: 2000),
          ),
        );
        
        if (response.statusCode == 200) {
          Get.snackbar(
            'Server Found!',
            'Server is running at: $url',
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.green.withOpacity(0.8),
            colorText: Colors.white,
            duration: Duration(seconds: 5),
          );
          return url;
        }
      } catch (e) {
        // Continue testing other URLs
        continue;
      }
    }

    Get.snackbar(
      'Server Not Found',
      'Could not find server on any of the tested URLs',
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.red.withOpacity(0.8),
      colorText: Colors.white,
      duration: Duration(seconds: 5),
    );
    
    return null;
  }

  /// Get your device's local IP address (simplified)
  static Future<String?> getLocalIPAddress() async {
    try {
      // This is a simplified version - you might need to use a package like 'network_info_plus'
      // for more accurate IP detection
      return '192.168.1.100'; // Placeholder
    } catch (e) {
      print('Error getting local IP: $e');
      return null;
    }
  }

  /// Show detailed connection error
  static void _showConnectionError(dynamic error) {
    String errorMessage = 'Unknown error';
    String solution = '';

    if (error is DioException) {
      switch (error.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
          errorMessage = 'Connection timeout';
          solution = 'Check if your server is running and accessible';
          break;
        case DioExceptionType.connectionError:
          errorMessage = 'Cannot connect to server';
          solution = 'Verify server IP address and port number';
          break;
        case DioExceptionType.badResponse:
          errorMessage = 'Server responded with error: ${error.response?.statusCode}';
          solution = 'Check server logs for issues';
          break;
        default:
          errorMessage = 'Network error: ${error.message}';
          solution = 'Check your network connection';
      }
    }

    Get.dialog(
      AlertDialog(
        title: Text('Connection Failed'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Error: $errorMessage'),
            SizedBox(height: 16),
            Text('Solution: $solution'),
            SizedBox(height: 16),
            Text('Current server URL:'),
            Text(
              EnvironmentConfig.baseUrl,
              style: TextStyle(
                fontFamily: 'monospace',
                backgroundColor: Colors.grey[200],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('OK'),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              findServerUrl(3000); // Default port
            },
            child: Text('Find Server'),
          ),
        ],
      ),
    );
  }

  /// Test WebSocket connection
  static Future<bool> testWebSocketConnection() async {
    try {
      // This would test WebSocket connectivity
      // For now, just test HTTP connectivity to the WebSocket endpoint
      final response = await _dio.get(
        EnvironmentConfig.websocketUrl.replaceFirst('ws://', 'http://'),
        options: Options(
          sendTimeout: Duration(milliseconds: 5000),
          receiveTimeout: Duration(milliseconds: 5000),
        ),
      );
      
      return response.statusCode == 200;
    } catch (e) {
      print('WebSocket test failed: $e');
      return false;
    }
  }

  /// Show network configuration dialog
  static void showNetworkConfigDialog() {
    Get.dialog(
      AlertDialog(
        title: Text('Network Configuration'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Current Configuration:', style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              _buildConfigRow('Environment:', EnvironmentConfig.currentEnvironment.toString()),
              _buildConfigRow('API Base URL:', EnvironmentConfig.baseUrl),
              _buildConfigRow('WebSocket URL:', EnvironmentConfig.websocketUrl),
              _buildConfigRow('File Upload URL:', EnvironmentConfig.fileUploadUrl),
              SizedBox(height: 16),
              Text('Network Settings:', style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              _buildConfigRow('Connection Timeout:', '${EnvironmentConfig.connectionTimeout}ms'),
              _buildConfigRow('Receive Timeout:', '${EnvironmentConfig.receiveTimeout}ms'),
              _buildConfigRow('Logging Enabled:', EnvironmentConfig.enableNetworkLogs.toString()),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('Close'),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              testConnection();
            },
            child: Text('Test Connection'),
          ),
        ],
      ),
    );
  }

  static Widget _buildConfigRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(label, style: TextStyle(fontWeight: FontWeight.w500)),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(fontFamily: 'monospace', fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
}