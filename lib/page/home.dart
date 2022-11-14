import 'package:cr_todoapp_sample/components/todo_calendar.dart';
import 'package:cr_todoapp_sample/components/work_card.dart';
import 'package:cr_todoapp_sample/components/work_editor.dart';
import 'package:cr_todoapp_sample/controller/home_controller.dart';
import 'package:cr_todoapp_sample/controller/work_editor_controller.dart';
import 'package:cr_todoapp_sample/utils/data_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class TodoHome extends GetView<HomeController> {
  const TodoHome({Key? key}) : super(key: key);
  Widget _header() {
    return Padding(
      key: controller.calendarHeaderKey,
      padding: const EdgeInsets.symmetric(vertical: 15.0),
      child: Obx(
        () => Text(
          TodoDataUtils.mainHeaderDateToString(controller.headerDate.value),
          style: GoogleFonts.notoSans(
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _calendalWidget() {
    return SizedBox(
      key: controller.calendarKey,
      height: 330,
      child: Obx(
        () => TodoCalendar(
          focusMonth: controller.headerDate.value,
          todoItmes: controller.currentMonthTodoList.value,
          onCalendarCreated: controller.onCalendarCreated,
          onPageChange: controller.onPageChange,
          onSelectedDate: controller.onSelectedDate,
        ),
      ),
    );
  }

  Widget _scrollingList(ScrollController sc) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.only(top: 10),
          height: 6,
          width: 50,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            color: Colors.grey.withOpacity(0.7),
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            controller: sc,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 25),
                  _todoListWidget(),
                  const SizedBox(height: 40),
                  _workedDoneListWidget(),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _todoListWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          '할일',
          style: GoogleFonts.notoSans(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 10),
        Obx(
          () => controller.currentTodoListByCurrentDate.isEmpty
              ? _emptyMessageWidget('할 일이 없습니다.')
              : Column(
                  children: [
                    ...List.generate(
                      controller.currentTodoListByCurrentDate.length,
                      (index) => WorkCard(
                        todoItem:
                            controller.currentTodoListByCurrentDate[index],
                        onEditTodoItem: controller.editTodoItem,
                        toggleTodoItem: controller.toggleTodoItem,
                        onDeleteItem: controller.deleteTodoItem,
                      ),
                    ),
                  ],
                ),
        )
      ],
    );
  }

  Widget _emptyMessageWidget(String message) {
    return SizedBox(
      height: 150,
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        SvgPicture.asset('assets/svg/icon_no_data.svg'),
        const SizedBox(height: 15),
        Text(
          message,
          style: GoogleFonts.notoSans(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        )
      ]),
    );
  }

  Widget _workedDoneListWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          '완료',
          style: GoogleFonts.notoSans(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 10),
        Obx(
          () => controller.currentWorkDoneListByCurrentDate.isEmpty
              ? _emptyMessageWidget('완료된 작업이 없습니다.')
              : Column(
                  children: [
                    ...List.generate(
                      controller.currentWorkDoneListByCurrentDate.length,
                      (index) => WorkCard(
                        todoItem:
                            controller.currentWorkDoneListByCurrentDate[index],
                        onEditTodoItem: controller.editTodoItem,
                        toggleTodoItem: controller.toggleTodoItem,
                        onDeleteItem: controller.deleteTodoItem,
                      ),
                    ),
                  ],
                ),
        )
      ],
    );
  }

  Widget _bottomProgressBarWidget() {
    return Container(
      height: 8 + Get.mediaQuery.padding.bottom,
      color: const Color.fromARGB(255, 237, 237, 237),
      child: Align(
          alignment: Alignment.centerLeft,
          child: Obx(
            () => AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: Get.width * controller.progress.value,
              height: 8 + Get.mediaQuery.padding.bottom,
              color: const Color(0xff1B5BBF),
            ),
          )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Obx(
          () => SlidingUpPanel(
            minHeight: controller.slidingUpPanelMinHeight,
            maxHeight: controller.slidingUpPanelMaxHeight,
            panelBuilder: (ScrollController sc) => _scrollingList(sc),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
            body: Container(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  children: [
                    _header(),
                    const SizedBox(height: 10),
                    _calendalWidget(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xff1B5BBF),
        onPressed: () async {
          var results = await Get.to(
            () => WorkEditor(),
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
          print(results);
        },
        child: Center(
          child: SvgPicture.asset('assets/svg/icon_edit.svg'),
        ),
      ),
      bottomNavigationBar: _bottomProgressBarWidget(),
    );
  }
}
