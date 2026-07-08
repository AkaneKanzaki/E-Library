import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/borrowing_provider.dart';
import '../../providers/book_provider.dart';
import '../../providers/auth_provider.dart';
import '../../models/book.dart';
import '../../models/borrowing.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AuthProvider>(context).currentUser;
    if (user == null) return const SizedBox();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Borrowing History'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Consumer2<BorrowingProvider, BookProvider>(
        builder: (context, borrowingProvider, bookProvider, child) {
          final historyList = borrowingProvider.getBorrowingsByUserId(user.email);

          if (historyList.isEmpty) {
            return const Center(
              child: Text('No borrowing history yet'),
            );
          }

          // Sort by most recently borrowed
          historyList.sort((a, b) => b.borrowDate.compareTo(a.borrowDate));

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: historyList.length,
            itemBuilder: (context, index) {
              final borrowItem = historyList[index];
              final book = bookProvider.getBookById(borrowItem.bookId);
              if (book == null) return const SizedBox();

              return _buildRiwayatCard(borrowItem, book);
            },
          );
        },
      ),
    );
  }

  Widget _buildRiwayatCard(Borrowing borrowings, Book book) {
    final bool isActive = borrowings.status == 'borrowed';
    final int fine = borrowings.calculateFine();
    
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
                    book.title,
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
                    isActive ? 'Borrowed' : 'Returned',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text('Author: ${book.author}'),
            const SizedBox(height: 8),
            Text('Borrow Date: ${_formatDate(borrowings.borrowDate)}'),
            Text('Due Date: ${_formatDate(borrowings.dueDate)}'),
            if (!isActive && borrowings.returnDate != null)
              Text('Return Date: ${_formatDate(borrowings.returnDate!)}'),
            
            if (fine > 0) ...[
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  border: Border.all(color: Colors.red.shade200),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.warning_amber_rounded, color: Colors.red, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      'Late Fine: Rp $fine',
                      style: const TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }
}