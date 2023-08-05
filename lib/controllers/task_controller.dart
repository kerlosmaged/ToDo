import 'package:get/get.dart';
import 'package:todo_app/db/datab.dart';
import 'package:todo_app/models/task.dart';

class TaskController extends GetxController {
  final RxList<Task> taskList = <Task>[].obs;

  Future<int> addTask({required Task task}) {
    return DBHelp.insert(task);
  }

  Future<void> getTasks() async {
    final List<Map<String, dynamic>> tasks = await DBHelp.query();
    taskList.assignAll(tasks.map((data) => Task.fromJson(data)).toList());
  }

  void deleteTask(Task task) async {
    await DBHelp.delete(task);
    getTasks();
  }

  void markTaskCompleted(int id) async {
    await DBHelp.update(id);
    getTasks();
  }

  void deleteAllData() async {
    await DBHelp.delteAllTasks();
    getTasks();
  }
}
