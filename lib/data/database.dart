import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

Future<Database> getDatabase() async {
  final databasesPath = await getDatabasesPath();
  final String path = join(databasesPath, 'medi.db');

  return await openDatabase(
    path,
    version: 1,
    onCreate: (db, version) {
      db.execute("#####");
    },
  );
}
