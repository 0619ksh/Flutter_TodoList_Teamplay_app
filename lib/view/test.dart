import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:todo_ex_app/model/todo_list.dart';
import 'package:todo_ex_app/view/add_view.dart';

class Test extends StatefulWidget {
  const Test({super.key});

  @override
  State<Test> createState() => _TestState();
}

class _TestState extends State<Test> {
  late List<TodoList> todoList;
  final box = GetStorage();

  @override
  void initState() {
    super.initState();

    todoList = [];
    addData();
    initStorage();
  }

  void addData() {
    todoList.add(TodoList(todoText: "학원", date: "2026-08-12", time: "10:00", category: "일상", isImportant: true, isCompleted: false));
  }

  // Storage 초기화
  void initStorage() {
    box.write("_todo", "");
    box.write("_date", "");
    box.write("_time", "");
    box.write("_category", "");
    box.write("_important", "");
  }
  
  @override
  void dispose() {
    box.erase();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Main View"),
        actions: [
          IconButton(
            onPressed: () async {
              await Get.to(AddView());
              
              final todoText = box.read("_todo") ?? "";
              final todoDate = box.read("_date") ?? "";
              final todoTime = box.read("_time") ?? "";
              final todoCategory = box.read("_category") ?? "";
              final todoIsImportant = box.read("_important") ?? false;

              if (todoText.isNotEmpty) {
                todoList.add(TodoList(todoText: todoText, date: todoDate, time: todoTime, category: todoCategory, isImportant: todoIsImportant, isCompleted: false));

                box.remove("_todo");
                box.remove("_date");
                box.remove("_time");
                box.remove("_category");
                box.remove("_important");
              }
              
              setState(() {});
            }, 
            icon: Icon(Icons.add)
          )
        ],
      ),
      body: ListView.builder(
        itemCount: todoList.length,
        itemBuilder: (context, index) {
          return SizedBox(
            height: 100.0,
            child: Card(
              color: index % 2 == 0
                      ? const Color.fromARGB(255, 111, 105, 159)
                      : const Color.fromARGB(255, 147, 115, 133),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  children: [
                    Text("${todoList[index].todoText}, ${todoList[index].date}, ${todoList[index].time}, ${todoList[index].category}, ${todoList[index].isImportant == true ? '중요' : '안중요'}"),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}