// screens/login_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/custom_button.dart';
import '../providers/user_provider.dart';
import '../widgets/snackbar_widget.dart'; // Import the SnackbarWidget
import 'postlist_screen.dart';
import 'signup_screen.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key}); // Added constructor for consistency

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userNotifier = ref.read(userProvider.notifier);
    final TextEditingController _usernameController = TextEditingController();
    final TextEditingController _passwordController = TextEditingController();
    final _formKey = GlobalKey<FormState>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Username Field
                CustomTextField(
                  controller: _usernameController,
                  hintText: 'Username',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your username';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),
                // Password Field
                CustomTextField(
                  controller: _passwordController,
                  hintText: 'Password',
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    } else if (value.length < 6) {
                      return 'Password must be at least 6 characters long';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),
                // Login Button
                CustomButton(
                  text: 'Login',
                  onPressed: () async {
                    if (_formKey.currentState?.validate() ?? false) {
                      try {
                        await userNotifier.login(
                          _usernameController.text,
                          _passwordController.text,
                        );
                        // On successful login, navigate to the home screen
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                 PostListScreen(), // Replace with your HomeScreen
                          ),
                        );
                      } catch (error) {
                        SnackbarWidget.show(
                            context, error.toString()); // Show error message
                      }
                    }
                  },
                ),
                const SizedBox(height: 24.0),
                // Signup prompt
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            const SignupScreen(), // Navigate to signup screen
                      ),
                    );
                  },
                  child: const Text(
                    "Don't have an account? Sign up.",
                    style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
