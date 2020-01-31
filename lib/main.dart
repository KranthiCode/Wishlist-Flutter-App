import 'package:flutter/material.dart';

import './app_screens/home.dart';

// TODO - add splash screen
class WishListApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Home(),
      theme: new ThemeData(
        primaryColor: Color.fromRGBO(194, 201, 214, 1.0),
        cardColor: Color.fromRGBO(194, 201, 214, 1.0),
        backgroundColor: Color.fromRGBO(194, 201, 214, 1.0),
        accentColor: Color.fromRGBO(194, 201, 214, 1.0),
        textTheme: TextTheme(
          button: TextStyle(color: Colors.white), // style of button text
          subhead: TextStyle(color: Colors.white), // style of input text
          title: TextStyle(color: Colors.white),
        ),
        inputDecorationTheme: InputDecorationTheme(
          labelStyle: TextStyle(color: Colors.white), // style for labels
        ),
      ),
    );
  }
}

void main() => runApp(WishListApp());
