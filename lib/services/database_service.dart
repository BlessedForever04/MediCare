import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  factory DatabaseService() => _instance;
  DatabaseService._internal();

  Database? _db;

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDB();
    return _db!;
  }

  Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'medical.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE medical_history(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT UNIQUE,
            notes TEXT,
            recorded_at TEXT
          )
        ''');
      },
    );
  }

  Future<void> insertDisease(String name, {String? notes}) async {
    final db = await database;
    await db.insert(
      "medical_history",
      {
        "name": name,
        "notes": notes ?? '',
        "recorded_at": DateTime.now().toIso8601String()
      },
      conflictAlgorithm: ConflictAlgorithm.ignore, // ✅ Prevent duplicates
    );
  }

  Future<List<Map<String, String>>> getMedicalHistory() async {
    final db = await database;
    final result = await db.query("medical_history");
    return result
        .map((row) => {
              "name": row["name"] as String,
              "notes": row["notes"] as String,
              "recorded_at": row["recorded_at"] as String,
            })
        .toList();
  }
}
