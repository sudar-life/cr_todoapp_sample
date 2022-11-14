import 'package:cr_todoapp_sample/app.dart';
import 'package:cr_todoapp_sample/bindings/init_binding.dart';
import 'package:cr_todoapp_sample/controller/home_controller.dart';
import 'package:cr_todoapp_sample/page/home.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() {
  initializeDateFormatting().then((_) => runApp(MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialBinding: InitBinding(),
      home: const App(),
    );
  }
}
