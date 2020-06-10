import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import './TodoScreen.dart';
import '../providers/Todo.dart';
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
                          StreamBuilder<DocumentSnapshot>(
                            stream: Firestore.instance
                                .collection('users')
                                .document(user.uid)
                                .snapshots(),
                            builder: (context, snapshot) {
                              if (!snapshot.hasData) {
                                return Container(
                                  child: Center(
                                    child: CircularProgressIndicator(
                                      backgroundColor:
                                          Theme.of(context).primaryColor,
                                    ),
                                  ),
                                );
                              }

                              DocumentSnapshot doc = snapshot.data;
                              List<CustomTodoListTile> todoListTile = [];

                              if (doc.data.isEmpty) {
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

                              List<Todo> todos = List.from(doc.data['todos'])
                                  .map(
                                    (todo) => Todo(
                                      title: todo['title'],
                                      endTime: todo['endTime'],
                                      priority: todo['priority'],
                                      startTime: todo['startTime'],
                                    ),
                                  )
                                  .toList();

                              todos.forEach((todo) {
                                todoListTile.add(
                                  CustomTodoListTile(
                                    title: todo.title,
                                    priority: todo.priority,
                                    startTime: todo.startTime,
                                    endTime: todo.endTime,
                                  ),
                                );
                              });

                              if (todoListTile.isEmpty) {
                                return Image.asset('assets/images/waiting.png');
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
