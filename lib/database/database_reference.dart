import 'dart:io';
import 'package:food_app/model/food_model.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseReference {
  final String _databaseName = 'food_database.db';
  final int _version = 1;
  Database? _database;

  //Todo Table
  String tableName = 'favorite';
  String id = 'id';
  String name = 'strMeal';
  String image = 'strMealThumb';
  String category = 'strCategory';
  String area = 'strArea';
  String tags = 'strTags';
  String instruction = 'strInstructions';
  String createdAt = 'created_at';

  Future<Database> database() async {
    if (_database != null) return _database!;
    _database = await initDatabase();
    return _database!;
  }

  Future initDatabase() async {
    Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path, _databaseName);
    return openDatabase(path, version: _version, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute(
        'CREATE TABLE $tableName ($id INTEGER PRIMARY KEY, $name TEXT NULL, $image TEXT NULL, $createdAt TEXT NULL, $category TEXT NULL, $area TEXT NULL, $tags TEXT NULL, $instruction TEXT NULL)');
  }

  Future<List<FoodModel>> all() async {
    final data = await _database!.query(tableName);
    List<FoodModel> result = data.map((e) => FoodModel.fromJson(e)).toList();

    return result;
  }

  Future<int> insert(Map<String, dynamic> row) async {
    final query = await _database!.insert(tableName, row);
    return query;
  }

  Future deleteAll() async {
    await _database!.delete(tableName);
  }

  Future delete(int idParam) async {
    await _database!
        .delete(tableName, where: ' $id = ? ', whereArgs: [idParam]);
    print('succes delete $idParam');
  }
}
