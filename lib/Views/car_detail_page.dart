import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inter_repair_car/Controllers/add_task_to_vehicle_controller.dart';
import 'package:inter_repair_car/Controllers/car_controller.dart';
import 'package:inter_repair_car/Controllers/car_listing_controller.dart';
import 'package:inter_repair_car/Controllers/vehicle_update_controller.dart';
import 'package:inter_repair_car/Models/Entities/Task.dart';

final VehicleUpdateController vehicleUpdateController = Get.put(
  VehicleUpdateController(),
);
final AddTaskToVehicleController addTaskController = Get.put(
  AddTaskToVehicleController(),
);

class CarDetailPage extends StatelessWidget {
  final CarController carController = Get.put(CarController());

  @override
  Widget build(BuildContext context) {
    // Fetch data when the page loads
    final int carId = Get.arguments; // Pass the car ID as an argument
    carController.fetchData(carId);

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
      body: Obx(() {
        final car = carController.car.value;
        final owner = carController.owner.value;
        final tasks = carController.tasks;

        if (car == null || owner == null) {
          return Center(child: Text('No data found'));
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Car Details',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              _buildDetailItem('VIN', car.vin),
              _buildDetailItem('Plate Number', car.plateNumber.toString()),
              _buildDetailItem('Make', car.make),
              _buildDetailItem('Model', car.model),
              _buildDetailItem('Year', car.year.toString()),
              (car.engineType == null)
                  ? Text("No Engine type specified")
                  : _buildDetailItem('Engine Type', car.engineType!),
              (car.mileage == null)
                  ? Text("No mileage specified")
                  : _buildDetailItem('Mileage', car.mileage.toString()),
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
                            builder: (
                              BuildContext context,
                              StateSetter setModelState,
                            ) {
                              return Container(
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
                                    child: Form(
                                      key: addTaskController.addTaskKey,
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
                                                      addTaskController
                                                          .taskNameController,
                                                  decoration: InputDecoration(
                                                    labelText: 'Task Name*',
                                                    iconColor: Colors.white,
                                                    hintText:
                                                        'e.g., Replace Brake Pads.',
                                                    hintStyle: TextStyle(
                                                      color: Colors.white
                                                          .withValues(
                                                            alpha: 0.5,
                                                          ),
                                                    ),
                                                    labelStyle: TextStyle(
                                                      color: Colors.white,
                                                    ),
                                                    focusedBorder:
                                                        OutlineInputBorder(
                                                          borderSide:
                                                              BorderSide(
                                                                color:
                                                                    Colors
                                                                        .white,
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
                                                    if (double.tryParse(
                                                          value,
                                                        ) ==
                                                        null) {
                                                      return 'Enter valid number';
                                                    }
                                                    return null;
                                                  },
                                                  controller:
                                                      addTaskController
                                                          .taskCostController,
                                                  keyboardType:
                                                      TextInputType.number,
                                                  decoration: InputDecoration(
                                                    labelText: 'Cost*',
                                                    iconColor: Colors.white,
                                                    labelStyle: TextStyle(
                                                      color: Colors.white,
                                                    ),
                                                    focusedBorder:
                                                        OutlineInputBorder(
                                                          borderSide:
                                                              BorderSide(
                                                                color:
                                                                    Colors
                                                                        .white,
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
                                                      addTaskController
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
                                                        addTaskController
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
                                                            addTaskController
                                                                .selectedStartTime,
                                                      );
                                                  if (timeOfDay != null) {
                                                    setModelState(() {
                                                      addTaskController
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
                                                        text: addTaskController
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
                                                          .withValues(
                                                            alpha: .5,
                                                          ),
                                                    ),
                                                    focusedBorder:
                                                        OutlineInputBorder(
                                                          borderSide:
                                                              BorderSide(
                                                                color:
                                                                    Colors
                                                                        .white,
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
                                                addTaskController
                                                    .taskDetailsController,
                                            keyboardType:
                                                TextInputType.multiline,
                                            maxLines: 3,
                                            decoration: InputDecoration(
                                              labelText: 'Details',
                                              iconColor: Colors.white,
                                              hintText:
                                                  'Additional details about the task.',
                                              hintStyle: TextStyle(
                                                color: Colors.white.withValues(
                                                  alpha: .5,
                                                ),
                                              ),
                                              labelStyle: TextStyle(
                                                color: Colors.white,
                                              ),
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
                                              if (addTaskController
                                                  .addTaskKey
                                                  .currentState!
                                                  .validate()) {
                                                Task newTask = Task(
                                                  name:
                                                      addTaskController
                                                          .taskNameController
                                                          .text,
                                                  details:
                                                      addTaskController
                                                          .taskDetailsController
                                                          .text,
                                                  status:
                                                      addTaskController
                                                          .taskStatusSelected
                                                          .name,
                                                  timeStart: DateTime(
                                                    DateTime.now().year,
                                                    DateTime.now().month,
                                                    DateTime.now().day,
                                                    addTaskController
                                                        .selectedStartTime
                                                        .hour,
                                                    addTaskController
                                                        .selectedStartTime
                                                        .minute,
                                                  ),
                                                  cost:
                                                      addTaskController
                                                              .taskCostController
                                                              .text
                                                              .isEmpty
                                                          ? 0.0
                                                          : double.parse(
                                                            addTaskController
                                                                .taskCostController
                                                                .text,
                                                          ),
                                                  vehicleId: car.id,
                                                );

                                                // 🔥 Refresh the vehicle list to update the UI
                                                Get.find<CarListingController>()
                                                    .fetchVehicles();

                                                await carController.addTask(
                                                  newTask,
                                                );
                                                Get.back();
                                              }
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
                        },
                      );
                    },
                    icon: Icon(Icons.add),
                  ),
                ],
              ),
              ...tasks.map((task) => _buildTaskCard(task)),
            ],
          ),
        );
      }),
    );
  }

  void _showEditBottomSheet(BuildContext context) {
    final car = carController.car.value;
    if (car == null) return;

    // Initialize the controllers with the current car values
    vehicleUpdateController.carVINController.text = car.vin;
    vehicleUpdateController.carPlateNumberController.text =
        car.plateNumber.toString();
    vehicleUpdateController.carMakerController.text = car.make;
    vehicleUpdateController.carModelController.text = car.model;
    vehicleUpdateController.carYearController.text = car.year.toString();
    vehicleUpdateController.carEngineTypeController.text = car.engineType ?? '';
    vehicleUpdateController.carMileageController.text =
        car.mileage?.toString() ?? '';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext ctx, StateSetter setModelState) {
            return Container(
              color: Colors.blueGrey[800],
              padding: const EdgeInsets.fromLTRB(0, 36, 0, 0),
              child: SingleChildScrollView(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                ),
                child: Container(
                  padding: EdgeInsets.all(16.0),
                  child: Form(
                    key: vehicleUpdateController.editFormKey,
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
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'VIN is required';
                            }
                            return null;
                          },
                          decoration: InputDecoration(labelText: 'VIN'),
                          controller: vehicleUpdateController.carVINController,
                        ),
                        TextFormField(
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Plate Number is required';
                            }
                            if (int.tryParse(value) == null) {
                              return 'Enter a valid plate number';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            labelText: 'Plate Number',
                            labelStyle: TextStyle(color: Colors.white),
                          ),
                          controller:
                              vehicleUpdateController.carPlateNumberController,
                          keyboardType: TextInputType.number,
                          maxLength: 8,
                          style: TextStyle(color: Colors.white),
                        ),
                        TextFormField(
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Make is required';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            labelText: 'Make',
                            labelStyle: TextStyle(color: Colors.white),
                          ),
                          controller:
                              vehicleUpdateController.carMakerController,
                          style: TextStyle(color: Colors.white),
                        ),
                        TextFormField(
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Model is required';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            labelText: 'Model',
                            labelStyle: TextStyle(color: Colors.white),
                          ),
                          controller:
                              vehicleUpdateController.carModelController,
                          style: TextStyle(color: Colors.white),
                        ),
                        TextFormField(
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Year is required';
                            }
                            final int? year = int.tryParse(value);
                            if (year == null ||
                                year < 1900 ||
                                year > DateTime.now().year) {
                              return 'Enter a valid year';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            labelText: 'Year',
                            labelStyle: TextStyle(color: Colors.white),
                          ),
                          controller: vehicleUpdateController.carYearController,
                          keyboardType: TextInputType.number,
                          maxLength: 4,
                          style: TextStyle(color: Colors.white),
                        ),
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Engine Type',
                            labelStyle: TextStyle(color: Colors.white),
                          ),
                          controller:
                              vehicleUpdateController.carEngineTypeController,
                          style: TextStyle(color: Colors.white),
                        ),
                        TextFormField(
                          validator: (value) {
                            if (value != null && value.isNotEmpty) {
                              final double? mileage = double.tryParse(value);
                              if (mileage == null || mileage < 0) {
                                return 'Enter valid mileage';
                              }
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            labelText: 'Mileage',
                            labelStyle: TextStyle(color: Colors.white),
                          ),
                          controller:
                              vehicleUpdateController.carMileageController,
                          keyboardType: TextInputType.number,
                          style: TextStyle(color: Colors.white),
                        ),
                        SizedBox(height: 20),
                        ElevatedButton(
                          child: Text(
                            'Save Changes',
                            style: TextStyle(color: Colors.white),
                          ),
                          onPressed: () async {
                            // Update the car object with new values
                            if (vehicleUpdateController
                                .editFormKey
                                .currentState!
                                .validate()) {
                              final updatedCar = car.copyWith(
                                vin:
                                    vehicleUpdateController
                                        .carVINController
                                        .text,
                                plateNumber:
                                    int.tryParse(
                                      vehicleUpdateController
                                          .carPlateNumberController
                                          .text,
                                    ) ??
                                    car.plateNumber,
                                make:
                                    vehicleUpdateController
                                        .carMakerController
                                        .text,
                                model:
                                    vehicleUpdateController
                                        .carModelController
                                        .text,
                                year:
                                    int.tryParse(
                                      vehicleUpdateController
                                          .carYearController
                                          .text,
                                    ) ??
                                    car.year,
                                engineType:
                                    vehicleUpdateController
                                        .carEngineTypeController
                                        .text,
                                mileage:
                                    int.tryParse(
                                      vehicleUpdateController
                                          .carMileageController
                                          .text,
                                    ) ??
                                    car.mileage,
                              );

                              await carController.updateCar(updatedCar);

                              final CarListingController carListingController =
                                  Get.find();
                              await carListingController.fetchVehicles();
                              Get.back();

                              // Show a SnackBar to confirm the update
                              ScaffoldMessenger.of(ctx).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Car details updated successfully!',
                                  ),
                                ),
                              );
                            }
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
            _buildDetailItem(
              'Time End',
              (task.timeEnd != null)
                  ? task.timeEnd.toString()
                  : 'Not finished yet',
            ),
            _buildDetailItem('Cost', '\$${task.cost.toStringAsFixed(2)}'),
          ],
        ),
      ),
    );
  }
}
