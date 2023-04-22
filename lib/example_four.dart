import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ExampleFour extends StatefulWidget {
  const ExampleFour({super.key});

  @override
  State<ExampleFour> createState() => _ExampleFourState();
}

class _ExampleFourState extends State<ExampleFour> {
  var data;
  Future<void> getUserApi() async {
    final response =
        await http.get(Uri.parse('https://jsonplaceholder.typicode.com/users'));

    if (response.statusCode == 200) {
      data = jsonDecode(response.body.toString());
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Without Model API REQUEST'),
      ),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder(
              future: getUserApi(),
              initialData: null,
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Text('Loading');
                } else {
                  // return Text(data[0]['name'].toString());
                  return ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Card(
                        color: const Color.fromARGB(255, 203, 200, 189),
                        child: Column(
                          children: [
                            ResuableRow(
                                title: 'Name',
                                value: data[index]['name'].toString()),
                            ResuableRow(
                                title: 'UserName',
                                value: data[index]['username'].toString()),
                            ResuableRow(
                                title: 'Adress',
                                value: data[index]['address']['street']
                                    .toString()),
                            ResuableRow(
                              title: 'Geo',
                              value: data[index]['address']['geo']['lng']
                                  .toString(),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                }
              },
            ),
          )
        ],
      ),
    );
  }
}

class ResuableRow extends StatelessWidget {
  String title, value;
  ResuableRow({super.key, required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title),
          Text(value),
        ],
      ),
    );
  }
}
