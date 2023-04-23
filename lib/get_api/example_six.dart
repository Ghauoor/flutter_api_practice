import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_apis_practice/models/todos_models.dart';

import 'package:http/http.dart' as http;

class ExampleSix extends StatefulWidget {
  const ExampleSix({super.key});

  @override
  State<ExampleSix> createState() => _ExampleSixState();
}

class _ExampleSixState extends State<ExampleSix> {
  List<TodosModel> todoList = [];

  Future<List<TodosModel>> get() async {
    final response =
        await http.get(Uri.parse('https://jsonplaceholder.typicode.com/todos'));

    var data = jsonDecode(response.body.toString());

    if (response.statusCode == 200) {
      todoList.clear();
      for (Map i in data) {
        todoList.add(TodosModel.fromJson(i));
      }
      return todoList;
    } else {
      return todoList;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo Api'),
      ),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder(
              future: get(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                    itemCount: todoList.length,
                    shrinkWrap: true,
                    physics: const ScrollPhysics(),
                    itemBuilder: (BuildContext context, int index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CheckboxListTile(
                          title: Text(todoList[index].title.toString()),
                          value:
                              todoList[index].completed == true ? true : false,
                          onChanged: (newValue) {
                            // Toggle the completed status of the item at the specified index
                            todoList[index].completed = newValue;
                          },
                          dense: true,
                          tileColor: const Color.fromARGB(255, 223, 209, 168),
                          tristate: true,
                        ),
                      );
                    },
                  );
                } else if (snapshot.hasError) {
                  return Text("${snapshot.error}");
                }
                return const Center(child: CircularProgressIndicator());
              },
            ),
          ),
        ],
      ),
    );
  }
}
