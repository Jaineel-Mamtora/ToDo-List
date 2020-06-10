import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import './SubTaskDialogContent.dart';

class SubTaskDialog {
  static Future<void> subTaskDialog({
    BuildContext context,
    double height,
    double width,
    String id,
    String title,
    String priority,
    Timestamp startTime,
    Timestamp endTime,
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
            id: id,
            title: title,
            priority: priority,
            startTime: startTime,
            endTime: endTime,
          ),
        );
      },
    );
  }
}
