import 'package:flutter/material.dart';
import 'view/Conversor.dart';
// import 'view/BolsaValores.dart';

void main() async {
  runApp(MaterialApp(
    home: const Conversor(),
    theme: ThemeData(hintColor: Colors.red, primaryColor: Colors.red),
  ));
}

