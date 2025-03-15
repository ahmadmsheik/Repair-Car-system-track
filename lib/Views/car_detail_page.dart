import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/get_core.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:inter_repair_car/Controllers/add_task_to_vehicle_controller.dart';
import 'package:inter_repair_car/Controllers/vehicle_update_controller.dart';
import 'package:inter_repair_car/Models/Entities/Task.dart';
import 'package:inter_repair_car/Models/Entities/User.dart';
import 'package:inter_repair_car/Models/Entities/vehicle.dart';
import 'package:inter_repair_car/Models/repositories/DatabaseHelper.dart';

class CarDetailPage extends StatelessWidget {
  final Vehicle car;
  final User owner;
  final List<Task> tasks;
  final DatabaseHelper dbHelper = DatabaseHelper();

  // Constructor to receive data with default values
  CarDetailPage({super.key, Vehicle? car, User? owner, List<Task>? tasks})
    : car =
          car ??
          Vehicle(
            vin: '1HGCM82633A123456',
            plateNumber: 13314,
            make: 'Toyota',
            model: 'Camry',
            year: 2012,
            engineType: 'V6',
            mileage: 15000,
          ),
      owner = owner ?? const User(name: 'John Doe', phone: 143546532),
      tasks =
          tasks ??
          [
            Task(
              name: 'Oil Change',
              status: 'Completed',
              timeStart: DateTime(2023, 10, 1, 9, 0),
              timeEnd: DateTime(2023, 10, 1, 10, 0),
              cost: 29.99,
              details: 'Changed engine oil and oil filter.',
            ),
            Task(
              name: 'Tire Rotation',
              status: 'Pending',
              timeStart: DateTime(2023, 10, 2, 11, 0),
              timeEnd: DateTime(2023, 10, 2, 12, 0),
              cost: 19.99,
              details: 'Rotated all four tires.',
            ),
          ];

