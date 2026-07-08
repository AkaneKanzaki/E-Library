import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/book.dart';
import '../../providers/borrowing_provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/favorite_provider.dart';
import './read_book_page.dart';
import 'package:elibrary/l10n/app_localizations.dart';

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
    final borrowingProvider = Provider.of<BorrowingProvider>(context);
    final user = authProvider.currentUser;

    // Check if the book is currently borrowed by this user
    final bool isBeingBorrowedByUser = user != null &&
        borrowingProvider
            .getBorrowingsByUserId(user.email)
            .where((p) => p.bookId == widget.book.id && p.status == 'borrowed')
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
            // Header with cover image
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
                        cacheWidth: 500,
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

            // Book information
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title and Status
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          widget.book.title,
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
                              widget.book.isAvailable ? Colors.green : Colors.red,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          widget.book.isAvailable ? 'Available' : AppLocalizations.of(context)!.borrowed,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Author
                  Text(
                    '${AppLocalizations.of(context)!.byAuthor}${widget.book.author}',
                    style: TextStyle(
                      fontSize: 16,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Detailed info in card
                  Card(
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildInfoRow('Publisher', widget.book.publisher, context),
                          const Divider(),
                          _buildInfoRow(
                              AppLocalizations.of(context)!.publishedYear, widget.book.publishYear, context),
                          const Divider(),
                          _buildInfoRow(AppLocalizations.of(context)!.category, widget.book.category, context),
                          const Divider(),
                          _buildInfoRow(AppLocalizations.of(context)!.totalPages,
                              '${widget.book.pageCount} ${AppLocalizations.of(context)!.pages}', context),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Description
                  Text(
                    'Description',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      widget.book.description,
                      style: TextStyle(
                        fontSize: 16,
                        height: 1.5,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Action buttons
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
                                  label: Text(AppLocalizations.of(context)!.readBook),
                                  style: ElevatedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 12),
                                  ),
                                )
                              : ElevatedButton.icon(
                                  onPressed: widget.book.isAvailable
                                      ? () async {
                                          if (user != null) {
                                            final success =
                                                await borrowingProvider
                                                    .borrowBook(
                                              user.email,
                                              widget.book.id,
                                            );
                                            if (!context.mounted) return;
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                  success
                                                      ? AppLocalizations.of(context)!.borrowSuccess
                                                      : AppLocalizations.of(context)!.borrowFail,
                                                ),
                                              ),
                                            );
                                          }
                                        }
                                      : null,
                                  icon: const Icon(Icons.bookmark_add),
                                  label: Text(widget.book.isAvailable
                                      ? AppLocalizations.of(context)!.borrowBook
                                      : AppLocalizations.of(context)!.borrowed),
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
                                          ? AppLocalizations.of(context)!.removedFavorite
                                          : AppLocalizations.of(context)!.addedFavorite),
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
                                    ? AppLocalizations.of(context)!.removeFavorite
                                    : AppLocalizations.of(context)!.addFavorite),
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

  Widget _buildInfoRow(String label, String value, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
