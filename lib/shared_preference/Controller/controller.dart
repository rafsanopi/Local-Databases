import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeController extends GetxController {
  RxBool isDarkMode = false.obs;
  var text = <String>[].obs;

  @override
  void onInit() {
    super.onInit();
    getThemeFromPrefs();
    getData();
  }

//Dark theme
  void toggleTheme() {
    isDarkMode.value = !isDarkMode.value;
    saveThemeToPrefs();
  }

  void saveThemeToPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isDarkMode', isDarkMode.value);
  }

  void getThemeFromPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    isDarkMode.value = prefs.getBool('isDarkMode')!;
  }

//
  // Save list of string values
  void saveData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('text', text);
  }

  void getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    text.value = prefs.getStringList('text')!;
  }

  void addData(String textData) async {
    text.add(textData);
    saveData();
  }
}
