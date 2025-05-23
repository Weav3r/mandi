import 'package:appwrite/appwrite.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:appwrite/models.dart' as models;
import 'auth_provider.dart';

final authControllerProvider = Provider<AuthController>((ref) {
  final account = ref.watch(authProvider);
  return AuthController(account);
});

class AuthController {
  final Account _account;

  AuthController(this._account);

  Future<models.User?> getCurrentUser() async {
    try {
      return await _account.get();
    } catch (_) {
      return null;
    }
  }

  Future<void> logout() async {
    await _account.deleteSession(sessionId: 'current');
  }

  Future<void> login({
    required String email,
    required String password,
  }) async {
    await _account.createEmailPasswordSession(email: email, password: password);
  }

  Future<void> signup({
    required String email,
    required String password,
    required String name,
  }) async {
    await _account.create(
      userId: ID.unique(),
      email: email,
      password: password,
      name: name,
    );
  }
}
