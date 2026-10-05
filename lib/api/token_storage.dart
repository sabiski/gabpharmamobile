import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Stockage sécurisé des tokens JWT.
class TokenStorage {
  TokenStorage._();

  static const _storage = FlutterSecureStorage();
  static const _accessKey = 'gabpharma_access';
  static const _refreshKey = 'gabpharma_refresh';

  static Future<void> saveTokens({
    required String access,
    required String refresh,
  }) async {
    await _storage.write(key: _accessKey, value: access);
    await _storage.write(key: _refreshKey, value: refresh);
  }

  static Future<String?> get access => _storage.read(key: _accessKey);
  static Future<String?> get refresh => _storage.read(key: _refreshKey);

  static Future<void> clear() async {
    await _storage.delete(key: _accessKey);
    await _storage.delete(key: _refreshKey);
  }
}
