import 'dart:convert';
import 'package:http/http.dart' as http;

class AhpService {
  // Singleton instance
  static final AhpService _instance = AhpService._internal();
  factory AhpService() => _instance;
  AhpService._internal();

  // Default Fallback API URL (Localhost)
  // Gunakan 10.0.2.2 untuk Android Emulator, localhost untuk Web
  static const String _defaultFallbackUrl = 'http://127.0.0.1:5000'; 
  
  // Storage for the Gist URL (In-memory for now)
  // Defaulting to the one provided by user for convenience, but can be changed via UI
  String _currentGistUrl = 'https://gist.githubusercontent.com/murdiyanedzwan321/270d97517bef8531775145eecdda01f5/raw/d310af7b602fa2f8f0f145961bb18465102a9a5f/config.json';

  String get currentGistUrl => _currentGistUrl;

  void setGistUrl(String url) {
    _currentGistUrl = url;
  }

  Future<String> getBaseUrl() async {
    if (_currentGistUrl.isEmpty) return _defaultFallbackUrl;

    try {
      final response = await http.get(Uri.parse(_currentGistUrl));
      if (response.statusCode == 200) {
        final Map<String, dynamic> config = jsonDecode(response.body);
        // Expecting JSON: { "base_url": "https://your-backend-api.com" }
        return config['base_url'] ?? _defaultFallbackUrl;
      }
    } catch (e) {
      print('Gagal mengambil config Gist, menggunakan fallback: $e');
    }
    return _defaultFallbackUrl;
  }

  Future<Map<String, dynamic>> calculateAhp(Map<String, dynamic> payload) async {
    // 1. Get Dynamic Base URL from Gist
    String baseUrl = await getBaseUrl();
    
    // Remove trailing slash if present to avoid double slashes
    if (baseUrl.endsWith('/')) {
      baseUrl = baseUrl.substring(0, baseUrl.length - 1);
    }

    final url = Uri.parse('$baseUrl/api/calculate-ahp');
    print("Sending request to: $url"); // Debug log
    
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(payload),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Server Error: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      throw Exception('Connection Error: $e');
    }
  }
}
