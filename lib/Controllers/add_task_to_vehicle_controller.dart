import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:inter_repair_car/Models/Entities/Task.dart';

class AddTaskToVehicleController {
  final TextEditingController taskNameController = TextEditingController();
  final TextEditingController taskDetailsController = TextEditingController();
  final TextEditingController taskTimeStartController = TextEditingController();
  final TextEditingController taskTimeEndController = TextEditingController();
  final TextEditingController taskCostController = TextEditingController();
  final TextEditingController taskCurrentMileageController = TextEditingController();

  TimeOfDay selectedStartTime = TimeOfDay.now();
  Status taskStatusSelected = Status.onGoing;

  final GlobalKey<FormState> addTaskKey = GlobalKey<FormState>();

  void clearFields() {
    taskNameController.clear();
    taskDetailsController.clear();
    taskTimeStartController.clear();
    taskTimeEndController.clear();
    taskCostController.clear();
    taskCurrentMileageController.clear();
  }
}
