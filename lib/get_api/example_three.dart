import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/users_models.dart';



class ExampleThree extends StatefulWidget {
  const ExampleThree({super.key});

  @override
  State<ExampleThree> createState() => _ExampleThreeState();
}

class _ExampleThreeState extends State<ExampleThree> {
  List<UsersModel> usersList = [];

  Future<List<UsersModel>> getUserApi() async {
    final response =
        await http.get(Uri.parse('https://jsonplaceholder.typicode.com/users'));

    var data = jsonDecode(response.body.toString());

    if (response.statusCode == 200) {
      for (Map i in data) {
        usersList.add(UsersModel.fromJson(i));
      }
      return usersList;
    } else {
      return usersList;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Complex Api Data'),
      ),
      body: Column(children: [
        Expanded(
            child: FutureBuilder(
          future: getUserApi(),
          builder: (context, AsyncSnapshot<List<UsersModel>> snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
              return ListView.builder(
                itemCount: usersList.length,
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                itemBuilder: (context, index) {
                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          ResuableRow(
                            title: 'Name',
                            value: snapshot.data![index].name.toString(),
                          ),
                          ResuableRow(
                            title: 'UserName: ',
                            value: snapshot.data![index].username.toString(),
                          ),
                          ResuableRow(
                            title: 'Email: ',
                            value: snapshot.data![index].email.toString(),
                          ),
                          ResuableRow(
                            title: 'Address: ',
                            value:
                                snapshot.data![index].address!.city.toString(),
                          ),
                          ResuableRow(
                            title: 'Lat: ',
                            value: snapshot.data![index].address!.geo!.lat
                                .toString(),
                          ),
                          ResuableRow(
                            title: 'lng: ',
                            value: snapshot.data![index].address!.geo!.lng
                                .toString(),
                          ),
                          ResuableRow(
                            title: 'Company',
                            value:
                                snapshot.data![index].company!.name.toString(),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }
          },
        )),
      ]),
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
