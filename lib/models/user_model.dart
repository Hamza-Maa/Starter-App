// models/user_model.dart
class UserModel {
  final String id; // Change to String
  final String name;
  final String username;
  final String email;
  final String phone;
  final String website;
  final String password;

  UserModel({
    required this.id,
    required this.name,
    required this.username,
    required this.email,
    required this.phone,
    required this.website,
    required this.password,
  });

  // Factory method to create a UserModel from JSON
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'], // No changes here, it already uses String
      name: json['name'],
      username: json['username'],
      email: json['email'],
      phone: json['phone'],
      website: json['website'],
      password: json['password'], // Fetching password from API
    );
  }

  // Convert UserModel to JSON (for updates, etc.)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'username': username,
      'email': email,
      'phone': phone,
      'website': website,
      'password': password,
    };
  }
}
