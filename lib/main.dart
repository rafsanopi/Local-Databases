import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:localdatabase/hive/hive_home.dart';
import 'package:localdatabase/shared_preference/Controller/controller.dart';
import 'package:localdatabase/sqflite/screens/notes_home.dart';
import 'package:localdatabase/shared_preference/screen/theme_toggole.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox("notes");
  // Get.put(ThemeController());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'My App',
      // theme: ThemeData.light().copyWith(useMaterial3: true),
      // darkTheme: ThemeData.dark().copyWith(useMaterial3: true),
      // themeMode: Get.find<ThemeController>().isDarkMode.value
      //     ? ThemeMode.dark
      //     : ThemeMode.light,
      // home: ThemeToggle(),
      home: HiveHome(),
    );
  }
}
