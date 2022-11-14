import 'package:cr_todoapp_sample/components/work_editor.dart';
import 'package:cr_todoapp_sample/controller/work_editor_controller.dart';
import 'package:cr_todoapp_sample/model/todo_item.dart';
import 'package:cr_todoapp_sample/repository/todo_repository.dart';
import 'package:cr_todoapp_sample/utils/data_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  static HomeController get to => Get.find();

  Rx<Size> calendarSize = Size.zero.obs;
  Rx<Size> calendarHeaderSize = Size.zero.obs;
  GlobalKey calendarKey = GlobalKey();
  GlobalKey calendarHeaderKey = GlobalKey();

  Rx<DateTime> headerDate = DateTime.now().obs;
  RxList<TodoItem> currentMonthTodoList = <TodoItem>[].obs;
  RxList<TodoItem> currentTodoListByCurrentDate = <TodoItem>[].obs;
  RxList<TodoItem> currentWorkDoneListByCurrentDate = <TodoItem>[].obs;
  RxDouble progress = 0.0.obs;
  DateTime currentDate = DateTime.now();

  @override
  void onInit() {
    super.onInit();
    refreshCurrentMonth();
  }

  void onCalendarCreated(PageController pageController) {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      var calendarSizeData = getRenderBoxSize(calendarKey);
      if (calendarSizeData != null) {
        calendarSize(calendarSizeData);
      }
      var calendarHeaderSizeData = getRenderBoxSize(calendarHeaderKey);
      if (calendarHeaderSizeData != null) {
        calendarHeaderSize(calendarHeaderSizeData);
      }
    });
  }

  Size? getRenderBoxSize(GlobalKey key) {
    if (key.currentContext != null) {
      var renderBox = key.currentContext!.findRenderObject() as RenderBox;
      var translation = renderBox.getTransformTo(null).getTranslation();
      return Size(0, renderBox.size.height + translation.y + 20);
    }
    return null;
  }

  void refreshCurrentMonth() async {
    await onPageChange(currentDate);
    var list =
        TodoDataUtils.findTodoListByDateTime(currentMonthTodoList, currentDate);
    onSelectedDate(currentDate, list);
  }

  void onSelectedDate(DateTime date, List<TodoItem> todayTodoList) {
    currentDate = date;
    currentWorkDoneListByCurrentDate.clear();
    currentTodoListByCurrentDate.clear();
    for (var todo in todayTodoList) {
      if (todo.isDone != null && todo.isDone) {
        currentWorkDoneListByCurrentDate.add(todo);
      } else {
        currentTodoListByCurrentDate.add(todo);
      }
    }
    _calcTodayWorkProgresive();
  }

  void toggleTodoItem(TodoItem todoItem) async {
    late TodoItem changeTodoItem;
    if (todoItem.isDone) {
      changeTodoItem = todoItem.clone(isDone: !todoItem.isDone);
      currentWorkDoneListByCurrentDate.remove(todoItem);
      currentTodoListByCurrentDate.add(changeTodoItem);
    } else {
      changeTodoItem = todoItem.clone(isDone: !todoItem.isDone);
      currentTodoListByCurrentDate.remove(todoItem);
      currentWorkDoneListByCurrentDate.add(changeTodoItem);
    }
    await TodoRepository.update(changeTodoItem);
    _calcTodayWorkProgresive();
    refreshCurrentMonth();
  }

  void _calcTodayWorkProgresive() {
    var total = currentTodoListByCurrentDate.length +
        currentWorkDoneListByCurrentDate.length;
    if (total == 0) {
      progress(0);
    } else {
      progress(currentWorkDoneListByCurrentDate.length / total);
    }
  }

  Future<void> onPageChange(DateTime date) async {
    var startDate = date.subtract(Duration(days: date.day - 1));
    var endDate = DateTime(date.year, date.month + 1, 0);
    var findCurrentMonthTodoList =
        await TodoRepository.findByDateRange(startDate, endDate);
    currentMonthTodoList(findCurrentMonthTodoList);
    headerDate(date);
  }

  Future<void> deleteTodoItem(TodoItem item) async {
    await TodoRepository.delete(item);
    refreshCurrentMonth();
  }

  Future<void> editTodoItem(TodoItem item) async {
    Get.to(
      () => const WorkEditor(),
      arguments: {'editItem': item},
      opaque: false,
      fullscreenDialog: true,
      duration: Duration.zero,
      transition: Transition.downToUp,
      binding: BindingsBuilder(
        () {
          Get.put(WorkEditorController());
        },
      ),
    );
  }

  double get slidingUpPanelMinHeight {
    return Get.height -
        calendarSize.value.height -
        Get.mediaQuery.padding.bottom;
  }

  double get slidingUpPanelMaxHeight {
    return Get.height -
        calendarHeaderSize.value.height +
        Get.mediaQuery.padding.top;
  }
}
