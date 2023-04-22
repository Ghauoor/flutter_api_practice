import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_apis_practice/models/photos_model.dart';
import 'package:http/http.dart' as http;

class ExampleTwo extends StatefulWidget {
  const ExampleTwo({super.key});

  @override
  State<ExampleTwo> createState() => _ExampleTwoState();
}

class _ExampleTwoState extends State<ExampleTwo> {
  List<PhotosModel> photos = [];

  Future<List<PhotosModel>> getPhotos() async {
    final response = await http
        .get(Uri.parse('https://jsonplaceholder.typicode.com/photos'));
    var data = jsonDecode(response.body.toString());

    if (response.statusCode == 200) {
      photos.clear();
      for (Map i in data) {
        PhotosModel photosModel =
            PhotosModel(title: i['title'], url: i['url'], id: i['id']);
        photos.add(photosModel);
      }
      return photos;
    } else {
      return photos;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Api Practice'),
      ),
      body: Column(children: [
        Expanded(
          child: FutureBuilder(
            future: getPhotos(),
            builder: (context, AsyncSnapshot<List<PhotosModel>> snapshot) {
              return ListView.builder(
                itemCount: photos.length,
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(snapshot.data![index].url),
                    ),
                    title: Text(snapshot.data![index].title.toString()),
                    subtitle: Text(snapshot.data![index].id.toString()),
                  );
                },
              );
            },
          ),
        )
      ]),
    );
  }
}
