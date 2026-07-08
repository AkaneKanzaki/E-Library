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
      version: 2,
      onCreate: _createDB,
      onUpgrade: _upgradeDB,
    );
  }

  Future _createDB(Database db, int version) async {
    const idType = 'TEXT PRIMARY KEY';
    const textType = 'TEXT NOT NULL';
    const textNullType = 'TEXT';
    const boolType = 'INTEGER NOT NULL';
    const intType = 'INTEGER NOT NULL';

    await db.execute('''
CREATE TABLE books (
  id $idType,
  title $textType,
  author $textType,
  publisher $textType,
  publishYear $textType,
  description $textType,
  coverUrl $textType,
  isAvailable $boolType,
  category $textType,
  bookPath $textType,
  pageCount $intType
)
''');

    await db.execute('''
CREATE TABLE borrowings (
  id $idType,
  userId $textType,
  bookId $textType,
  borrowDate $textType,
  returnDate $textNullType,
  dueDate $textType,
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

  Future _upgradeDB(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('ALTER TABLE borrowings ADD COLUMN dueDate TEXT');
    }
  }

  Future<void> close() async {
    final db = await instance.database;
    db.close();
  }
}
