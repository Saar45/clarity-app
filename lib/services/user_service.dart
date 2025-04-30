import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';

class UserService {
  static const String USER_KEY = 'current_user';
  static const String ALL_USERS_KEY = 'all_users';
  static User? _currentUser;
  
  // Demo users
  static final List<User> _defaultUsers = [
    User(
      id: '1', 
      name: 'Utilisateur Demo', 
      email: 'demo@clarity.com', 
      passwordHash: 'password123'
    ),
    User(
      id: '2', 
      name: 'Administrateur', 
      email: 'admin@clarity.com', 
      passwordHash: 'admin123'
    ),
  ];
  
  // In-memory users list
  static List<User> _users = [];
  
  // Initialize user data
  static Future<void> initialize() async {
    final prefs = await SharedPreferences.getInstance();
    
    // Load users from SharedPreferences or use defaults
    if (prefs.containsKey(ALL_USERS_KEY)) {
      final usersJson = prefs.getStringList(ALL_USERS_KEY) ?? [];
      _users = usersJson.map((json) => User.fromJson(jsonDecode(json))).toList();
    } else {
      _users = List.from(_defaultUsers);
      await _saveUsers();
    }
    
    // Check for logged in user
    if (prefs.containsKey(USER_KEY)) {
      try {
        final userJson = prefs.getString(USER_KEY);
        if (userJson != null) {
          _currentUser = User.fromJson(jsonDecode(userJson));
        }
      } catch (e) {
        print('Error loading user: $e');
      }
    }
  }
  
  // Get current user
  static User? get currentUser => _currentUser;
  
  // Login user
  static Future<bool> login(String email, String password) async {
    final user = _users.firstWhere(
      (user) => user.email == email && user.passwordHash == password,
      orElse: () => User.empty(),
    );
    
    if (user.id.isNotEmpty) {
      _currentUser = user;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(USER_KEY, jsonEncode(user.toJson()));
      return true;
    }
    return false;
  }
  
  // Register user
  static Future<bool> register(String name, String email, String password) async {
    // Check if email already exists
    if (_users.any((user) => user.email == email)) {
      return false;
    }
    
    // Create new user
    final newUser = User(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      email: email,
      passwordHash: password,
    );
    
    _users.add(newUser);
    _currentUser = newUser;
    
    // Save to SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(USER_KEY, jsonEncode(newUser.toJson()));
    await _saveUsers();
    
    return true;
  }
  
  // Logout user
  static Future<void> logout() async {
    _currentUser = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(USER_KEY);
  }
  
  // Save all users to SharedPreferences
  static Future<void> _saveUsers() async {
    final prefs = await SharedPreferences.getInstance();
    final usersJson = _users.map((user) => jsonEncode(user.toJson())).toList();
    await prefs.setStringList(ALL_USERS_KEY, usersJson);
  }
  
  // Get user by email
  static User? getUserByEmail(String email) {
    try {
      // Make sure users are initialized
      if (_users.isEmpty) {
        // Return default user if not found
        return _defaultUsers.firstWhere(
          (user) => user.email == email,
          orElse: () => User.empty()
        );
      }
      
      return _users.firstWhere(
        (user) => user.email == email,
        orElse: () => User.empty()
      );
    } catch (e) {
      print('Error getting user by email: $e');
      return null;
    }
  }
  
  // Check if a user exists by email
  static bool userExists(String email) {
    return _users.any((user) => user.email == email);
  }
  
  // Get the name of a user by email
  static String getNameByEmail(String email) {
    final user = getUserByEmail(email);
    return user?.name ?? 'Unknown User';
  }
  
  // Get all users for sharing suggestions (except current user)
  static List<User> getSharingUsers() {
    if (_currentUser == null) return [];
    return _users.where((user) => user.id != _currentUser!.id).toList();
  }
}
