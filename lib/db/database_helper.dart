import 'package:path/path.dart';
import 'package:practicaltest/model/model_user.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static const _databaseName = "user.db";
  static const _databaseVersion = 1;

  static const table = 'user';

  static const columnId = 'id';
  static const columnName = 'name';
  static const columnEmail = 'email';
  static const columnPhone = 'phone';
  static const columnDOB = 'dob';
  static const columnGender = 'gender';
  static const columnAddress = 'address';

  DatabaseHelper._();

  static final DatabaseHelper instance = DatabaseHelper._();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  _initDatabase() async {
    String path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE $table (
            $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
            $columnName TEXT NOT NULL,
            $columnEmail TEXT NOT NULL,
            $columnPhone TEXT NOT NULL,
            $columnDOB TEXT NOT NULL,
            $columnGender TEXT NOT NULL,
            $columnAddress TEXT NOT NULL
          )
          ''');
  }

  Future<int> insert(ModelUser modelUser) async {
    Database db = await instance.database;
    return await db.insert(table, {
      'name': modelUser.name,
      'email': modelUser.email,
      'phone': modelUser.phone,
      'dob': modelUser.dob.toString(),
      'gender': modelUser.gender,
      'address': modelUser.address
    });
  }

  Future<List<ModelUser>> getAllUser({String genderFilter = "M"}) async {
    Database db = await instance.database;
    var result;
    if(genderFilter.isEmpty){
      result = await db.query(table,orderBy: "dob");
    }else{
      result = await db.query(table,orderBy: "dob",where:"gender like ?" ,whereArgs: ['$genderFilter']);
    }

    // var result = await db.query(table,orderBy: "dob",where:"gender like ?" ,whereArgs: ['$genderFilter']);

    if (result.isEmpty) {
      return [];
    } else {
      List<ModelUser> list = [];
      for (int i = 0; i < result.length; i++) {
        list.add(ModelUser(
          id: int.parse(result[i]['id'].toString()),
          name: result[i]['name'].toString(),
          phone: result[i]['phone'].toString(),
          email: result[i]['email'].toString(),
          dob: DateTime.parse(result[i]['dob'].toString()),
          gender: result[i]['gender'].toString(),
          address: result[i]['address'].toString(),
        ));
      }
      return list;
    }
  }

  Future<List<Map<String, dynamic>>> queryRows(name) async {
    Database db = await instance.database;
    return await db.query(table, where: "$columnName LIKE '%$name%'");
  }

  Future<int> update(ModelUser modelUser) async {
    Database db = await instance.database;
    int id = modelUser.toMap()['id'];
    return await db.update(table, modelUser.toMap(),
        where: '$columnId = ?', whereArgs: [id]);
  }

  Future<int> delete(int id) async {
    Database db = await instance.database;
    return await db.delete(table, where: '$columnId = ?', whereArgs: [id]);
  }
}
