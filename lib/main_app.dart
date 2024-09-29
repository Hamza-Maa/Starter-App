import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'providers/user_provider.dart';
import 'screens/login_screen.dart';
import 'screens/postlist_screen.dart';

class StarterApp extends ConsumerWidget {
  const StarterApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: user != null ? const PostListScreen() : const LoginScreen(), // Conditional navigation
    );
  }
}