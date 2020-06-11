import 'package:cloud_firestore/cloud_firestore.dart';

class Todo {
  final String id;
  final String title;
  final String priority;
  final Timestamp startDate;
  final Timestamp endDate;

  Todo({
    this.id,
    this.title,
    this.priority,
    this.startDate,
    this.endDate,
  });

  Map<dynamic, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'priority': priority,
      'startDate': startDate,
      'endDate': endDate,
    };
  }
}

class SubTodo {
  final String id;
  final String title;
  final String priority;
  final Timestamp startDate;
  final Timestamp endDate;

  SubTodo({
    this.id,
    this.title,
    this.priority,
    this.startDate,
    this.endDate,
  });

  Map<dynamic, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'priority': priority,
      'startDate': startDate,
      'endDate': endDate,
    };
  }
}
