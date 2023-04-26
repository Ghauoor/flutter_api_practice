import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_apis_practice/models/store_products.dart';
import 'package:http/http.dart' as http;

class StoreExample extends StatefulWidget {
  const StoreExample({Key? key}) : super(key: key);

  @override
  State<StoreExample> createState() => _StoreExampleState();
}

class _StoreExampleState extends State<StoreExample> {
  List<StoreProducts> products = [];

  Future<List<StoreProducts>> get() async {
    final response =
        await http.get(Uri.parse('https://api.escuelajs.co/api/v1/products'));
    var data = jsonDecode(response.body.toString());

    if (response.statusCode == 200) {
      for (Map map in data) {
        products.add(StoreProducts.fromJson(map));
      }

      return products;
    } else {
      throw Exception('Failed to get products');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Online Store'),
      ),
      body: FutureBuilder(
        future: get(),
        builder: (BuildContext context,
            AsyncSnapshot<List<StoreProducts>> snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 8.0,
                mainAxisSpacing: 8.0,
              ),
              itemCount: products.length,
              itemBuilder: (BuildContext context, int index) {
                return Card(
                  elevation: 40,
                  shadowColor: const Color.fromARGB(255, 224, 146, 86),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        child: PageView.builder(
                          itemCount: products[index].images!.length,
                          itemBuilder: (BuildContext context, int imageIndex) {
                            return Image.network(
                              products[index].images![imageIndex],
                              fit: BoxFit.cover,
                            );
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          products[index].title.toString(),
                          style: const TextStyle(fontSize: 16.0),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 8.0,
                          right: 8.0,
                          bottom: 8.0,
                        ),
                        child: Text(
                          '\$${products[index].price}',
                          style: const TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
