import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/book_provider.dart';
import '../../providers/peminjaman_provider.dart';
import '../../providers/auth_provider.dart';

class LaporanPage extends StatelessWidget {
  const LaporanPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Laporan'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Statistik Umum
            const Text(
              'Statistik Umum',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Consumer3<BookProvider, PeminjamanProvider, AuthProvider>(
              builder: (context, bookProvider, peminjamanProvider, authProvider, child) {
                final totalBuku = bookProvider.books.length;
                final bukuTersedia = bookProvider.books.where((book) => book.tersedia).length;
                final bukuDipinjam = totalBuku - bukuTersedia;
                final totalPeminjaman = peminjamanProvider.peminjaman.length;
                final peminjamanAktif = peminjamanProvider.peminjaman
                    .where((p) => p.status == 'dipinjam').length;
                final totalPengguna = authProvider.users.length;
                final totalSiswa = authProvider.users.where((u) => u.role == 'siswa').length;

                return Column(
                  children: [
                    _buildStatCard(
                      'Total Buku',
                      totalBuku.toString(),
                      Icons.book,
                      Colors.blue,
                    ),
                    const SizedBox(height: 8),
                    _buildStatCard(
                      'Buku Tersedia',
                      bukuTersedia.toString(),
                      Icons.check_circle,
                      Colors.green,
                    ),
                    const SizedBox(height: 8),
                    _buildStatCard(
                      'Buku Dipinjam',
                      bukuDipinjam.toString(),
                      Icons.bookmark,
                      Colors.orange,
                    ),
                    const SizedBox(height: 16),
                    _buildStatCard(
                      'Total Peminjaman',
                      totalPeminjaman.toString(),
                      Icons.history,
                      Colors.purple,
                    ),
                    const SizedBox(height: 8),
                    _buildStatCard(
                      'Peminjaman Aktif',
                      peminjamanAktif.toString(),
                      Icons.access_time,
                      Colors.red,
                    ),
                    const SizedBox(height: 16),
                    _buildStatCard(
                      'Total Pengguna',
                      totalPengguna.toString(),
                      Icons.people,
                      Colors.indigo,
                    ),
                    const SizedBox(height: 8),
                    _buildStatCard(
                      'Total Siswa',
                      totalSiswa.toString(),
                      Icons.school,
                      Colors.teal,
                    ),
                  ],
                );
              },
            ),
            
            const SizedBox(height: 32),
            
            // Peminjaman Terbaru
            const Text(
              'Peminjaman Terbaru',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Consumer2<PeminjamanProvider, BookProvider>(
              builder: (context, peminjamanProvider, bookProvider, child) {
                final peminjaman = peminjamanProvider.peminjaman
                    .where((p) => p.status == 'dipinjam')
                    .take(5)
                    .toList();

                if (peminjaman.isEmpty) {
                  return const Card(
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Text('Tidak ada peminjaman aktif'),
                    ),
                  );
                }

                return Column(
                  children: peminjaman.map((p) {
                    final book = bookProvider.getBookById(p.bookId);
                    return Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: ListTile(
                        title: Text(book?.judul ?? 'Buku tidak ditemukan'),
                        subtitle: Text('Peminjam: ${p.userId}'),
                        trailing: Text(_formatDate(p.tanggalKembali)),
                      ),
                    );
                  }).toList(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(icon, size: 32, color: color),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    value,
                    style: TextStyle(
                      fontSize: 20,
                      color: color,
                      fontWeight: FontWeight.bold,
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

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
} 