import 'package:flutter/material.dart';

import './CustomTodoListTile.dart';
import '../models/User.dart';

class TodoSearch extends SearchDelegate<String> {
  final BuildContext ctx;
  final User user;
  final List<CustomTodoListTile> todoList;
  final List<String> titles;

  TodoSearch({
    this.ctx,
    this.user,
    this.todoList,
    this.titles,
  });

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestionList = query.isEmpty
        ? titles
        : titles
            .where((item) => item.toLowerCase().startsWith(query.toLowerCase()))
            .toList();
    return (suggestionList == null)
        ? Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Text(
                "No Todo(s) Found!",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 20,
                ),
              ),
            ),
          )
        : ListView.builder(
            itemBuilder: (context, index) {
              return todoList.singleWhere((todoListTile) =>
                  todoListTile.todoEntity.title == suggestionList[index]);
            },
            itemCount: suggestionList.length,
          );
  }

  @override
  Widget buildResults(BuildContext context) {
    throw UnimplementedError();
  }
}
