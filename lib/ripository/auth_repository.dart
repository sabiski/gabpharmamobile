import 'package:gabpharmamobile/api/api.dart';
import 'package:gabpharmamobile/api/api_url.dart';
import 'package:gabpharmamobile/models/user_model.dart';

class AuthRepository {
  /// POST /api/v1/auth/login/
  Future<Map<String, dynamic>?> login({
    required String username,
    required String password,
  }) async {
    return apiEnAttente<Map<String, dynamic>>(ApiUrl.login);
  }

  /// POST /api/v1/auth/register/
  Future<Map<String, dynamic>?> register(Map<String, dynamic> payload) async {
    return apiEnAttente<Map<String, dynamic>>(ApiUrl.register);
  }

  /// GET /api/v1/users/me/
  Future<UserModel?> me() async {
    apiEnAttente(ApiUrl.me);
    return null;
  }

  /// POST /api/v1/auth/refresh/
  Future<Map<String, dynamic>?> refresh(String refreshToken) async {
    return apiEnAttente<Map<String, dynamic>>(ApiUrl.refresh);
  }
}
