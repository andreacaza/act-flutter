import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Future<Producto> futureProducts;

  @override
  void initState() {
    super.initState();
    futureProducts = getProducts() as Future<Producto>;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            appBar: AppBar(
              title: Text('Pagina principal de productos'),
            ),
            body: Center(
              child: FutureBuilder<Producto>(
                future: futureProducts,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Text(snapshot.data!.name);
                  } else if (snapshot.hasError) {
                    return Text('${snapshot.error}');
                  }

                  // By default, show a loading spinner.
                  return const CircularProgressIndicator();
                },
              ),
            )));
  }
}

Future<Producto> getProducts() async {
  final response = await http
      .get(Uri.parse('https://api.alegra.com/api/v1/items'), headers: {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    'Authorization':
        'Basic YXNjYXphQHV0cGwuZWR1LmVjOmUzMGRlZTBkMTMxZGViODhmNzhl',
  });

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return Producto.fromJson(jsonDecode(response.body));
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load album');
  }
}

Future<http.Response> getProduct(id) {
  return http
      .get(Uri.parse('https://api.alegra.com/api/v1/items/' + id), headers: {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    'Authorization':
        'Basic YXNjYXphQHV0cGwuZWR1LmVjOmUzMGRlZTBkMTMxZGViODhmNzhl',
  });
}

Future<http.Response> saveProduct(product) {
  return http.post(
    Uri.parse('https://api.alegra.com/api/v1/items'),
    headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization':
          'Basic YXNjYXphQHV0cGwuZWR1LmVjOmUzMGRlZTBkMTMxZGViODhmNzhl',
    },
    body: product,
  );
}

Future<http.Response> updateProduct(id, product) {
  return http.put(
    Uri.parse('https://api.alegra.com/api/v1/items/' + id),
    headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization':
          'Basic YXNjYXphQHV0cGwuZWR1LmVjOmUzMGRlZTBkMTMxZGViODhmNzhl',
    },
    body: product,
  );
}

Future<http.Response> deleteProduct(id) {
  return http
      .delete(Uri.parse('https://api.alegra.com/api/v1/items/' + id), headers: {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    'Authorization':
        'Basic YXNjYXphQHV0cGwuZWR1LmVjOmUzMGRlZTBkMTMxZGViODhmNzhl',
  });
}

// DetalleProducto que contiene datos para mostrar
class Producto {
  final int id;
  final String name;
  final String description;
  final String reference;

  Producto({
    required this.id,
    required this.name,
    required this.description,
    required this.reference,
  });

  factory Producto.fromJson(Map<String, dynamic> json) {
    return Producto(
      id: json['id'],
      name: json['name'],
      description: json['title'],
      reference: json['reference'],
    );
  }
}
