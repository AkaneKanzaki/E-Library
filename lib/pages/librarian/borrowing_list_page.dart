import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/borrowing_provider.dart';
import '../../providers/book_provider.dart';
import '../../models/borrowing.dart';
import '../../models/book.dart';

class BorrowingListPage extends StatelessWidget {
  const BorrowingListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Borrowing List'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Consumer2<BorrowingProvider, BookProvider>(
        builder: (context, borrowingProvider, bookProvider, child) {
          final borrowings = borrowingProvider.borrowings;

          if (borrowings.isEmpty) {
            return const Center(
              child: Text('No borrowings yet'),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: borrowings.length,
            itemBuilder: (context, index) {
              final borrowItem = borrowings[index];
              final book = bookProvider.getBookById(borrowItem.bookId);
              if (book == null) return const SizedBox();

              return _buildBorrowingCard(
                  context, borrowItem, book, borrowingProvider);
            },
          );
        },
      ),
    );
  }

  Widget _buildBorrowingCard(
    BuildContext context,
    Borrowing borrowings,
    Book book,
    BorrowingProvider borrowingProvider,
  ) {
    final bool isActive = borrowings.status == 'borrowed';

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
            Text('Borrower: ${borrowings.userId}'),
            Text('Author: ${book.author}'),
            const SizedBox(height: 8),
            Text('Borrow Date: ${_formatDate(borrowings.borrowDate)}'),
            Text('Due Date: ${_formatDate(borrowings.dueDate)}'),
            if (!isActive && borrowings.returnDate != null)
              Text('Return Date: ${_formatDate(borrowings.returnDate!)}'),
            if (isActive) ...[
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    final success =
                        await borrowingProvider.returnBook(borrowings.id);
                    if (success) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Book successfully returned')),
                        );
                      }
                    }
                  },
                  child: const Text('Confirm Return'),
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
