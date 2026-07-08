import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';

class AuthProvider extends ChangeNotifier {
  bool _isAuthenticated = false;
  User? _currentUser;
  bool _isInitialized = false;

  final List<User> _users = [
    User(
      email: 'admin@perpus.com',
      password: 'admin123',
      nama: 'Administrator',
      role: 'administrator',
    ),
    User(
      email: 'pustakawan@perpus.com',
      password: 'pustakawan123',
      nama: 'Pustakawan',
      role: 'pustakawan',
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
      final savedEmail = prefs.getString('email');

      if (savedEmail != null && savedEmail.isNotEmpty) {
        final user = _users.firstWhere(
          (u) => u.email == savedEmail,
          orElse: () => User(email: '', password: '', nama: '', role: ''),
        );
        
        if (user.email.isNotEmpty) {
          _currentUser = user;
          _isAuthenticated = true;
        }
      }
    } catch (e) {
      print('Error reading shared preferences: $e');
    } finally {
      _isInitialized = true;
      notifyListeners();
    }
  }

  Future<bool> login(String email, String password) async {
    try {
      final user = _users.firstWhere(
        (u) => u.email == email && u.password == password,
        orElse: () => User(email: '', password: '', nama: '', role: ''),
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
      await prefs.setString('email', user.email);

      notifyListeners();
      return true;
    } catch (e) {
      print('Login failed: $e');
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
      print('Error removing session: $e');
    }
    
    notifyListeners();
  }

  Future<bool> register(User user, String password) async {
    if (_users.any((u) => u.email == user.email)) {
      return false;
    }

    final newUser = User(
      email: user.email,
      password: password,
      nama: user.nama,
      role: 'siswa',
    );

    _users.add(newUser);
    notifyListeners();
    return true;
  }

  void addUser(User user, String password) {
    final newUser = User(
      email: user.email,
      password: password,
      nama: user.nama,
      role: user.role,
    );
    _users.add(newUser);
    notifyListeners();
  }

  void updateUser(User updatedUser) {
    final index = _users.indexWhere((user) => user.email == updatedUser.email);
    if (index != -1) {
      _users[index] = User(
        email: updatedUser.email,
        password: _users[index].password,
        nama: updatedUser.nama,
        role: updatedUser.role,
      );
      notifyListeners();
    }
  }

  void deleteUser(String email) {
    _users.removeWhere((user) => user.email == email);
    notifyListeners();
  }

  User? getUserByEmail(String email) {
    try {
      final user = _users.firstWhere(
        (u) => u.email == email,
        orElse: () => User(email: '', password: '', nama: '', role: ''),
      );
      return user.email.isEmpty ? null : user;
    } catch (e) {
      return null;
    }
  }
}