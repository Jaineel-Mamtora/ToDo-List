import 'package:flutter/material.dart';

import './SubTaskDialogContent.dart';
import '../models/Todo.dart';

class SubTaskDialog {
  static Future<void> subTaskDialog({
    BuildContext context,
    double height,
    double width,
    SubTodo subTodoEntity,
  }) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          title: Text('Add Subtask'),
          content: SubTaskDialogContent(
            subTodoEntity: SubTodo(
              id: subTodoEntity.id,
              title: subTodoEntity.title,
              priority: subTodoEntity.priority,
              startTime: subTodoEntity.startTime,
              endTime: subTodoEntity.endTime,
            ),
          ),
        );
      },
    );
  }
}
