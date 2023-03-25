import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tp_flutter/models/task.dart';
import 'package:uuid/uuid.dart';
import 'package:tp_flutter/providers/tasks_provider.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';

final supabase = Supabase.instance.client;

class TaskForm extends StatefulWidget {
  const TaskForm({super.key});

  @override
  State<TaskForm> createState() => _TaskFormState();
}

class _TaskFormState extends State<TaskForm> {
  final _formKey = GlobalKey<FormState>();
  late String _title = "";
  late String _content = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create"),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Container(
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
                    _title = value!;
                  },
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
                    _content = value!;
                  },
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

                          int status = await context
                              .read<TasksProvider>()
                              .addTask(Task(
                                  id: const Uuid().v4(),
                                  title: _title,
                                  content: _content,
                                  completed: false));

                          if (status == 201) {
                            var snackBar = SnackBar(
                              elevation: 0,
                              behavior: SnackBarBehavior.floating,
                              backgroundColor: Colors.transparent,
                              content: AwesomeSnackbarContent(
                                title: "Task created",
                                message: "Your task has been created",
                                contentType: ContentType.success,
                              ),
                            );

                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                            Navigator.pop(context);
                          } else {
                            var snackBar = SnackBar(
                              elevation: 0,
                              behavior: SnackBarBehavior.floating,
                              backgroundColor: Colors.transparent,
                              content: AwesomeSnackbarContent(
                                title: "Error",
                                message: "An error has occured",
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
                        _title = "";
                        _content = "";
                        Navigator.pop(context);
                      },
                      child: const Text("Cancel"),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
