import 'package:cloud_firestore/cloud_firestore.dart';

enum Priority { Critical, Urgent, Important }

String getPriorityString(int index) {
  Map<int, String> priorityMap = {
    0: 'Critical',
    1: 'Urgent',
    2: 'Important',
  };
  return priorityMap[index];
}

int getPriorityIndex(String priority) {
  Map<int, String> indexMap = {
    0: 'Critical',
    1: 'Urgent',
    2: 'Important',
  };
  int index = indexMap.keys
      .firstWhere((k) => indexMap[k] == priority, orElse: () => null);
  return index;
}

class Todo {
  final String id;
  final String title;
  final Priority priority;
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
      'priority': priority.index,
      'startDate': startDate,
      'endDate': endDate,
    };
  }
}

class SubTodo {
  final String id;
  final String title;
  final Priority priority;
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
      'priority': priority.index,
      'startDate': startDate,
      'endDate': endDate,
    };
  }
}
