import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:elibrary/providers/auth_provider.dart';
import 'package:elibrary/pages/login_page.dart';
import 'package:elibrary/pages/register_page.dart';
import 'package:elibrary/pages/about_page.dart';
import 'package:elibrary/providers/book_provider.dart';
import 'package:elibrary/providers/peminjaman_provider.dart';
import 'package:elibrary/providers/favorite_provider.dart';
import 'package:elibrary/providers/theme_provider.dart';
import 'package:elibrary/providers/locale_provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:elibrary/l10n/app_localizations.dart';

import 'package:elibrary/pages/dashboard_page.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthProvider()),
        ChangeNotifierProvider(create: (context) => BookProvider()),
        ChangeNotifierProvider(create: (context) => FavoriteProvider()),
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
        ChangeNotifierProvider(create: (context) => LocaleProvider()),
        ChangeNotifierProvider(
          create: (context) => PeminjamanProvider(
            Provider.of<BookProvider>(context, listen: false),
          ),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<ThemeProvider, LocaleProvider>(
      builder: (context, themeProvider, localeProvider, child) {
        return MaterialApp(
          title: 'E-Library Mobile',
          locale: localeProvider.locale,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
            useMaterial3: true,
          ),
          darkTheme: ThemeData.dark(useMaterial3: true).copyWith(
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.blue,
              brightness: Brightness.dark,
            ),
          ),
          themeMode: themeProvider.themeMode,
          home: Consumer<AuthProvider>(
            builder: (context, auth, child) {
              if (!auth.isInitialized) {
                return const Scaffold(
                  body: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }
              if (auth.isAuthenticated) {
                return const DashboardPage();
              }
              return const HomePage();
            },
          ),
        );
      },
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('E-Library Mobile'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 20),
            // Logo atau Gambar Pustaka
            Icon(
              Icons.library_books,
              size: 100,
              color: Theme.of(context).primaryColor,
            ),
            const SizedBox(height: 30),
            // Tombol-tombol Menu
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                );
              },
              child: const Padding(
                padding: EdgeInsets.all(12.0),
                child: Text('Login'),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const RegisterPage()),
                );
              },
              child: const Padding(
                padding: EdgeInsets.all(12.0),
                child: Text('Daftar Anggota Baru'),
              ),
            ),
            const SizedBox(height: 16),
            OutlinedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AboutPage()),
                );
              },
              child: const Padding(
                padding: EdgeInsets.all(12.0),
                child: Text('Tentang Aplikasi'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
