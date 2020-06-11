import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../models/Todo.dart';
import '../providers/TodoProvider.dart';

class CustomSubTodoListTile extends StatelessWidget {
  final String todoId;
  final SubTodo subTodoEntity;

  CustomSubTodoListTile({this.todoId, this.subTodoEntity});

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
                  Fluttertoast.showToast(msg: 'Task deleted successfully!');
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
          title: Text(
            subTodoEntity.title,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            softWrap: false,
          ),
          subtitle: Row(
            children: <Widget>[
              Text(
                '${DateFormat('dd MMM, yyyy').format(subTodoEntity.startTime.toDate())} - ${DateFormat('dd MMM, yyyy').format(subTodoEntity.endTime.toDate())}',
                style: TextStyle(fontSize: 12),
              ),
              VerticalDivider(),
              Text(
                'Priority : ${subTodoEntity.priority}',
                style: TextStyle(fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
