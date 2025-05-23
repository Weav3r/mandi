import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app/router/app_router.dart';
import 'services/appwrite_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initAppwrite(); // Initializes Appwrite client
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'To-Do App',
      darkTheme: ThemeData.dark(), // Replace with AppTheme if needed
      themeMode: ThemeMode.system,
      routerConfig: router,
    );
  }
}
