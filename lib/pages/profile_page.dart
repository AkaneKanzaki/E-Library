import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/peminjaman_provider.dart';
import '../providers/theme_provider.dart';
import '../providers/locale_provider.dart';
import 'package:elibrary/l10n/app_localizations.dart';
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AuthProvider>(context).currentUser;
    if (user == null) return const SizedBox();

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.profileTitle),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Avatar
            CircleAvatar(
              radius: 50,
              backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
              child: Text(
                user.nama[0].toUpperCase(),
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ),
            const SizedBox(height: 24),
            
            // Info Pengguna
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _buildInfoRow(
                      context,
                      icon: Icons.person,
                      label: 'Nama',
                      value: user.nama,
                    ),
                    const Divider(),
                    _buildInfoRow(
                      context,
                      icon: Icons.email,
                      label: 'Email',
                      value: user.email,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            
            // Pengaturan
            Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Consumer<ThemeProvider>(
                  builder: (context, themeProvider, child) {
                    return SwitchListTile(
                      title: const Text('Dark Mode'),
                      secondary: const Icon(Icons.dark_mode),
                      value: themeProvider.isDarkMode,
                      onChanged: (bool value) {
                        themeProvider.toggleTheme(value);
                      },
                    );
                  },
                ),
              ),
            ),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Consumer<LocaleProvider>(
                  builder: (context, localeProvider, child) {
                    return SwitchListTile(
                      title: Text(AppLocalizations.of(context)!.language),
                      subtitle: Text(localeProvider.locale.languageCode == 'id' ? 'Bahasa Indonesia' : 'English'),
                      secondary: const Icon(Icons.language),
                      value: localeProvider.locale.languageCode == 'en',
                      onChanged: (bool value) {
                        localeProvider.toggleLocale();
                      },
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Statistik Peminjaman
            Consumer<PeminjamanProvider>(
              builder: (context, peminjamanProvider, child) {
                final jumlahDipinjam = peminjamanProvider.getJumlahBukuDipinjam(user.email);
                final jumlahRiwayat = peminjamanProvider.getJumlahRiwayatPeminjaman(user.email);

                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppLocalizations.of(context)!.borrowingStatistics,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        _buildInfoRow(
                          context,
                          icon: Icons.book,
                          label: AppLocalizations.of(context)!.borrowedBooks,
                          value: jumlahDipinjam.toString(),
                        ),
                        const Divider(),
                        _buildInfoRow(
                          context,
                          icon: Icons.history,
                          label: AppLocalizations.of(context)!.totalBorrowing,
                          value: jumlahRiwayat.toString(),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 24),

            // Tombol Logout
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  Provider.of<AuthProvider>(context, listen: false).logout();
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.logout),
                label: Text(AppLocalizations.of(context)!.logout),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.all(16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 24),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
} 