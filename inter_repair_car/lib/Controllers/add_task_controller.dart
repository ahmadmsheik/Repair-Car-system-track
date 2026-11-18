import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inter_repair_car/Models/Entities/Part.dart';

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

    final TextEditingController currentTaskMileage = TextEditingController();

  // Add to your AddTaskController
  RxList<Part> parts = <Part>[].obs;
  var showPartFields = false.obs;
  final partNameController = TextEditingController();
  final partSupplierController = TextEditingController();
  final partPriceController = TextEditingController();
}
