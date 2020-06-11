import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CustomDrawer extends StatefulWidget {
  static bool sortByPriority = false;
  static bool sortByTitle = false;

  @override
  _CustomDrawerState createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<FirebaseUser>(context);
    Size deviceSize = MediaQuery.of(context).size;
    return Drawer(
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.symmetric(
                      horizontal: deviceSize.width * 0.05,
                      vertical: deviceSize.height * 0.01,
                    ),
                    child: Text(
                      'Home',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(
                      horizontal: deviceSize.width * 0.05,
                    ),
                    child: Text(
                      '${user.email}',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(
                      horizontal: deviceSize.width * 0.03,
                    ),
                    child: Divider(
                      thickness: 1,
                    ),
                  ),
                  SwitchListTile(
                    title: const Text('Sort by Priority'),
                    value: CustomDrawer.sortByPriority,
                    activeColor: Theme.of(context).primaryColor,
                    onChanged: (bool value) {
                      setState(() {
                        CustomDrawer.sortByPriority = value;
                      });
                    },
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(
                      horizontal: deviceSize.width * 0.03,
                    ),
                    child: Divider(
                      thickness: 1,
                    ),
                  ),
                  SwitchListTile(
                    title: const Text('Sort by Priority'),
                    value: CustomDrawer.sortByTitle,
                    activeColor: Theme.of(context).primaryColor,
                    onChanged: (bool value) {
                      setState(() {
                        CustomDrawer.sortByTitle = value;
                      });
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
