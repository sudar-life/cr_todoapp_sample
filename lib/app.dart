import 'package:cr_todoapp_sample/controller/database_controller.dart';
import 'package:cr_todoapp_sample/controller/home_controller.dart';
import 'package:cr_todoapp_sample/page/home.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child: Container(
        color: Colors.white,
        child: FutureBuilder<bool>(
            future: DataBaseController.to.initDataBase(),
            builder: (_, snaphot) {
              if (snaphot.hasError) {
                return const Center(
                  child: Text('sqflite를 지원하지 않습니다.'),
                );
              }
              if (snaphot.hasData) {
                Get.put(HomeController());
                return const TodoHome();
              }
              return const Center(
                child: CircularProgressIndicator(),
              );
            }),
      ),
    );
  }
}
