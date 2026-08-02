import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:swift_core/swift_core.dart';

import 'welcome_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
    ),
  );

  // Graceful global error screen instead of the red-yellow death banner.
  ErrorWidget.builder = (details) => _ErrorFallback(details: details);

  FlutterError.onError = (details) {
    debugPrint('Flutter error: ${details.exception}');
  };

  runApp(const ProviderScope(child: SwiftVendorApp()));
}

class SwiftVendorApp extends ConsumerWidget {
  const SwiftVendorApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: 'Swift Vendor',
      debugShowCheckedModeBanner: false,
      theme: SwiftTheme.light(),
      home: const WelcomeScreen(),
    );
  }
}

class _ErrorFallback extends StatelessWidget {
  const _ErrorFallback({required this.details});
  final FlutterErrorDetails details;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.background,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline_rounded,
                  color: AppColors.danger, size: 56),
              const SizedBox(height: 16),
              const Text('Something went wrong',
                  style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 18,
                      fontWeight: FontWeight.w700)),
              const SizedBox(height: 8),
              Text(
                details.exceptionAsString(),
                textAlign: TextAlign.center,
                style: AppTypography.bodySm(AppColors.textSecondary),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
