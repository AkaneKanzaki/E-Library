// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get loginTitle => 'Login';

  @override
  String get emailLabel => 'Email';

  @override
  String get passwordLabel => 'Password';

  @override
  String get loginButton => 'Login';

  @override
  String get loginFailedMsg => 'Login failed. Please try again.';

  @override
  String get registerTitle => 'Register';

  @override
  String get registerButton => 'Register';

  @override
  String get dashboardTitle => 'Dashboard';

  @override
  String get profileTitle => 'Profile';

  @override
  String get aboutTitle => 'About App';

  @override
  String get searchBookHint => 'Search book...';

  @override
  String get borrowButton => 'Borrow Book';

  @override
  String get returnButton => 'Return Book';

  @override
  String get borrowHistory => 'Borrow History';

  @override
  String get darkMode => 'Dark Mode';

  @override
  String get language => 'Language';

  @override
  String get logout => 'Logout';

  @override
  String get borrowingStatistics => 'Borrowing Statistics';

  @override
  String get borrowedBooks => 'Borrowed Books';

  @override
  String get totalBorrowing => 'Total Borrowing';

  @override
  String get popularBooks => 'Popular Books';

  @override
  String get welcomeAdmin => 'Welcome, Administrator';

  @override
  String get mainMenu => 'Main Menu';

  @override
  String get manageUsers => 'Manage Users';

  @override
  String get reports => 'Reports';

  @override
  String get welcomeLibrarian => 'Welcome, Librarian';

  @override
  String get manageBooks => 'Manage Books';

  @override
  String get manageBorrowing => 'Manage Borrowing';
}
