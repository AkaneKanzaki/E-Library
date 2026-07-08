import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/peminjaman_provider.dart';
import '../providers/book_provider.dart';
import '../providers/auth_provider.dart';
import '../models/book.dart';
import '../models/peminjaman.dart';

class PinjamBukuPage extends StatefulWidget {
  const PinjamBukuPage({super.key});

  @override
  State<PinjamBukuPage> createState() => _PinjamBukuPageState();
}

class _PinjamBukuPageState extends State<PinjamBukuPage> {
  @override
  void initState() {
    super.initState();
    // Refresh data saat halaman dibuka
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<PeminjamanProvider>(context, listen: false).refreshPeminjaman();
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AuthProvider>(context).currentUser;
    if (user == null) return const SizedBox();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Buku Dipinjam'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Consumer2<PeminjamanProvider, BookProvider>(
        builder: (context, peminjamanProvider, bookProvider, child) {
          final peminjaman = peminjamanProvider.getPeminjamanByUserId(user.email)
              .where((p) => p.status == 'dipinjam')
              .toList();

          if (peminjaman.isEmpty) {
            return const Center(
              child: Text('Belum ada buku yang dipinjam'),
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
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              book.judul,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text('Penulis: ${book.penulis}'),
            const SizedBox(height: 8),
            Text(
              'Tanggal Pinjam: ${_formatDate(peminjaman.tanggalPinjam)}',
            ),
            Text(
              'Batas Waktu: ${_formatDate(peminjaman.batasWaktu)}',
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                final success = await peminjamanProvider.kembalikanBuku(peminjaman.id);
                if (!context.mounted) return;
                
                if (success) {
                  await peminjamanProvider.refreshPeminjaman();
                  if (!context.mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Buku berhasil dikembalikan')),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Gagal mengembalikan buku. Silakan coba lagi'),
                    ),
                  );
                }
              },
              child: const Text('Kembalikan Buku'),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
} 