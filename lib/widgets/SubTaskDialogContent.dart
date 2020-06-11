import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/Todo.dart';
import '../providers/TodoProvider.dart';

class SubTaskDialogContent extends StatefulWidget {
  final SubTodo subTodoEntity;

  SubTaskDialogContent({this.subTodoEntity});
  @override
  _SubTaskDialogContentState createState() => _SubTaskDialogContentState();
}

class _SubTaskDialogContentState extends State<SubTaskDialogContent> {
  TextEditingController _titleController = TextEditingController();
  TextEditingController _priorityController = TextEditingController();
  TextEditingController _startDateController = TextEditingController();
  TextEditingController _endDateController = TextEditingController();
  TextEditingController _subTaskController = TextEditingController();

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
    Size deviceSize = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.symmetric(vertical: deviceSize.height * 0.01),
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
                    hintText: "Subtask Title*",
                  ),
                ),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: deviceSize.height * 0.01),
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
                    child: Text("Add Subtask Priority"),
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
          Container(
            margin: EdgeInsets.symmetric(vertical: deviceSize.height * 0.01),
            child: TextFormField(
              controller: _startDateController,
              decoration: InputDecoration(
                filled: true,
                fillColor: Theme.of(context).accentColor,
                suffixIcon: Icon(Icons.date_range),
                suffixIconConstraints: BoxConstraints.tight(deviceSize * 0.07),
                hintText: "Start Date*",
              ),
              onTap: () => _getStartDate(context),
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: deviceSize.height * 0.01),
            child: TextFormField(
              controller: _endDateController,
              decoration: InputDecoration(
                filled: true,
                fillColor: Theme.of(context).accentColor,
                suffixIcon: Icon(Icons.date_range),
                suffixIconConstraints: BoxConstraints.tight(deviceSize * 0.07),
                hintText: "End Date*",
              ),
              onTap: () => _getEndDate(context),
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: deviceSize.height * 0.01),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                RaisedButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  color: Colors.blue,
                  child: Text(
                    'Cancel',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                RaisedButton(
                  child: Text(
                    'Save',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  color: Theme.of(context).primaryColor,
                  onPressed: (_titleController.text == '' ||
                          _startDateController.text == '' ||
                          _endDateController.text == '')
                      ? null
                      : () {
                          TodoProvider.uploadAndUpdateSubTodo(
                            context: context,
                            subTodoEntity: SubTodo(
                              id: widget.subTodoEntity.id,
                              title: _titleController.text,
                              priority: Priority
                                  .values[getPriorityIndex(_selectedPriority)],
                              startDate: Timestamp.fromDate(_pickedStartDate),
                              endDate: Timestamp.fromDate(_pickedEndDate),
                            ),
                          );
                        },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
