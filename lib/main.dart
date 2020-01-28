import 'package:flutter/material.dart';
import './app_screens/home.dart';
import './app_screens/add_wish.dart';

//TODO: add launch/splash screen
void main() => runApp(WishListApp());

class WishListApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Home(),
      routes: <String, WidgetBuilder>{
        '/AddWish': (context) => AddWish(),
      },
      theme: new ThemeData(primaryColor: Color.fromRGBO(58, 66, 86, 1.0)),
    );
  }
}
