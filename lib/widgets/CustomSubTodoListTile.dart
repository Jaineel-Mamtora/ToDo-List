import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../providers/TodoProvider.dart';

class CustomSubTodoListTile extends StatelessWidget {
  final String todoId;
  final String id;
  final String title;
  final String priority;
  final Timestamp startTime;
  final Timestamp endTime;

  CustomSubTodoListTile({
    this.todoId,
    this.id,
    this.title,
    this.priority,
    this.startTime,
    this.endTime,
  });

  @override
  Widget build(BuildContext context) {
    Size deviceSize = MediaQuery.of(context).size;
    return Dismissible(
      key: ValueKey(id),
      background: Container(
        color: Colors.red,
        child: Icon(
          Icons.delete,
          color: Colors.white,
          size: 40,
        ),
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20),
        margin: EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 4,
        ),
      ),
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) {
        return showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text('Are you sure?'),
            content: Text(
              'Do you want to remove the Task?',
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('No'),
                onPressed: () {
                  Navigator.of(ctx).pop(false);
                },
              ),
              FlatButton(
                child: Text('Yes'),
                onPressed: () {
                  Navigator.of(ctx).pop(true);
                },
              ),
            ],
          ),
        );
      },
      onDismissed: (direction) {
        TodoProvider.deleteSubTodo(todoId, id);
      },
      child: Container(
        margin: EdgeInsets.symmetric(
          horizontal: deviceSize.width * 0.04,
          vertical: deviceSize.height * 0.01,
        ),
        decoration: BoxDecoration(
          color: Theme.of(context).accentColor,
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: ListTile(
          title: Text(
            title,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            softWrap: false,
          ),
          subtitle: Row(
            children: <Widget>[
              Text(
                '${DateFormat('dd MMM, yyyy').format(startTime.toDate())} - ${DateFormat('dd MMM, yyyy').format(endTime.toDate())}',
                style: TextStyle(fontSize: 12),
              ),
              VerticalDivider(),
              Text(
                'Priority : $priority',
                style: TextStyle(fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
