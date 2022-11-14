class TodoItem {
  int? id;
  String todo;
  String description;
  DateTime createdAt;
  bool isDone;

  TodoItem({
    this.id,
    required this.todo,
    required this.description,
    required this.createdAt,
    this.isDone = false,
  });

  Map<String, dynamic> toMap() {
    return {
      TodoItemDbInfo.id: id,
      TodoItemDbInfo.todo: todo,
      TodoItemDbInfo.description: description,
      TodoItemDbInfo.createdAt: createdAt.toIso8601String(),
      TodoItemDbInfo.isDone: isDone ? 1 : 0,
    };
  }

  factory TodoItem.fromJson(Map<String, dynamic> json) {
    return TodoItem(
      id: json[TodoItemDbInfo.id] as int,
      todo: json[TodoItemDbInfo.todo] as String,
      description: json[TodoItemDbInfo.description] as String,
      isDone: (json[TodoItemDbInfo.isDone] as int) == 1,
      createdAt: DateTime.parse(json[TodoItemDbInfo.createdAt] as String),
    );
  }

  TodoItem clone({
    int? id,
    String? todo,
    String? description,
    DateTime? createdAt,
    bool? isDone,
  }) {
    return TodoItem(
      id: id ?? this.id,
      todo: todo ?? this.todo,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
      isDone: isDone ?? this.isDone,
    );
  }
}

class TodoItemDbInfo {
  static String table = 'todo_item';
  static String id = 'id';
  static String todo = 'todo';
  static String description = 'description';
  static String createdAt = 'createdAt';
  static String isDone = 'isDone';
}
