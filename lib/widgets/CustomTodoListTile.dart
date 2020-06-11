import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../models/Todo.dart';
import '../providers/TodoProvider.dart';
import '../screens/TodoScreen.dart';

class CustomTodoListTile extends StatelessWidget {
  final Todo todoEntity;

  CustomTodoListTile({this.todoEntity});

  @override
  Widget build(BuildContext context) {
    Size deviceSize = MediaQuery.of(context).size;
    return Dismissible(
      key: ValueKey(todoEntity.id),
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
        TodoProvider.deleteTodo(todoEntity.id);
      },
      child: Container(
        margin: EdgeInsets.symmetric(
          horizontal: deviceSize.width * 0.04,
          vertical: deviceSize.height * 0.01,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: ListTile(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => TodoScreen(
                  todoEntity: Todo(
                    id: todoEntity.id,
                    title: todoEntity.title,
                    priority: todoEntity.priority,
                    startDate: todoEntity.startDate,
                    endDate: todoEntity.endDate,
                  ),
                ),
              ),
            );
          },
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Flexible(
                child: Text(
                  todoEntity.title,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  softWrap: false,
                ),
              ),
              IconButton(
                alignment: Alignment.center,
                padding: EdgeInsets.all(0),
                visualDensity: VisualDensity.compact,
                iconSize: 40,
                icon: Icon(
                  Icons.keyboard_arrow_right,
                ),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => TodoScreen(
                        todoEntity: Todo(
                          id: todoEntity.id,
                          title: todoEntity.title,
                          priority: todoEntity.priority,
                          startDate: todoEntity.startDate,
                          endDate: todoEntity.endDate,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
          subtitle: Row(
            children: <Widget>[
              Text(
                '${DateFormat('dd MMM, yyyy').format(todoEntity.startDate.toDate())} - ${DateFormat('dd MMM, yyyy').format(todoEntity.endDate.toDate())}',
                style: TextStyle(fontSize: 12),
              ),
              VerticalDivider(),
              Text(
                'Priority : ${todoEntity.priority}',
                style: TextStyle(fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
