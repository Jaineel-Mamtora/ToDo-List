import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CustomTodoListTile extends StatelessWidget {
  final String title;
  final String priority;
  final Timestamp startTime;
  final Timestamp endTime;

  CustomTodoListTile({
    this.title,
    this.priority,
    this.startTime,
    this.endTime,
  });

  @override
  Widget build(BuildContext context) {
    Size deviceSize = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: deviceSize.width * 0.04,
        vertical: deviceSize.height * 0.01,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: ListTile(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(title),
            IconButton(
              alignment: Alignment.center,
              padding: EdgeInsets.all(0),
              visualDensity: VisualDensity.compact,
              iconSize: 40,
              icon: Icon(
                Icons.keyboard_arrow_down,
              ),
              onPressed: () {},
            ),
          ],
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
    );
  }
}
