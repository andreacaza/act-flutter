import 'dart:convert';

import 'package:act_flutter/models/producto.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Future<List<Producto>> _listadoProductos;

  Future<List<Producto>> getProductos() async {
    final response = await http
        .get(Uri.parse('https://api.alegra.com/api/v1/items'), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization':
          'Basic YXNjYXphQHV0cGwuZWR1LmVjOmUzMGRlZTBkMTMxZGViODhmNzhl',
    });
    List<Producto> productos = [];
    if (response.statusCode == 200) {
      String body = utf8.decode(response.bodyBytes);
      final jsonData = jsonDecode(body);
      for (var item in jsonData) {
        productos
            .add(Producto(item["id"], item["name"], item["price"][0]["price"]));
      }

      return productos;
    } else {
      throw Exception("Falló la conexión");
    }
  }

  @override
  void initState() {
    super.initState();
    _listadoProductos = getProductos();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Actividad flutter Andrea Caza',
      home: Scaffold(
          appBar: AppBar(
            title: Text('Actividad flutter Andrea Caza'),
          ),
          body: FutureBuilder(
              future: _listadoProductos,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ListView(children: _listaProductos(snapshot.data));
                } else if (snapshot.hasError) {
                  return Text("Error al consultar el API");
                }
                return Center(child: CircularProgressIndicator());
              })),
    );
  }

  List<Widget> _listaProductos(data) {
    List<Widget> productos = [];
    for (var item in data) {
      productos.add(Card(
          child: Column(
        children: [
          Row(
            children: [
              Text("Producto: ", style: TextStyle(fontWeight: FontWeight.bold)),
              Text(item.name)
            ],
          ),
          Row(
            children: [
              Text("Precio: \$", style: TextStyle(fontWeight: FontWeight.bold)),
              Text(item.price)
            ],
          ),
        ],
      )));
    }
    return productos;
  }
}
