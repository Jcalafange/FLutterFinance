import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

import '../styles/Cores.dart';
import '../components/DrawerComponent.dart';

const request =
    "https://api.hgbrasil.com/finance?format=json-cors&key=aca64e24";

class BolsaValores extends StatefulWidget {
  const BolsaValores({super.key});

  @override
  _BolsaValoresState createState() => _BolsaValoresState();
}

class _BolsaValoresState extends State<BolsaValores> {
  double selic = 0;
  double cdi = 0;

  Future<Map> getData() async {
    http.Response response = await http.get(Uri.parse(request));

    selic = json.decode(response.body)['results']['taxes'][0]['selic'];
    cdi = json.decode(response.body)['results']['taxes'][0]['cdi'];

    return json.decode(response.body);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Cores.secondaryColor,
      drawer: Drawer(child: DrawerComponent()),
      appBar: AppBar(
        title: const Text("Bolsa de Valores"),
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
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        child: ListView.builder(
                          itemCount: snapshot.data!["results"]["stocks"].length,
                          itemBuilder: (context, index) {
                            // Get the key (source name) at the current index
                            final String sourceName = snapshot
                                .data!["results"]["stocks"].keys
                                .elementAt(index);
                            // Access the specific Bitcoin source data using the key
                            final Map<String, dynamic> bitcoinSource =
                                snapshot.data!["results"]["stocks"][sourceName];

                            final String name = bitcoinSource["name"];
                            final double points = bitcoinSource["points"];

                            return Card(
                              child: ListTile(
                                tileColor: Cores.tileColor,
                                title: Text(name, textAlign: TextAlign.center),
                                subtitle: Text('Pontos da bolsa: $points',
                                    textAlign: TextAlign.center),
                              ),
                            );
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    width: 150,
                                    height: 150,
                                    color: Cores.tileColor,
                                    child: Text(
                                      'informações sobre SELIC\n\n'
                                      '%$cdi',
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 24),
                                Expanded(
                                  child: Container(
                                    width: 150,
                                    height: 150,
                                    color: Cores.tileColor,
                                    child: Text(
                                      'informações sobre  CDI\n\n'
                                      '%$cdi\n\n',
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                }
            }
          }),
    );
  }
}
