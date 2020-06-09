import 'package:flutter/material.dart';

import './screens/AuthScreen.dart';
import './screens/InitScreen.dart';
import './screens/HomeScreen.dart';

void main() => runApp(MyToDoListApp());

class MyToDoListApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo List',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        accentColor: Color.fromRGBO(243, 245, 249, 1),
        primaryColor: Color.fromRGBO(56, 149, 249, 1),
        visualDensity: VisualDensity.adaptivePlatformDensity,
        fontFamily: 'OpenSans',
      ),
      initialRoute: InitScreen.routeName,
      routes: {
        InitScreen.routeName: (ctx) => InitScreen(),
        AuthScreen.routeName: (ctx) => AuthScreen(),
        HomeScreen.routeName: (ctx) => HomeScreen(),
      },
    );
  }
}
