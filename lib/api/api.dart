import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:gabpharmamobile/api/api_url.dart';
import 'package:gabpharmamobile/api/token_storage.dart';

/// Client HTTP unique (Dio + refresh JWT + gestion 402 paywall).
class Api {
  Api._();

  static final Dio client = _build();

  static bool _refreshing = false;

  static Dio _build() {
    final dio = Dio(
      BaseOptions(
        baseUrl: ApiUrl.base,
        connectTimeout: const Duration(seconds: 20),
        receiveTimeout: const Duration(seconds: 20),
        headers: const {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      ),
    );

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await TokenStorage.access;
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          handler.next(options);
        },
        onError: (error, handler) async {
          final status = error.response?.statusCode;

          if (status == 402) {
            debugPrint('Paywall Gab\'Pharma (402) sur ${error.requestOptions.path}');
            handler.next(error);
            return;
          }

          if (status == 401 && !_refreshing) {
            _refreshing = true;
            try {
              final refreshed = await _tryRefresh();
              if (refreshed) {
                final retry = await client.fetch(error.requestOptions);
                handler.resolve(retry);
                return;
              }
            } catch (e) {
              debugPrint('Refresh JWT échoué: $e');
              await TokenStorage.clear();
            } finally {
              _refreshing = false;
            }
          }

          handler.next(error);
        },
      ),
    );

    return dio;
  }

  static Future<bool> _tryRefresh() async {
    final refresh = await TokenStorage.refresh;
    if (refresh == null || refresh.isEmpty) return false;

    final response = await Dio(
      BaseOptions(baseUrl: ApiUrl.base),
    ).post(ApiUrl.refresh, data: {'refresh': refresh});

    final data = response.data;
    if (data is Map && data['access'] != null) {
      await TokenStorage.saveTokens(
        access: data['access'].toString(),
        refresh: (data['refresh'] ?? refresh).toString(),
      );
      return true;
    }
    return false;
  }
}

/// À utiliser dans les repositories tant que le contrat JSON n'est pas fourni.
T? apiEnAttente<T>(String endpoint) {
  debugPrint('TODO API $endpoint — en attente du contrat JSON.');
  return null;
}
