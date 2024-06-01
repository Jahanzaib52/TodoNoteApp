import 'package:flutter/material.dart';
import 'package:todo_notes/note/sql_helper.dart';
import 'package:todo_notes/task/task.dart';

class TaskProvider extends ChangeNotifier {
  List<Task> tasks = [];

  void addTask(Task task) async {
    await SQLHelper.createtTask(task).whenComplete(() => tasks.add(task));
    loadTask();
    //print(tasks);
    notifyListeners();
  }

  void loadTask() async {
    tasks = await SQLHelper.readTask().then(
      (list) => list
          .map(
            (task) => Task(
              id: task["id"],
              user: task["user"],
              title: task["title"],
              dateTime: DateTime.parse(task["dateTime"]),
              isDone: task["isDone"]==1?true:false,
            ),
          )
          .toList(),
    );
    notifyListeners();
  }

  // void deleteTask(Task task) {
  //   tasks.remove(task);
  //   notifyListeners();
  // }
  void deleteTask(int id) async{
    await SQLHelper.deleteTask(id).whenComplete(() => loadTask());
    notifyListeners();
  }

  void updateisDone(Task task) async{
    await SQLHelper.isDone(task).whenComplete(() => loadTask());
    //print(tasks);
    //task.toggleDone();
    notifyListeners();
  }
}
