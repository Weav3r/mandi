import 'package:appwrite/models.dart' show Session;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:mandi/features/auth/providers/auth_provider.dart';

class SplashScreen extends ConsumerWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<AsyncValue<Session?>>(
      authStateProvider,
      (previous, next) {
        next.when(
          data: (session) {
            if (session != null) {
              context.go('/home');
            } else {
              context.go('/login');
            }
          },
          loading: () {},
          error: (_, __) => context.go('/login'),
        );
      },
    );

    return const Scaffold(
      backgroundColor: Colors.green,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Welcome'),
            CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
