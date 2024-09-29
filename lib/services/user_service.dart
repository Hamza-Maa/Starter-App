// services/user_service.dart
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';

class UserService {
  final Dio _dio = Dio();
  final String baseUrl = 'API KEY';

  // Fetch all users (could be used for signup or login)
  Future<List<UserModel>> fetchUsers() async {
    try {
      final response = await _dio.get(baseUrl);
      final List<dynamic> userData = response.data;

      return userData.map((json) => UserModel.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to load users: $e'); // Added error detail
    }
  }

  // Simulate login by checking if the user exists and matches the password
  Future<UserModel?> login(String username, String password) async {
    try {
      final users = await fetchUsers();
      // Check the password from the mock API
      for (var user in users) {
        if (user.username == username && user.password == password) {
          await saveUser(user); // Save user data after successful login
          return user;
        }
      }
      return null; // No user found or password mismatch
    } catch (e) {
      throw Exception('Login failed: $e'); // Added error detail
    }
  }

  // Simulate user signup
  Future<UserModel> signup(String name, String username, String email,
      String phone, String password) async {
    try {
      final newUser = UserModel(
        id: '', // Placeholder for the ID, since the API will return it
        name: name,
        username: username,
        email: email,
        phone: phone,
        website: '',
        password: password, // Store the password locally
      );

      // Send a POST request to create a new user
      final response = await _dio.post(baseUrl, data: newUser.toJson());
      await saveUser(UserModel.fromJson(response.data)); // Save new user data
      return UserModel.fromJson(response.data);
    } catch (e) {
      throw Exception('Signup failed: $e'); // Added error detail
    }
  }

  // Fetch a specific user by ID
  Future<UserModel> fetchUserById(String id) async {
    try {
      final response = await _dio.get('$baseUrl/$id');
      return UserModel.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to load user: $e'); // Added error detail
    }
  }

  // Simulate updating user profile
  Future<UserModel> updateUser(UserModel user) async {
    try {
      final response =
          await _dio.put('$baseUrl/${user.id}', data: user.toJson());
      return UserModel.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to update user: $e'); // Added error detail
    }
  }

  // Save user information in shared preferences
  Future<void> saveUser(UserModel user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('userId', user.id);
    await prefs.setString('username', user.username);
    await prefs.setString('password', user.password); // Optionally store password
    // Save other user details if needed
  }

  // Retrieve user information from shared preferences
  Future<UserModel?> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('userId');
    if (userId != null) {
      return UserModel(
        id: userId,
        username: prefs.getString('username') ?? '',
        password: prefs.getString('password') ?? '', 
        name: prefs.getString('name') ?? '', 
        email: prefs.getString('email') ?? '',
        phone: prefs.getString('phone') ?? '',
        website: prefs.getString('website') ?? '',

        // Fetch other fields as necessary
      );
    }
    return null;
  }

  // Clear user data from shared preferences
  Future<void> clearUser() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('userId');
    await prefs.remove('username');
    await prefs.remove('password');
  }
}
