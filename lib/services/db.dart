import 'package:kader/constants/keys.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DB {
  DB._();

  static final instance = DB._();
  late Database _db;

  Future<void> init() async {
    final dbPath = join(await getDatabasesPath(), Keys.dbName);
    _db = await openDatabase(
      dbPath,
      version: 1,
      onCreate: (db, version) async {
        // await db.execute('');
      },
    );
  }
}
