import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/peminjaman_provider.dart';
import '../providers/book_provider.dart';
import '../providers/auth_provider.dart';
import '../models/book.dart';
import '../models/peminjaman.dart';

class RiwayatPage extends StatefulWidget {
  const RiwayatPage({super.key});

  @override
  State<RiwayatPage> createState() => _RiwayatPageState();
}

class _RiwayatPageState extends State<RiwayatPage> {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AuthProvider>(context).currentUser;
    if (user == null) return const SizedBox();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Riwayat Peminjaman'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Consumer2<PeminjamanProvider, BookProvider>(
        builder: (context, peminjamanProvider, bookProvider, child) {
          final riwayat = peminjamanProvider.getPeminjamanByUserId(user.email);

          if (riwayat.isEmpty) {
            return const Center(
              child: Text('Belum ada riwayat peminjaman'),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: riwayat.length,
            itemBuilder: (context, index) {
              final pinjam = riwayat[index];
              final book = bookProvider.getBookById(pinjam.bookId);
              if (book == null) return const SizedBox();

              return _buildRiwayatCard(pinjam, book);
            },
          );
        },
      ),
    );
  }

  Widget _buildRiwayatCard(Peminjaman peminjaman, Book book) {
    final bool isActive = peminjaman.status == 'dipinjam';
    
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    book.judul,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: isActive ? Colors.green : Colors.grey,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    isActive ? 'Dipinjam' : 'Dikembalikan',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text('Penulis: ${book.penulis}'),
            const SizedBox(height: 8),
            Text('Tanggal Pinjam: ${_formatDate(peminjaman.tanggalPinjam)}'),
            Text('Tanggal Kembali: ${_formatDate(peminjaman.tanggalKembali)}'),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
} 