  final VehicleUpdateController controller = Get.put(VehicleUpdateController());
  final AddTaskToVehicleController controllerv = Get.put(
    AddTaskToVehicleController(),
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Car Details'),
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () => _showEditBottomSheet(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Car Details',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            (car.vin == null)
                ? const Text('No VIN')
                : _buildDetailItem('VIN', car.vin!),
            _buildDetailItem('Plate Number', car.plateNumber.toString()),
            _buildDetailItem('Make', car.make),
            _buildDetailItem('Model', car.model),
            (car.year == null)
                ? const Text('No year')
                : _buildDetailItem('Year', car.year.toString()),
            _buildDetailItem('Engine Type', car.engineType!),
            _buildDetailItem('Mileage', car.mileage.toString()),
            const SizedBox(height: 20),
            const Text(
              'Owner Details',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            _buildDetailItem('Name', owner.name),
            _buildDetailItem('Phone', owner.phone.toString()),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Tasks',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  onPressed: () async {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      builder: (context) {
                        return StatefulBuilder(
                          builder:
                              (
                                BuildContext context,
                                StateSetter setModelState,
                              ) => Container(
                                color: Colors.blueGrey[800],
                                padding: const EdgeInsets.fromLTRB(0, 36, 0, 0),
                                child: SingleChildScrollView(
                                  padding: EdgeInsets.only(
                                    bottom:
                                        MediaQuery.of(
                                          context,
                                        ).viewInsets.bottom,
                                  ),
                                  child: Container(
                                    padding: EdgeInsets.all(16.0),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        Text(
                                          'Add New Task',
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                        SizedBox(height: 20),
                                        Row(
                                          children: [
                                            Expanded(
                                              flex: 2,
                                              child: TextFormField(
                                                validator: (value) {
                                                  if (value == null ||
                                                      value.isEmpty) {
                                                    return 'Task Name is required';
                                                  }
                                                  return null;
                                                },
                                                controller:
                                                    controllerv
                                                        .taskNameController,
                                                keyboardType:
                                                    TextInputType.text,
                                                decoration: InputDecoration(
                                                  labelText: 'Task Name*',
                                                  iconColor: Colors.white,
                                                  hintText:
                                                      'e.g., Replace Brake Pads.',
                                                  hintStyle: TextStyle(
                                                    color: Colors.white
                                                        .withValues(alpha: 0.5),
                                                  ),
                                                  labelStyle: TextStyle(
                                                    color: Colors.white,
                                                  ),
                                                  focusColor: Colors.white,
                                                  focusedBorder:
                                                      OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                          color: Colors.white,
                                                          width: 2.0,
                                                        ),
                                                      ),
                                                  border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          3,
                                                        ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            SizedBox(width: 12),
                                            Expanded(
                                              flex: 1,
                                              child: TextFormField(
                                                validator: (value) {
                                                  if (value == null ||
                                                      value.isEmpty) {
                                                    return 'Cost is required';
                                                  }
                                                  if (double.tryParse(value) ==
                                                      null) {
                                                    return 'Please enter a valid number';
                                                  }
                                                  return null;
                                                },
                                                controller:
                                                    controllerv
                                                        .taskCostController,
                                                keyboardType:
                                                    TextInputType.number,
                                                decoration: InputDecoration(
                                                  labelText: 'Cost*',
                                                  iconColor: Colors.white,
                                                  labelStyle: TextStyle(
                                                    color: Colors.white,
                                                  ),
                                                  focusColor: Colors.white,
                                                  focusedBorder:
                                                      OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                          color: Colors.white,
                                                          width: 2.0,
                                                        ),
                                                      ),
                                                  border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          3,
                                                        ),
                                                  ),
                                                  prefixText: '\$',
                                                  prefixStyle: TextStyle(
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 12),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.fromLTRB(
                                                20,
                                                0,
                                                40,
                                                0,
                                              ),
                                              child: Text(
                                                'Task Status',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 20,
                                                ),
                                              ),
                                            ),
                                            Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 12,
                                                  ),
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                  color: Colors.white
                                                      .withValues(alpha: .2),
                                                  width: 1,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(3),
                                              ),
                                              child: DropdownButton(
                                                value:
                                                    controllerv
                                                        .taskStatusSelected,
                                                items:
                                                    Status.values.map((
                                                      element,
                                                    ) {
                                                      return DropdownMenuItem(
                                                        value: element,
                                                        child: Text(
                                                          element.name
                                                              .toUpperCase(),
                                                        ),
                                                      );
                                                    }).toList(),
                                                onChanged: (value) {
                                                  if (value != null) {
                                                    setModelState(() {
                                                      controllerv
                                                              .taskStatusSelected =
                                                          value;
                                                    });
                                                  }
                                                },
                                                dropdownColor:
                                                    Colors.blueGrey[800],
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                ),
                                                underline: Container(),
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 18),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            ElevatedButton(
                                              onPressed: () async {
                                                final TimeOfDay? timeOfDay =
                                                    await showTimePicker(
                                                      context: context,
                                                      initialTime:
                                                          controllerv
                                                              .selectedStartTime,
                                                    );
                                                if (timeOfDay != null) {
                                                  setModelState(() {
                                                    controllerv
                                                            .selectedStartTime =
                                                        timeOfDay;
                                                  });
                                                }
                                              },
                                              child: Text(
                                                'Choose Start Time',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                            SizedBox(width: 40),
                                            SizedBox(
                                              width: 130,
                                              child: TextFormField(
                                                textAlign: TextAlign.center,
                                                controller:
                                                    TextEditingController(
                                                      text: controllerv
                                                          .selectedStartTime
                                                          .format(context),
                                                    ),
                                                style: TextStyle(
                                                  color: Colors.white,
                                                ),
                                                decoration: InputDecoration(
                                                  enabled: false,
                                                  iconColor: Colors.white,
                                                  hintStyle: TextStyle(
                                                    color: Colors.white
                                                        .withValues(alpha: 0.5),
                                                  ),
                                                  focusColor: Colors.white,
                                                  focusedBorder:
                                                      OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                          color: Colors.white,
                                                          width: 2.0,
                                                        ),
                                                      ),
                                                  border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          3,
                                                        ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 12),
                                        TextFormField(
                                          controller:
                                              controllerv.taskDetailsController,
                                          keyboardType: TextInputType.multiline,
                                          maxLines: 3,
                                          decoration: InputDecoration(
                                            labelText: 'Details',
                                            iconColor: Colors.white,
                                            hintText:
                                                'Additional details about the task.',
                                            hintStyle: TextStyle(
                                              color: Colors.white.withValues(
                                                alpha: 0.5,
                                              ),
                                            ),
                                            labelStyle: TextStyle(
                                              color: Colors.white,
                                            ),
                                            focusColor: Colors.white,
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Colors.white,
                                                width: 2.0,
                                              ),
                                            ),
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(3),
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 20),
                                        ElevatedButton(
                                          child: Text(
                                            'Save Task',
                                            style: TextStyle(
                                              color: Colors.white,
                                            ),
                                          ),
                                          onPressed: () async {
                                            Task newTask = Task(
                                              name:
                                                  controllerv
                                                      .taskNameController
                                                      .text,
                                              details:
                                                  controllerv
                                                      .taskDetailsController
                                                      .text,
                                              status:
                                                  controllerv
                                                      .taskStatusSelected
                                                      .name,
                                              timeStart: DateTime(
                                                DateTime.now().year,
                                                DateTime.now().month,
                                                DateTime.now().day,
                                                controllerv
                                                    .selectedStartTime
                                                    .hour,
                                                controllerv
                                                    .selectedStartTime
                                                    .minute,
                                              ),

                                              cost:
                                                  controllerv
                                                          .taskCostController
                                                          .text
                                                          .isEmpty
                                                      ? 0.0
                                                      : double.parse(
                                                        controllerv
                                                            .taskCostController
                                                            .text,
                                                      ),
                                              vehicleId: car.id,
                                            );

                                            await dbHelper.insertTask(newTask);
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                        SizedBox(height: 20),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                        );
                      },
                    );

                    // Optionally, refresh the task list
                    // You can use a state management solution (e.g., Provider, GetX) to update the UI
                  },
                  icon: Icon(Icons.add),
                ),
              ],
            ),
            ...tasks.map((task) => _buildTaskCard(task)),
          ],
        ),
      ),
    );
  }

  void _showEditBottomSheet(BuildContext context) {
    // Initialize the controllers with the current car values
    controller.carVINController.text = car.vin ?? '';
    controller.carPlateNumberController.text = car.plateNumber.toString();
    controller.carMakerController.text = car.make;
    controller.carModelController.text = car.model;
    controller.carYearController.text = car.year?.toString() ?? '';
    controller.carEngineTypeController.text = car.engineType ?? '';
    controller.carMileageController.text = car.mileage?.toString() ?? '';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(
          builder:
              (BuildContext ctx, StateSetter setModelState) => Container(
                color: Colors.blueGrey[800],
                padding: const EdgeInsets.fromLTRB(0, 36, 0, 0),
                child: SingleChildScrollView(
                  padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom,
                  ),
                  child: Container(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text(
                          'Edit Car Details',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextFormField(
                          decoration: InputDecoration(labelText: 'VIN'),
                          controller: controller.carVINController,
                        ),
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Plate Number',
                          ),
                          controller: controller.carPlateNumberController,
                        ),
                        TextFormField(
                          decoration: InputDecoration(labelText: 'Make'),
                          controller: controller.carMakerController,
                        ),
                        TextFormField(
                          decoration: InputDecoration(labelText: 'Model'),
                          controller: controller.carModelController,
                        ),
                        TextFormField(
                          decoration: InputDecoration(labelText: 'Year'),
                          controller: controller.carYearController,
                        ),
                        TextFormField(
                          decoration: InputDecoration(labelText: 'Engine Type'),
                          controller: controller.carEngineTypeController,
                        ),
                        TextFormField(
                          decoration: InputDecoration(labelText: 'Mileage'),
                          controller: controller.carMileageController,
                        ),
                        SizedBox(height: 20),
                        ElevatedButton(
                          child: Text(
                            'Save Changes',
                            style: TextStyle(color: Colors.white),
                          ),
                          onPressed: () async {
                            // Update the car object with new values
                            car.vin = controller.carVINController.text;
                            car.plateNumber =
                                int.tryParse(
                                  controller.carPlateNumberController.text,
                                ) ??
                                car.plateNumber;
                            car.make = controller.carMakerController.text;
                            car.model = controller.carModelController.text;
                            car.year =
                                int.tryParse(
                                  controller.carYearController.text,
                                ) ??
                                car.year;
                            car.engineType =
                                controller.carEngineTypeController.text;
                            car.mileage =
                                int.tryParse(
                                  controller.carMileageController.text,
                                ) ??
                                car.mileage;

                            // Update the car in the database
                            await dbHelper.updateVehicle(car);

                            Get.back();

                            // Show a SnackBar to confirm the update
                            ScaffoldMessenger.of(ctx).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Car details updated successfully!',
                                ),
                              ),
                            );
                          },
                        ),
                        SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ),
        );
      },
    );
  }

  // Helper method to build detail items
  Widget _buildDetailItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Text('$label: ', style: const TextStyle(fontWeight: FontWeight.bold)),
          Text(value),
        ],
      ),
    );
  }

  // Helper method to build task cards
  Widget _buildTaskCard(Task task) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              task.name,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            _buildDetailItem('Status', task.status),
            _buildDetailItem('Time Start', task.timeStart.toString()),
            _buildDetailItem('Time End', task.timeEnd.toString()),
            _buildDetailItem('Cost', '\$${task.cost.toStringAsFixed(2)}'),
          ],
        ),
      ),
    );
  }
}
