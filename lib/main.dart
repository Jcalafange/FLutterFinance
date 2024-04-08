import 'package:flutter/material.dart';
import 'view/Conversor.dart';

void main() async {
  runApp(MaterialApp(
    home: const Conversor(),
    theme: ThemeData(hintColor: Color.fromARGB(255, 249, 249, 70), primaryColor: Colors.blue[200]),
  ));
}

