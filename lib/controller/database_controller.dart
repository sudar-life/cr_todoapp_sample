import 'package:cr_todoapp_sample/model/todo_item.dart';
import 'package:get/get.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as path;

class DataBaseController extends GetxService {
  static DataBaseController get to => Get.find();

  late Database _database;

  Database get database {
    return _database;
  }

  Future<bool> initDataBase() async {
    var databasePath = await getDatabasesPath();
    var dataPath = path.join(databasePath, 'todo.db');
    _database =
        await openDatabase(dataPath, version: 1, onCreate: _onCreateTable);
    return true;
  }

  Future<void> _onCreateTable(Database db, int version) async {
    await db.execute('''
      create table ${TodoItemDbInfo.table} (
        ${TodoItemDbInfo.id} integer primary key autoincrement,
        ${TodoItemDbInfo.todo} text not null,
        ${TodoItemDbInfo.description} text,
        ${TodoItemDbInfo.createdAt} text not null,
        ${TodoItemDbInfo.isDone} integer not null default 0
      )
    ''');
  }
}
