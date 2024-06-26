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

class Conversor extends StatefulWidget {
  const Conversor({super.key});

  @override
  _ConversorState createState() => _ConversorState();
}

class _ConversorState extends State<Conversor> {
  final dolarController = TextEditingController();
  final euroController = TextEditingController();
  final realController = TextEditingController();
  final bitcoinController = TextEditingController();

  double dolar = 0;
  double euro = 0;
  double bitcoin = 0;

  void _realChange(String text) {
    if (text.isEmpty) {
      _clearAll();
      return;
    }
    double real = double.parse(text);
    dolarController.text = (real / dolar).toStringAsFixed(2);
    euroController.text = (real / euro).toStringAsFixed(2);
    bitcoinController.text = (euro * this.euro / bitcoin).toStringAsFixed(10);
  }

  void _dolarChange(String text) {
    if (text.isEmpty) {
      _clearAll();
      return;
    }
    double dolar = double.parse(text);
    realController.text = (dolar * this.dolar).toStringAsFixed(2);
    euroController.text = (dolar * this.dolar / euro).toStringAsFixed(2);
    bitcoinController.text = (euro * this.euro / bitcoin).toStringAsFixed(10);
  }

  void _euroChange(String text) {
    if (text.isEmpty) {
      _clearAll();
      return;
    }
    double euro = double.parse(text);
    realController.text = (euro * this.euro).toStringAsFixed(2);
    dolarController.text = (euro * this.euro / dolar).toStringAsFixed(2);
    bitcoinController.text = (euro * this.euro / bitcoin).toStringAsFixed(10);
  }

    void _bitcoinChange(String text) {
    if (text.isEmpty) {
      _clearAll();
      return;
    }
    double bitcoin = double.parse(text);
    realController.text = (bitcoin * this.bitcoin).toStringAsFixed(2);
    dolarController.text = (bitcoin * this.bitcoin / dolar).toStringAsFixed(2);
    euroController.text = (bitcoin * this.bitcoin / euro).toStringAsFixed(2);
  }

  void _clearAll() {
    realController.text = "";
    dolarController.text = "";
    euroController.text = "";
    bitcoinController.text = "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: Drawer(child: DrawerComponent()),
        backgroundColor: Cores.secondaryColor,
        appBar: AppBar(
            title: const Text("Conversor de Moedas"),
            centerTitle: true,
            backgroundColor: Cores.primaryColor,),
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
                    dolar =
                    snapshot.data!["results"]["currencies"]["USD"]["buy"];
                    euro =
                    snapshot.data!["results"]["currencies"]["EUR"]["buy"];
                    bitcoin =
                    snapshot.data!["results"]["currencies"]["BTC"]["buy"];

                    return SingleChildScrollView(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          const Icon(Icons.monetization_on,
                              size: 150.0, color: Cores.primaryColor),
                          buildTextFormField(
                              "Reais", "R\$", realController, _realChange),
                          const Divider(),
                          buildTextFormField(
                              "Dólar", "US\$", dolarController, _dolarChange),
                          const Divider(),
                          buildTextFormField(
                              "Euro", "EUR", euroController, _euroChange),
                          const Divider(),
                          buildTextFormField(
                          "Bitcoin", "BTC", bitcoinController, _bitcoinChange),
                        ],
                      ),
                    );
                  }
              }
            }));
  }

  Widget buildTextFormField(String label, String prefix,
      TextEditingController controller, Function f) {
    return TextField(
      onChanged: (value) => f(value),
      controller: controller,
      decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Cores.primaryColor),
          border: const OutlineInputBorder(),
          prefixText: "$prefix "),
      style: const TextStyle(color: Cores.primaryColor, fontSize: 25.0),
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
    );
  }
}