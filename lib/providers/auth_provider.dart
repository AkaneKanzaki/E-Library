import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';

class AuthProvider extends ChangeNotifier {
  bool _isAuthenticated = false;
  User? _currentUser;
  bool _isInitialized = false;

  final List<User> _users = [
    User(
      email: 'admin@library.com',
      password: 'admin123',
      name: 'Administrator',
      role: 'Administrator',
    ),
    User(
      email: 'librarian@library.com',
      password: 'librarian123',
      name: 'Librarian',
      role: 'Librarian',
    ),
  ];

  bool get isAuthenticated => _isAuthenticated;
  User? get currentUser => _currentUser;
  List<User> get users => _users;
  bool get isInitialized => _isInitialized;

  AuthProvider() {
    checkLoginStatus();
  }

  Future<void> checkLoginStatus() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedEmail = prefs.getString('email')?.toLowerCase();

      if (savedEmail != null && savedEmail.isNotEmpty) {
        final user = _users.firstWhere(
          (u) => u.email.trim().toLowerCase() == savedEmail,
          orElse: () => User(email: '', password: '', name: '', role: ''),
        );

        if (user.email.isNotEmpty) {
          _currentUser = user;
          _isAuthenticated = true;
        }
      }
    } catch (e) {
      debugPrint('Error reading shared preferences: $e');
    } finally {
      _isInitialized = true;
      notifyListeners();
    }
  }

  Future<bool> login(String email, String password) async {
    try {
      final trimmedEmail = email.trim().toLowerCase();
      final user = _users.firstWhere(
        (u) => u.email.trim().toLowerCase() == trimmedEmail && u.password == password,
        orElse: () => User(email: '', password: '', name: '', role: ''),
      );

      if (user.email.isEmpty) {
        _currentUser = null;
        _isAuthenticated = false;
        notifyListeners();
        return false;
      }

      _currentUser = user;
      _isAuthenticated = true;

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('email', user.email.toLowerCase());

      notifyListeners();
      return true;
    } catch (e) {
      debugPrint('Login error: $e');
      _currentUser = null;
      _isAuthenticated = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    _isAuthenticated = false;
    _currentUser = null;

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('email');
    } catch (e) {
      debugPrint('Error removing session: $e');
    }

    notifyListeners();
  }

  Future<bool> register(User user, String password) async {
    final trimmedEmail = user.email.trim().toLowerCase();
    if (_users.any((u) => u.email.trim().toLowerCase() == trimmedEmail)) {
      return false;
    }

    final newUser = User(
      email: trimmedEmail,
      password: password,
      name: user.name,
      role: 'student',
    );

    _users.add(newUser);
    notifyListeners();
    return true;
  }

  void addUser(User user, String password) {
    final newUser = User(
      email: user.email.trim().toLowerCase(),
      password: password,
      name: user.name,
      role: user.role,
    );
    _users.add(newUser);
    notifyListeners();
  }

  void updateUser(User updatedUser) {
    final index = _users.indexWhere((user) => user.email.trim().toLowerCase() == updatedUser.email.trim().toLowerCase());
    if (index != -1) {
      _users[index] = User(
        email: updatedUser.email.trim().toLowerCase(),
        password: _users[index].password,
        name: updatedUser.name,
        role: updatedUser.role,
      );
      notifyListeners();
    }
  }

  void deleteUser(String email) {
    _users.removeWhere((user) => user.email.trim().toLowerCase() == email.trim().toLowerCase());
    notifyListeners();
  }

  User? getUserByEmail(String email) {
    try {
      final user = _users.firstWhere(
        (u) => u.email.trim().toLowerCase() == email.trim().toLowerCase(),
        orElse: () => User(email: '', password: '', name: '', role: ''),
      );
      return user.email.isEmpty ? null : user;
    } catch (e) {
      return null;
    }
  }
}
