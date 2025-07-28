import 'dart:io';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart';
import '../config/api_config.dart';
import '../services/api_service.dart';

class FileService extends GetxService {
  static FileService get instance => Get.find<FileService>();
  
  final ImagePicker _imagePicker = ImagePicker();
  final ApiService _apiService = ApiService();

  // File picker methods
  Future<File?> pickImage({ImageSource source = ImageSource.gallery}) async {
    try {
      // Request permission
      await _requestPermission();
      
      final XFile? pickedFile = await _imagePicker.pickImage(
        source: source,
        maxWidth: 1920,
        maxHeight: 1920,
        imageQuality: 85,
      );
      
      if (pickedFile != null) {
        final file = File(pickedFile.path);
        
        // Validate file size
        final fileSize = await file.length();
        if (fileSize > ApiConfig.maxImageSize) {
          Get.snackbar(
            'Error',
            'Image size must be less than ${_formatFileSize(ApiConfig.maxImageSize)}',
            snackPosition: SnackPosition.BOTTOM,
          );
          return null;
        }
        
        return file;
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to pick image: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
    return null;
  }

  Future<List<File>?> pickMultipleImages() async {
    try {
      await _requestPermission();
      
      final List<XFile> pickedFiles = await _imagePicker.pickMultipleImages(
        maxWidth: 1920,
        maxHeight: 1920,
        imageQuality: 85,
      );
      
      if (pickedFiles.isNotEmpty) {
        final List<File> files = [];
        
        for (final pickedFile in pickedFiles) {
          final file = File(pickedFile.path);
          final fileSize = await file.length();
          
          if (fileSize <= ApiConfig.maxImageSize) {
            files.add(file);
          } else {
            Get.snackbar(
              'Warning',
              'Skipped ${pickedFile.name} - file too large',
              snackPosition: SnackPosition.BOTTOM,
            );
          }
        }
        
        return files.isNotEmpty ? files : null;
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to pick images: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
    return null;
  }

  Future<File?> pickFile() async {
    try {
      await _requestPermission();
      
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ApiConfig.allowedFileTypes,
        allowMultiple: false,
      );

      if (result != null && result.files.single.path != null) {
        final file = File(result.files.single.path!);
        final fileSize = await file.length();
        
        if (fileSize > ApiConfig.maxFileSize) {
          Get.snackbar(
            'Error',
            'File size must be less than ${_formatFileSize(ApiConfig.maxFileSize)}',
            snackPosition: SnackPosition.BOTTOM,
          );
          return null;
        }
        
        return file;
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to pick file: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
    return null;
  }

  Future<List<File>?> pickMultipleFiles() async {
    try {
      await _requestPermission();
      
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ApiConfig.allowedFileTypes,
        allowMultiple: true,
      );

      if (result != null) {
        final List<File> files = [];
        
        for (final platformFile in result.files) {
          if (platformFile.path != null) {
            final file = File(platformFile.path!);
            final fileSize = await file.length();
            
            if (fileSize <= ApiConfig.maxFileSize) {
              files.add(file);
            } else {
              Get.snackbar(
                'Warning',
                'Skipped ${platformFile.name} - file too large',
                snackPosition: SnackPosition.BOTTOM,
              );
            }
          }
        }
        
        return files.isNotEmpty ? files : null;
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to pick files: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
    return null;
  }

  // File upload methods
  Future<FileUploadResult?> uploadFile(File file, {
    Function(double)? onProgress,
    String? customFileName,
  }) async {
    try {
      final fileName = customFileName ?? file.path.split('/').last;
      
      // Create form data
      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(
          file.path,
          filename: fileName,
        ),
      });

      // Upload with progress tracking
      final response = await _apiService._dio.post(
        ApiConfig.uploadFile,
        data: formData,
        onSendProgress: (sent, total) {
          if (onProgress != null && total > 0) {
            onProgress(sent / total);
          }
        },
      );

      if (response.statusCode == 200) {
        return FileUploadResult.fromJson(response.data);
      }
    } catch (e) {
      Get.snackbar(
        'Upload Error',
        'Failed to upload file: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
    return null;
  }

  Future<List<FileUploadResult>> uploadMultipleFiles(
    List<File> files, {
    Function(int, double)? onProgress,
  }) async {
    final List<FileUploadResult> results = [];
    
    for (int i = 0; i < files.length; i++) {
      final result = await uploadFile(
        files[i],
        onProgress: (progress) {
          onProgress?.call(i, progress);
        },
      );
      
      if (result != null) {
        results.add(result);
      }
    }
    
    return results;
  }

  // File download methods
  Future<File?> downloadFile(
    String fileUrl,
    String fileName, {
    Function(double)? onProgress,
  }) async {
    try {
      // Get downloads directory
      final directory = await getApplicationDocumentsDirectory();
      final downloadsDir = Directory('${directory.path}/downloads');
      
      if (!await downloadsDir.exists()) {
        await downloadsDir.create(recursive: true);
      }
      
      final filePath = '${downloadsDir.path}/$fileName';
      
      // Download file
      await _apiService._dio.download(
        fileUrl,
        filePath,
        onReceiveProgress: (received, total) {
          if (onProgress != null && total > 0) {
            onProgress(received / total);
          }
        },
      );
      
      return File(filePath);
    } catch (e) {
      Get.snackbar(
        'Download Error',
        'Failed to download file: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
    return null;
  }

  // File management methods
  Future<bool> deleteFile(File file) async {
    try {
      if (await file.exists()) {
        await file.delete();
        return true;
      }
    } catch (e) {
      print('Error deleting file: $e');
    }
    return false;
  }

  Future<String> getFileSize(File file) async {
    final size = await file.length();
    return _formatFileSize(size);
  }

  String getFileExtension(String fileName) {
    return fileName.split('.').last.toLowerCase();
  }

  bool isImageFile(String fileName) {
    final extension = getFileExtension(fileName);
    return ApiConfig.allowedImageTypes.contains(extension);
  }

  bool isAllowedFileType(String fileName) {
    final extension = getFileExtension(fileName);
    return ApiConfig.allowedFileTypes.contains(extension) || 
           ApiConfig.allowedImageTypes.contains(extension);
  }

  // Utility methods
  String _formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    if (bytes < 1024 * 1024 * 1024) return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
  }

  Future<void> _requestPermission() async {
    if (Platform.isAndroid) {
      final status = await Permission.storage.request();
      if (status.isDenied) {
        throw Exception('Storage permission denied');
      }
    }
  }

  // Cache management
  Future<void> clearCache() async {
    try {
      final directory = await getTemporaryDirectory();
      if (await directory.exists()) {
        await directory.delete(recursive: true);
        await directory.create();
      }
    } catch (e) {
      print('Error clearing cache: $e');
    }
  }

  Future<double> getCacheSize() async {
    try {
      final directory = await getTemporaryDirectory();
      return await _calculateDirectorySize(directory);
    } catch (e) {
      print('Error calculating cache size: $e');
      return 0.0;
    }
  }

  Future<double> _calculateDirectorySize(Directory directory) async {
    double size = 0;
    try {
      if (await directory.exists()) {
        await for (final entity in directory.list(recursive: true)) {
          if (entity is File) {
            size += await entity.length();
          }
        }
      }
    } catch (e) {
      print('Error calculating directory size: $e');
    }
    return size / (1024 * 1024); // Return size in MB
  }

  // Image compression
  Future<File?> compressImage(File imageFile, {int quality = 85}) async {
    try {
      final directory = await getTemporaryDirectory();
      final fileName = imageFile.path.split('/').last;
      final compressedPath = '${directory.path}/compressed_$fileName';
      
      // This is a placeholder - you would implement actual image compression here
      // You could use packages like flutter_image_compress
      
      return File(compressedPath);
    } catch (e) {
      print('Error compressing image: $e');
      return null;
    }
  }
}

// Result models
class FileUploadResult {
  final String fileId;
  final String fileName;
  final String fileUrl;
  final String mimeType;
  final int fileSize;
  final String? thumbnailUrl;

  FileUploadResult({
    required this.fileId,
    required this.fileName,
    required this.fileUrl,
    required this.mimeType,
    required this.fileSize,
    this.thumbnailUrl,
  });

  factory FileUploadResult.fromJson(Map<String, dynamic> json) {
    return FileUploadResult(
      fileId: json['file_id'] ?? '',
      fileName: json['file_name'] ?? '',
      fileUrl: json['file_url'] ?? '',
      mimeType: json['mime_type'] ?? '',
      fileSize: json['file_size'] ?? 0,
      thumbnailUrl: json['thumbnail_url'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'file_id': fileId,
      'file_name': fileName,
      'file_url': fileUrl,
      'mime_type': mimeType,
      'file_size': fileSize,
      'thumbnail_url': thumbnailUrl,
    };
  }
}