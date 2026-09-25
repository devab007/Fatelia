import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class ApiService {
  // Remplace par ton IP locale (ex: http://192.168.1.X:8000) pour tester sur téléphone
  static const String baseUrl = 'http://10.0.2.2:8000'; // 10.0.2.2 pour l'émulateur Android

  // Envoyer l'audio pour transcription ASR
  static Future<Map<String, dynamic>> sendAudioToASR(String audioFilePath, String language) async {
    try {
      final uri = Uri.parse('$baseUrl/api/transcribe');
      final request = http.MultipartRequest('POST', uri);

      request.fields['language'] = language;
      request.files.add(
        await http.MultipartFile.fromPath(
          'file',
          audioFilePath,
        ),
      );

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return {
          'success': false,
          'error': 'Erreur serveur: ${response.statusCode}',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'error': 'Impossible de se connecter au serveur : $e',
      };
    }
  }
}