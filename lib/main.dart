import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

import './screens/AuthScreen.dart';
import './screens/InitScreen.dart';
import './screens/HomeScreen.dart';
import './screens/TodoScreen.dart';

void main() => runApp(MyToDoListApp());

class MyToDoListApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        StreamProvider<FirebaseUser>.value(
          value: FirebaseAuth.instance.onAuthStateChanged,
        ),
      ],
      child: MaterialApp(
        title: 'Todo List',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: Color.fromRGBO(56, 149, 249, 1),
          accentColor: Color.fromRGBO(243, 245, 249, 1),
          visualDensity: VisualDensity.adaptivePlatformDensity,
          fontFamily: 'OpenSans',
        ),
        initialRoute: InitScreen.routeName,
        routes: {
          InitScreen.routeName: (ctx) => InitScreen(),
          AuthScreen.routeName: (ctx) => AuthScreen(),
          HomeScreen.routeName: (ctx) => HomeScreen(),
          TodoScreen.routeName: (ctx) => TodoScreen(),
        },
      ),
    );
  }
}
