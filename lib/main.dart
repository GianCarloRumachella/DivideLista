import 'package:app_divide_lista/Home.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    home: Home(),
    theme: ThemeData(
      primaryColor: Colors.blueGrey[800],
      accentColor: Colors.white,
    ),
    debugShowCheckedModeBanner: false,
  ));
}
