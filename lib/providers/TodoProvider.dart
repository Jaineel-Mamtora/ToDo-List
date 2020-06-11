import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/Todo.dart';

class TodoProvider {
  static Future<void> uploadTodo({
    BuildContext context,
    Todo todoEntity,
  }) async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    CollectionReference todoCR = Firestore.instance
        .collection('users')
        .document(user.uid)
        .collection('todos');
    DocumentReference todoDR = todoCR.document();
    String todoDocId = todoDR.documentID;
    if (todoEntity.title.isEmpty ||
        todoEntity.priority.isEmpty ||
        todoEntity.startTime == null ||
        todoEntity.endTime == null) {
      Fluttertoast.showToast(msg: "Please enter all the details");
      return;
    }

    await todoCR.document(todoDocId).setData({
      'id': todoDocId,
      'title': todoEntity.title,
      'priority': todoEntity.priority,
      'startTime': todoEntity.startTime,
      'endTime': todoEntity.endTime,
    }, merge: true);

    Fluttertoast.showToast(msg: 'Saved Successfully!');
    Navigator.of(context).pop();
  }

  static Future<void> uploadAndUpdateSubTodo({
    BuildContext context,
    SubTodo subTodoEntity,
  }) async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    CollectionReference todoCR = Firestore.instance
        .collection('users')
        .document(user.uid)
        .collection('todos');
    DocumentReference todoDR = todoCR.document();
    String subtodoDocId = todoDR.documentID;
    if (subTodoEntity.title.isEmpty ||
        subTodoEntity.priority.isEmpty ||
        subTodoEntity.startTime == null ||
        subTodoEntity.endTime == null) {
      Fluttertoast.showToast(msg: "Please enter all the details");
      return;
    }
    List<SubTodo> subTodoList = [];

    DocumentSnapshot doc = await todoCR.document(subTodoEntity.id).get();

    if (doc.data['sub-todos'] != null && subTodoEntity.id != null) {
      // print(id);
      List<SubTodo> allSubTodos = List.from(doc.data['sub-todos'])
          .map(
            (subTodo) => SubTodo(
              id: subTodo['id'],
              title: subTodo['title'],
              priority: subTodo['priority'],
              startTime: subTodo['startTime'],
              endTime: subTodo['endTime'],
            ),
          )
          .toList();
      var st = allSubTodos
          .where((subTodo) => subTodo.id == subTodoEntity.id)
          .toList();
      if (st != null) {
        await todoCR.document(subTodoEntity.id).updateData({
          'sub-todos': FieldValue.arrayRemove(
              st.map((todoItem) => todoItem.toMap()).toList()),
        });
      }
    }

    SubTodo subTodo = SubTodo(
      id: subtodoDocId,
      title: subTodoEntity.title,
      priority: subTodoEntity.priority,
      startTime: subTodoEntity.startTime,
      endTime: subTodoEntity.endTime,
    );

    subTodoList.add(subTodo);

    await todoCR.document(subTodoEntity.id).updateData({
      'sub-todos': FieldValue.arrayUnion(
          subTodoList.map((subTodoItem) => subTodoItem.toMap()).toList()),
    });

    Fluttertoast.showToast(msg: 'Added Successfully!');
    Navigator.of(context).pop();
  }

  static Future<void> updateTodo({
    BuildContext context,
    Todo todoEntity,
  }) async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    CollectionReference todoCR = Firestore.instance
        .collection('users')
        .document(user.uid)
        .collection('todos');

    if (todoEntity.title.isEmpty ||
        todoEntity.priority.isEmpty ||
        todoEntity.startTime == null ||
        todoEntity.endTime == null) {
      Fluttertoast.showToast(msg: "Please enter all the details");
      return;
    }

    await todoCR.document(todoEntity.id).updateData({
      'title': todoEntity.title,
      'priority': todoEntity.priority,
      'startTime': todoEntity.startTime,
      'endTime': todoEntity.endTime,
    });
    Fluttertoast.showToast(msg: 'Updated Successfully!');
    Navigator.of(context).pop();
  }

  static Future<void> deleteTodo(String todoId) async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    CollectionReference todoCR = Firestore.instance
        .collection('users')
        .document(user.uid)
        .collection('todos');

    await todoCR.document(todoId).delete();
  }

  static Future<void> deleteSubTodo(String todoId, String subTodoId) async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    CollectionReference todoCR = Firestore.instance
        .collection('users')
        .document(user.uid)
        .collection('todos');
    var doc = await todoCR.document(todoId).get();

    if (doc.data['sub-todos'] != null && subTodoId != null) {
      // print(id);
      List<SubTodo> allSubTodos = List.from(doc.data['sub-todos'])
          .map(
            (subTodo) => SubTodo(
              id: subTodo['id'],
              title: subTodo['title'],
              priority: subTodo['priority'],
              startTime: subTodo['startTime'],
              endTime: subTodo['endTime'],
            ),
          )
          .toList();
      var st = allSubTodos.where((todo) => todo.id == subTodoId).toList();
      if (st != null) {
        await todoCR.document(todoId).updateData({
          'sub-todos': FieldValue.arrayRemove(
              st.map((todoItem) => todoItem.toMap()).toList()),
        });
      }
    }
  }
}
