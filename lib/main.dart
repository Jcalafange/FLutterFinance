import 'package:flutter/material.dart';
import 'view/Conversor.dart';


void main() async {
  runApp(MaterialApp(
    home: const Conversor(),
    theme: ThemeData(hintColor: Colors.blue[200], primaryColor: Colors.blue[200]),
  ));
}

