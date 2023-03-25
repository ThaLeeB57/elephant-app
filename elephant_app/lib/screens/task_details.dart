import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:tp_flutter/models/task.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:provider/provider.dart';
import 'package:tp_flutter/pageRoute.dart';
import 'package:tp_flutter/providers/tasks_provider.dart';
import 'package:tp_flutter/screens/tasks_master.dart';

final supabase = Supabase.instance.client;

class TaskDetails extends StatefulWidget {
  TaskDetails({super.key, required this.task});

  late Task task;

  @override
  State<TaskDetails> createState() => _TaskDetailsState();
}

class _TaskDetailsState extends State<TaskDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Task Details"),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
          backgroundColor: Theme.of(context).primaryColor,
        ),
        body: Container(
          width: MediaQuery.of(context).size.width - 20,
          margin: const EdgeInsets.only(left: 10, right: 10),
          child: FormTask(task: widget.task),
        ));
  }
}

class FormTask extends StatefulWidget {
  FormTask({super.key, required this.task});

  late Task task;

  @override
  State<FormTask> createState() => _FormTaskState();
}

class _FormTaskState extends State<FormTask> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        margin: const EdgeInsets.all(10),
        width: MediaQuery.of(context).size.width - 20,
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.all(10),
                child: TextFormField(
                  decoration: const InputDecoration(
                    labelText: "Title",
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter some text';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    widget.task.title = value!;
                  },
                  initialValue: widget.task.title,
                  cursorColor: Theme.of(context).focusColor,
                ),
              ),
              Container(
                margin: const EdgeInsets.all(10),
                child: TextFormField(
                  decoration: const InputDecoration(
                    labelText: "Content",
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter some text';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    widget.task.content = value!;
                  },
                  initialValue: widget.task.content,
                  maxLines: 5,
                  cursorColor: Theme.of(context).focusColor,
                ),
              ),
              Container(
                margin: const EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();

                          Task task = Task(
                              id: widget.task.id,
                              title: widget.task.title ?? "",
                              content: widget.task.content,
                              completed: widget.task.completed);

                          int status = await context
                              .read<TasksProvider>()
                              .updateTask(task);

                          if (status == 204) {
                            var snackBar = SnackBar(
                              elevation: 0,
                              behavior: SnackBarBehavior.floating,
                              backgroundColor: Colors.transparent,
                              content: AwesomeSnackbarContent(
                                title: "Suceess",
                                message: "Task updated",
                                contentType: ContentType.help,
                              ),
                            );

                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                          } else {
                            var snackBar = SnackBar(
                              elevation: 0,
                              behavior: SnackBarBehavior.floating,
                              backgroundColor: Colors.transparent,
                              content: AwesomeSnackbarContent(
                                title: "Error",
                                message: "Error while updating task",
                                contentType: ContentType.failure,
                              ),
                            );

                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                          }
                        }
                      },
                      child: const Text("Save"),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text("Delete task"),
                              content: const Text(
                                  "Are you sure you want to delete this task?"),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text("Cancel"),
                                ),
                                TextButton(
                                  onPressed: () async {
                                    int status = await context
                                        .read<TasksProvider>()
                                        .deleteTask(widget.task.id!);

                                    if (status == 204) {
                                      var snackBar = SnackBar(
                                        elevation: 0,
                                        behavior: SnackBarBehavior.floating,
                                        backgroundColor: Colors.transparent,
                                        content: AwesomeSnackbarContent(
                                          title: "Success",
                                          message: "Task deleted",
                                          contentType: ContentType.warning,
                                        ),
                                      );

                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(snackBar);

                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const TasksMaster(),
                                        ),
                                      );
                                    } else {
                                      var snackBar = SnackBar(
                                        elevation: 0,
                                        behavior: SnackBarBehavior.floating,
                                        backgroundColor: Colors.transparent,
                                        content: AwesomeSnackbarContent(
                                          title: "Error",
                                          message: "Error while deleting task",
                                          contentType: ContentType.failure,
                                        ),
                                      );

                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(snackBar);
                                    }
                                  },
                                  child: const Text("Delete"),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      child: const Text("Delete"),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
