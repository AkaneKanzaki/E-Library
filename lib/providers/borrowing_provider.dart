import 'package:flutter/material.dart';
import '../models/borrowing.dart';
import 'book_provider.dart';
import '../services/db_helper.dart';

class BorrowingProvider extends ChangeNotifier {
  List<Borrowing> _borrowings = [];
  final BookProvider _bookProvider;

  BorrowingProvider(this._bookProvider) {
    _loadBorrowings();
  }

  List<Borrowing> get borrowings => _borrowings;

  Future<void> _loadBorrowings() async {
    final db = await DatabaseHelper.instance.database;
    final maps = await db.query('borrowings');

    _borrowings = maps.map((map) => Borrowing.fromMap(map)).toList();
    notifyListeners();
  }

  List<Borrowing> getBorrowingsByUserId(String userId) {
    return _borrowings.where((p) => p.userId == userId).toList();
  }

  Future<bool> borrowBook(String userId, String bookId) async {
    try {
      final book = _bookProvider.getBookById(bookId);
      if (book == null || !book.isAvailable) {
        return false;
      }

      final existingPinjam = _borrowings.any(
        (p) => p.bookId == bookId && p.userId == userId && p.status == 'borrowed',
      );
      if (existingPinjam) {
        return false;
      }

      final newBorrowing = Borrowing(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        userId: userId,
        bookId: bookId,
        borrowDate: DateTime.now(),
        returnDate: null,
        dueDate: DateTime.now().add(const Duration(days: 7)),
        status: 'borrowed',
      );

      final db = await DatabaseHelper.instance.database;
      await db.insert('borrowings', newBorrowing.toMap());

      await _bookProvider.updateBookStatus(bookId, false);
      
      _borrowings.add(newBorrowing);
      notifyListeners();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> returnBook(String borrowingId) async {
    try {
      final index = _borrowings.indexWhere((p) => p.id == borrowingId);
      if (index == -1) return false;

      final borrowings = _borrowings[index];
      
      final updatedBorrowing = Borrowing(
        id: borrowings.id,
        userId: borrowings.userId,
        bookId: borrowings.bookId,
        borrowDate: borrowings.borrowDate,
        returnDate: DateTime.now(),
        dueDate: borrowings.dueDate,
        status: 'returned',
      );

      final db = await DatabaseHelper.instance.database;
      await db.update(
        'borrowings',
        updatedBorrowing.toMap(),
        where: 'id = ?',
        whereArgs: [updatedBorrowing.id],
      );

      _borrowings[index] = updatedBorrowing;
      await _bookProvider.updateBookStatus(borrowings.bookId, true);
      
      notifyListeners();
      return true;
    } catch (e) {
      return false;
    }
  }

  int getBorrowedBooksCount(String userId) {
    return _borrowings.where((p) => p.userId == userId && p.status == 'borrowed').length;
  }

  int getBorrowingHistoryCount(String userId) {
    return _borrowings.where((p) => p.userId == userId).length;
  }

  Future<void> refreshBorrowings() async {
    for (var borrowItem in _borrowings) {
      if (borrowItem.status == 'borrowed') {
        await _bookProvider.updateBookStatus(borrowItem.bookId, false);
      } else {
        await _bookProvider.updateBookStatus(borrowItem.bookId, true);
      }
    }
    notifyListeners();
  }
}