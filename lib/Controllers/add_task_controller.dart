import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inter_repair_car/Models/Entities/Task.dart';

class AddTaskController extends GetxController {
  Status taskStatusSelected = Status.onGoing;

  TimeOfDay selectedStartTime = TimeOfDay.now();

  final formKey = GlobalKey<FormState>();

  final TextEditingController carMakerController = TextEditingController();

  final TextEditingController carModelController = TextEditingController();

  final TextEditingController plateNumberController = TextEditingController();

  final TextEditingController yearController = TextEditingController();

  final TextEditingController engineTypeController = TextEditingController();

  final TextEditingController mileageController = TextEditingController();

  final TextEditingController vinController = TextEditingController();

  final TextEditingController ownerNameController = TextEditingController();

  final TextEditingController phoneNumberController = TextEditingController();

  final TextEditingController taskNameController = TextEditingController();

  final TextEditingController costController = TextEditingController();

  final TextEditingController detailsController = TextEditingController();
}
