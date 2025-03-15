import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inter_repair_car/Controllers/task_update_controller.dart';
import 'package:inter_repair_car/Models/Entities/Task.dart';

final TaskUpdateController controller = TaskUpdateController();

class TypeTaskView extends StatefulWidget {
  final String typeTask;

  const TypeTaskView({super.key, required this.typeTask});

  @override
  _TypeTaskViewState createState() => _TypeTaskViewState();
}

class _TypeTaskViewState extends State<TypeTaskView> {
  final TextEditingController _searchController = TextEditingController();
  List<Task> tasks = [
    Task(
      name: "Fix Engine",
      status: "onGoing",
      timeStart: DateTime.now(),
      timeEnd: DateTime.now().add(Duration(hours: 2)),
      cost: 150.0,
      details: "Engine needs replacement",
      vehicleId: 101,
    ),
    Task(
      name: "Change Oil",
      status: "pending",
      timeStart: DateTime.now(),
      timeEnd: null,
      cost: 50.0,
      details: null,
      vehicleId: null,
    ),
  ]; // Dummy tasks
  List<Task> filteredTasks = [];

  @override
  void initState() {
    super.initState();
    filteredTasks = tasks; // Initialize with all tasks
  }

  // Filter tasks based on search query
  void _filterTasks(String query) {
    setState(() {
      filteredTasks = tasks
          .where((task) => task.name.toLowerCase().contains(query.toLowerCase()))
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
              Colors.grey[800]!.withOpacity(0.6),
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
                  fillColor: Colors.grey[800]!.withOpacity(0.5),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: Colors.white.withOpacity(0.3), // White border with low opacity
                      width: 1.0, // Border width
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: Colors.white.withOpacity(0.3), // White border with low opacity
                      width: 1.0, // Border width
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: Colors.white.withOpacity(0.5), // Slightly more opacity when focused
                      width: 1.5, // Slightly thicker border when focused
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
              child: ListView.builder(
                itemCount: filteredTasks.length,
                itemBuilder: (context, index) {
                  return _buildTaskCard(context, filteredTasks[index]);
                },
              ),
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

  // Helper method to show the edit bottom sheet
  void _showEditBottomSheet(BuildContext context, Task task) {
    controller.nameController = TextEditingController(
      text: task.name,
    );
    controller.costController = TextEditingController(
      text: task.cost.toString(),
    );
    controller.detailsController = TextEditingController(
      text: task.details,
    );

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
                      onPressed: () {
                        // Save changes (dummy logic for now)
                        Get.back();
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
            );
          },
        );
      },
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
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                // Delete the task (dummy logic for now)
                Get.back();
              },
              child: const Text("Delete"),
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
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                // Mark the task as completed (dummy logic for now)
                Get.back();
              },
              child: const Text("Confirm"),
            ),
          ],
        );
      },
    );
  }
}