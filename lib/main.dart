import 'package:flutter/material.dart';

import './app_screens/home.dart';

// TODO - add splash screen
class WishListApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Home(),
      theme: new ThemeData(primaryColor: Color.fromRGBO(58, 66, 86, 1.0)),
    );
  }
}

void main() => runApp(WishListApp());
