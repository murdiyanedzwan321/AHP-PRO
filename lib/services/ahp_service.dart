import 'dart:convert';
import 'package:http/http.dart' as http;

class AhpService {
  // FALLBACK URL (Untuk testing di localhost jika Gist belum siap atau down)
  // Di Emulator Android gunakan 10.0.2.2 sebagai localhost
  // Di Web/iOS gunakan 127.0.0.1 atau localhost
  // Ganti port sesuai Flask (5000)
  static const String _fallbackUrl = 'https://gist.githubusercontent.com/murdiyanedzwan321/270d97517bef8531775145eecdda01f5/raw/d310af7b602fa2f8f0f145961bb18465102a9a5f/config.json'; 
  
  // URL Raw Gist (Nanti diisi User sesuai TOR)
  static const String _configGistUrl = 'https://gist.githubusercontent.com/murdiyanedzwan321/270d97517bef8531775145eecdda01f5/raw/d310af7b602fa2f8f0f145961bb18465102a9a5f/config.json';

  Future<String> getBaseUrl() async {
    try {
      final response = await http.get(Uri.parse(_configGistUrl));
      if (response.statusCode == 200) {
        final Map<String, dynamic> config = jsonDecode(response.body);
        return config['base_url'] ?? _fallbackUrl;
      }
    } catch (e) {
      print('Gagal mengambil config Gist, menggunakan fallback: $e');
    }
    return _fallbackUrl;
  }

  Future<Map<String, dynamic>> calculateAhp(Map<String, dynamic> payload) async {
    // 1. Dapatkan Base URL (Idealnya dari Gist, tapi kita hardcode localhost dulu utk dev)
    // String baseUrl = await getBaseUrl();
    String baseUrl = _fallbackUrl; // Bypass Gist untuk dev lokal

    final url = Uri.parse('$baseUrl/api/calculate-ahp');
    
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
