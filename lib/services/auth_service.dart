import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'api_service.dart';

/// Gère la session utilisateur : login, register, logout, et persistance
/// du token + des infos utilisateur entre les lancements de l'app.
///
/// Utilisation typique :
///   - Au démarrage (splash screen / main.dart) : `await AuthService.tryAutoLogin();`
///   - À la connexion : `final result = await AuthService.login(...)`
///   - Pour vérifier si connecté : `AuthService.isAuthenticated`
///   - Pour appeler une route protégée : `AuthService.token` (à mettre dans le header Authorization)
class AuthService {
  static const String _tokenKey = 'auth_token';
  static const String _userKey = 'auth_user';

  static String? _token;
  static Map<String, dynamic>? _user;

  static String? get token => _token;
  static Map<String, dynamic>? get currentUser => _user;
  static bool get isAuthenticated => _token != null;

  /// Recharge la session sauvegardée localement (si l'utilisateur s'était
  /// déjà connecté auparavant). Retourne true si une session a été restaurée.
  static Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    final savedToken = prefs.getString(_tokenKey);
    final savedUser = prefs.getString(_userKey);

    if (savedToken == null || savedUser == null) {
      return false;
    }

    _token = savedToken;
    _user = jsonDecode(savedUser) as Map<String, dynamic>;
    return true;
  }

  /// Pratique pour un splash screen : recharge la session sauvegardée
  /// (si besoin) puis indique si l'utilisateur est connecté.
  /// Ex. dans main.dart : `final loggedIn = await AuthService.isLoggedIn();`
  static Future<bool> isLoggedIn() async {
    if (_token != null) return true;
    return tryAutoLogin();
  }

  /// Crée un compte et sauvegarde la session si succès.
  static Future<Map<String, dynamic>> register({
    required String fullName,
    required String phone,
    required String password,
    required String language,
  }) async {
    final result = await ApiService.register(
      fullName: fullName,
      phone: phone,
      password: password,
      language: language,
    );

    if (result['success'] == true) {
      await _saveSession(result['token'] as String, result['user'] as Map<String, dynamic>);
    }

    return result;
  }

  /// Connecte un utilisateur existant et sauvegarde la session si succès.
  static Future<Map<String, dynamic>> login({
    required String phone,
    required String password,
  }) async {
    final result = await ApiService.login(phone: phone, password: password);

    if (result['success'] == true) {
      await _saveSession(result['token'] as String, result['user'] as Map<String, dynamic>);
    }

    return result;
  }

  /// Déconnecte l'utilisateur et efface la session locale.
  static Future<void> logout() async {
    _token = null;
    _user = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove(_userKey);
  }

  /// Sauvegarde manuellement une session (token + user), par ex. si tu
  /// appelles ApiService toi-même ailleurs et veux juste persister le résultat.
  static Future<void> saveSession(String token, Map<String, dynamic> user) async {
    await _saveSession(token, user);
  }

  static Future<void> _saveSession(String token, Map<String, dynamic> user) async {
    _token = token;
    _user = user;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
    await prefs.setString(_userKey, jsonEncode(user));
  }
}