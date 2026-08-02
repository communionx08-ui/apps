import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:swift_core/swift_core.dart';
import 'main_scaffold.dart';
import 'welcome_screen.dart';

void main() {
  runApp(const ProviderScope(child: SwiftVendorApp()));
}

class SwiftVendorApp extends StatelessWidget {
  const SwiftVendorApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Swift Vendor',
      theme: SwiftTheme.light(),
      home: const WelcomeScreen(),
      routes: {
        '/home': (context) => const MainScaffold(),
      },
    );
  }
}
