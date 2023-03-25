import 'package:flutter/material.dart';
import 'package:tp_flutter/screens/tasks_master.dart';
import 'package:tp_flutter/theme_app.dart';

class ElephantApp extends StatefulWidget {
  @override
  State<ElephantApp> createState() => _ElephantAppState();
}

class _ElephantAppState extends State<ElephantApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: themeDataApp,
      home: const TasksMaster(),
    );
  }
}
