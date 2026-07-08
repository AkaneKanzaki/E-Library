import 'package:flutter/material.dart';
import '../models/book.dart';

class BookProvider extends ChangeNotifier {
  final List<Book> _books = [
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

  List<Book> get books => _books;

  Book? getBookById(String id) {
    try {
      return _books.firstWhere((book) => book.id == id);
    } catch (e) {
      return null;
    }
  }

  void addBook(Book book) {
    _books.add(book);
    notifyListeners();
  }

  void updateBook(Book updatedBook) {
    final index = _books.indexWhere((book) => book.id == updatedBook.id);
    if (index != -1) {
      _books[index] = Book(
        id: updatedBook.id,
        judul: updatedBook.judul,
        penulis: updatedBook.penulis,
        penerbit: updatedBook.penerbit,
        tahunTerbit: updatedBook.tahunTerbit,
        deskripsi: updatedBook.deskripsi,
        coverUrl: updatedBook.coverUrl,
        tersedia: updatedBook.tersedia,
        kategori: updatedBook.kategori,
        bookPath: updatedBook.bookPath,
        jumlahHalaman: updatedBook.jumlahHalaman,
      );
      notifyListeners();
    }
  }

  void updateBookStatus(String id, bool tersedia) {
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

  void deleteBook(String id) {
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