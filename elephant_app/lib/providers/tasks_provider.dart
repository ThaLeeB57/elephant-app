import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tp_flutter/models/task.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final supabase = Supabase.instance.client;

class TasksProvider extends ChangeNotifier {
  List<Task> _tasks = [];

  List<Task> get tasks => _tasks;

  Future<void> init() async {
    final response = await supabase.from("tasks").select("*");
    _tasks = response.map((task) => Task.fromJson(task)).toList().cast<Task>();
    notifyListeners();
  }

  Future<List<Task>> fetchTasks() async {
    final response = await supabase.from("tasks").select("*");
    _tasks = response.map((task) => Task.fromJson(task)).toList().cast<Task>();
    notifyListeners();
    return _tasks;
  }

  Future<int> addTask(Task task) async {
    final response =
        await supabase.from("tasks").insert(task.toJson()).execute();
    if (response.status == 201) {
      _tasks.add(task);
      notifyListeners();
    }

    return response.status;
  }

  Future<int> updateTask(Task task) async {
    final response = await supabase
        .from("tasks")
        .update(task.toJson())
        .eq("id", task.id)
        .execute();
    if (response.status == 204) {
      // final index = _tasks.indexWhere((element) => element.id == task.id);
      // _tasks[index] = task;
      _tasks.remove(_tasks.firstWhere((element) => element.id == task.id));
      _tasks.add(task);
      notifyListeners();
    }

    return response.status;
  }

  Future<int> deleteTask(String id) async {
    final response =
        await supabase.from("tasks").delete().eq("id", id).execute();
    if (response.status == 204) {
      _tasks.remove(_tasks.firstWhere((element) => element.id == id));
      notifyListeners();
    }

    return response.status;
  }

  Future<List<Task>> getCompleted() async {
    final response =
        await supabase.from("tasks").select().eq("completed", true).execute();
    List<Task> completedTasks = [];
    for (var task in response.data) {
      completedTasks.add(Task.fromJson(task));
    }
    return completedTasks;
  }

  Future<int> completeTask(String id) async {
    final response = await supabase
        .from("tasks")
        .update({"completed": true})
        .eq("id", id)
        .execute();
    if (response.status == 204) {
      final index = _tasks.indexWhere((element) => element.id == id);
      _tasks[index].completed = true;
      notifyListeners();
    }

    return response.status;
  }

  Future<int> uncompleteTask(String id) async {
    final response = await supabase
        .from("tasks")
        .update({"completed": false})
        .eq("id", id)
        .execute();
    if (response.status == 204) {
      final index = _tasks.indexWhere((element) => element.id == id);
      _tasks[index].completed = false;
      notifyListeners();
    }

    return response.status;
  }
}
