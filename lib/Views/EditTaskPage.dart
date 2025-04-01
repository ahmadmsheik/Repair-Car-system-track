import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:inter_repair_car/Controllers/task_controller.dart';
import 'package:inter_repair_car/Controllers/task_update_controller.dart';
import 'package:inter_repair_car/Models/Entities/Task.dart';
import 'package:inter_repair_car/Models/repositories/DatabaseHelper.dart';

class EditTaskPage extends StatefulWidget {
  final Task task;
  final String typeTask;

  const EditTaskPage({super.key, required this.task, required this.typeTask});

  @override
  _EditTaskPageState createState() => _EditTaskPageState();
}

class _EditTaskPageState extends State<EditTaskPage> {
  final TaskUpdateController _controller = Get.put(TaskUpdateController());
  final TaskController _taskController = Get.put(
    TaskController(),
  ); // Initialize the controller
  late String selectedStatus;

  @override
  void initState() {
    super.initState();
    selectedStatus = widget.task.status;
    _controller.nameController = TextEditingController(text: widget.task.name);
    _controller.costController = TextEditingController(
      text: widget.task.cost.toString(),
    );
    _controller.detailsController = TextEditingController(
      text: widget.task.details,
    );
    _controller.currentMileage = TextEditingController(
      text: widget.task.currentMileage?.toString() ?? "",
    );
  }

  @override
  void dispose() {
    _controller.nameController.dispose();
    _controller.costController.dispose();
    _controller.detailsController.dispose();
    _controller.currentMileage.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Task"),
        backgroundColor: Colors.blueGrey[900],
      ),
      body: Container(
        height: double.infinity,
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
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 30),
        child: Form(
          key: _controller.taskUpdateKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Task Name is required';
                    }
                    return null;
                  },
                  controller: _controller.nameController,
                  decoration: const InputDecoration(
                    labelText: "Name",
                    border: OutlineInputBorder(),
                    labelStyle: TextStyle(color: Colors.white),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white, width: 2),
                    ),
                  ),
                  style: const TextStyle(color: Colors.white),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _controller.currentMileage,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: "Mileage",
                    border: OutlineInputBorder(),
                    labelStyle: TextStyle(color: Colors.white),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white, width: 2),
                    ),
                  ),
                  style: const TextStyle(color: Colors.white),
                ),
                const SizedBox(height: 16),
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
                        controller: _controller.costController,
                        decoration: const InputDecoration(
                          labelText: "Cost",
                          border: OutlineInputBorder(),
                          labelStyle: TextStyle(color: Colors.white),
                          prefixText: '\$',
                          prefixStyle: TextStyle(color: Colors.white),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.white,
                              width: 2,
                            ),
                          ),
                        ),
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _controller.detailsController,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    labelText: "Details",
                    border: OutlineInputBorder(),
                    labelStyle: TextStyle(color: Colors.white),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white, width: 2),
                    ),
                  ),
                  style: const TextStyle(color: Colors.white),
                ),

                // Parts Management Section
                const SizedBox(height: 24),
                const Divider(color: Colors.white54),
                const Text(
                  'Parts Used',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 12),
                FutureBuilder<List<Map<String, dynamic>>>(
                  future: DatabaseHelper().getPartsByTask(widget.task.id!),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (snapshot.hasError ||
                        !snapshot.hasData ||
                        snapshot.data!.isEmpty) {
                      return Column(
                        children: [
                          const Text(
                            'No parts added yet',
                            style: TextStyle(color: Colors.white70),
                          ),
                          const SizedBox(height: 12),
                          ElevatedButton(
                            onPressed:
                                () => _showAddPartDialog(context, widget.task),
                            child: const Text(
                              'Add Part',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      );
                    }

                    final parts = snapshot.data!;
                    return Column(
                      children: [
                        ...parts.map(
                          (part) => ListTile(
                            title: Text(
                              part['name'],
                              style: const TextStyle(color: Colors.white),
                            ),
                            subtitle: Text(
                              '${part['supplier']} - \$${part['price'].toStringAsFixed(2)}',
                              style: const TextStyle(color: Colors.white70),
                            ),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () async {
                                await DatabaseHelper().deletePart(part['id']);
                                setState(() {}); // Refresh the view
                              },
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Total Parts Cost: \$${_calculatePartsTotal(parts).toStringAsFixed(2)}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        ElevatedButton(
                          onPressed:
                              () => _showAddPartDialog(context, widget.task),
                          child: const Text(
                            'Add Another Part',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 24),

                // Save Changes Button
                ElevatedButton(
                  onPressed: () async {
                    if (_controller.taskUpdateKey.currentState!.validate()) {
                      final updatedTask = Task(
                        id: widget.task.id,
                        name: _controller.nameController.text,
                        status: selectedStatus,
                        timeStart: widget.task.timeStart,
                        timeEnd: widget.task.timeEnd,
                        cost: double.parse(_controller.costController.text),
                        currentMileage:
                            _controller.currentMileage.text.isNotEmpty
                                ? int.parse(_controller.currentMileage.text)
                                : null,
                        details: _controller.detailsController.text,
                        vehicleId: widget.task.vehicleId,
                      );

                      await _taskController.updateTask(
                        updatedTask,
                        widget.typeTask,
                      );
                      Get.back();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueGrey[700],
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  child: const Text(
                    "Save Changes",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showAddPartDialog(BuildContext context, Task task) {
    final partNameController = TextEditingController();
    final partSupplierController = TextEditingController();
    final partPriceController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.blueGrey[800],
          title: const Text(
            'Add New Part',
            style: TextStyle(color: Colors.white),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: partNameController,
                decoration: const InputDecoration(
                  labelText: 'Part Name*',
                  labelStyle: TextStyle(color: Colors.white),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white, width: 2),
                  ),
                ),
                style: const TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: partSupplierController,
                decoration: const InputDecoration(
                  labelText: 'Supplier*',
                  labelStyle: TextStyle(color: Colors.white),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white, width: 2),
                  ),
                ),
                style: const TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: partPriceController,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(
                  labelText: 'Price*',
                  prefixText: '\$',
                  labelStyle: TextStyle(color: Colors.white),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white, width: 2),
                  ),
                ),
                style: const TextStyle(color: Colors.white),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Get.back(),
              child: const Text(
                'Cancel',
                style: TextStyle(color: Colors.white70),
              ),
            ),
            TextButton(
              onPressed: () async {
                if (partNameController.text.isNotEmpty &&
                    partSupplierController.text.isNotEmpty &&
                    partPriceController.text.isNotEmpty) {
                  final price = double.tryParse(partPriceController.text);
                  if (price != null && price > 0) {
                    await DatabaseHelper().insertPart(
                      name: partNameController.text,
                      supplier: partSupplierController.text,
                      price: price,
                      taskId: task.id!,
                    );
                    setState(() {}); // Refresh the page
                    Get.back();
                  } else {
                    Get.snackbar(
                      'Invalid Price',
                      'Please enter a valid price greater than 0',
                      backgroundColor: Colors.red,
                      colorText: Colors.white,
                    );
                  }
                } else {
                  Get.snackbar(
                    'Missing Information',
                    'Please fill all fields',
                    backgroundColor: Colors.red,
                    colorText: Colors.white,
                  );
                }
              },
              child: const Text('Add', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  double _calculatePartsTotal(List<Map<String, dynamic>> parts) {
    return parts.fold(0.0, (sum, part) => sum + (part['price'] as double));
  }
}
