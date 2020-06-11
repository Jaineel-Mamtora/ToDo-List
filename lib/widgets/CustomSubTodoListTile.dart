import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../models/Todo.dart';
import '../providers/TodoProvider.dart';

class CustomSubTodoListTile extends StatelessWidget {
  final String todoId;
  final SubTodo subTodoEntity;

  CustomSubTodoListTile({this.todoId, this.subTodoEntity});

  Future<void> showSubTaskDetailsDialog({
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
          title: Text('Subtask Details'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('Subtask Title :'),
                Divider(
                  height: 10,
                ),
                Text(
                  '${subTodoEntity.title}',
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
                Divider(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text('Subtask Priority :'),
                    Text('${getPriorityString(subTodoEntity.priority.index)}'),
                  ],
                ),
                Divider(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text('Start Date :'),
                    Text(
                        '${DateFormat('dd MMM, yyyy').format(subTodoEntity.startDate.toDate())}'),
                  ],
                ),
                Divider(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text('End Date :'),
                    Text(
                        '${DateFormat('dd MMM, yyyy').format(subTodoEntity.endDate.toDate())}'),
                  ],
                ),
              ],
            ),
          ),
          actions: <Widget>[
            RaisedButton(
              color: Theme.of(context).primaryColor,
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Size deviceSize = MediaQuery.of(context).size;
    return Dismissible(
      key: ValueKey(subTodoEntity.id),
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
              RaisedButton(
                color: Theme.of(context).primaryColor,
                child: Text('No'),
                onPressed: () {
                  Navigator.of(ctx).pop(false);
                },
              ),
              RaisedButton(
                color: Theme.of(context).primaryColor,
                child: Text('Yes'),
                onPressed: () {
                  Fluttertoast.showToast(
                    msg: 'Task deleted successfully!',
                    backgroundColor: Colors.green,
                    textColor: Colors.white,
                  );
                  Navigator.of(ctx).pop(true);
                },
              ),
            ],
          ),
        );
      },
      onDismissed: (direction) {
        TodoProvider.deleteSubTodo(todoId, subTodoEntity.id);
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
          onTap: () {
            showSubTaskDetailsDialog(
              context: context,
              height: deviceSize.height,
              width: deviceSize.width,
              subTodoEntity: subTodoEntity,
            );
          },
          title: Text(
            subTodoEntity.title,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            softWrap: false,
          ),
          subtitle: Row(
            children: <Widget>[
              Text(
                '${DateFormat('dd MMM, yyyy').format(subTodoEntity.startDate.toDate())} - ${DateFormat('dd MMM, yyyy').format(subTodoEntity.endDate.toDate())}',
                style: TextStyle(fontSize: 12),
              ),
              VerticalDivider(),
              Text(
                'Priority : ${getPriorityString(subTodoEntity.priority.index)}',
                style: TextStyle(fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
