import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_id.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('id')
  ];

  /// No description provided for @loginTitle.
  ///
  /// In id, this message translates to:
  /// **'Login'**
  String get loginTitle;

  /// No description provided for @emailLabel.
  ///
  /// In id, this message translates to:
  /// **'Email'**
  String get emailLabel;

  /// No description provided for @passwordLabel.
  ///
  /// In id, this message translates to:
  /// **'Password'**
  String get passwordLabel;

  /// No description provided for @loginButton.
  ///
  /// In id, this message translates to:
  /// **'Login'**
  String get loginButton;

  /// No description provided for @loginFailedMsg.
  ///
  /// In id, this message translates to:
  /// **'Login gagal. Silakan coba lagi.'**
  String get loginFailedMsg;

  /// No description provided for @registerTitle.
  ///
  /// In id, this message translates to:
  /// **'Daftar'**
  String get registerTitle;

  /// No description provided for @registerButton.
  ///
  /// In id, this message translates to:
  /// **'Daftar'**
  String get registerButton;

  /// No description provided for @dashboardTitle.
  ///
  /// In id, this message translates to:
  /// **'Dashboard'**
  String get dashboardTitle;

  /// No description provided for @profileTitle.
  ///
  /// In id, this message translates to:
  /// **'Profil'**
  String get profileTitle;

  /// No description provided for @aboutTitle.
  ///
  /// In id, this message translates to:
  /// **'Tentang Aplikasi'**
  String get aboutTitle;

  /// No description provided for @searchBookHint.
  ///
  /// In id, this message translates to:
  /// **'Cari buku...'**
  String get searchBookHint;

  /// No description provided for @borrowButton.
  ///
  /// In id, this message translates to:
  /// **'Pinjam Buku'**
  String get borrowButton;

  /// No description provided for @returnButton.
  ///
  /// In id, this message translates to:
  /// **'Kembalikan Buku'**
  String get returnButton;

  /// No description provided for @borrowHistory.
  ///
  /// In id, this message translates to:
  /// **'Riwayat Peminjaman'**
  String get borrowHistory;

  /// No description provided for @darkMode.
  ///
  /// In id, this message translates to:
  /// **'Mode Gelap'**
  String get darkMode;

  /// No description provided for @language.
  ///
  /// In id, this message translates to:
  /// **'Bahasa'**
  String get language;

  /// No description provided for @logout.
  ///
  /// In id, this message translates to:
  /// **'Keluar'**
  String get logout;

  /// No description provided for @borrowingStatistics.
  ///
  /// In id, this message translates to:
  /// **'Statistik Peminjaman'**
  String get borrowingStatistics;

  /// No description provided for @borrowedBooks.
  ///
  /// In id, this message translates to:
  /// **'Buku Dipinjam'**
  String get borrowedBooks;

  /// No description provided for @totalBorrowing.
  ///
  /// In id, this message translates to:
  /// **'Total Peminjaman'**
  String get totalBorrowing;

  /// No description provided for @popularBooks.
  ///
  /// In id, this message translates to:
  /// **'Buku Populer'**
  String get popularBooks;

  /// No description provided for @welcomeAdmin.
  ///
  /// In id, this message translates to:
  /// **'Selamat datang, Administrator'**
  String get welcomeAdmin;

  /// No description provided for @mainMenu.
  ///
  /// In id, this message translates to:
  /// **'Menu Utama'**
  String get mainMenu;

  /// No description provided for @manageUsers.
  ///
  /// In id, this message translates to:
  /// **'Kelola Pengguna'**
  String get manageUsers;

  /// No description provided for @reports.
  ///
  /// In id, this message translates to:
  /// **'Laporan'**
  String get reports;

  /// No description provided for @welcomeLibrarian.
  ///
  /// In id, this message translates to:
  /// **'Selamat datang, Pustakawan'**
  String get welcomeLibrarian;

  /// No description provided for @manageBooks.
  ///
  /// In id, this message translates to:
  /// **'Kelola Buku'**
  String get manageBooks;

  /// No description provided for @manageBorrowing.
  ///
  /// In id, this message translates to:
  /// **'Daftar Peminjaman'**
  String get manageBorrowing;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'id'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'id':
      return AppLocalizationsId();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
