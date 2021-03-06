import 'package:flutter/material.dart';
import 'package:modern_crpytography/home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(fontFamily: 'Noto'),
      home: const HomePage(),
    );
  }
}
