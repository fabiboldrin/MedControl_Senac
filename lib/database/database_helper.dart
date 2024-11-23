import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  static const _databaseName = "app.db";

  // Incrementando a versão, sempre que tiver uma alteração no db
  static const int _databaseVersion = 1;

  DatabaseHelper._init();

  Future<Database> get database async {
    await _deleteDatabaseFile(_databaseName);

    if (_database != null) return _database!;
    _database = await _initDB(_databaseName);
    return _database!;
  }

  static Future<void> _deleteDatabaseFile(String filePath) async {
    // final dbPath = await getDatabasesPath();
    // final path = join(dbPath, filePath);

    // // Delete the database file
    // await deleteDatabase(path);
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: _databaseVersion, // Incrementar a versão
      onCreate: _createDB,
      onUpgrade: _onUpgrade,
    );
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE profiles (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        birthdate TEXT,
        healthHistory TEXT,
        allergies TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE medications (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        profileId INTEGER NOT NULL,
        name TEXT NOT NULL,
        dosage TEXT NOT NULL,
        scheduleTimes TEXT,
        colorCode TEXT NOT NULL,
        stock INTEGER NOT NULL DEFAULT 0,
        archived INTEGER NOT NULL DEFAULT 0,
        FOREIGN KEY(profileId) REFERENCES profiles(id)
      )
    ''');

    await db.execute('''
      CREATE TABLE medications_taken (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        profileId INTEGER NOT NULL,
        medicationId INTEGER NOT NULL,
        scheduleTime TEXT,
        takenDate TEXT,
        takenTime TEXT,
        FOREIGN KEY(profileId) REFERENCES profiles(id),
        FOREIGN KEY(medicationId) REFERENCES medications(id)
      )
    ''');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < newVersion) {
      if (oldVersion == 1) {
        // Adiciona o campo "archived" na tabela "medications" para versões anteriores
        // await db.execute(
        //   'ALTER TABLE medications ADD COLUMN archived INTEGER DEFAULT 0',
        // );
      }
      // Você pode adicionar mais condições para versões futuras
    }
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
