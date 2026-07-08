# E-Library Mobile App

An offline-first Digital Library mobile application built using the **Flutter** framework and **SQLite**. This application is designed to provide a comprehensive library management ecosystem ranging from borrowing books, reading PDF books, to automated fine management based on a Role-Based Access Control (RBAC) system.

## Key Features

- **Role-Based Authentication**: Supports 3 access levels:
  - **Administrator**: Has full control over the system, including adding or removing Librarians and Students.
  - **Librarian (Pustakawan)**: Manages the book catalog (CRUD) and monitors the entire book borrowing history.
  - **Student (Siswa)**: Can search for books, borrow books, read books, and view their fine history.
- **Integrated PDF Reader**: Read PDF book files directly within the application. Equipped with an automatic bookmark memory, allowing users to resume reading from the last opened page.
- **Automated Fine System**: Intelligently calculates the borrowing duration and delays, automatically accumulating fines if the return deadline is exceeded.
- **Debounced Search**: A highly optimized book search feature (500ms debounce) to prevent UI lag on devices when typing book titles rapidly.
- **Dark Mode Support**: Fully integrated Dark Mode with preferences stored in the device memory.
- **Offline-First (SQLite)**: All user data, books, and borrowing histories are stored locally on the device without requiring an internet connection.

## Technologies Used

- [Flutter](https://flutter.dev/) (SDK)
- [Dart](https://dart.dev/) (Language)
- [sqflite](https://pub.dev/packages/sqflite) (Local Database)
- [provider](https://pub.dev/packages/provider) (State Management)
- [shared_preferences](https://pub.dev/packages/shared_preferences) (Persistent Storage)
- [flutter_pdfview](https://pub.dev/packages/flutter_pdfview) (PDF Viewer)

## How to Run Locally

1. **Prerequisites**: Ensure that you have installed the Flutter SDK (latest version recommended).
2. **Clone the Repository**:
   ```bash
   git clone https://github.com/AkaneKanzaki/E-Library.git
   cd E-Library
   ```
3. **Install Dependencies**:
   ```bash
   flutter pub get
   ```
4. **Run the Application**:
   Ensure your emulator is running or your physical device is connected (with USB Debugging enabled).
   ```bash
   flutter run
   ```

## Default Accounts (Dummy Data)

This application uses a local SQLite system and comes pre-populated with several built-in accounts for testing and demonstration purposes:

- **Administrator**
  - Email: `admin@library.com`
  - Password: `admin123`
- **Librarian (Pustakawan)**
  - Email: `pustakawan@library.com`
  - Password: `pustakawan123`

For the **Student** role, you can register a new account directly through the **Registrasi** (Register) button on the initial application page.

## Screenshots

Here are the application interfaces based on your screenshots:

<p align="center">
  <img src="screenshots/dashboard.jpg" width="30%" alt="Dashboard" />
  <img src="screenshots/history.jpg" width="30%" alt="Riwayat Peminjaman" />
  <img src="screenshots/profile.jpg" width="30%" alt="Profil" />
</p>
<p align="center">
  <img src="screenshots/borrowed.jpg" width="30%" alt="Buku Dipinjam" />
  <img src="screenshots/about.jpg" width="30%" alt="Tentang Aplikasi" />
</p>

---

## Contributing

Contributions, issues, and feature requests are welcome! Feel free to check the [issues page](https://github.com/AkaneKanzaki/E-Library/issues) if you want to contribute.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
