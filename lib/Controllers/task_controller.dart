import 'package:get/get.dart';
import 'package:inter_repair_car/Models/Entities/Task.dart';
import 'package:inter_repair_car/Models/repositories/DatabaseHelper.dart';

class TaskController extends GetxController {
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  // Observable list of tasks
  var tasks = <Task>[].obs;

  // Fetch tasks by status from the database
  Future<void> fetchTasksByStatus(String status) async {
    final taskList = await _databaseHelper.getTasksByStatus(status);
    tasks.assignAll(taskList); // Update the observable list
  }

  // Add a new task
  Future<void> addTask(Task task) async {
    await _databaseHelper.insertTask(task);
    await fetchTasksByStatus(task.status); // Refresh the task list
  }

  // Update a task
  Future<void> updateTask(Task task) async {
    await _databaseHelper.updateTask(task);
    await fetchTasksByStatus(task.status); // Refresh the task list
  }

  // Delete a task
  Future<void> deleteTask(int id, String status) async {
    await _databaseHelper.deleteTask(id);
    await fetchTasksByStatus(status); // Refresh the task list
  }

  Future<void> markTaskAsCompleted(int taskId, String currentStatus) async {
    await _databaseHelper.updateTaskStatus(
      taskId,
      "completed",
      DateTime.now(),
    ); // Update status
    await fetchTasksByStatus(currentStatus); // Refresh the task list
  }
}
