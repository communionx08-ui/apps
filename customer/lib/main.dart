import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:swift_core/swift_core.dart';
import 'screens/home_screen_v2.dart';
import 'welcome_screen.dart';

void main() {
  runApp(const ProviderScope(child: SwiftCustomerApp()));
}

class SwiftCustomerApp extends StatelessWidget {
  const SwiftCustomerApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Swift Customer',
      theme: SwiftTheme.light(),
      home: const WelcomeScreen(),
      routes: {
        '/home': (context) => const HomeScreenV2(),
      },
    );
  }
}
