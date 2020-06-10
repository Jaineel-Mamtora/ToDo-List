import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../providers/TodoProvider.dart';

class TodoScreen extends StatefulWidget {
  static const routeName = '/todo';
  final String id;
  final String title;
  final String priority;
  final Timestamp startTime;
  final Timestamp endTime;

  TodoScreen({
    this.id,
    this.title,
    this.priority,
    this.startTime,
    this.endTime,
  });

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

  List<String> _priorities = ['Critical', 'Urgent', 'Important'];
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
    if ((widget.id != null ||
            widget.title != null ||
            widget.priority != null ||
            widget.startTime != null ||
            widget.endTime != null) &&
        isAlreadyUpdated == false) {
      isUpdate = true;
      isAlreadyUpdated = true;
      _titleController.text = widget.title;
      _selectedPriority = widget.priority;
      _startDateController.text =
          DateFormat('dd MMM, yyyy').format(widget.startTime.toDate());
      _endDateController.text =
          DateFormat('dd MMM, yyyy').format(widget.endTime.toDate());
    }
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
                  FlatButton(
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    visualDensity: VisualDensity.compact,
                    child: Text(
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
                            if (isUpdate == true) {
                              TodoProvider.uploadTodo(
                                context: context,
                                id: widget.id,
                                title: _titleController.text,
                                priority: _selectedPriority,
                                startTime: Timestamp.fromDate(
                                    widget.startTime.toDate()),
                                endTime:
                                    Timestamp.fromDate(widget.endTime.toDate()),
                              );
                            } else {
                              TodoProvider.uploadTodo(
                                context: context,
                                title: _titleController.text,
                                priority: _selectedPriority,
                                startTime: Timestamp.fromDate(_pickedStartDate),
                                endTime: Timestamp.fromDate(_pickedEndDate),
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
              child: TextFormField(
                controller: _titleController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Theme.of(context).accentColor,
                  hintText: "Todo Title*",
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
          ],
        ),
      ),
    );
  }
}
