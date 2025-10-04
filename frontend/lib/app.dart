import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'features/landing/presentation/landing_page.dart';
import 'features/builder/presentation/builder_page.dart';
import 'features/preview/presentation/preview_page.dart';
import 'features/example/presentation/example_page.dart';
import 'features/auth/providers/auth_provider.dart';
import 'core/theme/app_theme.dart';

class MyApp extends ConsumerWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);

    return MaterialApp(
      title: 'Resume UltraProMax',
      theme: AppTheme.lightTheme,
      debugShowCheckedModeBanner: false,

      // Show loading screen while auth state is loading
      home: authState.when(
        data: (user) =>
            user != null ? const BuilderPage() : const LandingPage(),
        loading: () =>
            const Scaffold(body: Center(child: CircularProgressIndicator())),
        error: (_, __) => const LandingPage(),
      ),

      // Named routes for navigation
      routes: {
        '/builder': (context) => const BuilderPage(),
        '/preview': (context) => const PreviewPage(),
        '/example': (context) => const ExamplePage(),
      },
    );
  }
}
