import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import './Todo.dart';

class TodoProvider {
  static Future<void> uploadTodo({
    BuildContext context,
    String id,
    String title,
    String priority,
    Timestamp startTime,
    Timestamp endTime,
  }) async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    CollectionReference userCf = Firestore.instance.collection('users');
    DocumentReference userDf = userCf.document();
    String userDocId = userDf.documentID;
    List<Todo> todoList = [];
    if (title.isEmpty ||
        priority.isEmpty ||
        startTime == null ||
        endTime == null) {
      Fluttertoast.showToast(msg: "Please enter all the details");
      return;
    }

    var doc =
        await Firestore.instance.collection('users').document(user.uid).get();
    // print(doc.data['todos'] != null);
    // print(id != null);
    if (doc.data['todos'] != null && id != null) {
      print(id);
      List<Todo> allTodos = List.from(doc.data['todos'])
          .map(
            (todo) => Todo(
              id: todo['id'],
              title: todo['title'],
              priority: todo['priority'],
              startTime: todo['startTime'],
              endTime: todo['endTime'],
            ),
          )
          .toList();
      var t = allTodos.where((todo) => todo.id == id).toList();
      if (t != null) {
        // print('t != null : ${t[0].id}');
        await Firestore.instance
            .collection('users')
            .document(user.uid)
            .updateData({
          'todos': FieldValue.arrayRemove(
              t.map((todoItem) => todoItem.toMap()).toList()),
        });
      }
    }

    Todo todo = Todo(
      id: userDocId,
      title: title,
      priority: priority,
      startTime: startTime,
      endTime: endTime,
    );

    todoList.add(todo);

    await Firestore.instance.collection('users').document(user.uid).updateData({
      'todos': FieldValue.arrayUnion(
          todoList.map((todoItem) => todoItem.toMap()).toList()),
    });
    Fluttertoast.showToast(msg: 'Saved Successfully!');
    Navigator.of(context).pop();
  }

  static Future<void> deleteTodo(String id) async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    var doc =
        await Firestore.instance.collection('users').document(user.uid).get();
    if (doc.data['todos'] != null && id != null) {
      print('In deleteTodo : $id');
      List<Todo> allTodos = List.from(doc.data['todos'])
          .map(
            (todo) => Todo(
              id: todo['id'],
              title: todo['title'],
              priority: todo['priority'],
              startTime: todo['startTime'],
              endTime: todo['endTime'],
            ),
          )
          .toList();
      var t = allTodos.where((todo) => todo.id == id).toList();
      if (t != null) {
        await Firestore.instance
            .collection('users')
            .document(user.uid)
            .updateData({
          'todos': FieldValue.arrayRemove(
              t.map((todoItem) => todoItem.toMap()).toList()),
        });
      }
    }
  }
}
