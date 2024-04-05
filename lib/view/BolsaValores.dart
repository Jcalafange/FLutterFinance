import 'package:flutter/material.dart';

import '../components/DrawerComponent.dart';

class BolsaValores extends StatefulWidget {
  const BolsaValores({super.key});

  @override
  _BolsaValoresState createState() => _BolsaValoresState();
}

class _BolsaValoresState extends State<BolsaValores> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[900],
      drawer: Drawer(child: DrawerComponent()),
      appBar: AppBar(
        title: Text("Bolsa de Valores"),
        centerTitle: true,
        backgroundColor: Colors.red[900],
      ),
    );
  }
}