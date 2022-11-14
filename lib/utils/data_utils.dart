import 'package:cr_todoapp_sample/model/todo_item.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TodoDataUtils {
  static String convertWeekdayToStringValue(int weekDay) {
    switch (weekDay) {
      case 1:
        return '월';
      case 2:
        return '화';
      case 3:
        return '수';
      case 4:
        return '목';
      case 5:
        return '금';
      case 6:
        return '토';
      case 7:
        return '일';
    }
    return '';
  }

  static int workDoneCountToLevel(int workDoneCount) {
    if (workDoneCount > 0 && workDoneCount <= 3) {
      return 1;
    }
    if (workDoneCount > 3 && workDoneCount <= 8) {
      return 2;
    }
    if (workDoneCount > 8 && workDoneCount <= 15) {
      return 3;
    }
    if (workDoneCount > 15) {
      return 4;
    }
    return 0;
  }

  static DateTime makeCurrentDateWithNowDate(DateTime now, int afterDay) {
    return now.add(Duration(days: afterDay));
  }

  static String mainHeaderDateToString(DateTime time) {
    var dateString = StringBuffer();
    dateString.write(time.year);
    dateString.write('.');
    dateString.write(time.month < 10 ? '0${time.month}' : time.month);
    return dateString.toString();
  }

  static Color dayToColor(DateTime date, {double opacity = 1}) {
    return date.weekday == DateTime.sunday
        ? Colors.red[300]!.withOpacity(opacity)
        : date.weekday == DateTime.saturday
            ? Colors.blue[300]!.withOpacity(opacity)
            : Colors.black.withOpacity(opacity);
  }

  static String dateFormat(DateTime dateTime, {String format = 'yyyy-MM-dd'}) {
    final f = DateFormat(format);
    return f.format(dateTime);
  }

  static List<TodoItem> findTodoListByDateTime(
      List<TodoItem> allTodoList, DateTime date) {
    return allTodoList.where((todoItem) {
      return (date.month == todoItem.createdAt.month &&
          date.day == todoItem.createdAt.day);
    }).toList();
  }

  static bool isComplate(List<TodoItem> items, DateTime date) {
    var cItems = findTodoListByDateTime(items, date);
    var values = cItems.where((item) => !item.isDone).toList();
    return values.isEmpty;
  }

  static bool isSameDate(DateTime sourceDate, DateTime targetDate) {
    return (sourceDate.year == targetDate.year &&
        sourceDate.month == targetDate.month &&
        sourceDate.day == targetDate.day);
  }
}
