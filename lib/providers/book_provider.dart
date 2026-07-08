import 'package:flutter/material.dart';
import '../models/book.dart';
import '../services/db_helper.dart';

class BookProvider extends ChangeNotifier {
  List<Book> _books = [];

  List<Book> get books => _books;

  BookProvider() {
    _loadBooks();
  }

  Future<void> _loadBooks() async {
    final db = await DatabaseHelper.instance.database;
    final maps = await db.query('books');

    if (maps.isEmpty) {
      await _seedDefaultBooks();
    } else {
      _books = maps.map((map) => Book.fromMap(map)).toList();
      notifyListeners();
    }
  }

  Future<void> _seedDefaultBooks() async {
    final db = await DatabaseHelper.instance.database;
    final defaultBooks = [
      Book(
        id: '1',
        judul: 'Bahasa Indonesia',
        penulis: 'Eugenia Rakhma Subarna, Sofie Dewayani, Cicilia Erni Setyowati',
        penerbit: 'Kementerian Pendidikan, Kebudayaan, Riset, dan Teknologi Republik Indonesia',
        tahunTerbit: '2023',
        deskripsi: 'Buku pelajaran Bahasa Indonesia untuk siswa SMP/MTs Kelas VII. Buku ini dirancang untuk membantu siswa meningkatkan kemampuan berbahasa Indonesia melalui kegiatan pembelajaran yang menyenangkan, mencakup berbagai topik seperti teks deskripsi, teks naratif, teks prosedur, teks berita, dan teks tanggapan.',
        coverUrl: 'assets/images/bahasa_indonesia.png',
        tersedia: true,
        kategori: 'Buku Pelajaran Bahasa Indonesia',
        bookPath: 'assets/books/bahasa_indonesia.pdf',
        jumlahHalaman: 272,
      ),
      Book(
        id: '2',
        judul: 'Ilmu Pengetahuan Alam',
        penulis: 'Victoriani Inabuy, Cece Sutia, Okky Fajar Tri Maryana, Budiyanti Dwi Hardanie, Sri Handayani Lestari',
        penerbit: 'Kementerian Pendidikan, Kebudayaan, Riset, dan Teknologi Republik Indonesia',
        tahunTerbit: '2023',
        deskripsi: 'Buku pelajaran Ilmu Pengetahuan Alam untuk siswa SMP/MTs Kelas VII. Buku ini merupakan sumber belajar utama dalam pembelajaran bagi siswa dan menjadi salah satu referensi atau inspirasi bagi guru dalam merancang dan mengembangkan pembelajaran sesuai karakteristik, potensi, dan kebutuhan peserta didik.',
        coverUrl: 'assets/images/ipa.png',
        tersedia: true,
        kategori: 'Ilmu Pengetahuan Alam, Buku Pelajaran',
        bookPath: 'assets/books/ipa.pdf',
        jumlahHalaman: 280,
      ),
      Book(
        id: '3',
        judul: 'Ilmu Pengetahuan Sosial',
        penulis: 'Muhammad Nursa\'ban, Supardi',
        penerbit: 'Kementerian Pendidikan, Kebudayaan, Riset, dan Teknologi Republik Indonesia',
        tahunTerbit: '2023',
        deskripsi: 'Buku pelajaran Ilmu Pengetahuan Sosial untuk siswa SMP/MTs Kelas VII. Buku ini menyajikan materi terkait dengan keberadaan diri dan keluarga dalam keberagaman lingkungan sosial terdekat, potensi ekonomi lingkungan, dan pemberdayaan masyarakat.',
        coverUrl: 'assets/images/ips.png',
        tersedia: true,
        kategori: 'Ilmu Pengetahuan Sosial, Buku Pelajaran',
        bookPath: 'assets/books/ips.pdf',
        jumlahHalaman: 280,
      ),
    ];

    for (var book in defaultBooks) {
      await db.insert('books', book.toMap());
    }
    
    _books = defaultBooks;
    notifyListeners();
  }

  Book? getBookById(String id) {
    try {
      return _books.firstWhere((book) => book.id == id);
    } catch (e) {
      return null;
    }
  }

  Future<void> addBook(Book book) async {
    final db = await DatabaseHelper.instance.database;
    await db.insert('books', book.toMap());
    
    _books.add(book);
    notifyListeners();
  }

  Future<void> updateBook(Book updatedBook) async {
    final db = await DatabaseHelper.instance.database;
    await db.update(
      'books',
      updatedBook.toMap(),
      where: 'id = ?',
      whereArgs: [updatedBook.id],
    );

    final index = _books.indexWhere((book) => book.id == updatedBook.id);
    if (index != -1) {
      _books[index] = updatedBook;
      notifyListeners();
    }
  }

  Future<void> updateBookStatus(String id, bool tersedia) async {
    final db = await DatabaseHelper.instance.database;
    await db.update(
      'books',
      {'tersedia': tersedia ? 1 : 0},
      where: 'id = ?',
      whereArgs: [id],
    );

    final index = _books.indexWhere((book) => book.id == id);
    if (index != -1) {
      final book = _books[index];
      _books[index] = Book(
        id: book.id,
        judul: book.judul,
        penulis: book.penulis,
        penerbit: book.penerbit,
        tahunTerbit: book.tahunTerbit,
        deskripsi: book.deskripsi,
        coverUrl: book.coverUrl,
        tersedia: tersedia,
        kategori: book.kategori,
        bookPath: book.bookPath,
        jumlahHalaman: book.jumlahHalaman,
      );
      notifyListeners();
    }
  }

  Future<void> deleteBook(String id) async {
    final db = await DatabaseHelper.instance.database;
    await db.delete(
      'books',
      where: 'id = ?',
      whereArgs: [id],
    );

    _books.removeWhere((book) => book.id == id);
    notifyListeners();
  }

  List<Book> searchBooks(String query) {
    return _books.where((book) =>
      book.judul.toLowerCase().contains(query.toLowerCase()) ||
      book.penulis.toLowerCase().contains(query.toLowerCase()) ||
      book.kategori.toLowerCase().contains(query.toLowerCase())
    ).toList();
  }
}