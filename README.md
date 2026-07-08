# E-Library Mobile App

Aplikasi mobile Perpustakaan Digital (E-Library) *offline-first* yang dibangun menggunakan framework **Flutter** dan **SQLite**. Aplikasi ini dirancang untuk menyediakan ekosistem manajemen perpustakaan yang komprehensif mulai dari peminjaman buku, membaca buku format PDF, hingga pengelolaan denda otomatis berdasarkan sistem *Role-Based Access Control* (RBAC).

## Fitur Utama

- **Role-Based Authentication**: Mendukung 3 jenis hak akses:
  - **Administrator**: Memiliki kendali penuh terhadap sistem, termasuk menambah/menghapus data Pustakawan dan Siswa.
  - **Pustakawan**: Mengelola katalog buku (CRUD) dan memantau seluruh riwayat peminjaman buku.
  - **Siswa**: Dapat mencari buku, meminjam buku, membaca buku, dan melihat riwayat denda.
- **Integrated PDF Reader**: Membaca file buku PDF langsung di dalam aplikasi. Dilengkapi dengan memori *bookmark* otomatis, sehingga pengguna bisa melanjutkan bacaan dari halaman terakhir yang dibuka.
- **Sistem Denda Otomatis**: Secara cerdas menghitung durasi peminjaman dan keterlambatan, serta mengakumulasi denda secara otomatis jika batas waktu pengembalian dilewati.
- **Debounced Search**: Fitur pencarian buku yang sangat optimal (*debounce 500ms*) untuk menghindari efek *lag* pada perangkat saat mengetik judul buku dengan cepat.
- **Dark Mode Support**: Tema Gelap yang terintegrasi penuh dan preferensinya disimpan di memori perangkat.
- **Offline-First (SQLite)**: Seluruh data pengguna, buku, dan riwayat peminjaman disimpan secara lokal di dalam *device* tanpa membutuhkan koneksi internet.

## Teknologi yang Digunakan

- [Flutter](https://flutter.dev/) (SDK)
- [Dart](https://dart.dev/) (Language)
- [sqflite](https://pub.dev/packages/sqflite) (Local Database)
- [provider](https://pub.dev/packages/provider) (State Management)
- [shared_preferences](https://pub.dev/packages/shared_preferences) (Persistent Storage)
- [flutter_pdfview](https://pub.dev/packages/flutter_pdfview) (PDF Viewer)

## Cara Menjalankan Aplikasi Lokal

1. **Prasyarat**: Pastikan Anda sudah menginstal Flutter SDK (versi terbaru direkomendasikan).
2. **Kloning Repositori**:
   ```bash
   git clone https://github.com/AkaneKanzaki/E-Library.git
   cd E-Library
   ```
3. **Unduh Dependencies**:
   ```bash
   flutter pub get
   ```
4. **Jalankan Aplikasi**:
   Pastikan emulator atau *device* fisik Anda (dengan mode *USB Debugging*) sudah tersambung.
   ```bash
   flutter run
   ```

## Akun Default (Dummy)

Aplikasi ini menggunakan sistem SQLite lokal dan sudah dibekali beberapa akun bawaan untuk keperluan *testing* dan demonstrasi:

- **Administrator**
  - Email: `admin@library.com`
  - Password: `admin123`
- **Pustakawan**
  - Email: `pustakawan@library.com`
  - Password: `pustakawan123`

Untuk *Siswa*, Anda dapat mendaftarkan akun baru secara langsung melalui tombol **Registrasi** pada halaman awal aplikasi.

## Screenshots (Tampilan Aplikasi)

*(Anda dapat menambahkan screenshot/GIF aplikasi Anda di sini dengan format)*
`![Login Screen](link-gambar)` | `![Dashboard](link-gambar)` | `![PDF Reader](link-gambar)`

---

Dibuat menggunakan Flutter.
