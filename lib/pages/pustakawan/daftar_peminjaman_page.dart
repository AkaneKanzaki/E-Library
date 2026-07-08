import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/peminjaman_provider.dart';
import '../../providers/book_provider.dart';
import '../../models/peminjaman.dart';
import '../../models/book.dart';

class DaftarPeminjamanPage extends StatelessWidget {
  const DaftarPeminjamanPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Peminjaman'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Consumer2<PeminjamanProvider, BookProvider>(
        builder: (context, peminjamanProvider, bookProvider, child) {
          final peminjaman = peminjamanProvider.peminjaman;

          if (peminjaman.isEmpty) {
            return const Center(
              child: Text('Belum ada peminjaman'),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: peminjaman.length,
            itemBuilder: (context, index) {
              final pinjam = peminjaman[index];
              final book = bookProvider.getBookById(pinjam.bookId);
              if (book == null) return const SizedBox();

              return _buildPeminjamanCard(context, pinjam, book, peminjamanProvider);
            },
          );
        },
      ),
    );
  }

  Widget _buildPeminjamanCard(
    BuildContext context,
    Peminjaman peminjaman,
    Book book,
    PeminjamanProvider peminjamanProvider,
  ) {
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
            Text('Peminjam: ${peminjaman.userId}'),
            Text('Penulis: ${book.penulis}'),
            const SizedBox(height: 8),
            Text('Tanggal Pinjam: ${_formatDate(peminjaman.tanggalPinjam)}'),
            Text('Batas Waktu: ${_formatDate(peminjaman.batasWaktu)}'),
            if (!isActive && peminjaman.tanggalKembali != null)
              Text('Tanggal Kembali: ${_formatDate(peminjaman.tanggalKembali!)}'),
            if (isActive) ...[
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    final success = await peminjamanProvider.kembalikanBuku(peminjaman.id);
                    if (success) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Buku berhasil dikembalikan')),
                        );
                      }
                    }
                  },
                  child: const Text('Konfirmasi Pengembalian'),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
} 