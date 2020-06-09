import 'package:flutter/material.dart';

import './screens/HomeScreen.dart';

void main() => runApp(MyToDoListApp());

class MyToDoListApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo List',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Color.fromRGBO(243, 245, 249, 1),
        accentColor: Color.fromRGBO(56, 149, 249, 1),
        visualDensity: VisualDensity.adaptivePlatformDensity,
        fontFamily: 'OpenSans',
      ),
      initialRoute: HomeScreen.routeName,
      routes: {
        HomeScreen.routeName: (ctx) => HomeScreen(),
      },
    );
  }
}
