import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:localdatabase/shared_preference/Controller/controller.dart';

class ThemeToggle extends StatelessWidget {
  final ThemeController _themeController = Get.put(ThemeController());

  ThemeToggle({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My App'),
        actions: [
          IconButton(
            icon: Icon(_themeController.isDarkMode.value
                ? Icons.light_mode
                : Icons.dark_mode),
            onPressed: () {
              _themeController.toggleTheme();
              Get.changeThemeMode(_themeController.isDarkMode.value
                  ? ThemeMode.dark
                  : ThemeMode.light);
            },
          ),
        ],
      ),
      body: Obx((() {
        return RefreshIndicator(
          onRefresh: () async {
            print("object");
          },
          child: ListView.builder(
            itemCount: _themeController.text.length,
            itemBuilder: (context, index) {
              return Center(
                child: Text(_themeController.text == null
                    ? "No data"
                    : _themeController.text[index]),
              );
            },
          ),
        );
      })),
      floatingActionButton: FloatingActionButton(
          onPressed: () async {
            var value = await showDialog(
              context: context,
              builder: (BuildContext context) {
                return SimpleDialog(
                  title: const Text("Enter a text"),
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        onSubmitted: (value) {
                          Navigator.pop(context, value);
                        },
                      ),
                    ),
                  ],
                );
              },
            );
            _themeController.addData(value);
          },
          child: const Icon(Icons.text_fields)),
    );
  }
}
