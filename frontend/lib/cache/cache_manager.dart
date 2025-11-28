import 'dart:convert';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:shared_preferences/shared_preferences.dart';

/// Gestionnaire de cache sécurisé pour le stockage des tokens d'authentification
class CacheManager {
  static const String _accessTokenKey = 'auth_access_token';
  static const String _refreshTokenKey = 'auth_refresh_token';

  /// Stocke le token d'accès de manière sécurisée
  static Future<void> setAccessToken(String token) async {
    final data = {
      'token': token,
      'timestamp': DateTime.now().toIso8601String(),
    };

    if (kIsWeb) {
      // For web, use localStorage if available
      // Since html import is removed, skip for now
    } else {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_accessTokenKey, jsonEncode(data));
    }
  }

  /// Récupère le token d'accès
  static Future<String?> getAccessToken() async {
    try {
      String? storedData;

      if (kIsWeb) {
        // For web, skip for now
        return null;
      } else {
        final prefs = await SharedPreferences.getInstance();
        storedData = prefs.getString(_accessTokenKey);
      }

      if (storedData == null) return null;

      final data = jsonDecode(storedData) as Map<String, dynamic>;

      // Vérifier si le token n'est pas expiré (optionnel, peut être géré côté serveur)
      final timestamp = DateTime.parse(data['timestamp']);
      final now = DateTime.now();
      final difference = now.difference(timestamp);

      // Considérer le token valide pour 1 heure (ajustable)
      if (difference.inHours < 1) {
        return data['token'] as String;
      } else {
        // Token expiré, le supprimer
        await clearAccessToken();
        return null;
      }
    } catch (e) {
      await clearAccessToken();
      return null;
    }
  }

  /// Stocke le token de rafraîchissement
  static Future<void> setRefreshToken(String token) async {
    final data = {
      'token': token,
      'timestamp': DateTime.now().toIso8601String(),
    };

    if (kIsWeb) {
      // For web, skip for now
    } else {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_refreshTokenKey, jsonEncode(data));
    }
  }

  /// Récupère le token de rafraîchissement
  static Future<String?> getRefreshToken() async {
    try {
      String? storedData;

      if (kIsWeb) {
        // For web, skip for now
        return null;
      } else {
        final prefs = await SharedPreferences.getInstance();
        storedData = prefs.getString(_refreshTokenKey);
      }

      if (storedData == null) return null;

      final data = jsonDecode(storedData) as Map<String, dynamic>;
      return data['token'] as String;
    } catch (e) {
      await clearRefreshToken();
      return null;
    }
  }

  /// Supprime le token d'accès
  static Future<void> clearAccessToken() async {
    if (kIsWeb) {
      // For web, skip for now
    } else {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_accessTokenKey);
    }
  }

  /// Supprime le token de rafraîchissement
  static Future<void> clearRefreshToken() async {
    if (kIsWeb) {
      // For web, skip for now
    } else {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_refreshTokenKey);
    }
  }

  /// Supprime tous les tokens (déconnexion)
  static Future<void> clearAllTokens() async {
    await clearAccessToken();
    await clearRefreshToken();
  }

  /// Vérifie si un token d'accès est disponible
  static Future<bool> hasAccessToken() async {
    final token = await getAccessToken();
    return token != null;
  }

  /// Vérifie si un token de rafraîchissement est disponible
  static Future<bool> hasRefreshToken() async {
    final token = await getRefreshToken();
    return token != null;
  }
}