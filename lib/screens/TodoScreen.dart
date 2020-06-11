import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/Todo.dart';
import '../providers/TodoProvider.dart';
import '../widgets/SubTaskDialog.dart';
import '../widgets/CustomSubTodoListTile.dart';

class TodoScreen extends StatefulWidget {
  static const routeName = '/todo';
  final Todo todoEntity;

  TodoScreen({this.todoEntity});

  @override
  _TodoScreenState createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  TextEditingController _titleController = TextEditingController();
  TextEditingController _priorityController = TextEditingController();
  TextEditingController _startDateController = TextEditingController();
  TextEditingController _endDateController = TextEditingController();
  TextEditingController _subTaskController = TextEditingController();
  bool isUpdate = false;
  bool isAlreadyUpdated = false;

  DateTime _pickedStartDate;
  DateTime _pickedEndDate;

  List<String> _priorities = ['Important', 'Urgent', 'Critical'];
  String _selectedPriority;

  _getStartDate(BuildContext ctx) async {
    FocusScope.of(ctx).requestFocus(new FocusNode());
    _pickedStartDate = await showDatePicker(
      context: ctx,
      initialDate: _pickedStartDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2050),
    );
    if (_startDateController.text == '' && _pickedStartDate == null) {
      Fluttertoast.showToast(msg: "Please select a Start Date!");
      return;
    }
    if (_startDateController.text != null && _pickedStartDate != null) {
      _startDateController.text =
          DateFormat('dd MMM, yyyy').format(_pickedStartDate) ??
              DateTime.now().toIso8601String();
    }
  }

  _getEndDate(BuildContext ctx) async {
    FocusScope.of(ctx).requestFocus(new FocusNode());
    _pickedEndDate = await showDatePicker(
      context: ctx,
      initialDate: _pickedEndDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2050),
    );
    if (_endDateController.text == '' && _pickedEndDate == null) {
      Fluttertoast.showToast(msg: "Please select an End Date!");
      return;
    }
    if (_pickedStartDate == null) {
      Fluttertoast.showToast(msg: "Please enter Start Date first.");
      return;
    }

    if (_endDateController.text != null && _pickedEndDate != null) {
      _endDateController.text =
          DateFormat('dd MMM, yyyy').format(_pickedEndDate) ??
              DateTime.now().toIso8601String();
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _priorityController.dispose();
    _startDateController.dispose();
    _endDateController.dispose();
    _subTaskController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.todoEntity != null) {
      if ((widget.todoEntity.id != null ||
              widget.todoEntity.title != null ||
              widget.todoEntity.priority != null ||
              widget.todoEntity.startDate != null ||
              widget.todoEntity.endDate != null) &&
          isAlreadyUpdated == false) {
        isUpdate = true;
        isAlreadyUpdated = true;
        _titleController.text = widget.todoEntity.title;
        _selectedPriority = getPriorityString(widget.todoEntity.priority.index);
        _startDateController.text = DateFormat('dd MMM, yyyy')
            .format(widget.todoEntity.startDate.toDate());
        _endDateController.text = DateFormat('dd MMM, yyyy')
            .format(widget.todoEntity.endDate.toDate());
      }
    }
    final user = Provider.of<FirebaseUser>(context);
    Size deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        title: Text(
          'Create Todo',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
          ),
        ),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(
                right: deviceSize.width * 0.04,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  FlatButton.icon(
                    icon: Icon(Icons.save),
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    label: Text(
                      'Save Task',
                      style: TextStyle(
                        fontSize: deviceSize.height * 0.025,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onPressed: (_titleController.text == '' ||
                            _startDateController.text == '' ||
                            _endDateController.text == '')
                        ? null
                        : () {
                            // print(isAlreadyUpdated);
                            if (isUpdate == true) {
                              TodoProvider.updateTodo(
                                context: context,
                                todoEntity: Todo(
                                  id: widget.todoEntity.id,
                                  title: _titleController.text,
                                  priority: Priority.values[
                                      getPriorityIndex(_selectedPriority)],
                                  startDate: Timestamp.fromDate(
                                      widget.todoEntity.startDate.toDate()),
                                  endDate: Timestamp.fromDate(
                                      widget.todoEntity.endDate.toDate()),
                                ),
                              );
                            } else {
                              TodoProvider.uploadTodo(
                                context: context,
                                todoEntity: Todo(
                                  title: _titleController.text,
                                  priority: Priority.values[
                                      getPriorityIndex(_selectedPriority)],
                                  startDate:
                                      Timestamp.fromDate(_pickedStartDate),
                                  endDate: Timestamp.fromDate(_pickedEndDate),
                                ),
                              );
                            }
                          },
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: deviceSize.width * 0.04,
                vertical: deviceSize.height * 0.02,
              ),
              child: ConstrainedBox(
                constraints: new BoxConstraints(
                  minHeight: 50,
                  maxHeight: 100,
                ),
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  reverse: true,
                  child: TextFormField(
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    controller: _titleController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Theme.of(context).accentColor,
                      hintText: "Todo Title*",
                    ),
                  ),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(
                horizontal: deviceSize.width * 0.04,
                vertical: deviceSize.height * 0.02,
              ),
              decoration: BoxDecoration(
                color: Theme.of(context).accentColor,
                borderRadius: BorderRadius.circular(5.0),
              ),
              child: Column(
                children: <Widget>[
                  DropdownButton<String>(
                    dropdownColor: Theme.of(context).accentColor,
                    isExpanded: true,
                    iconSize: deviceSize.height * 0.05,
                    underline: Container(width: 0, height: 0),
                    hint: Padding(
                      padding: EdgeInsets.only(
                        left: deviceSize.width * 0.03,
                      ),
                      child: Text("Add Priority"),
                    ),
                    value: _selectedPriority,
                    onChanged: (String value) {
                      setState(() {
                        _selectedPriority = value;
                      });
                    },
                    items: _priorities.map((String priority) {
                      return DropdownMenuItem<String>(
                        value: priority,
                        child: Padding(
                          padding: EdgeInsets.only(
                            left: deviceSize.width * 0.03,
                          ),
                          child: Text(
                            priority,
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  Divider(
                    height: 0,
                    thickness: 1,
                    color: Colors.black38,
                  ),
                ],
              ),
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: Container(
                    padding: EdgeInsets.only(
                      left: deviceSize.width * 0.04,
                      top: deviceSize.height * 0.02,
                      right: deviceSize.width * 0.02,
                      bottom: deviceSize.height * 0.02,
                    ),
                    child: TextFormField(
                      controller: _startDateController,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Theme.of(context).accentColor,
                        suffixIcon: Icon(Icons.date_range),
                        suffixIconConstraints:
                            BoxConstraints.tight(deviceSize * 0.07),
                        hintText: "Start Date*",
                      ),
                      onTap: () => _getStartDate(context),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.only(
                      left: deviceSize.width * 0.02,
                      top: deviceSize.height * 0.02,
                      right: deviceSize.width * 0.04,
                      bottom: deviceSize.height * 0.02,
                    ),
                    child: TextFormField(
                      controller: _endDateController,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Theme.of(context).accentColor,
                        suffixIcon: Icon(Icons.date_range),
                        suffixIconConstraints:
                            BoxConstraints.tight(deviceSize * 0.07),
                        hintText: "End Date*",
                      ),
                      onTap: () => _getEndDate(context),
                    ),
                  ),
                ),
              ],
            ),
            user != null && widget.todoEntity != null
                ? StreamBuilder<QuerySnapshot>(
                    stream: Firestore.instance
                        .collection('users')
                        .document(user.uid)
                        .collection('todos')
                        .where('id', isEqualTo: widget.todoEntity.id)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        // print(widget.id);
                        return Container(
                          margin: EdgeInsets.only(
                            top: deviceSize.height * 0.35,
                          ),
                          child: CircularProgressIndicator(
                            backgroundColor: Theme.of(context).primaryColor,
                          ),
                        );
                      }

                      DocumentSnapshot doc = snapshot.data.documents.firstWhere(
                          (d) => d.data['id'] == widget.todoEntity.id);
                      List<CustomSubTodoListTile> subTodoListTile = [];

                      if (doc.data['sub-todos'] == null) {
                        return Container(
                            // margin: EdgeInsets.only(
                            //   top: deviceSize.height * 0.35,
                            // ),
                            // child: Text(
                            //   "Oops! Your Todo List is Empty\nPress '+' Button to Add",
                            //   textAlign: TextAlign.center,
                            //   style: TextStyle(
                            //     fontSize: 18,
                            //     color: Colors.grey,
                            //   ),
                            // ),
                            );
                      }

                      List<SubTodo> subTodos = List.from(doc.data['sub-todos'])
                          .map(
                            (subTodo) => SubTodo(
                              id: subTodo['id'],
                              title: subTodo['title'],
                              endDate: subTodo['endDate'],
                              priority: Priority.values[
                                  int.parse(subTodo['priority'].toString())],
                              startDate: subTodo['startDate'],
                            ),
                          )
                          .toList();

                      subTodos.forEach((subTodo) {
                        subTodoListTile.add(
                          CustomSubTodoListTile(
                            todoId: widget.todoEntity.id,
                            subTodoEntity: SubTodo(
                              id: subTodo.id,
                              title: subTodo.title,
                              priority: subTodo.priority,
                              startDate: subTodo.startDate,
                              endDate: subTodo.endDate,
                            ),
                          ),
                        );
                      });

                      if (subTodos.isNotEmpty) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              margin: EdgeInsets.symmetric(
                                horizontal: deviceSize.width * 0.06,
                                vertical: deviceSize.height * 0.01,
                              ),
                              child: Text(
                                'SubTasks:',
                                style: TextStyle(
                                  fontSize: deviceSize.height * 0.025,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Column(
                              children: subTodoListTile,
                            ),
                          ],
                        );
                      }

                      return Column(
                        children: subTodoListTile,
                      );
                    },
                  )
                : Container(width: 0, height: 0),
            Container(
              margin: EdgeInsets.symmetric(
                horizontal: deviceSize.width * 0.04,
                vertical: deviceSize.height * 0.02,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  RaisedButton.icon(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    onPressed: () {
                      SubTaskDialog.subTaskDialog(
                        context: context,
                        subTodoEntity: SubTodo(
                          id: widget.todoEntity.id,
                          title: widget.todoEntity.title,
                          priority: widget.todoEntity.priority,
                          startDate: widget.todoEntity.startDate,
                          endDate: widget.todoEntity.endDate,
                        ),
                        height: deviceSize.height,
                        width: deviceSize.width,
                      );
                    },
                    icon: Icon(Icons.playlist_add_check),
                    color: Theme.of(context).accentColor,
                    label: Text(
                      'Add SubTask',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
