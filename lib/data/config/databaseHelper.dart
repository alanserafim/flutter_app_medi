import 'package:flutter_app_medi/data/repositories/dose_repository.dart';
import 'package:flutter_app_medi/data/repositories/medicine_repository.dart';
import 'package:flutter_app_medi/data/repositories/user_repository.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('medi.db');
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

  Future<void> _createDB(Database db, int version) async {
    await db.execute(MedicineRepository.tableSql);
    await db.execute(DoseRepository.tableSql);
    await db.execute(UserRepository.tableSql);
  }

  Future<void> close() async {
    final db = _database;
    if (db != null) {
      await db.close();
    }
  }
}