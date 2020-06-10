import 'package:cloud_firestore/cloud_firestore.dart';

class Todo {
  final String id;
  final String title;
  final String priority;
  final Timestamp startTime;
  final Timestamp endTime;

  Todo({
    this.id,
    this.title,
    this.priority,
    this.startTime,
    this.endTime,
  });

  Map<dynamic, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'priority': priority,
      'startTime': startTime,
      'endTime': endTime,
    };
  }
}
