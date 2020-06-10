import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import './AuthScreen.dart';
import './HomeScreen.dart';

class InitScreen extends StatefulWidget {
  static const routeName = '/init';

  @override
  _InitScreenState createState() => _InitScreenState();
}

class _InitScreenState extends State<InitScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _redirect;
  String _redirectURL;

  Future<bool> _checkAuthStatus(BuildContext ctx) async {
    try {
      FirebaseUser currentUser = await FirebaseAuth.instance.currentUser();
      if (currentUser == null) {
        _redirect = true;
        _redirectURL = AuthScreen.routeName;
        return true;
      }

      print(currentUser.uid);

      _redirectURL = HomeScreen.routeName;
      _redirect = true;
      return true;
    } catch (err) {
      print(err);
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Container(
        color: Colors.white,
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'ToDo List',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 30),
            FutureBuilder<bool>(
              future: _checkAuthStatus(context),
              builder: (BuildContext c, AsyncSnapshot<bool> snapshot) {
                List<Widget> children = [];
                if (snapshot.hasData && snapshot.data) {
                  print("InitState Returned: ${snapshot.data}");
                  new Future.delayed(
                    Duration(milliseconds: 100),
                    () {
                      print("Redirect => $_redirect $_redirectURL");
                      Navigator.of(_scaffoldKey.currentContext)
                          .pushReplacementNamed(_redirectURL);
                    },
                  );
                  return Container();
                } else if (snapshot.hasError) {
                  print(snapshot.error);
                  Text(
                    "Authentication Error",
                    style: TextStyle(
                      fontFamily: 'OpenSans',
                      fontSize: 28,
                      fontWeight: FontWeight.w300,
                      color: Colors.white,
                    ),
                  );
                }
                print(children.isEmpty.toString());
                return Column(
                  children: children,
                );
              },
            ),
            CircularProgressIndicator(
              backgroundColor: Colors.white,
              valueColor: AlwaysStoppedAnimation(
                Theme.of(context).primaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
