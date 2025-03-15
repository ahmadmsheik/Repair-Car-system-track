import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:inter_repair_car/Controllers/add_task_controller.dart';
import 'package:inter_repair_car/Models/Entities/Task.dart';
import 'package:inter_repair_car/Models/Entities/User.dart';
import 'package:inter_repair_car/Models/Entities/vehicle.dart';
import 'package:inter_repair_car/Models/repositories/DatabaseHelper.dart';

import 'package:inter_repair_car/Views/home_view.dart';
import 'package:inter_repair_car/Views/settings_view.dart';
import 'package:inter_repair_car/Widgets/phone_number_formatter.dart';

class NavigationMenu extends StatefulWidget {
  const NavigationMenu({super.key});

  @override
  State<NavigationMenu> createState() => _NavigationMenuState();
}

class _NavigationMenuState extends State<NavigationMenu> {
  int _slectedIndex = 0;

  final AddTaskController controller = Get.put(AddTaskController());

  void _navigateBottomBar(int index) {
    setState(() {
      _slectedIndex = index;
    });
  }

  final List<Widget> _pages = <Widget>[
    const HomeView(),
    const SettingsView(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton:
          (_slectedIndex == 0)
              ? FloatingActionButton(
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    builder: (ctx) {
                      return StatefulBuilder(
                        builder: (
                          BuildContext context,
                          StateSetter setModelState,
                        ) {
                          return Container(
                            color: Colors.blueGrey[800],
                            margin: const EdgeInsets.fromLTRB(0, 36, 0, 0),
                            child: Form(
                              key: controller.formKey,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  // Arrow at the top
                                  const Padding(
                                    padding: EdgeInsets.only(
                                      top: 12.0,
                                      bottom: 8.0,
                                    ),
                                    child: Icon(
                                      Icons.keyboard_arrow_down,
                                      size: 32,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const Divider(height: 1, color: Colors.white),
                                  Expanded(
                                    child: SingleChildScrollView(
                                      child: Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(16.0),
                                            child: Column(
                                              children: [
                                                const Row(
                                                  children: [
                                                    FaIcon(
                                                      FontAwesomeIcons.car,
                                                    ),
                                                    SizedBox(width: 12),
                                                    Text(
                                                      'Car Details',
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 24,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(height: 36),
                                                TextFormField(
                                                  validator: (value) {
                                                    if (value == null ||
                                                        value.isEmpty) {
                                                      return "Car Maker is required.";
                                                    }
                                                    return null;
                                                  },
                                                  controller:
                                                      controller
                                                          .carMakerController,
                                                  keyboardType:
                                                      TextInputType.text,
                                                  decoration: InputDecoration(
                                                    labelText: 'Car Maker*',
                                                    iconColor: Colors.white,
                                                    hintText:
                                                        'e.g., Toyota, Ford',
                                                    hintStyle: TextStyle(
                                                      color: Colors.white
                                                          .withValues(
                                                            alpha: .5,
                                                          ),
                                                    ),
                                                    labelStyle: const TextStyle(
                                                      color: Colors.white,
                                                    ),
                                                    focusColor: Colors.white,
                                                    focusedBorder:
                                                        const OutlineInputBorder(
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
                                                const SizedBox(height: 12),
                                                TextFormField(
                                                  validator: (value) {
                                                    if (value == null ||
                                                        value.isEmpty) {
                                                      return "Car Model is required";
                                                    }
                                                    return null;
                                                  },
                                                  controller:
                                                      controller
                                                          .carModelController,
                                                  keyboardType:
                                                      TextInputType.text,
                                                  decoration: InputDecoration(
                                                    labelText: 'Car Model*',
                                                    iconColor: Colors.white,
                                                    hintText:
                                                        'e.g., Camry, Mustang',
                                                    hintStyle: TextStyle(
                                                      color: Colors.white
                                                          .withValues(
                                                            alpha: .5,
                                                          ),
                                                    ),
                                                    labelStyle: const TextStyle(
                                                      color: Colors.white,
                                                    ),
                                                    focusColor: Colors.white,
                                                    focusedBorder:
                                                        const OutlineInputBorder(
                                                          borderSide: BorderSide(
                                                            color: Colors.white,
                                                            width: 2.0,
                                                          ), // Change color here
                                                        ),
                                                    border: OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            3,
                                                          ),
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(height: 12),
                                                Row(
                                                  children: [
                                                    Expanded(
                                                      child: TextFormField(
                                                        validator: (value) {
                                                          if (value == null ||
                                                              value.isEmpty) {
                                                            return 'Plate Number is required';
                                                          }
                                                          return null;
                                                        },
                                                        controller:
                                                            controller
                                                                .plateNumberController,
                                                        keyboardType:
                                                            TextInputType
                                                                .number,
                                                        maxLength: 8,
                                                        decoration: InputDecoration(
                                                          labelText:
                                                              'Plate Number*',
                                                          iconColor:
                                                              Colors.white,
                                                          hintText:
                                                              'e.g., 765 238',
                                                          hintStyle: TextStyle(
                                                            color: Colors.white
                                                                .withValues(
                                                                  alpha: .5,
                                                                ),
                                                          ),
                                                          labelStyle:
                                                              const TextStyle(
                                                                color:
                                                                    Colors
                                                                        .white,
                                                              ),
                                                          focusColor:
                                                              Colors.white,
                                                          focusedBorder:
                                                              const OutlineInputBorder(
                                                                borderSide: BorderSide(
                                                                  color:
                                                                      Colors
                                                                          .white,
                                                                  width: 2.0,
                                                                ), // Change color here
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
                                                    const SizedBox(width: 12),
                                                    Expanded(
                                                      child: TextFormField(
                                                        validator: (value) {
                                                          if (value == null ||
                                                              value.isEmpty) {
                                                            return null;
                                                          }
                                                          final int? year =
                                                              int.tryParse(
                                                                value,
                                                              );
                                                          if (year == null ||
                                                              year < 1900 ||
                                                              year >
                                                                  DateTime.now()
                                                                      .year) {
                                                            return 'Please enter a valid year';
                                                          }
                                                          return null;
                                                        },
                                                        controller:
                                                            controller
                                                                .yearController,
                                                        keyboardType:
                                                            TextInputType
                                                                .number,
                                                        maxLength: 4,
                                                        decoration: InputDecoration(
                                                          labelText: 'Year',
                                                          iconColor:
                                                              Colors.white,
                                                          hintText:
                                                              'Manufacturing year',
                                                          hintStyle: TextStyle(
                                                            color: Colors.white
                                                                .withValues(
                                                                  alpha: .5,
                                                                ),
                                                          ),
                                                          labelStyle:
                                                              const TextStyle(
                                                                color:
                                                                    Colors
                                                                        .white,
                                                              ),
                                                          focusColor:
                                                              Colors.white,
                                                          focusedBorder:
                                                              const OutlineInputBorder(
                                                                borderSide: BorderSide(
                                                                  color:
                                                                      Colors
                                                                          .white,
                                                                  width: 2.0,
                                                                ), // Change color here
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
                                                const SizedBox(height: 12),
                                                Row(
                                                  children: [
                                                    Expanded(
                                                      child: TextFormField(
                                                        controller:
                                                            controller
                                                                .engineTypeController,
                                                        keyboardType:
                                                            TextInputType.text,
                                                        decoration: InputDecoration(
                                                          labelText:
                                                              'Engine Type',
                                                          iconColor:
                                                              Colors.white,
                                                          hintText:
                                                              'e.g., V6, Electric',
                                                          hintStyle: TextStyle(
                                                            color: Colors.white
                                                                .withValues(
                                                                  alpha: .5,
                                                                ),
                                                          ),
                                                          labelStyle:
                                                              const TextStyle(
                                                                color:
                                                                    Colors
                                                                        .white,
                                                              ),
                                                          focusColor:
                                                              Colors.white,
                                                          focusedBorder:
                                                              const OutlineInputBorder(
                                                                borderSide: BorderSide(
                                                                  color:
                                                                      Colors
                                                                          .white,
                                                                  width: 2.0,
                                                                ), // Change color here
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
                                                    const SizedBox(width: 12),
                                                    Expanded(
                                                      child: TextFormField(
                                                        validator: (value) {
                                                          if (value == null ||
                                                              value.isEmpty) {
                                                            return null;
                                                          }
                                                          final double?
                                                          mileage =
                                                              double.tryParse(
                                                                value,
                                                              );
                                                          if (mileage == null ||
                                                              mileage < 0) {
                                                            return 'Please enter a valid mileage';
                                                          }
                                                          return null;
                                                        },
                                                        controller:
                                                            controller
                                                                .mileageController,
                                                        keyboardType:
                                                            TextInputType
                                                                .number,
                                                        decoration: InputDecoration(
                                                          labelText: 'Mileage',
                                                          iconColor:
                                                              Colors.white,
                                                          hintText:
                                                              'Current mileage of the vehicle in km.',
                                                          hintStyle: TextStyle(
                                                            color: Colors.white
                                                                .withValues(
                                                                  alpha: .5,
                                                                ),
                                                          ),
                                                          labelStyle:
                                                              const TextStyle(
                                                                color:
                                                                    Colors
                                                                        .white,
                                                              ),
                                                          focusColor:
                                                              Colors.white,
                                                          focusedBorder:
                                                              const OutlineInputBorder(
                                                                borderSide: BorderSide(
                                                                  color:
                                                                      Colors
                                                                          .white,
                                                                  width: 2.0,
                                                                ), // Change color here
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
                                                const SizedBox(height: 12),
                                                TextFormField(
                                                  controller:
                                                      controller.vinController,
                                                  keyboardType:
                                                      TextInputType.text,
                                                  decoration: InputDecoration(
                                                    labelText: 'VIN',
                                                    iconColor: Colors.white,
                                                    hintText:
                                                        'Vehicle Identification Number.',
                                                    hintStyle: TextStyle(
                                                      color: Colors.white
                                                          .withValues(
                                                            alpha: .5,
                                                          ),
                                                    ),
                                                    labelStyle: const TextStyle(
                                                      color: Colors.white,
                                                    ),
                                                    focusColor: Colors.white,
                                                    focusedBorder:
                                                        const OutlineInputBorder(
                                                          borderSide: BorderSide(
                                                            color: Colors.white,
                                                            width: 2.0,
                                                          ), // Change color here
                                                        ),
                                                    border: OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            3,
                                                          ),
                                                    ),
                                                  ),
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
                                                    FaIcon(
                                                      FontAwesomeIcons.userTag,
                                                    ),
                                                    SizedBox(width: 12),
                                                    Text(
                                                      'Owner Details',
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 24,
                                                        fontWeight:
                                                            FontWeight.w500,
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
                                                          if (value == null ||
                                                              value.isEmpty) {
                                                            return "Full Name is required";
                                                          }
                                                          return null;
                                                        },
                                                        controller:
                                                            controller
                                                                .ownerNameController,
                                                        keyboardType:
                                                            TextInputType.name,
                                                        maxLength: 50,
                                                        decoration: InputDecoration(
                                                          labelText:
                                                              'Full Name*',
                                                          iconColor:
                                                              Colors.white,
                                                          hintText:
                                                              'e.g., John Doe',
                                                          hintStyle: TextStyle(
                                                            color: Colors.white
                                                                .withValues(
                                                                  alpha: .5,
                                                                ),
                                                          ),
                                                          labelStyle:
                                                              const TextStyle(
                                                                color:
                                                                    Colors
                                                                        .white,
                                                              ),
                                                          focusColor:
                                                              Colors.white,
                                                          focusedBorder:
                                                              const OutlineInputBorder(
                                                                borderSide: BorderSide(
                                                                  color:
                                                                      Colors
                                                                          .white,
                                                                  width: 2.0,
                                                                ), // Change color here
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
                                                    const SizedBox(width: 12),
                                                    Expanded(
                                                      flex: 2,
                                                      child: TextFormField(
                                                        validator: (value) {
                                                          if (value == null ||
                                                              value.isEmpty) {
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
                                                        controller:
                                                            controller
                                                                .phoneNumberController,
                                                        keyboardType:
                                                            TextInputType.phone,
                                                        inputFormatters: [
                                                          PhoneNumberFormatter(), // Apply the custom formatter
                                                          LengthLimitingTextInputFormatter(
                                                            11,
                                                          ),
                                                        ],
                                                        decoration: InputDecoration(
                                                          labelText:
                                                              'Phone Number*',
                                                          iconColor:
                                                              Colors.white,
                                                          hintText:
                                                              'e.g., 12 345 678',
                                                          hintStyle: TextStyle(
                                                            color: Colors.white
                                                                .withValues(
                                                                  alpha: .5,
                                                                ),
                                                          ),
                                                          labelStyle:
                                                              const TextStyle(
                                                                color:
                                                                    Colors
                                                                        .white,
                                                              ),
                                                          focusColor:
                                                              Colors.white,
                                                          focusedBorder:
                                                              const OutlineInputBorder(
                                                                borderSide: BorderSide(
                                                                  color:
                                                                      Colors
                                                                          .white,
                                                                  width: 2.0,
                                                                ), // Change color here
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
                                                    FaIcon(
                                                      FontAwesomeIcons
                                                          .barsProgress,
                                                    ),
                                                    SizedBox(width: 12),
                                                    Text(
                                                      'Task Details',
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 24,
                                                        fontWeight:
                                                            FontWeight.w500,
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
                                                          if (value == null ||
                                                              value.isEmpty) {
                                                            return 'Task Name is required';
                                                          }
                                                          return null;
                                                        },
                                                        controller:
                                                            controller
                                                                .taskNameController,
                                                        keyboardType:
                                                            TextInputType.text,
                                                        decoration: InputDecoration(
                                                          labelText:
                                                              'Task Name*',
                                                          iconColor:
                                                              Colors.white,
                                                          hintText:
                                                              'e.g., Replace Brake Pads.',
                                                          hintStyle: TextStyle(
                                                            color: Colors.white
                                                                .withValues(
                                                                  alpha: .5,
                                                                ),
                                                          ),
                                                          labelStyle:
                                                              const TextStyle(
                                                                color:
                                                                    Colors
                                                                        .white,
                                                              ),
                                                          focusColor:
                                                              Colors.white,
                                                          focusedBorder:
                                                              const OutlineInputBorder(
                                                                borderSide: BorderSide(
                                                                  color:
                                                                      Colors
                                                                          .white,
                                                                  width: 2.0,
                                                                ), // Change color here
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
                                                    const SizedBox(width: 12),
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
                                                            return 'Please enter a valid number';
                                                          }
                                                          return null;
                                                        },
                                                        controller:
                                                            controller
                                                                .costController,
                                                        keyboardType:
                                                            TextInputType
                                                                .number,
                                                        decoration: InputDecoration(
                                                          labelText: 'Cost*',
                                                          iconColor:
                                                              Colors.white,
                                                          labelStyle:
                                                              const TextStyle(
                                                                color:
                                                                    Colors
                                                                        .white,
                                                              ),
                                                          focusColor:
                                                              Colors.white,
                                                          focusedBorder:
                                                              const OutlineInputBorder(
                                                                borderSide:
                                                                    BorderSide(
                                                                      color:
                                                                          Colors
                                                                              .white,
                                                                      width:
                                                                          2.0,
                                                                    ),
                                                                // Change color here
                                                              ),
                                                          border: OutlineInputBorder(
                                                            borderRadius:
                                                                BorderRadius.circular(
                                                                  3,
                                                                ),
                                                          ),
                                                          prefixText: '\$',
                                                          prefixStyle:
                                                              const TextStyle(
                                                                color:
                                                                    Colors
                                                                        .white,
                                                              ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(height: 12),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceAround,
                                                  children: [
                                                    const Padding(
                                                      padding:
                                                          EdgeInsets.fromLTRB(
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
                                                              .withValues(
                                                                alpha: .2,
                                                              ),
                                                          width: 1,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              3,
                                                            ),
                                                      ),
                                                      child: DropdownButton(
                                                        value:
                                                            controller
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
                                                              controller
                                                                      .taskStatusSelected =
                                                                  value;
                                                            });
                                                          }
                                                        },
                                                        dropdownColor:
                                                            Colors
                                                                .blueGrey[800],
                                                        style: const TextStyle(
                                                          color: Colors.white,
                                                        ),
                                                        underline: Container(),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(height: 18),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    ElevatedButton(
                                                      onPressed: () async {
                                                        final TimeOfDay?
                                                        timeOfDay =
                                                            await showTimePicker(
                                                              context: context,
                                                              initialTime:
                                                                  controller
                                                                      .selectedStartTime,
                                                            );
                                                        if (timeOfDay != null) {
                                                          setModelState(() {
                                                            controller
                                                                    .selectedStartTime =
                                                                timeOfDay;
                                                          });
                                                        }
                                                      },
                                                      child: const Text(
                                                        'Choose Start Time',
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(width: 40),
                                                    SizedBox(
                                                      width: 130,
                                                      child: TextFormField(
                                                        textAlign:
                                                            TextAlign.center,
                                                        controller:
                                                            TextEditingController(
                                                              text: controller
                                                                  .selectedStartTime
                                                                  .format(
                                                                    context,
                                                                  ),
                                                            ),
                                                        style: const TextStyle(
                                                          color: Colors.white,
                                                        ),
                                                        decoration: InputDecoration(
                                                          enabled: false,
                                                          iconColor:
                                                              Colors.white,
                                                          hintStyle: TextStyle(
                                                            color: Colors.white
                                                                .withValues(
                                                                  alpha: 0.5,
                                                                ),
                                                          ),
                                                          focusColor:
                                                              Colors.white,
                                                          focusedBorder:
                                                              const OutlineInputBorder(
                                                                borderSide: BorderSide(
                                                                  color:
                                                                      Colors
                                                                          .white,
                                                                  width: 2.0,
                                                                ), // Change color here
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
                                                const SizedBox(height: 12),
                                                TextFormField(
                                                  controller:
                                                      controller
                                                          .detailsController,
                                                  keyboardType:
                                                      TextInputType.multiline,
                                                  maxLines: 3,
                                                  decoration: InputDecoration(
                                                    labelText: 'Details',
                                                    iconColor: Colors.white,
                                                    hintText:
                                                        'Additional details about the task.',
                                                    hintStyle: TextStyle(
                                                      color: Colors.white
                                                          .withValues(
                                                            alpha: 0.5,
                                                          ),
                                                    ),
                                                    labelStyle: const TextStyle(
                                                      color: Colors.white,
                                                    ),
                                                    focusColor: Colors.white,
                                                    focusedBorder:
                                                        const OutlineInputBorder(
                                                          borderSide: BorderSide(
                                                            color: Colors.white,
                                                            width: 2.0,
                                                          ), // Change color here
                                                        ),
                                                    border: OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            3,
                                                          ),
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(height: 24),
                                                const Divider(
                                                  height: 1,
                                                  color: Colors.white,
                                                ),
                                                const SizedBox(height: 12),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
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
                                                        if (controller
                                                            .formKey
                                                            .currentState!
                                                            .validate()) {
                                                          // Add the objects to the database

                                                          final dbHelper =
                                                              DatabaseHelper();

                                                          // Insert the objects into the database
                                                          try {
                                                            final User
                                                            user = User(
                                                              name:
                                                                  controller
                                                                      .ownerNameController
                                                                      .text,
                                                              phone: int.parse(
                                                                controller
                                                                    .phoneNumberController
                                                                    .text
                                                                    .replaceAll(
                                                                      " ",
                                                                      "",
                                                                    ),
                                                              ),
                                                            );

                                                            // Insert User
                                                            final userId =
                                                                await dbHelper
                                                                    .insertUser(
                                                                      user,
                                                                    );

                                                            final Vehicle
                                                            vehicle = Vehicle(
                                                              plateNumber:
                                                                  int.parse(
                                                                    controller
                                                                        .plateNumberController
                                                                        .text,
                                                                  ),
                                                              make:
                                                                  controller
                                                                      .carMakerController
                                                                      .text,
                                                              model:
                                                                  controller
                                                                      .carModelController
                                                                      .text,
                                                              vin:
                                                                  (controller
                                                                          .vinController
                                                                          .text
                                                                          .isNotEmpty)
                                                                      ? controller
                                                                          .vinController
                                                                          .text
                                                                      : null,
                                                              year:
                                                                  (controller
                                                                          .yearController
                                                                          .text
                                                                          .isNotEmpty)
                                                                      ? int.tryParse(
                                                                        controller
                                                                            .yearController
                                                                            .text,
                                                                      )
                                                                      : null,
                                                              engineType:
                                                                  (controller
                                                                          .engineTypeController
                                                                          .text
                                                                          .isNotEmpty)
                                                                      ? controller
                                                                          .engineTypeController
                                                                          .text
                                                                      : null,
                                                              mileage:
                                                                  (controller
                                                                          .mileageController
                                                                          .text
                                                                          .isNotEmpty)
                                                                      ? int.tryParse(
                                                                        controller
                                                                            .mileageController
                                                                            .text,
                                                                      )
                                                                      : null,
                                                              userId: userId,
                                                            );

                                                            // Insert Vehicle
                                                            final vehicleId =
                                                                await dbHelper
                                                                    .insertVehicle(
                                                                      vehicle,
                                                                    );

                                                            final Task
                                                            task = Task(
                                                              name:
                                                                  controller
                                                                      .taskNameController
                                                                      .text,
                                                              status:
                                                                  controller
                                                                      .taskStatusSelected
                                                                      .name,
                                                              timeStart: DateTime(
                                                                DateTime.now()
                                                                    .year,
                                                                DateTime.now()
                                                                    .month,
                                                                DateTime.now()
                                                                    .day,
                                                                controller
                                                                    .selectedStartTime
                                                                    .hour,
                                                                controller
                                                                    .selectedStartTime
                                                                    .minute,
                                                              ),
                                                              cost: double.parse(
                                                                controller
                                                                    .costController
                                                                    .text,
                                                              ),
                                                              vehicleId:
                                                                  vehicleId,
                                                              details: '',
                                                            );

                                                            // Insert Task

                                                            await dbHelper
                                                                .insertTask(
                                                                  task,
                                                                );
                                                            // print(
                                                            //   'Task inserted with id: $taskId',
                                                            // );

                                                            // Optionally, you can link the Task to the Vehicle or User using their IDs
                                                            // For example, you could add a `vehicleId` field to the Task model and set it here:
                                                            // task.vehicleId = vehicleId;
                                                            // Then update the Task in the database:
                                                            // await dbHelper.updateTask(task);

                                                            // Show a success message or navigate back
                                                            Get.back();
                                                            Get.snackbar(
                                                              'Success',
                                                              'Data saved successfully!',
                                                            );
                                                          } catch (e) {
                                                            // Handle any errors that occur during database operations
                                                            Get.snackbar(
                                                              'Error',
                                                              'Please contact us!',
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
                                                const SizedBox(height: 20,)
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                  );
                },
                hoverColor: Colors.blueGrey[900],
                backgroundColor: Colors.blueGrey[800],
                child: const Icon(Icons.add),
              )
              : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      appBar: AppBar(title: const Text('Repair Car Track System')),
      body: _pages[_slectedIndex],
      
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.white, // Color for selected label and icon
        unselectedItemColor: Colors.grey, // Color for unselected label and icon
        selectedIconTheme: IconThemeData(
          color: Colors.white, // Color for selected icon
        ),
        unselectedIconTheme: IconThemeData(
          color: Colors.grey, // Color for unselected icon
        ),
        onTap: _navigateBottomBar,
        currentIndex: _slectedIndex,
        items: const [
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.house),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.gear),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}
