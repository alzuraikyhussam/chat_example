enum Environment {
  development,
  production,
}

class EnvironmentConfig {
  // Set this to your current environment
  static const Environment currentEnvironment = Environment.development;
  
  // Development (Local LAN) Configuration
  static const Map<String, String> developmentConfig = {
    'baseUrl': 'http://192.168.1.100:3000/api/v1',      // Replace with your server IP
    'websocketUrl': 'ws://192.168.1.100:3000/ws',       // Replace with your server IP
    'fileUploadUrl': 'http://192.168.1.100:3000/api/v1/files',
  };
  
  // Production Configuration
  static const Map<String, String> productionConfig = {
    'baseUrl': 'https://your-production-domain.com/api/v1',
    'websocketUrl': 'wss://your-production-domain.com/ws',
    'fileUploadUrl': 'https://your-production-domain.com/api/v1/files',
  };
  
  // Get current configuration based on environment
  static Map<String, String> get currentConfig {
    switch (currentEnvironment) {
      case Environment.development:
        return developmentConfig;
      case Environment.production:
        return productionConfig;
    }
  }
  
  // Helper getters
  static String get baseUrl => currentConfig['baseUrl']!;
  static String get websocketUrl => currentConfig['websocketUrl']!;
  static String get fileUploadUrl => currentConfig['fileUploadUrl']!;
  
  // Network configuration for local development
  static const bool allowInsecureConnections = true; // For local HTTP
  static const int connectionTimeout = 10000; // 10 seconds for local network
  static const int receiveTimeout = 10000;
  static const int sendTimeout = 10000;
  
  // Debug settings
  static const bool enableLogging = true;
  static const bool enableNetworkLogs = true;
}

// Helper class to find your local IP address
class NetworkHelper {
  // Common local IP ranges to try
  static const List<String> commonLocalIPs = [
    '192.168.1.',   // Most common home router range
    '192.168.0.',   // Alternative home router range
    '10.0.0.',      // Corporate/VPN range
    '172.16.',      // Private network range
  ];
  
  // Helper method to construct URLs for different IP ranges
  static List<String> generatePossibleUrls(int port) {
    List<String> urls = [];
    
    for (String ipRange in commonLocalIPs) {
      for (int i = 1; i <= 254; i++) {
        urls.add('http://$ipRange$i:$port');
      }
    }
    
    return urls;
  }
  
  // Quick test URLs for common setups
  static List<String> getQuickTestUrls(int port) {
    return [
      'http://localhost:$port',
      'http://127.0.0.1:$port',
      'http://192.168.1.1:$port',
      'http://192.168.1.100:$port',
      'http://192.168.1.101:$port',
      'http://192.168.0.1:$port',
      'http://192.168.0.100:$port',
      'http://10.0.0.1:$port',
    ];
  }
}