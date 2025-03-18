import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get/instance_manager.dart';
import 'package:image_picker/image_picker.dart';
import 'package:inter_repair_car/Controllers/add_task_controller.dart';
import 'package:inter_repair_car/Models/Entities/Task.dart';
import 'package:inter_repair_car/Models/Entities/User.dart';
import 'package:inter_repair_car/Models/Entities/vehicle.dart';
import 'package:inter_repair_car/Models/repositories/DatabaseHelper.dart';
import 'package:inter_repair_car/Widgets/phone_number_formatter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

class AddingAVehicleWithTaskView extends StatefulWidget {
  const AddingAVehicleWithTaskView({super.key});

  @override
  State<AddingAVehicleWithTaskView> createState() =>
      _AddingAVehicleWithTaskViewState();
}

class _AddingAVehicleWithTaskViewState
    extends State<AddingAVehicleWithTaskView> {
  Future<String?> saveImagePermanently(XFile imageFile) async {
    try {
      // Get the external storage directory (e.g., "Pictures" folder)
      final Directory? externalDir = await getExternalStorageDirectory();
      if (externalDir == null) {
        throw Exception("External storage directory not found");
      }

      // Create a subdirectory for your app (e.g., "InterRepairCar")
      final Directory appDir = Directory('${externalDir.path}/InterRepairCar');
      if (!await appDir.exists()) {
        await appDir.create(
          recursive: true,
        ); // Create the directory if it doesn't exist
      }

      // Generate a unique file name
      final String fileName =
          'vehicle_image_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final File permanentFile = File(join(appDir.path, fileName));

      // Copy the temporary file to the permanent location
      await permanentFile.writeAsBytes(await imageFile.readAsBytes());

      // Log the saved file path

      // Return the path of the saved file
      return permanentFile.path;
    } catch (e) {
      // Handle errors

      return null;
    }
  }

  final AddTaskController controller = Get.put(AddTaskController());

  final ImagePicker _picker = ImagePicker();
  XFile? _imageFile;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add a new work"),
        backgroundColor: Colors.grey[850],
      ),
      body: StatefulBuilder(
        builder: (BuildContext context, StateSetter setModelState) {
          return Container(
            color: Colors.blueGrey[800],
            child: Form(
              key: controller.formKey,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          const Row(
                            children: [
                              FaIcon(FontAwesomeIcons.car),
                              SizedBox(width: 12),
                              Text(
                                'Car Details',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 36),
                          TextFormField(
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Car Maker is required.";
                              }
                              return null;
                            },
                            controller: controller.carMakerController,
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                              labelText: 'Car Maker*',
                              iconColor: Colors.white,
                              hintText: 'e.g., Toyota, Ford',
                              hintStyle: TextStyle(
                                color: Colors.white.withValues(alpha: .5),
                              ),
                              labelStyle: const TextStyle(color: Colors.white),
                              focusColor: Colors.white,
                              focusedBorder: const OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.white,
                                  width: 2.0,
                                ),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(3),
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          TextFormField(
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Car Model is required";
                              }
                              return null;
                            },
                            controller: controller.carModelController,
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                              labelText: 'Car Model*',
                              iconColor: Colors.white,
                              hintText: 'e.g., Camry, Mustang',
                              hintStyle: TextStyle(
                                color: Colors.white.withValues(alpha: .5),
                              ),
                              labelStyle: const TextStyle(color: Colors.white),
                              focusColor: Colors.white,
                              focusedBorder: const OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.white,
                                  width: 2.0,
                                ), // Change color here
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(3),
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          TextFormField(
                            controller: controller.vinController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'VIN is required';
                              }
                              return null;
                            },
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                              labelText: 'VIN*',
                              iconColor: Colors.white,
                              hintText: 'Vehicle Identification Number.',
                              hintStyle: TextStyle(
                                color: Colors.white.withValues(alpha: .5),
                              ),
                              labelStyle: const TextStyle(color: Colors.white),
                              focusColor: Colors.white,
                              focusedBorder: const OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.white,
                                  width: 2.0,
                                ), // Change color here
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(3),
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Plate Number is required';
                                    }
                                    if (int.tryParse(value) == null) {
                                      return "Please enter a valid plate numebr";
                                    }
                                    return null;
                                  },
                                  controller: controller.plateNumberController,
                                  keyboardType: TextInputType.number,
                                  maxLength: 8,
                                  decoration: InputDecoration(
                                    labelText: 'Plate Number*',
                                    iconColor: Colors.white,
                                    hintText: 'e.g., 765 238',
                                    hintStyle: TextStyle(
                                      color: Colors.white.withValues(alpha: .5),
                                    ),
                                    labelStyle: const TextStyle(
                                      color: Colors.white,
                                    ),
                                    focusColor: Colors.white,
                                    focusedBorder: const OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.white,
                                        width: 2.0,
                                      ), // Change color here
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(3),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: TextFormField(
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Year field is required';
                                    }
                                    final int? year = int.tryParse(value);
                                    if (year == null ||
                                        year < 1900 ||
                                        year > DateTime.now().year) {
                                      return 'Please enter a valid year';
                                    }
                                    return null;
                                  },
                                  controller: controller.yearController,
                                  keyboardType: TextInputType.number,
                                  maxLength: 4,
                                  decoration: InputDecoration(
                                    labelText: 'Year*',
                                    iconColor: Colors.white,
                                    hintText: 'Manufacturing year',
                                    hintStyle: TextStyle(
                                      color: Colors.white.withValues(alpha: .5),
                                    ),
                                    labelStyle: const TextStyle(
                                      color: Colors.white,
                                    ),
                                    focusColor: Colors.white,
                                    focusedBorder: const OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.white,
                                        width: 2.0,
                                      ), // Change color here
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(3),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: controller.engineTypeController,
                                  keyboardType: TextInputType.text,
                                  decoration: InputDecoration(
                                    labelText: 'Engine Type',
                                    iconColor: Colors.white,
                                    hintText: 'e.g., V6, Electric',
                                    hintStyle: TextStyle(
                                      color: Colors.white.withValues(alpha: .5),
                                    ),
                                    labelStyle: const TextStyle(
                                      color: Colors.white,
                                    ),
                                    focusColor: Colors.white,
                                    focusedBorder: const OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.white,
                                        width: 2.0,
                                      ), // Change color here
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(3),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: TextFormField(
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return null;
                                    }
                                    final double? mileage = double.tryParse(
                                      value,
                                    );
                                    if (mileage == null || mileage < 0) {
                                      return 'Please enter a valid mileage';
                                    }
                                    return null;
                                  },
                                  controller: controller.mileageController,
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    labelText: 'Mileage',
                                    iconColor: Colors.white,
                                    hintText:
                                        'Current mileage of the vehicle in km.',
                                    hintStyle: TextStyle(
                                      color: Colors.white.withValues(alpha: .5),
                                    ),
                                    labelStyle: const TextStyle(
                                      color: Colors.white,
                                    ),
                                    focusColor: Colors.white,
                                    focusedBorder: const OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.white,
                                        width: 2.0,
                                      ), // Change color here
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(3),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),
                          Row(
                            children: [
                              const SizedBox(width: 4),
                              GestureDetector(
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: const Text('Upload Image'),
                                        content: const Text(
                                          'Choose the source of the image:',
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () async {
                                              Navigator.pop(context);
                                              final XFile? image = await _picker
                                                  .pickImage(
                                                    source: ImageSource.camera,
                                                  );
                                              if (image != null) {
                                                setModelState(() {
                                                  _imageFile = image;
                                                });
                                              }
                                            },
                                            child: const Text(
                                              'Camera',
                                              style: TextStyle(
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                          TextButton(
                                            onPressed: () async {
                                              Navigator.pop(context);
                                              final XFile? image = await _picker
                                                  .pickImage(
                                                    source: ImageSource.gallery,
                                                  );
                                              if (image != null) {
                                                setModelState(() {
                                                  _imageFile = image;
                                                });
                                              }
                                            },
                                            child: const Text(
                                              'Gallery',
                                              style: TextStyle(
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                }, // Show the dialog when tapped
                                child: Container(
                                  height: 150,
                                  width: 175,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(color: Colors.white),
                                  ),
                                  child: Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const Icon(
                                          Icons.camera_alt,
                                          color: Colors.white,
                                          size: 40,
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          _imageFile == null
                                              ? 'Upload an Image'
                                              : 'Change Image',
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 24),
                              if (_imageFile != null)
                                Container(
                                  height: 150,
                                  width: 175,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    image: DecorationImage(
                                      image: FileImage(File(_imageFile!.path)),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          const Row(
                            children: [
                              FaIcon(FontAwesomeIcons.userTag),
                              SizedBox(width: 12),
                              Text(
                                'Owner Details',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 36),
                          Row(
                            children: [
                              Expanded(
                                flex: 3,
                                child: TextFormField(
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return "Full Name is required";
                                    }
                                    return null;
                                  },
                                  controller: controller.ownerNameController,
                                  keyboardType: TextInputType.name,
                                  maxLength: 50,
                                  decoration: InputDecoration(
                                    labelText: 'Full Name*',
                                    iconColor: Colors.white,
                                    hintText: 'e.g., John Doe',
                                    hintStyle: TextStyle(
                                      color: Colors.white.withValues(alpha: .5),
                                    ),
                                    labelStyle: const TextStyle(
                                      color: Colors.white,
                                    ),
                                    focusColor: Colors.white,
                                    focusedBorder: const OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.white,
                                        width: 2.0,
                                      ), // Change color here
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(3),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                flex: 2,
                                child: TextFormField(
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Phone Number is required';
                                    }
                                    if (!RegExp(
                                      r'^\d{2} \d{3} \d{3}$',
                                    ).hasMatch(value)) {
                                      return 'Please enter a valid phone number';
                                    }
                                    return null;
                                  },
                                  maxLength: 10,
                                  controller: controller.phoneNumberController,
                                  keyboardType: TextInputType.phone,
                                  inputFormatters: [
                                    PhoneNumberFormatter(), // Apply the custom formatter
                                    LengthLimitingTextInputFormatter(11),
                                  ],
                                  decoration: InputDecoration(
                                    labelText: 'Phone Number*',
                                    iconColor: Colors.white,
                                    hintText: 'e.g., 12 345 678',
                                    hintStyle: TextStyle(
                                      color: Colors.white.withValues(alpha: .5),
                                    ),
                                    labelStyle: const TextStyle(
                                      color: Colors.white,
                                    ),
                                    focusColor: Colors.white,
                                    focusedBorder: const OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.white,
                                        width: 2.0,
                                      ), // Change color here
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(3),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          const Row(
                            children: [
                              FaIcon(FontAwesomeIcons.barsProgress),
                              SizedBox(width: 12),
                              Text(
                                'Task Details',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 36),
                          Row(
                            children: [
                              Expanded(
                                flex: 2,
                                child: TextFormField(
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Task Name is required';
                                    }
                                    return null;
                                  },
                                  controller: controller.taskNameController,
                                  keyboardType: TextInputType.text,
                                  decoration: InputDecoration(
                                    labelText: 'Task Name*',
                                    iconColor: Colors.white,
                                    hintText: 'e.g., Replace Brake Pads.',
                                    hintStyle: TextStyle(
                                      color: Colors.white.withValues(alpha: .5),
                                    ),
                                    labelStyle: const TextStyle(
                                      color: Colors.white,
                                    ),
                                    focusColor: Colors.white,
                                    focusedBorder: const OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.white,
                                        width: 2.0,
                                      ), // Change color here
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(3),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                flex: 1,
                                child: TextFormField(
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Cost is required';
                                    }
                                    if (double.tryParse(value) == null) {
                                      return 'Please enter a valid number';
                                    }
                                    return null;
                                  },
                                  controller: controller.costController,
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    labelText: 'Cost*',
                                    iconColor: Colors.white,
                                    labelStyle: const TextStyle(
                                      color: Colors.white,
                                    ),
                                    focusColor: Colors.white,
                                    focusedBorder: const OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.white,
                                        width: 2.0,
                                      ),
                                      // Change color here
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(3),
                                    ),
                                    prefixText: '\$',
                                    prefixStyle: const TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              const Padding(
                                padding: EdgeInsets.fromLTRB(20, 0, 40, 0),
                                child: Text(
                                  'Task Status',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                ),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.white.withValues(alpha: .2),
                                    width: 1,
                                  ),
                                  borderRadius: BorderRadius.circular(3),
                                ),
                                child: DropdownButton(
                                  value: controller.taskStatusSelected,
                                  items:
                                      Status.values.map((element) {
                                        return DropdownMenuItem(
                                          value: element,
                                          child: Text(
                                            element.name.toUpperCase(),
                                          ),
                                        );
                                      }).toList(),
                                  onChanged: (value) {
                                    if (value != null) {
                                      setModelState(() {
                                        controller.taskStatusSelected = value;
                                      });
                                    }
                                  },
                                  dropdownColor: Colors.blueGrey[800],
                                  style: const TextStyle(color: Colors.white),
                                  underline: Container(),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 18),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ElevatedButton(
                                onPressed: () async {
                                  final TimeOfDay? timeOfDay =
                                      await showTimePicker(
                                        context: context,
                                        initialTime:
                                            controller.selectedStartTime,
                                      );
                                  if (timeOfDay != null) {
                                    setModelState(() {
                                      controller.selectedStartTime = timeOfDay;
                                    });
                                  }
                                },
                                child: const Text(
                                  'Choose Start Time',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                              const SizedBox(width: 40),
                              SizedBox(
                                width: 130,
                                child: TextFormField(
                                  textAlign: TextAlign.center,
                                  controller: TextEditingController(
                                    text: controller.selectedStartTime.format(
                                      context,
                                    ),
                                  ),
                                  style: const TextStyle(color: Colors.white),
                                  decoration: InputDecoration(
                                    enabled: false,
                                    iconColor: Colors.white,
                                    hintStyle: TextStyle(
                                      color: Colors.white.withValues(
                                        alpha: 0.5,
                                      ),
                                    ),
                                    focusColor: Colors.white,
                                    focusedBorder: const OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.white,
                                        width: 2.0,
                                      ), // Change color here
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(3),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          TextFormField(
                            controller: controller.detailsController,
                            keyboardType: TextInputType.multiline,
                            maxLines: 3,
                            decoration: InputDecoration(
                              labelText: 'Details',
                              iconColor: Colors.white,
                              hintText: 'Additional details about the task.',
                              hintStyle: TextStyle(
                                color: Colors.white.withValues(alpha: 0.5),
                              ),
                              labelStyle: const TextStyle(color: Colors.white),
                              focusColor: Colors.white,
                              focusedBorder: const OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.white,
                                  width: 2.0,
                                ), // Change color here
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(3),
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),
                          const Divider(height: 1, color: Colors.white),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const SizedBox(width: 12),
                              TextButton(
                                onPressed: () {
                                  Get.back();
                                },
                                child: const Text(
                                  'Cancel',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                              ElevatedButton(
                                onPressed: () async {
                                  if (controller.formKey.currentState!
                                      .validate()) {
                                    // Validate the form
                                    final dbHelper = DatabaseHelper();

                                    try {
                                      // Save the image permanently if an image is selected
                                      String? savedImagePath;
                                      if (_imageFile != null) {
                                        savedImagePath =
                                            await saveImagePermanently(
                                              _imageFile!,
                                            );
                                        if (savedImagePath == null) {
                                          // Show an error if the image could not be saved
                                          Get.snackbar(
                                            'Error',
                                            'Failed to save the image. Please try again.',
                                          );
                                          return;
                                        }
                                      }

                                      // Check if the user already exists by phone number
                                      final String phoneNumber = controller
                                          .phoneNumberController
                                          .text
                                          .replaceAll(" ", "");
                                      final User? existingUser = await dbHelper
                                          .getUserByPhone(
                                            int.parse(phoneNumber),
                                          );

                                      int userId;
                                      if (existingUser != null) {
                                        // Use the existing user's ID
                                        userId = existingUser.id!;
                                      } else {
                                        // Insert a new user
                                        final User user = User(
                                          name:
                                              controller
                                                  .ownerNameController
                                                  .text,
                                          phone: int.parse(phoneNumber),
                                        );
                                        userId = await dbHelper.insertUser(
                                          user,
                                        );
                                      }

                                      // Check if the car already exists by VIN
                                      final String vin =
                                          controller.vinController.text;
                                      final Vehicle? existingVehicle =
                                          await dbHelper.getVehicleByVin(vin);

                                      if (existingVehicle != null) {
                                        // Show a dialog informing the user to add a task to the existing car
                                        Get.dialog(
                                          AlertDialog(
                                            title: const Text(
                                              "Car Already Exists",
                                            ),
                                            content: const Text(
                                              "A car with this VIN already exists. Please add a task to this car from the correct place.",
                                            ),
                                            actions: [
                                              TextButton(
                                                onPressed: () => Get.back(),
                                                child: const Text("OK"),
                                              ),
                                            ],
                                          ),
                                        );
                                        return; // Stop further execution
                                      }

                                      // Insert Vehicle
                                      final Vehicle vehicle = Vehicle(
                                        plateNumber: int.parse(
                                          controller.plateNumberController.text,
                                        ),
                                        make:
                                            controller.carMakerController.text,
                                        model:
                                            controller.carModelController.text,
                                        vin: vin, // VIN is required
                                        year: int.parse(
                                          controller.yearController.text,
                                        ),
                                        engineType:
                                            controller
                                                    .engineTypeController
                                                    .text
                                                    .isNotEmpty
                                                ? controller
                                                    .engineTypeController
                                                    .text
                                                : null,
                                        mileage:
                                            controller
                                                    .mileageController
                                                    .text
                                                    .isNotEmpty
                                                ? int.tryParse(
                                                  controller
                                                      .mileageController
                                                      .text,
                                                )
                                                : null,
                                        imagePath:
                                            (savedImagePath == null ||
                                                    savedImagePath.isEmpty)
                                                ? 'assets/images/car.png'
                                                : savedImagePath,
                                        userId: userId,
                                      );

                                      final int vehicleId = await dbHelper
                                          .insertVehicle(vehicle);

                                      // Insert Task
                                      final Task task = Task(
                                        name:
                                            controller.taskNameController.text,
                                        status:
                                            controller.taskStatusSelected.name,
                                        timeStart: DateTime(
                                          DateTime.now().year,
                                          DateTime.now().month,
                                          DateTime.now().day,
                                          controller.selectedStartTime.hour,
                                          controller.selectedStartTime.minute,
                                        ),
                                        cost: double.parse(
                                          controller.costController.text,
                                        ),
                                        vehicleId: vehicleId,
                                        details:
                                            controller.detailsController.text,
                                      );
                                      await dbHelper.insertTask(task);

                                      // Show success message and close the bottom sheet
                                      Get.back();
                                      Get.back();
                                      _imageFile = null;
                                      Get.snackbar(
                                        'Success',
                                        'Data saved successfully!',
                                      );
                                    } catch (e) {
                                      // Handle any errors
                                      Get.snackbar(
                                        'Error',
                                        'An error occurred. $e',
                                      );
                                    }
                                  }
                                },
                                child: const Text(
                                  'Submit',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                            ],
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
