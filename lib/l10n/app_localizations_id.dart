// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Indonesian (`id`).
class AppLocalizationsId extends AppLocalizations {
  AppLocalizationsId([String locale = 'id']) : super(locale);

  @override
  String get loginTitle => 'Login';

  @override
  String get emailLabel => 'Email';

  @override
  String get passwordLabel => 'Password';

  @override
  String get loginButton => 'Login';

  @override
  String get loginFailedMsg => 'Login gagal. Silakan coba lagi.';

  @override
  String get registerTitle => 'Register';

  @override
  String get registerButton => 'Register';

  @override
  String get dashboardTitle => 'Dashboard';

  @override
  String get profileTitle => 'Profile';

  @override
  String get aboutTitle => 'Tentang Aplikasi';

  @override
  String get searchBookHint => 'Cari buku...';

  @override
  String get borrowButton => 'Pinjam Buku';

  @override
  String get returnButton => 'Return Book';

  @override
  String get borrowHistory => 'Borrowing History';

  @override
  String get darkMode => 'Dark Mode';

  @override
  String get language => 'Bahasa';

  @override
  String get logout => 'Logout';
}
