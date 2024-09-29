// providers/user_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user_model.dart';
import '../services/user_service.dart';

final userServiceProvider = Provider((ref) => UserService());

class UserNotifier extends StateNotifier<UserModel?> {
  final UserService _userService;

  UserNotifier(this._userService) : super(null) {
    _loadUser(); // Load user data when the provider is created
  }

  // Load user data from shared preferences
  Future<void> _loadUser() async {
    try {
      final user = await _userService.getUser();
      state = user; // Set the user state if a user is found
    } catch (e) {
      // Handle error if needed
      print('Error loading user: ${e.toString()}');
    }
  }

  // Simulate login
  Future<void> login(String username, String password) async {
    try {
      final user = await _userService.login(username, password);
      if (user != null) {
        state = user; // Set logged-in user
      } else {
        throw Exception('Invalid username or password');
      }
    } catch (e) {
      throw Exception('Login error: ${e.toString()}');
    }
  }

  // Simulate user signup
  Future<void> signup(String name, String username, String email, String phone,
      String password) async {
    try {
      final newUser =
          await _userService.signup(name, username, email, phone, password);
      state = newUser; // Set newly registered user
    } catch (e) {
      throw Exception('Signup error: ${e.toString()}');
    }
  }

  // Fetch user profile by ID
  Future<void> fetchUserProfile(String id) async {
    try {
      final user = await _userService.fetchUserById(id);
      state = user; // Set fetched user
    } catch (e) {
      throw Exception('Error fetching user profile: ${e.toString()}');
    }
  }

  // Update user profile
  Future<void> updateUserProfile(UserModel user) async {
    try {
      final updatedUser = await _userService.updateUser(user);
      state = updatedUser; // Set updated user
    } catch (e) {
      throw Exception('Error updating profile: ${e.toString()}');
    }
  }

  // Logout method
  Future<void> logout() async {
    await _userService.clearUser(); // Clear user data from shared preferences
    state = null; // Clear the user state
  }
}

// Provider for the current logged-in user
final userProvider = StateNotifierProvider<UserNotifier, UserModel?>(
  (ref) {
    final userService = ref.read(userServiceProvider);
    return UserNotifier(userService);
  },
);
