import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/borrowing_provider.dart';
import '../books/search_book_page.dart';
import '../books/borrow_book_page.dart';
import '../auth/login_page.dart';
import './history_page.dart';
import './profile_page.dart';
import '../../providers/book_provider.dart';
import '../books/book_detail_page.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';
import '../../models/user.dart';
import 'package:elibrary/l10n/app_localizations.dart';
import '../administrator/dashboard_administrator_page.dart';
import '../librarian/dashboard_librarian_page.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AuthProvider>(context).currentUser;
    if (user == null) {
      return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text(AppLocalizations.of(context)!.dashboardTitle),
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Please login first'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginPage()),
                  );
                },
                child: Text(AppLocalizations.of(context)!.loginButton),
              ),
            ],
          ),
        ),
      );
    }

    if (user.role.toLowerCase() == 'administrator') {
      return const DashboardAdministratorPage();
    } else if (user.role.toLowerCase() == 'librarian') {
      return const DashboardLibrarianPage();
    } else {
      return _buildStudentDashboard(context, user);
    }
  }

  Widget _buildStudentDashboard(BuildContext context, User user) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        title: GestureDetector(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const SearchBookPage()),
          ),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Theme.of(context).dividerColor.withValues(alpha: 0.1)),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.search,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                  size: 20,
                ),
                const SizedBox(width: 12),
                Text(
                  'Search books...',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    fontSize: 15,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: IconButton(
              icon: const Icon(Icons.person_outline),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfilePage()),
              ),
            ),
          ),
        ],
      ),
      body: Consumer<BorrowingProvider>(
        builder: (context, borrowingProvider, child) {
          final borrowedCount =
              borrowingProvider.getBorrowedBooksCount(user.email);
          final historyCount =
              borrowingProvider.getBorrowingHistoryCount(user.email);

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Hello,',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                            ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        user.name,
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                      ),
                        const SizedBox(height: 24),
                        Row(
                          children: [
                            Expanded(
                              child: InkWell(
                                onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const BorrowBookPage()),
                                ),
                                child: Container(
                                  padding: const EdgeInsets.all(20),
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).colorScheme.surfaceContainerHighest,
                                    borderRadius: BorderRadius.circular(16),
                                    boxShadow: [
                                      BoxShadow(
                                        color:
                                            Colors.black.withValues(alpha: 0.1),
                                        blurRadius: 10,
                                        offset: const Offset(0, 5),
                                      ),
                                    ],
                                  ),
                                  child: _buildStatItem(
                                    icon: Icons.book,
                                    label: AppLocalizations.of(context)!.borrowedBooks,
                                    value: borrowedCount.toString(),
                                    color: Colors.blue,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: InkWell(
                                onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const HistoryPage()),
                                ),
                                child: Container(
                                  padding: const EdgeInsets.all(20),
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).colorScheme.surfaceContainerHighest,
                                    borderRadius: BorderRadius.circular(16),
                                    boxShadow: [
                                      BoxShadow(
                                        color:
                                            Colors.black.withValues(alpha: 0.1),
                                        blurRadius: 10,
                                        offset: const Offset(0, 5),
                                      ),
                                    ],
                                  ),
                                  child: _buildStatItem(
                                    icon: Icons.history,
                                    label: AppLocalizations.of(context)!.borrowHistory,
                                    value: historyCount.toString(),
                                    color: Colors.green,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                ),
                const SizedBox(height: 24),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Text(
                    AppLocalizations.of(context)!.popularBooks,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Consumer<BookProvider>(
                  builder: (context, bookProvider, child) {
                    final books = bookProvider.books;
                    return FlutterCarousel(
                      items: books
                          .map((book) => GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          BookDetailPage(book: book),
                                    ),
                                  );
                                },
                                child: Container(
                                  margin:
                                      const EdgeInsets.symmetric(horizontal: 5),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(16),
                                    boxShadow: [
                                      BoxShadow(
                                        color:
                                            Colors.black.withValues(alpha: 0.2),
                                        spreadRadius: 1,
                                        blurRadius: 8,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(16),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          child: Image.asset(
                                            book.coverUrl,
                                            fit: BoxFit.cover,
                                            cacheWidth: 300,
                                            width: double.infinity,
                                            errorBuilder: (context, error, stackTrace) {
                                              return Container(
                                                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                                                child: const Icon(Icons.book, size: 40),
                                              );
                                            },
                                          ),
                                        ),
                                        Container(
                                          padding: const EdgeInsets.all(8),
                                          color: Theme.of(context).colorScheme.surface,
                                          child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  book.title,
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: const TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                const SizedBox(height: 4),
                                                Text(
                                                  book.author,
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.grey.shade600,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                ),
                              ))
                          .toList(),
                      options: CarouselOptions(
                        height: 320,
                        viewportFraction: 0.6,
                        enlargeCenterPage: true,
                        autoPlay: true,
                        autoPlayInterval: const Duration(seconds: 3),
                        autoPlayAnimationDuration:
                            const Duration(milliseconds: 800),
                        autoPlayCurve: Curves.fastOutSlowIn,
                        showIndicator: false,
                      ),
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, size: 30, color: color),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
}
