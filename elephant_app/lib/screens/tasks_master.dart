import 'package:flutter/material.dart';
import 'package:provider/provider.dart' as provider;
import 'package:tp_flutter/models/task.dart';
import 'package:tp_flutter/providers/tasks_provider.dart';
import 'package:tp_flutter/screens/task_details.dart';
import 'package:shimmer/shimmer.dart';
import 'package:tp_flutter/screens/task_done.dart';
import 'package:tp_flutter/screens/task_form.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:tp_flutter/pageRoute.dart';

class TasksMaster extends StatefulWidget {
  const TasksMaster({super.key});

  @override
  State<TasksMaster> createState() => _TasksMasterState();
}

class _TasksMasterState extends State<TasksMaster> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text("Elephant")),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(PersonalizedRoute(
                nextPage: const TaskDone(),
                duration: 750,
                begin: Offset(1, 0),
                end: Offset.zero,
              ).next());
            },
            icon: const Icon(
              Icons.task_alt_outlined,
              color: Colors.white,
            ),
          ),
        ],
        leading: IconButton(
            onPressed: () {},
            icon: Image.asset(
              "assets/logo_app_splash.png",
              width: 40,
            )),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
              PersonalizedRoute(nextPage: const TaskForm(), duration: 750)
                  .next());
        },
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add),
      ),
      body: FutureBuilder(
          future: provider.Provider.of<TasksProvider>(context, listen: false)
              .fetchTasks(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<Task> tasks = [];

              tasks = snapshot.data as List<Task>;

              tasks = tasks.where((element) => !element.completed).toList();

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
                return RefreshIndicator(
                  onRefresh: () async {
                    await provider.Provider.of<TasksProvider>(context,
                            listen: false)
                        .fetchTasks();
                  },
                  child: ListView.builder(
                      itemCount: tasks.length,
                      itemBuilder: (context, index) {
                        return Dismissible(
                          key: Key(tasks[index].id.toString()),
                          background: Container(
                            color: Colors.red,
                            alignment: Alignment.centerLeft,
                            padding: const EdgeInsets.only(left: 20),
                            child:
                                const Icon(Icons.delete, color: Colors.white),
                          ),
                          secondaryBackground: Container(
                            color: Colors.green,
                            alignment: Alignment.centerRight,
                            padding: const EdgeInsets.only(right: 20),
                            child: const Icon(Icons.check, color: Colors.white),
                          ),
                          onDismissed: (direction) {
                            if (direction == DismissDirection.startToEnd) {
                              provider.Provider.of<TasksProvider>(context,
                                      listen: false)
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
                                action: SnackBarAction(
                                  textColor: Colors.orange,
                                  label: "Undo",
                                  onPressed: () {
                                    provider.Provider.of<TasksProvider>(context,
                                            listen: false)
                                        .addTask(tasks[index]);
                                  },
                                ),
                              );

                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
                            } else {
                              provider.Provider.of<TasksProvider>(context,
                                      listen: false)
                                  .completeTask(tasks[index].id!);

                              var snackBar = SnackBar(
                                elevation: 0,
                                behavior: SnackBarBehavior.floating,
                                backgroundColor: Colors.transparent,
                                content: AwesomeSnackbarContent(
                                  title: "Task completed",
                                  message: "Task completed successfully",
                                  contentType: ContentType.success,
                                ),
                                action: SnackBarAction(
                                  textColor: Colors.green,
                                  label: "Undo",
                                  onPressed: () {
                                    provider.Provider.of<TasksProvider>(context,
                                            listen: false)
                                        .uncompleteTask(tasks[index].id!);
                                  },
                                ),
                              );

                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
                            }
                          },
                          child: TaskPreview(task: tasks[index]),
                        );
                      }),
                );
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

class TaskPreview extends StatefulWidget {
  const TaskPreview({super.key, required this.task});

  final Task task;

  @override
  State<TaskPreview> createState() => _TaskPreviewState();
}

class _TaskPreviewState extends State<TaskPreview> {
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
      onTap: () => Navigator.of(context).push(
        PersonalizedRoute(
          nextPage: TaskDetails(task: widget.task),
          duration: 750,
        ).next(),
      ),
    );
  }
}
