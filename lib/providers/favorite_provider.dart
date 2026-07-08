import 'package:flutter/material.dart';
import '../services/db_helper.dart';

class FavoriteProvider extends ChangeNotifier {
  List<String> _favoriteBookIds = [];

  FavoriteProvider() {
    _loadFavorites();
  }

  List<String> get favoriteBookIds => _favoriteBookIds;

  Future<void> _loadFavorites() async {
    final db = await DatabaseHelper.instance.database;
    final maps = await db.query('favorites');
    
    _favoriteBookIds = maps.map((map) => map['bookId'] as String).toList();
    notifyListeners();
  }

  bool isFavorite(String bookId) {
    return _favoriteBookIds.contains(bookId);
  }

  Future<void> toggleFavorite(String bookId) async {
    final db = await DatabaseHelper.instance.database;
    
    if (_favoriteBookIds.contains(bookId)) {
      await db.delete(
        'favorites',
        where: 'bookId = ?',
        whereArgs: [bookId],
      );
      _favoriteBookIds.remove(bookId);
    } else {
      await db.insert('favorites', {'bookId': bookId});
      _favoriteBookIds.add(bookId);
    }
    notifyListeners();
  }

  int getFavoriteCount() {
    return _favoriteBookIds.length;
  }
}