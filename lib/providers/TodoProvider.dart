import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import './Todo.dart';

class TodoProvider {
  static Future<void> uploadTodo({
    String title,
    String priority,
    Timestamp startTime,
    Timestamp endTime,
  }) async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    List<Todo> todoList = [];
    if (title.isEmpty ||
        priority.isEmpty ||
        startTime == null ||
        endTime == null) {
      Fluttertoast.showToast(msg: "Please enter all the details");
      return;
    }

    Todo todo = Todo(
      title: title,
      priority: priority,
      startTime: startTime,
      endTime: endTime,
    );

    todoList.add(todo);
    print(todo.title);

    await Firestore.instance.collection('users').document(user.uid).updateData({
      'todos': FieldValue.arrayUnion(
          todoList.map((todoItem) => todoItem.toMap()).toList()),
    });
  }
}
