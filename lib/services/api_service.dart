/*import 'dart:convert';
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
}*/

import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class ApiService {
  // Remplace par ton IP locale (ex: http://192.168.1.X:8000) pour tester sur téléphone
  static const String baseUrl = 'http://192.168.1.101:8000'; // 10.0.2.2 pour l'émulateur Android

  // ==========================================================
  // Authentification
  // ==========================================================

  /// Crée un compte. Retourne toujours un Map avec 'success'.
  /// Si succès : {'success': true, 'token': ..., 'user': {...}}
  static Future<Map<String, dynamic>> register({
    required String fullName,
    required String phone,
    required String password,
    required String language,
  }) async {
    try {
      final uri = Uri.parse('$baseUrl/api/auth/register');
      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'full_name': fullName,
          'phone': phone,
          'password': password,
          'language': language,
        }),
      );

      final body = jsonDecode(response.body);

      if (response.statusCode == 201) {
        return body as Map<String, dynamic>;
      }
      return {
        'success': false,
        'error': body['detail'] ?? 'Impossible de créer le compte',
      };
    } catch (e) {
      return {
        'success': false,
        'error': 'Impossible de se connecter au serveur : $e',
      };
    }
  }

  /// Connecte un utilisateur existant.
  static Future<Map<String, dynamic>> login({
    required String phone,
    required String password,
  }) async {
    try {
      final uri = Uri.parse('$baseUrl/api/auth/login');
      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'phone': phone, 'password': password}),
      );

      final body = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return body as Map<String, dynamic>;
      }
      return {
        'success': false,
        'error': body['detail'] ?? 'Numéro ou mot de passe incorrect',
      };
    } catch (e) {
      return {
        'success': false,
        'error': 'Impossible de se connecter au serveur : $e',
      };
    }
  }

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