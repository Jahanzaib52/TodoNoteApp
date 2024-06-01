import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_notes/task/task.dart';
import 'package:todo_notes/task/task_provider.dart';

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({super.key});

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  late String taskTitle;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          "Add Task",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.blue,
            fontSize: 20,
            fontWeight: FontWeight.bold,
            decoration: TextDecoration.underline,
            decorationColor: Colors.blue,
          ),
        ),
        TextFormField(
          textAlign: TextAlign.center,
          autofocus: true,
          onChanged: (value) {
            taskTitle = value;
          },
        ),
        ElevatedButton(
          style: const ButtonStyle(
            foregroundColor: MaterialStatePropertyAll<Color>(Colors.white),
            backgroundColor: MaterialStatePropertyAll<Color>(Colors.blue),
          ),
          onPressed: () {
            context.read<TaskProvider>().addTask(
                  Task(
                    user: "currentUser",
                    title: taskTitle,
                    dateTime: DateTime.now(),
                  ),
                );
            Navigator.pop(context);
          },
          child: const Text("ADD"),
        ),
      ],
    );
  }
}
