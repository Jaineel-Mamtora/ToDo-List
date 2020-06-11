import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import './TodoScreen.dart';
import '../models/Todo.dart';
import '../providers/FirebaseAuthenticationService.dart';
import '../widgets/CustomDrawer.dart';
import '../widgets/CustomTodoListTile.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = '/home';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final FirebaseAuthenticationService _auth = FirebaseAuthenticationService();
  bool priority;
  bool title;

  @override
  Widget build(BuildContext context) {
    Size deviceSize = MediaQuery.of(context).size;
    double statusBarHeight = MediaQuery.of(context).padding.top;
    final user = Provider.of<FirebaseUser>(context);
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      drawer: CustomDrawer(),
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
                                      priority: Priority.values[int.parse(
                                          doc.data['priority'].toString())],
                                      startDate: doc.data['startDate'],
                                      endDate: doc.data['endDate'],
                                    ),
                                  ),
                                );
                              });
                              if (todoListTile.isNotEmpty) {
                                return StreamBuilder<DocumentSnapshot>(
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
                                          backgroundColor:
                                              Theme.of(context).primaryColor,
                                        ),
                                      );
                                    }

                                    Map<String, dynamic> userData =
                                        snapshot.data.data;

                                    if (userData['sortByPriority'] == true &&
                                        userData['sortByDate'] == true) {
                                      todoListTile.sort(
                                        (a, b) => a.todoEntity.startDate
                                            .toDate()
                                            .compareTo(
                                              b.todoEntity.startDate.toDate(),
                                            ),
                                      );
                                      todoListTile.sort(
                                        (a, b) => a.todoEntity.priority.index
                                            .compareTo(
                                          b.todoEntity.priority.index,
                                        ),
                                      );
                                    } else if (userData['sortByPriority'] ==
                                        true) {
                                      todoListTile.sort(
                                        (a, b) => a.todoEntity.priority.index
                                            .compareTo(
                                          b.todoEntity.priority.index,
                                        ),
                                      );
                                    } else if (userData['sortByDate'] == true) {
                                      todoListTile.sort(
                                        (a, b) => a.todoEntity.startDate
                                            .toDate()
                                            .compareTo(
                                              b.todoEntity.startDate.toDate(),
                                            ),
                                      );
                                    }
                                    return Column(
                                      children: todoListTile,
                                    );
                                  },
                                );
                              }

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
                  onPressed: () => _scaffoldKey.currentState.openDrawer(),
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
                    // PopupMenuItem(
                    //   value: 2,
                    //   child: SwitchListTile(
                    //     title: const Text('Sort by Priority'),
                    //     value: sortByPriority,
                    //     onChanged: (bool value) {
                    //       setState(() {
                    //         print(sortByPriority);
                    //         sortByPriority = value;
                    //       });
                    //     },
                    //   ),
                    // ),
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
