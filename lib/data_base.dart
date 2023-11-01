import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class SqlDb {
  static Database? _db;
  Future<Database?> get db async {
    if (_db == null) {
      _db = await intialDb();
      return _db;
    } else {
      return _db;
    }
  }

  intialDb() async {
    String DatabasePath = await getDatabasesPath();
    String path = join(DatabasePath, 'shimaa.db');
    Database mydb = await openDatabase(path,
        onCreate: _onCreate, onUpgrade: _onUpgrade, version: 1);
    return mydb;
  }

  _onCreate(Database db, int version) async {
    await db.execute(''' 
    CREATE TABLE "notes" (
    'id' INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    'note' TEXT  NOT NULL
     )
    ''');
    print("database created============");
  }

  _onUpgrade(Database db, int oldVersion, int newVersion) {
    print("onUpgrade================================");
  }

  Future<List<Map<String, dynamic>>> readData(String sql) async {
    Database? mydb = await db;
    List<Map<String, dynamic>> response = await mydb!.rawQuery(sql);
    return response;
  }



  insertData(String sql) async {
    Database? mydb = await db;
    int response = await mydb!.rawInsert(sql);
    return response;
  }

  updateData(String sql) async {
    Database? mydb = await db;
    int response = await mydb!.rawUpdate(sql);
    return response;
  }

  deleteData(String sql) async {
    Database? mydb = await db;
    int response = await mydb!.rawDelete(sql);
    return response;
  }
}
