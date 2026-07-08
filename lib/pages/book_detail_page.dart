import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/book.dart';
import '../providers/peminjaman_provider.dart';
import '../providers/auth_provider.dart';
import '../providers/favorite_provider.dart';
import './read_book_page.dart';

class BookDetailPage extends StatefulWidget {
  final Book book;

  const BookDetailPage({super.key, required this.book});

  @override
  State<BookDetailPage> createState() => _BookDetailPageState();
}

class _BookDetailPageState extends State<BookDetailPage> {
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final peminjamanProvider = Provider.of<PeminjamanProvider>(context);
    final user = authProvider.currentUser;

    // Cek apakah buku sedang dipinjam oleh user ini
    final bool isBeingBorrowedByUser = user != null &&
        peminjamanProvider
            .getPeminjamanByUserId(user.email)
            .where((p) => p.bookId == widget.book.id && p.status == 'dipinjam')
            .isNotEmpty;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Book Details'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header dengan gambar cover
            Container(
              width: double.infinity,
              color: Theme.of(context).colorScheme.surface,
              child: Column(
                children: [
                  const SizedBox(height: 16),
                  Container(
                    width: 180,
                    height: 270,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.08),
                          spreadRadius: 0,
                          blurRadius: 15,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.asset(
                        widget.book.coverUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: Colors.grey.shade200,
                            child: const Icon(Icons.book, size: 80),
                          );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),

            // Informasi buku
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Judul dan Status
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          widget.book.judul,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color:
                              widget.book.tersedia ? Colors.green : Colors.red,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          widget.book.tersedia ? 'Available' : 'Dipinjam',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Penulis
                  Text(
                    'Oleh: ${widget.book.penulis}',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Info detail dalam card
                  Card(
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildInfoRow('Publisher', widget.book.penerbit),
                          const Divider(),
                          _buildInfoRow(
                              'Tahun Terbit', widget.book.tahunTerbit),
                          const Divider(),
                          _buildInfoRow('Kategori', widget.book.kategori),
                          const Divider(),
                          _buildInfoRow('Jumlah Halaman',
                              '${widget.book.jumlahHalaman} halaman'),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Deskripsi
                  const Text(
                    'Description',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      widget.book.deskripsi,
                      style: const TextStyle(
                        fontSize: 16,
                        height: 1.5,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Tombol aksi
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Expanded(
                          child: isBeingBorrowedByUser
                              ? ElevatedButton.icon(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            ReadBookPage(book: widget.book),
                                      ),
                                    );
                                  },
                                  icon: const Icon(Icons.book_outlined),
                                  label: const Text('Read Book'),
                                  style: ElevatedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 12),
                                  ),
                                )
                              : ElevatedButton.icon(
                                  onPressed: widget.book.tersedia
                                      ? () async {
                                          if (user != null) {
                                            final success =
                                                await peminjamanProvider
                                                    .pinjamBuku(
                                              user.email,
                                              widget.book.id,
                                            );
                                            if (!context.mounted) return;
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                  success
                                                      ? 'Book successfully borrowed'
                                                      : 'Gagal meminjam buku',
                                                ),
                                              ),
                                            );
                                          }
                                        }
                                      : null,
                                  icon: const Icon(Icons.bookmark_add),
                                  label: Text(widget.book.tersedia
                                      ? 'Pinjam Buku'
                                      : 'Sedang Dipinjam'),
                                  style: ElevatedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 12),
                                  ),
                                ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Consumer<FavoriteProvider>(
                            builder: (context, favoriteProvider, child) {
                              final isFavorite =
                                  favoriteProvider.isFavorite(widget.book.id);
                              return ElevatedButton.icon(
                                onPressed: () {
                                  favoriteProvider
                                      .toggleFavorite(widget.book.id);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(isFavorite
                                          ? 'Dihapus dari favorit'
                                          : 'Ditambahkan ke favorit'),
                                    ),
                                  );
                                },
                                icon: Icon(
                                  isFavorite
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                  color: isFavorite ? Colors.red : null,
                                ),
                                label: Text(isFavorite
                                    ? 'Hapus Favorit'
                                    : 'Tambah Favorit'),
                                style: ElevatedButton.styleFrom(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 12),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
