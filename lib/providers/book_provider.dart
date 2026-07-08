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
        title: 'Bahasa Indonesia',
        author: 'Eugenia Rakhma Subarna, Sofie Dewayani, Cicilia Erni Setyowati',
        publisher: 'Kementerian Pendidikan, Kebudayaan, Riset, dan Teknologi Republik Indonesia',
        publishYear: '2023',
        description: 'Indonesian Language textbook for Junior High School Grade VII. Designed to help students improve their Indonesian language skills through fun learning activities.',
        coverUrl: 'assets/images/bahasa_indonesia.png',
        isAvailable: true,
        category: 'Indonesian Language Textbook',
        bookPath: 'assets/books/bahasa_indonesia.pdf',
        pageCount: 272,
      ),
      Book(
        id: '2',
        title: 'Ilmu Pengetahuan Alam',
        author: 'Victoriani Inabuy, Cece Sutia, Okky Fajar Tri Maryana, Budiyanti Dwi Hardanie, Sri Handayani Lestari',
        publisher: 'Kementerian Pendidikan, Kebudayaan, Riset, dan Teknologi Republik Indonesia',
        publishYear: '2023',
        description: 'Natural Sciences textbook for Junior High School Grade VII. A core learning resource for students and reference for teachers in designing learning activities.',
        coverUrl: 'assets/images/ipa.png',
        isAvailable: true,
        category: 'Natural Sciences, Textbook',
        bookPath: 'assets/books/ipa.pdf',
        pageCount: 280,
      ),
      Book(
        id: '3',
        title: 'Ilmu Pengetahuan Sosial',
        author: 'Muhammad Nursa\'ban, Supardi',
        publisher: 'Kementerian Pendidikan, Kebudayaan, Riset, dan Teknologi Republik Indonesia',
        publishYear: '2023',
        description: 'Social Sciences textbook for Junior High School Grade VII. Presents materials related to self-existence and family in the closest social environment.',
        coverUrl: 'assets/images/ips.png',
        isAvailable: true,
        category: 'Social Sciences, Textbook',
        bookPath: 'assets/books/ips.pdf',
        pageCount: 280,
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

  Future<void> updateBookStatus(String id, bool isAvailable) async {
    final db = await DatabaseHelper.instance.database;
    await db.update(
      'books',
      {'isAvailable': isAvailable ? 1 : 0},
      where: 'id = ?',
      whereArgs: [id],
    );

    final index = _books.indexWhere((book) => book.id == id);
    if (index != -1) {
      final book = _books[index];
      _books[index] = Book(
        id: book.id,
        title: book.title,
        author: book.author,
        publisher: book.publisher,
        publishYear: book.publishYear,
        description: book.description,
        coverUrl: book.coverUrl,
        isAvailable: isAvailable,
        category: book.category,
        bookPath: book.bookPath,
        pageCount: book.pageCount,
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
      book.title.toLowerCase().contains(query.toLowerCase()) ||
      book.author.toLowerCase().contains(query.toLowerCase()) ||
      book.category.toLowerCase().contains(query.toLowerCase())
    ).toList();
  }
}