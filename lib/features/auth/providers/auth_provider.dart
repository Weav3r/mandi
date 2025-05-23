import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:appwrite/models.dart';
import '../../../services/appwrite_service.dart';
import 'package:appwrite/appwrite.dart';

final authProvider = Provider<Account>((ref) => Account(client));

final authStateProvider = StreamProvider.autoDispose<Session?>((ref) {
  final account = Account(client);

  return Stream.periodic(const Duration(seconds: 5)).asyncMap((_) async {
    try {
      return await account.getSession(sessionId: 'current');
    } catch (_) {
      return null;
    }
  });
});
