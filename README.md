# E-Library Mobile App

An offline-first Digital Library mobile application built using the **Flutter** framework and **SQLite**. This application is designed to provide a comprehensive library management ecosystem ranging from borrowing books, reading PDF books, to automated fine management based on a Role-Based Access Control (RBAC) system.

**Created by**: [@AkaneKanzaki (Muhammad Rizky Aulia)](https://github.com/AkaneKanzaki)

## Key Features

- **Role-Based Authentication**: Supports 3 access levels:
  - **Administrator**: Has full control over the system, including adding or removing Librarians and Students.
  - **Librarian**: Manages the book catalog (CRUD) and monitors the entire book borrowing history.
  - **Student**: Can search for books, borrow books, read books, and view their fine history.
- **Integrated PDF Reader**: Read PDF book files directly within the application. Equipped with an automatic bookmark memory, allowing users to resume reading from the last opened page.
- **Automated Fine System**: Intelligently calculates the borrowing duration and delays, automatically accumulating fines if the return deadline is exceeded.
- **Modern Immersive UI & Dark Mode**: Built with Material 3 design principles, featuring an immersive fullscreen layout by default and fully integrated Dark Mode.
- **Multilingual Support**: Automatically adapts to device language settings (Supports English and Indonesian).
- **Debounced Search**: A highly optimized book search feature (500ms debounce) to prevent UI lag on devices when typing book titles rapidly.
- **Offline-First (SQLite)**: All user data, books, and borrowing histories are stored locally on the device without requiring an internet connection.
- **Automated CI/CD Pipeline**: Fully configured with GitHub Actions to automatically build and attach APK releases whenever a new version tag (`v*`) is pushed to the repository.

## Tech Stack & Architecture

### Core Stack
- **Framework**: [Flutter](https://flutter.dev/) (SDK) with Material 3 Design
- **Language**: [Dart](https://dart.dev/)
- **State Management**: [provider](https://pub.dev/packages/provider) (Centralized App State)
- **Database**: [sqflite](https://pub.dev/packages/sqflite) (Offline-First Local Storage)
- **Key Libraries**:
  - `shared_preferences`: Persistent storage for Theme & Locale settings
  - `flutter_pdfview`: Native PDF rendering engine
  - `package_info_plus`: Dynamic application versioning
- **CI/CD**: **GitHub Actions** (Automated APK Build & Release)

### Architecture Highlights
- **Role-Based Routing**: The application dynamically determines the entry point and dashboard interface based on the authenticated user's role (Administrator, Librarian, Student).
- **Service-Oriented Providers**: Business logic is separated from UI using the Provider pattern (e.g., `AuthProvider`, `BookProvider`, `BorrowingProvider`), ensuring clean, maintainable, and testable code.
- **Offline-First Strategy**: All crucial transactions (borrowing, returning, fine accumulation) are executed against the local SQLite database synchronously, making the app 100% functional without an internet connection.

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
- **Librarian**
  - Email: `librarian@library.com`
  - Password: `librarian123`

For the **Student** role, you can register a new account directly through the **Register** button on the initial application page.

## Screenshots

Here are the application interfaces based on your screenshots:

<p align="center">
  <img src="screenshots/dashboard.jpg" width="30%" alt="Dashboard" />
  <img src="screenshots/history.jpg" width="30%" alt="Borrowing History" />
  <img src="screenshots/profile.jpg" width="30%" alt="Profile" />
</p>
<p align="center">
  <img src="screenshots/borrowed.jpg" width="30%" alt="Borrowed Books" />
  <img src="screenshots/about.jpg" width="30%" alt="About App" />
</p>

---

## Contributing

Contributions, issues, and feature requests are welcome! Feel free to check the [issues page](https://github.com/AkaneKanzaki/E-Library/issues) if you want to contribute.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
