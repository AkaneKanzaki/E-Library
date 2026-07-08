import 'package:flutter/material.dart';
import '../models/peminjaman.dart';
import 'book_provider.dart';

class PeminjamanProvider extends ChangeNotifier {
  final List<Peminjaman> _peminjaman = [];
  final BookProvider _bookProvider;

  PeminjamanProvider(this._bookProvider);

  List<Peminjaman> get peminjaman => _peminjaman;

  List<Peminjaman> getPeminjamanByUserId(String userId) {
    final result = _peminjaman.where((p) => p.userId == userId).toList();
    print('Peminjaman untuk user $userId: ${result.length}');
    return result;
  }

  Future<bool> pinjamBuku(String userId, String bookId) async {
    try {
      // Cek apakah buku tersedia
      final book = _bookProvider.getBookById(bookId);
      if (book == null || !book.tersedia) {
        print('Buku tidak tersedia: ${book?.tersedia}');
        return false;
      }

      // Cek apakah user sudah meminjam buku yang sama
      final existingPinjam = _peminjaman.any(
        (p) => p.bookId == bookId && p.userId == userId && p.status == 'dipinjam',
      );
      if (existingPinjam) {
        print('Buku sudah dipinjam oleh user');
        return false;
      }

      // Buat peminjaman baru
      final newPeminjaman = Peminjaman(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        userId: userId,
        bookId: bookId,
        tanggalPinjam: DateTime.now(),
        tanggalKembali: DateTime.now().add(const Duration(days: 7)),
        status: 'dipinjam',
      );

      // Update status buku
      _bookProvider.updateBookStatus(bookId, false);
      
      // Tambah ke daftar peminjaman
      _peminjaman.add(newPeminjaman);
      print('Peminjaman berhasil ditambahkan: ${_peminjaman.length}');
      notifyListeners();
      return true;
    } catch (e) {
      print('Error saat meminjam buku: $e');
      return false;
    }
  }

  Future<bool> kembalikanBuku(String peminjamanId) async {
    try {
      final index = _peminjaman.indexWhere((p) => p.id == peminjamanId);
      if (index == -1) return false;

      final peminjaman = _peminjaman[index];
      
      // Update status peminjaman
      _peminjaman[index] = Peminjaman(
        id: peminjaman.id,
        userId: peminjaman.userId,
        bookId: peminjaman.bookId,
        tanggalPinjam: peminjaman.tanggalPinjam,
        tanggalKembali: DateTime.now(),
        status: 'dikembalikan',
      );

      // Update status buku
      _bookProvider.updateBookStatus(peminjaman.bookId, true);
      
      notifyListeners();
      return true;
    } catch (e) {
      return false;
    }
  }

  int getJumlahBukuDipinjam(String userId) {
    final count = _peminjaman.where(
      (p) => p.userId == userId && p.status == 'dipinjam'
    ).length;
    print('Jumlah buku dipinjam user $userId: $count');
    return count;
  }

  int getJumlahRiwayatPeminjaman(String userId) {
    return _peminjaman.where((p) => p.userId == userId).length;
  }

  Future<void> refreshPeminjaman() async {
    // Update status buku berdasarkan peminjaman yang ada
    for (var pinjam in _peminjaman) {
      if (pinjam.status == 'dipinjam') {
        _bookProvider.updateBookStatus(pinjam.bookId, false);
      } else {
        _bookProvider.updateBookStatus(pinjam.bookId, true);
      }
    }
    notifyListeners();
  }
}