import 'package:cloud_firestore/cloud_firestore.dart';

enum Priority { Important, Urgent, Critical }

String getPriorityString(int index) {
  Map<int, String> priorityMap = {
    0: 'Important',
    1: 'Urgent',
    2: 'Critical',
  };
  return priorityMap[index];
}

int getPriorityIndex(String priority) {
  Map<int, String> indexMap = {
    0: 'Important',
    1: 'Urgent',
    2: 'Critical',
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
