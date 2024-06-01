import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_notes/task/add_task.dart';
import 'package:todo_notes/task/task.dart';
import 'package:todo_notes/task/task_provider.dart';

class ToDoScreen extends StatefulWidget {
  const ToDoScreen({super.key});

  @override
  State<ToDoScreen> createState() => _ToDoScreenState();
}

class _ToDoScreenState extends State<ToDoScreen> {
  @override
  void initState() {
    super.initState();
    context.read<TaskProvider>().loadTask();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              SearchBar(
                elevation: const MaterialStatePropertyAll(0),
                leading: const Icon(Icons.search),
                backgroundColor:
                    MaterialStatePropertyAll(Colors.blueGrey.withOpacity(0.2)),
                hintText: "Search Todos...",
                trailing: [
                  ElevatedButton(
                    onPressed: () {},
                    child: const Text("Search",
                        style: TextStyle(color: Colors.blue)),
                  ),
                ],
              ),
              const SizedBox(
                height: 8,
              ),
              Expanded(
                child: Consumer<TaskProvider>(
                    builder: (context, taskProvider, child) {
                  return ListView.builder(
                    itemCount: taskProvider.tasks.length,
                    itemBuilder: (context, index) {
                      final Task task = taskProvider.tasks[index];
                      return GestureDetector(
                        onLongPress: () {
                          taskProvider.deleteTask(task.id!);
                        },
                        child: Card(
                          child: ListTile(
                            // leading: Visibility(
                            //   visible: true,
                            //   child: Checkbox(
                            //     value: toDelete,
                            //     onChanged: (state) {
                            //       //toDelete=true;
                            //     },
                            //   ),
                            // ),
                            leading: Text(
                              (taskProvider.tasks.indexOf(task) + 1).toString(),
                              style: const TextStyle(
                                fontSize: 18,
                              ),
                            ),
                            title: Text(
                              task.title,
                              maxLines: 1,
                              style: task.isDone == true
                                  ? const TextStyle(
                                      fontSize: 18,
                                      decoration: TextDecoration.lineThrough,
                                      overflow: TextOverflow.ellipsis,
                                      color: Colors.grey,
                                    )
                                  : const TextStyle(
                                      fontSize: 18,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                            ),
                            trailing: Checkbox(
                              activeColor: Colors.blue,
                              value: task.isDone,
                              onChanged: (state) {
                                taskProvider.updateisDone(task);
                              },
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        shape: const CircleBorder(),
        child: const Icon(
          Icons.add,
          size: 40,
        ),
        onPressed: () {
          showModalBottomSheet(
              context: context,
              builder: (context) {
                return const AddTaskScreen();
              });
        },
      ),
    );
  }
}
