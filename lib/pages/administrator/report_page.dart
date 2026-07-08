import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/book_provider.dart';
import '../../providers/borrowing_provider.dart';
import '../../providers/auth_provider.dart';

class ReportPage extends StatelessWidget {
  const ReportPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reports'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // General Statistics
            const Text(
              'General Statistics',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Consumer3<BookProvider, BorrowingProvider, AuthProvider>(
              builder: (context, bookProvider, borrowingProvider, authProvider, child) {
                final totalBuku = bookProvider.books.length;
                final availableBooks = bookProvider.books.where((book) => book.isAvailable).length;
                final borrowedBooks = totalBuku - availableBooks;
                final totalBorrowings = borrowingProvider.borrowings.length;
                final activeBorrowings = borrowingProvider.borrowings
                    .where((p) => p.status == 'borrowed').length;
                final totalPengguna = authProvider.users.length;
                final totalStudents = authProvider.users.where((u) => u.role == 'student').length;

                return Column(
                  children: [
                    _buildStatCard(
                      'Total Books',
                      totalBuku.toString(),
                      Icons.book,
                      Colors.blue,
                    ),
                    const SizedBox(height: 8),
                    _buildStatCard(
                      'Available Books',
                      availableBooks.toString(),
                      Icons.check_circle,
                      Colors.green,
                    ),
                    const SizedBox(height: 8),
                    _buildStatCard(
                      'Borrowed Books',
                      borrowedBooks.toString(),
                      Icons.bookmark,
                      Colors.orange,
                    ),
                    const SizedBox(height: 16),
                    _buildStatCard(
                      'Total Borrowing',
                      totalBorrowings.toString(),
                      Icons.history,
                      Colors.purple,
                    ),
                    const SizedBox(height: 8),
                    _buildStatCard(
                      'Active Borrowings',
                      activeBorrowings.toString(),
                      Icons.access_time,
                      Colors.red,
                    ),
                    const SizedBox(height: 16),
                    _buildStatCard(
                      'Total Users',
                      totalPengguna.toString(),
                      Icons.people,
                      Colors.indigo,
                    ),
                    const SizedBox(height: 8),
                    _buildStatCard(
                      'Total Students',
                      totalStudents.toString(),
                      Icons.school,
                      Colors.teal,
                    ),
                  ],
                );
              },
            ),
            
            const SizedBox(height: 32),
            
            // Recent Borrowings
            const Text(
              'Borrowing Terbaru',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Consumer2<BorrowingProvider, BookProvider>(
              builder: (context, borrowingProvider, bookProvider, child) {
                final borrowings = borrowingProvider.borrowings
                    .where((p) => p.status == 'borrowed')
                    .take(5)
                    .toList();

                if (borrowings.isEmpty) {
                  return const Card(
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Text('No active borrowings'),
                    ),
                  );
                }

                return Column(
                  children: borrowings.map((p) {
                    final book = bookProvider.getBookById(p.bookId);
                    return Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: ListTile(
                        title: Text(book?.title ?? 'Book not found'),
                        subtitle: Text('Borrower: ${p.userId}'),
                        trailing: Text(_formatDate(p.dueDate)),
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