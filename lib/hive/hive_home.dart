import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HiveHome extends StatefulWidget {
  const HiveHome({super.key});

  @override
  State<HiveHome> createState() => _HiveHomeState();
}

class _HiveHomeState extends State<HiveHome> {
  TextEditingController nameController = TextEditingController();
  TextEditingController quantityController = TextEditingController();
  //
  List<Map<String, dynamic>> itemsNote = [];
  final notesBox = Hive.box("notes");
  //
  refreshItem() async {
    final data = notesBox.keys.map((key) {
      final item = notesBox.get(key);
      return {"key": key, "name": item["name"], "quantity": item["quantity"]};
    }).toList();
    setState(() {
      itemsNote = data.reversed.toList();
    });
  }

  //
  void _createItems(Map<String, dynamic> newItems) async {
    await notesBox.add(newItems);
    refreshItem();
  }

  //
  void _updateItems(int itemkey, Map<String, dynamic> newItems) async {
    await notesBox.put(itemkey, newItems);
    refreshItem();
  }

  //
  void _deleteItems(int itemkey) async {
    await notesBox.delete(
      itemkey,
    );
    refreshItem();
    Get.snackbar("Deleted", "The item has successfully deleted",
        colorText: Colors.white);
  }

//
  void bottomSheet(BuildContext buildContext, int? itemkey) async {
    if (itemkey != null) {
      final existingItem =
          itemsNote.firstWhere((element) => element["key"] == itemkey);
      nameController.text = existingItem["name"];
      quantityController.text = existingItem["quantity"];
    }
    return showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
              top: 15,
              left: 15,
              right: 15),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(hintText: "Name"),
              ),
              const SizedBox(
                height: 10,
              ),
              TextField(
                controller: quantityController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(hintText: "Ammount"),
              ),
              const SizedBox(
                height: 10,
              ),
              ElevatedButton(
                  onPressed: () {
                    if (itemkey != null) {
                      _updateItems(itemkey, {
                        "name": nameController.text.trim(),
                        "quantity": quantityController.text.trim()
                      });
                    } else {
                      _createItems({
                        "name": nameController.text,
                        "quantity": quantityController.text
                      });
                    }
                    navigator!.pop();
                  },
                  child: const Text("Done")),
              const SizedBox(
                height: 10,
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void initState() {
    refreshItem();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Hive"),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            bottomSheet(context, null);
          },
          child: const Icon(Icons.add),
        ),
        body: ListView.builder(
          itemCount: itemsNote.length,
          itemBuilder: (context, index) {
            final currentIndex = itemsNote[index];
            return Card(
              color: Colors.grey,
              margin: const EdgeInsets.all(5),
              child: ListTile(
                title: Text(currentIndex["name"]),
                subtitle: Text(currentIndex["quantity"]),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                        onPressed: () {
                          bottomSheet(context, currentIndex["key"]);
                        },
                        icon: const Icon(Icons.edit)),
                    IconButton(
                        onPressed: () {
                          _deleteItems(
                            currentIndex["key"],
                          );
                        },
                        icon: const Icon(Icons.delete)),
                  ],
                ),
              ),
            );
          },
        ));
  }
}
