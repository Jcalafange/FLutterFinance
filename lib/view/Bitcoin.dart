import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

import '../styles/Cores.dart';
import '../components/DrawerComponent.dart';

const request =
    "https://api.hgbrasil.com/finance?format=json-cors&key=aca64e24";

Future<Map> getData() async {
  http.Response response = await http.get(Uri.parse(request));
  return json.decode(response.body);
}

class Bitcoin extends StatefulWidget {
  const Bitcoin({super.key});

  @override
  _BitcoinState createState() => _BitcoinState();
}

class _BitcoinState extends State<Bitcoin> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Cores.secondaryColor,
      drawer: Drawer(child: DrawerComponent()),
      appBar: AppBar(
        title: Text("Bitcoin"),
        centerTitle: true,
        backgroundColor: Cores.primaryColor,
      ),
      body: FutureBuilder<Map>(
          future: getData(),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
              case ConnectionState.active:
              case ConnectionState.waiting:
                return const Center(
                    child: Text(
                  "Carregando dados...",
                  style: TextStyle(color: Cores.primaryColor, fontSize: 25.0),
                  textAlign: TextAlign.center,
                ));
              default:
                if (snapshot.hasError) {
                  return const Center(
                      child: Text(
                    "Erro ao carregar dados...",
                    style: TextStyle(color: Cores.primaryColor, fontSize: 25.0),
                    textAlign: TextAlign.center,
                  ));
                } else {
                  return ListView.builder(
                    itemCount: snapshot.data!["results"]["bitcoin"].length,
                    itemBuilder: (context, index) {
                      // Get the key (source name) at the current index
                      final String sourceName = snapshot
                          .data!["results"]["bitcoin"].keys
                          .elementAt(index);
                      // Access the specific Bitcoin source data using the key
                      final Map<String, dynamic> bitcoinSource =
                          snapshot.data!["results"]["bitcoin"][sourceName];

                      final String name = bitcoinSource["name"];
                      final double last = bitcoinSource["last"];
                      final String format = bitcoinSource["format"][0];

                      return Card(
                        child: ListTile(
                          tileColor: Cores.tileColor,
                          title: Text(name, textAlign: TextAlign.center),
                          subtitle: Text('Valor em $format: $last',
                              textAlign: TextAlign.center),
                        ),
                      );
                    },
                  );
                }
            }
          }),
    );
  }
}
