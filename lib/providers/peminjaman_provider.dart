import 'package:flutter/material.dart';
import '../models/peminjaman.dart';
import 'book_provider.dart';
import '../services/db_helper.dart';

class PeminjamanProvider extends ChangeNotifier {
  List<Peminjaman> _peminjaman = [];
  final BookProvider _bookProvider;

  PeminjamanProvider(this._bookProvider) {
    _loadPeminjaman();
  }

  List<Peminjaman> get peminjaman => _peminjaman;

  Future<void> _loadPeminjaman() async {
    final db = await DatabaseHelper.instance.database;
    final maps = await db.query('peminjaman');

    _peminjaman = maps.map((map) => Peminjaman.fromMap(map)).toList();
    notifyListeners();
  }

  List<Peminjaman> getPeminjamanByUserId(String userId) {
    return _peminjaman.where((p) => p.userId == userId).toList();
  }

  Future<bool> pinjamBuku(String userId, String bookId) async {
    try {
      final book = _bookProvider.getBookById(bookId);
      if (book == null || !book.tersedia) {
        return false;
      }

      final existingPinjam = _peminjaman.any(
        (p) => p.bookId == bookId && p.userId == userId && p.status == 'dipinjam',
      );
      if (existingPinjam) {
        return false;
      }

      final newPeminjaman = Peminjaman(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        userId: userId,
        bookId: bookId,
        tanggalPinjam: DateTime.now(),
        tanggalKembali: null,
        batasWaktu: DateTime.now().add(const Duration(days: 7)),
        status: 'dipinjam',
      );

      final db = await DatabaseHelper.instance.database;
      await db.insert('peminjaman', newPeminjaman.toMap());

      await _bookProvider.updateBookStatus(bookId, false);
      
      _peminjaman.add(newPeminjaman);
      notifyListeners();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> kembalikanBuku(String peminjamanId) async {
    try {
      final index = _peminjaman.indexWhere((p) => p.id == peminjamanId);
      if (index == -1) return false;

      final peminjaman = _peminjaman[index];
      
      final updatedPeminjaman = Peminjaman(
        id: peminjaman.id,
        userId: peminjaman.userId,
        bookId: peminjaman.bookId,
        tanggalPinjam: peminjaman.tanggalPinjam,
        tanggalKembali: DateTime.now(),
        batasWaktu: peminjaman.batasWaktu,
        status: 'dikembalikan',
      );

      final db = await DatabaseHelper.instance.database;
      await db.update(
        'peminjaman',
        updatedPeminjaman.toMap(),
        where: 'id = ?',
        whereArgs: [updatedPeminjaman.id],
      );

      _peminjaman[index] = updatedPeminjaman;
      await _bookProvider.updateBookStatus(peminjaman.bookId, true);
      
      notifyListeners();
      return true;
    } catch (e) {
      return false;
    }
  }

  int getJumlahBukuDipinjam(String userId) {
    return _peminjaman.where((p) => p.userId == userId && p.status == 'dipinjam').length;
  }

  int getJumlahRiwayatPeminjaman(String userId) {
    return _peminjaman.where((p) => p.userId == userId).length;
  }

  Future<void> refreshPeminjaman() async {
    for (var pinjam in _peminjaman) {
      if (pinjam.status == 'dipinjam') {
        await _bookProvider.updateBookStatus(pinjam.bookId, false);
      } else {
        await _bookProvider.updateBookStatus(pinjam.bookId, true);
      }
    }
    notifyListeners();
  }
}