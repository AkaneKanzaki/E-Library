import 'package:flutter/material.dart';

class FavoriteProvider extends ChangeNotifier {
  final List<String> _favoriteBookIds = [];

  List<String> get favoriteBookIds => _favoriteBookIds;

  bool isFavorite(String bookId) {
    return _favoriteBookIds.contains(bookId);
  }

  void toggleFavorite(String bookId) {
    if (_favoriteBookIds.contains(bookId)) {
      _favoriteBookIds.remove(bookId);
    } else {
      _favoriteBookIds.add(bookId);
    }
    notifyListeners();
  }

  int getFavoriteCount() {
    return _favoriteBookIds.length;
  }
} 