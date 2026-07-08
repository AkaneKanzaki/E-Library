import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/borrowing_provider.dart';
import '../../providers/book_provider.dart';
import '../../providers/auth_provider.dart';
import '../../models/book.dart';
import '../../models/borrowing.dart';

class BorrowBookPage extends StatefulWidget {
  const BorrowBookPage({super.key});

  @override
  State<BorrowBookPage> createState() => _BorrowBookPageState();
}

class _BorrowBookPageState extends State<BorrowBookPage> {
  @override
  void initState() {
    super.initState();
    // Refresh data when page opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<BorrowingProvider>(context, listen: false).refreshBorrowings();
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AuthProvider>(context).currentUser;
    if (user == null) return const SizedBox();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Borrowed Books'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Consumer2<BorrowingProvider, BookProvider>(
        builder: (context, borrowingProvider, bookProvider, child) {
          final borrowings = borrowingProvider.getBorrowingsByUserId(user.email)
              .where((p) => p.status == 'borrowed')
              .toList();

          if (borrowings.isEmpty) {
            return const Center(
              child: Text('No books borrowed yet'),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: borrowings.length,
            itemBuilder: (context, index) {
              final borrowItem = borrowings[index];
              final book = bookProvider.getBookById(borrowItem.bookId);
              if (book == null) return const SizedBox();

              return _buildBorrowingCard(context, borrowItem, book, borrowingProvider);
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
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              book.title,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text('Author: ${book.author}'),
            const SizedBox(height: 8),
            Text(
              'Borrow Date: ${_formatDate(borrowings.borrowDate)}',
            ),
            Text(
              'Due Date: ${_formatDate(borrowings.dueDate)}',
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                final success = await borrowingProvider.returnBook(borrowings.id);
                if (!context.mounted) return;
                
                if (success) {
                  await borrowingProvider.refreshBorrowings();
                  if (!context.mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Book successfully returned')),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Failed to return book. Please try again'),
                    ),
                  );
                }
              },
              child: const Text('Return Book'),
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