import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_app/models/task.dart';

class DBHelp {
  static Database? _database;
  int version = 1;
  static const String _tableName = 'tasks';

  Future<Database?> get db async {
    if (_database == null) {
      _database = await initDataBase();
      print('Data Base Is New Created');
      return _database;
    } else {
      print('Data Base Is Already Created');
      return _database;
    }
  }

  initDataBase() async {
    String databasepath = await getDatabasesPath();
    String path = join(databasepath, 'taskdatabase.db');
    Database mydb = await openDatabase(
      path,
      onCreate: _onCreate,
      version: version,
    );
    return mydb;
  }

  _onCreate(Database db, int version) {
    db.execute('''CREATE TABLE $_tableName (
              id INTEGER PRIMARY KEY NOT NULL AUTOINCREMENT,
              title STRING, note TEXT, date STRING,
              startTime STRING, endTime STRING,
              remind INTGER, repeat STRING,
              color INTEGER,
              isCompleted INTEGER
              )''');
    print('DataBaseCreatedOnCreate');
  }

  static Future<int> insert(Task? task) async {
    print('insert somthing called');
    return await _database!.insert(_tableName, task!.toJson());
  }

  static Future<int> delete(Task task) async {
    print('delete somthing called');
    return await _database!
        .delete(_tableName, where: 'id = ?', whereArgs: [task.id]);
  }

  static Future<int> delteAllTasks() async {
    print('delete All Values somthing called');
    return await _database!.delete(_tableName);
  }

  static Future<List<Map<String, dynamic>>> query() async {
    print('query somthing called');
    return await _database!.query(_tableName);
  }

  static Future<int> update(int id) async {
    print('update somthing called');
    return await _database!.rawUpdate(
      '''
UPDATE tasks
SET isCompleted = ?
WHERE id = ?
''',
      [1, id],
    );
  }
}
