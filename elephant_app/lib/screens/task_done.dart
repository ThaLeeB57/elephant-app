import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:tp_flutter/models/task.dart';
import 'package:tp_flutter/providers/tasks_provider.dart';

class TaskDone extends StatefulWidget {
  const TaskDone({super.key});

  @override
  State<TaskDone> createState() => _TaskDoneState();
}

class _TaskDoneState extends State<TaskDone> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text("Tasks done")),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: FutureBuilder(
          future:
              Provider.of<TasksProvider>(context, listen: false).getCompleted(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List tasks = snapshot.data as List;

              if (tasks.isEmpty) {
                return Center(
                    child: SizedBox(
                  height: MediaQuery.of(context).size.height / 2,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Image.asset(
                        "assets/task_logo.png",
                        width: 250,
                        color: Colors.orange,
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        "No tasks yet !",
                        style: TextStyle(fontSize: 20, color: Colors.orange),
                      ),
                    ],
                  ),
                ));
              } else {
                return ListView.builder(
                    itemCount: tasks.length,
                    itemBuilder: (context, index) {
                      return Dismissible(
                        key: Key(tasks[index].id.toString()),
                        background: Container(
                          color: Colors.red,
                          alignment: Alignment.centerLeft,
                          padding: const EdgeInsets.only(left: 20),
                          child: const Icon(Icons.delete, color: Colors.white),
                        ),
                        secondaryBackground: Container(
                          color: Colors.green,
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 20),
                          child: const Icon(Icons.check, color: Colors.white),
                        ),
                        onDismissed: (direction) {
                          if (direction == DismissDirection.startToEnd) {
                            Provider.of<TasksProvider>(context, listen: false)
                                .deleteTask(tasks[index].id!);

                            var snackBar = SnackBar(
                              elevation: 0,
                              behavior: SnackBarBehavior.floating,
                              backgroundColor: Colors.transparent,
                              content: AwesomeSnackbarContent(
                                title: "Task deleted",
                                message: "Task deleted successfully",
                                contentType: ContentType.warning,
                              ),
                            );

                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                          } else {
                            Provider.of<TasksProvider>(context, listen: false)
                                .uncompleteTask(tasks[index].id!);

                            var snackBar = SnackBar(
                              elevation: 0,
                              behavior: SnackBarBehavior.floating,
                              backgroundColor: Colors.transparent,
                              content: AwesomeSnackbarContent(
                                title: "Task uncompleted",
                                message: "Task uncompleted successfully",
                                contentType: ContentType.success,
                              ),
                            );

                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                          }
                        },
                        child: TaskDonePreview(task: tasks[index]),
                      );
                    });
              }
            } else {
              return Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child: ListView.builder(
                      itemCount: 10,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Container(
                            color: Colors.white,
                            height: 20,
                          ),
                          subtitle: Container(
                            color: Colors.white,
                            height: 20,
                          ),
                          trailing: Container(
                            color: Colors.white,
                            height: 20,
                            width: 20,
                          ),
                        );
                      }));
            }
          }),
    );
  }
}

class TaskDonePreview extends StatefulWidget {
  const TaskDonePreview({super.key, required this.task});

  final Task task;

  @override
  State<TaskDonePreview> createState() => _TaskDonePreviewState();
}

class _TaskDonePreviewState extends State<TaskDonePreview> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        widget.task.title ?? "",
        style: Theme.of(context).textTheme.headlineMedium,
      ),
      subtitle: Text(
        widget.task.content,
        overflow: TextOverflow.ellipsis,
        style: Theme.of(context).textTheme.bodyMedium,
      ),
      trailing: Container(
        decoration: BoxDecoration(
          // color: Colors.orange,
          color: Theme.of(context).unselectedWidgetColor,
          borderRadius: BorderRadius.circular(5),
        ),
        padding: const EdgeInsets.all(5),
        child: const Text(
          "Pending",
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
