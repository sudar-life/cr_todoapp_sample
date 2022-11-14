import 'package:cr_todoapp_sample/controller/home_controller.dart';
import 'package:cr_todoapp_sample/controller/work_editor_controller.dart';
import 'package:cr_todoapp_sample/model/todo_item.dart';
import 'package:cr_todoapp_sample/utils/data_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class WorkEditor extends GetView<WorkEditorController> {
  const WorkEditor({
    Key? key,
  }) : super(key: key);

  Widget _header() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 15),
          child: Text(
            TodoDataUtils.dateFormat(controller.createdAt,
                format: 'yyyy.MM.dd'),
            style: GoogleFonts.notoSans(
              fontSize: 20,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        GestureDetector(
          onTap: controller.back,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 15),
            child: Text(
              '취소',
              style: GoogleFonts.notoSans(
                fontSize: 16,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _title() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(7),
        color: const Color(0xffeeeeee),
      ),
      child: TextField(
        controller: controller.titleController,
        decoration: const InputDecoration(
          hintText: '할일을 입력해주세요.',
          border: InputBorder.none,
        ),
      ),
    );
  }

  Widget _desciption() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(7),
        color: const Color(0xffeeeeee),
      ),
      child: TextField(
        maxLines: null,
        expands: true,
        controller: controller.dscriptionController,
        decoration: const InputDecoration(
          hintText: '할일에 대해 설명을 입력해주세요.',
          border: InputBorder.none,
        ),
      ),
    );
  }

  Widget _btn() {
    return GestureDetector(
      onTap: controller.submit,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 15),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(7),
          color: Colors.blue,
        ),
        child: Text(
          controller.isEditMode ? '수정' : '등록',
          style: GoogleFonts.notoSans(
            fontSize: 17,
            color: Colors.white,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: controller.focusOut,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        resizeToAvoidBottomInset: true,
        body: Stack(
          children: [
            Container(
              color: Colors.black.withOpacity(0.7),
            ),
            Obx(
              () => AnimatedPositioned(
                duration: const Duration(milliseconds: 200),
                top: controller.modalPosition.value,
                bottom: 0,
                child: Container(
                  width: Get.width,
                  height: Get.height,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(20),
                    ),
                    color: Colors.white,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _header(),
                      _title(),
                      const SizedBox(height: 15),
                      Expanded(child: _desciption()),
                      _btn(),
                      SizedBox(height: Get.mediaQuery.padding.bottom),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
