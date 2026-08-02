import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:swift_core/swift_core.dart';
import 'home_screen_v2.dart';
import 'welcome_screen.dart';

void main() {
  runApp(const ProviderScope(child: SwiftRiderApp()));
}

class SwiftRiderApp extends StatelessWidget {
  const SwiftRiderApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Swift Rider',
      theme: SwiftTheme.light(),
      home: const WelcomeScreen(),
      routes: {
        '/home': (context) => const HomeScreenV2(),
      },
    );
  }
}
