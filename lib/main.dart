import 'package:dynamic_todo_widget/DynamicForm.dart';
import 'package:flutter/material.dart';

import 'DynamicForm.dart';
void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dynamic Form List',
      home:  DynamicForm(),
    );
  }
}
