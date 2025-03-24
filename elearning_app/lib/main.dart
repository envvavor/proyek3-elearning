import 'package:flutter/material.dart';
import 'login_page.dart';
import 'home_page.dart';
import 'class_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Elearning SMKN 2 Indramayu',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => LoginPage(),
        '/home': (context) => HomePage(),
        '/class': (context) => ClassPage(),
      },
    );
  }
}