import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:inter_repair_car/Controllers/task_controller.dart';
import 'package:inter_repair_car/Controllers/task_update_controller.dart';
import 'package:inter_repair_car/Models/Entities/Task.dart';
import 'package:inter_repair_car/Models/Entities/vehicle.dart';
import 'package:inter_repair_car/Models/repositories/DatabaseHelper.dart';

final TaskUpdateController controller = TaskUpdateController();

class TypeTaskView extends StatefulWidget {
  final String typeTask;

  const TypeTaskView({super.key, required this.typeTask});

  @override
  _TypeTaskViewState createState() => _TypeTaskViewState();
}

class _TypeTaskViewState extends State<TypeTaskView> {
  final TextEditingController _searchController = TextEditingController();
  final TaskController _taskController = Get.put(
    TaskController(),
  ); // Initialize the controller

  @override
  void initState() {
    super.initState();
    _taskController.fetchTasksByStatus(
      widget.typeTask,
    ); // Fetch tasks by status
  }

  // Filter tasks based on search query
  void _filterTasks(String query) {
    setState(() {
      _taskController.tasks.value =
          _taskController.tasks
              .where(
                (task) => task.name.toLowerCase().contains(query.toLowerCase()),
              )
              .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.typeTask} Tasks"),
        backgroundColor: Colors.blueGrey[900],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.grey[900]!,
              Colors.grey[800]!.withValues(alpha: .6),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search Bar
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: TextField(
                controller: _searchController,
                onChanged: _filterTasks,
                decoration: InputDecoration(
                  hintText: "Search tasks...",
                  hintStyle: const TextStyle(color: Colors.white70),
                  prefixIcon: const Icon(Icons.search, color: Colors.white70),
                  filled: true,
                  fillColor: Colors.grey[800]!.withValues(alpha: .5),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: Colors.white.withValues(alpha: .3),
                      width: 1.0,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: Colors.white.withValues(alpha: .3),
                      width: 1.0,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: Colors.white.withValues(alpha: .5),
                      width: 1.5,
                    ),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 16,
                  ),
                ),
                style: const TextStyle(color: Colors.white),
              ),
            ),
            const Text(
              'Tasks',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Obx(() {
                if (_taskController.tasks.isEmpty) {
                  return const Center(child: Text("No tasks found"));
                }
                return ListView.builder(
                  itemCount: _taskController.tasks.length,
                  itemBuilder: (context, index) {
                    return _buildTaskCard(
                      context,
                      _taskController.tasks[index],
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to build task cards
  Widget _buildTaskCard(BuildContext context, Task task) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      color: Colors.blueGrey[800],
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title row with delete and edit icons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Task name
                Text(
                  task.name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                // Delete and edit icons
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.white),
                      onPressed: () {
                        _showEditBottomSheet(context, task);
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.white),
                      onPressed: () {
                        _confirmDelete(context, task);
                      },
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),
            // Task details
            _buildDetailItem('Status', task.status),
            // Add the vehicle name here
            if (task.vehicleId != null)
              FutureBuilder<Vehicle?>(
                future: DatabaseHelper().getVehicleById(task.vehicleId!),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return _buildDetailItem('Vehicle', 'Loading...');
                  }
                  if (snapshot.hasError || !snapshot.hasData) {
                    return _buildDetailItem('Vehicle', 'Unknown vehicle');
                  }
                  final vehicle = snapshot.data!;
                  return _buildDetailItem(
                    'Vehicle',
                    '${vehicle.make} ${vehicle.model}',
                  );
                },
              ),
            _buildDetailItem('Start Time', task.timeStart.toString()),
            if (task.timeEnd != null)
              _buildDetailItem('End Time', task.timeEnd.toString()),
            _buildDetailItem('Cost', '\$${task.cost.toStringAsFixed(2)}'),
            if (task.details != null)
              _buildDetailItem('Details', task.details!),
            // "Mark as Completed" button for ongoing tasks
            if (task.status == "onGoing") const SizedBox(height: 8),
            if (task.status == "onGoing")
              Align(
                alignment: Alignment.centerLeft,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    foregroundColor: Colors.white,
                    side: const BorderSide(color: Colors.white),
                  ),
                  onPressed: () {
                    _markAsCompleted(context, task);
                  },
                  child: const Text("Mark as Completed"),
                ),
              ),
          ],
        ),
      ),
    );
  }

  // Helper method to show the edit bottom sheet
  void _showEditBottomSheet(BuildContext context, Task task) {
    controller.nameController = TextEditingController(text: task.name);
    controller.costController = TextEditingController(
      text: task.cost.toString(),
    );
    controller.detailsController = TextEditingController(text: task.details);

    // Dropdown value for status
    String selectedStatus = task.status;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Container(
                color: Colors.blueGrey[800],
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: controller.taskUpdateKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Edit Task Details",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Task Name is required';
                          }
                          return null;
                        },
                        controller: controller.nameController,
                        decoration: const InputDecoration(
                          labelText: "Name",
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Status dropdown
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.white.withValues(alpha: .2),
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(3),
                            ),
                            child: DropdownButton<String>(
                              value: selectedStatus,
                              items: const [
                                DropdownMenuItem(
                                  value: "onGoing",
                                  child: Text("ONGOING"),
                                ),
                                DropdownMenuItem(
                                  value: "pending",
                                  child: Text("PENDING"),
                                ),
                                DropdownMenuItem(
                                  value: "completed",
                                  child: Text("COMPLETED"),
                                ),
                              ],
                              onChanged: (value) {
                                setState(() {
                                  selectedStatus = value!;
                                });
                              },
                              dropdownColor: Colors.blueGrey[800],
                              style: const TextStyle(color: Colors.white),
                              underline: Container(),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: TextFormField(
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Cost is required';
                                }
                                if (double.tryParse(value) == null) {
                                  return 'Enter valid number';
                                }
                                return null;
                              },
                              keyboardType: TextInputType.number,
                              controller: controller.costController,
                              decoration: const InputDecoration(
                                labelText: "Cost",
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: controller.detailsController,
                        decoration: const InputDecoration(
                          labelText: "Details",
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () async {
                          if (controller.taskUpdateKey.currentState!
                              .validate()) {
                            final updatedTask = Task(
                              id: task.id,
                              name: controller.nameController.text,
                              status: selectedStatus,
                              timeStart: task.timeStart,
                              timeEnd: task.timeEnd,
                              cost: double.parse(
                                controller.costController.text,
                              ),
                              details: controller.detailsController.text,
                              vehicleId: task.vehicleId,
                            );

                            // Update the task in the database
                            await _taskController.updateTask(updatedTask);

                            // Close the bottom sheet
                            Get.back();
                          }
                        },
                        child: const Text(
                          "Save Changes",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  // Helper method to build detail items
  Widget _buildDetailItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label: ',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white70,
            ),
          ),
          Expanded(
            child: Text(value, style: const TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  // Helper method to confirm deletion
  void _confirmDelete(BuildContext context, Task task) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Delete Task"),
          content: const Text("Are you sure you want to delete this task?"),
          actions: [
            TextButton(
              onPressed: () => Get.back(),
              child: const Text(
                "Cancel",
                style: TextStyle(color: Colors.white),
              ),
            ),
            TextButton(
              onPressed: () {
                _taskController.deleteTask(task.id!, widget.typeTask);
                Get.back();
              },
              child: const Text(
                "Delete",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  // Helper method to mark a task as completed
  void _markAsCompleted(BuildContext context, Task task) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Mark as Completed"),
          content: const Text(
            "Are you sure you want to mark this task as completed?",
          ),
          actions: [
            TextButton(
              onPressed: () => Get.back(),
              child: const Text(
                "Cancel",
                style: TextStyle(color: Colors.white),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _taskController.markTaskAsCompleted(task.id!, widget.typeTask);
              },
              child: const Text(
                "Confirm",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }
}
