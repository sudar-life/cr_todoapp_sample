import 'package:cr_todoapp_sample/controller/database_controller.dart';
import 'package:cr_todoapp_sample/model/todo_item.dart';

class TodoRepository {
  static Future<int> create(TodoItem item) async {
    return await DataBaseController.to.database.insert(
      TodoItemDbInfo.table,
      item.toMap(),
    );
  }

  static Future<List<TodoItem>> findByDateRange(
      DateTime startDate, DateTime endDate,
      {bool? isDone}) async {
    List<dynamic> queryValues = [
      startDate.toIso8601String(),
      endDate.toIso8601String()
    ];
    var query = '''
              select 
              *
              from ${TodoItemDbInfo.table} 
              where ${TodoItemDbInfo.createdAt} >= ? and ${TodoItemDbInfo.createdAt} <= ? ''';
    if (isDone != null) {
      query += 'and ${TodoItemDbInfo.isDone} = ?';
      queryValues.add(isDone ? 1 : 0);
    }
    var results = await DataBaseController.to.database.rawQuery(
      query,
      queryValues,
    );
    return results.map((data) => TodoItem.fromJson(data)).toList();
  }

  static Future<int> update(TodoItem item) async {
    try {
      return await DataBaseController.to.database.update(
          TodoItemDbInfo.table, item.toMap(),
          where: '${TodoItemDbInfo.id} = ?', whereArgs: [item.id]);
    } catch (e) {
      print(e);

      return 0;
    }
  }

  static Future<int> delete(TodoItem item) async {
    return await DataBaseController.to.database
        .delete(TodoItemDbInfo.table, where: 'id=?', whereArgs: [item.id]);
  }
}
