import 'package:flutter/material.dart';

class Task extends ChangeNotifier {
  String? title;
  bool completed;

  Task({
    this.title,
    this.completed = false,
  });

  Task.fromMap(Map<String, dynamic> map)
      : title = map['title'],
        completed = map['completed'];

  updateTitle(title) {
    this.title = title;
  }

  Map toMap() {
    return {
      'title': title,
      'completed': completed,
    };
  }
}
