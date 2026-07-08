import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('elibrary.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version) async {
    const idType = 'TEXT PRIMARY KEY';
    const textType = 'TEXT NOT NULL';
    const boolType = 'INTEGER NOT NULL';
    const intType = 'INTEGER NOT NULL';

    await db.execute('''
CREATE TABLE books (
  id $idType,
  judul $textType,
  penulis $textType,
  penerbit $textType,
  tahunTerbit $textType,
  deskripsi $textType,
  coverUrl $textType,
  tersedia $boolType,
  kategori $textType,
  bookPath $textType,
  jumlahHalaman $intType
)
''');

    await db.execute('''
CREATE TABLE peminjaman (
  id $idType,
  userId $textType,
  bookId $textType,
  tanggalPinjam $textType,
  tanggalKembali $textType,
  status $textType
)
''');

    await db.execute('''
CREATE TABLE favorites (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  bookId $textType
)
''');
  }

  Future<void> close() async {
    final db = await instance.database;
    db.close();
  }
}
