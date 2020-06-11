import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import './TodoScreen.dart';
import '../models/Todo.dart';
import '../providers/FirebaseAuthenticationService.dart';
import '../widgets/CustomTodoListTile.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = '/home';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirebaseAuthenticationService _auth = FirebaseAuthenticationService();

  @override
  Widget build(BuildContext context) {
    Size deviceSize = MediaQuery.of(context).size;
    double statusBarHeight = MediaQuery.of(context).padding.top;
    final user = Provider.of<FirebaseUser>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        margin: EdgeInsets.only(top: statusBarHeight * 1.1),
        height: double.maxFinite,
        decoration: BoxDecoration(
          color: Theme.of(context).accentColor,
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Column(
          children: <Widget>[
            Expanded(
              child: user != null
                  ? SingleChildScrollView(
                      child: Column(
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Container(
                                margin: EdgeInsets.symmetric(
                                  horizontal: deviceSize.width * 0.04,
                                  vertical: deviceSize.height * 0.02,
                                ),
                                child: Text(
                                  'All Todo',
                                  style: TextStyle(
                                    fontSize: deviceSize.height * 0.03,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          // CustomTodoListTile(),
                          StreamBuilder<QuerySnapshot>(
                            stream: Firestore.instance
                                .collection('users')
                                .document(user.uid)
                                .collection('todos')
                                .snapshots(),
                            builder: (context, snapshot) {
                              if (!snapshot.hasData) {
                                return Container(
                                  margin: EdgeInsets.only(
                                    top: deviceSize.height * 0.35,
                                  ),
                                  child: CircularProgressIndicator(
                                    backgroundColor:
                                        Theme.of(context).primaryColor,
                                  ),
                                );
                              }

                              List<DocumentSnapshot> docs =
                                  snapshot.data.documents;
                              List<CustomTodoListTile> todoListTile = [];

                              docs.forEach((doc) {
                                todoListTile.add(
                                  CustomTodoListTile(
                                    todoEntity: Todo(
                                      id: doc.data['id'],
                                      title: doc.data['title'],
                                      priority: doc.data['priority'],
                                      startTime: doc.data['startTime'],
                                      endTime: doc.data['endTime'],
                                    ),
                                  ),
                                );
                              });

                              if (todoListTile.isEmpty) {
                                return Container(
                                  margin: EdgeInsets.only(
                                    top: deviceSize.height * 0.35,
                                  ),
                                  child: Text(
                                    "Oops! Your Todo List is Empty\nPress '+' Button to Add",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.grey,
                                    ),
                                  ),
                                );
                              }

                              return Column(
                                children: todoListTile,
                              );
                            },
                          )
                        ],
                      ),
                    )
                  : Container(),
            ),
            Container(
              height: deviceSize.height * 0.065,
              color: Colors.white,
              child: ListTile(
                leading: IconButton(
                  icon: Icon(Icons.menu),
                  onPressed: () {},
                ),
                trailing: PopupMenuButton(
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: 1,
                      child: FlatButton(
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        visualDensity: VisualDensity.compact,
                        child: Text('SignOut'),
                        onPressed: () async {
                          _auth.signOut(context);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColor,
        onPressed: () {
          Navigator.of(context).pushNamed(TodoScreen.routeName);
        },
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        child: Icon(
          Icons.add,
          size: deviceSize.height * 0.04,
          color: Theme.of(context).accentColor,
        ),
      ),
    );
  }
}
