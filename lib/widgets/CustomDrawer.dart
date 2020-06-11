import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../providers/SortProvider.dart';

class CustomDrawer extends StatefulWidget {
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
              color: Colors.white,
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
                  Container(
                    margin: EdgeInsets.symmetric(
                      horizontal: deviceSize.width * 0.05,
                    ),
                    child: Text(
                      'Sorting',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  StreamBuilder<DocumentSnapshot>(
                    stream: Firestore.instance
                        .collection('users')
                        .document(user.uid)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return Container(
                          margin: EdgeInsets.only(
                            top: deviceSize.height * 0.35,
                          ),
                          child: CircularProgressIndicator(
                            backgroundColor: Theme.of(context).primaryColor,
                          ),
                        );
                      }
                      Map<String, dynamic> userData = snapshot.data.data;
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          SwitchListTile(
                            title: const Text('Sort by Priority'),
                            value: userData['sortByPriority'],
                            activeColor: Theme.of(context).primaryColor,
                            onChanged: (bool value) {
                              setState(() {
                                SortProvider.uploadSortByPriority(
                                    sortByPriority: value);
                              });
                            },
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(
                              horizontal: deviceSize.width * 0.05,
                            ),
                            child: Text(
                              'Sort by Date:',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          SwitchListTile(
                            title: const Text('Ascending'),
                            value: userData['sortByDateAscending'],
                            activeColor: Theme.of(context).primaryColor,
                            onChanged: (bool value) {
                              setState(() {
                                SortProvider.uploadSortByDateAscending(
                                    sortByDateAscending: value);
                              });
                            },
                          ),
                          SwitchListTile(
                            title: const Text('Descending'),
                            value: userData['sortByDateDescending'],
                            activeColor: Theme.of(context).primaryColor,
                            onChanged: (bool value) {
                              setState(() {
                                SortProvider.uploadSortByDateDescending(
                                    sortByDateDescending: value);
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
                        ],
                      );
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
