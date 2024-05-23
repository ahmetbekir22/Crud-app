import 'package:flutter/material.dart';
import 'pages/home_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CRUD App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        textTheme: TextTheme(
          bodyLarge: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
          bodyMedium: TextStyle(fontSize: 14.0),
          labelLarge: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
        ),
      ),
      home: HomePage(),
    );
  }
}