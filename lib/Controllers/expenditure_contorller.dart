import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inter_repair_car/Models/Entities/Expenditure.dart';

class ExpenditureController extends GetxController {
  // Form key
  final formKey = GlobalKey<FormState>();

  // Text editing controllers
  final nameController = TextEditingController();
  final amountController = TextEditingController();
  final descriptionController = TextEditingController();

  // Dropdown value
  final expenseTypes = ['Rent', 'Utilities', 'Salary'];
  var selectedExpenseType = 'Rent'.obs;
  var dueDate = Rxn<DateTime>();

  // Initialize with existing expenditure (for edit mode)
  void initExpenditure(Expenditure? expenditure) {
    if (expenditure != null) {
      nameController.text = expenditure.name;
      selectedExpenseType.value = expenditure.expenseType;
      amountController.text = expenditure.amount.toString();
      descriptionController.text = expenditure.description ?? '';
      dueDate.value = expenditure.dueDate;
    } else {
      clearForm();
    }
  }

  // In expenditure_controller.dart
  void updateDueDate(DateTime? newDate) {
    dueDate.value = newDate;
    update(); // This triggers the Obx listeners
  }

  // Clear the form
  void clearForm() {
    nameController.clear();
    selectedExpenseType.value = 'Rent';
    amountController.clear();
    descriptionController.clear();
    dueDate.value = null;
  }

  // Validate and return expenditure
  Expenditure? validateAndReturnExpenditure(int? id) {
    if (formKey.currentState?.validate() ?? false) {
      return Expenditure(
        id: id,
        name: nameController.text,
        expenseType: selectedExpenseType.value,
        amount: double.parse(amountController.text),
        dueDate: dueDate.value,
        description:
            descriptionController.text.isEmpty
                ? null
                : descriptionController.text,
      );
    }
    return null;
  }

  // Dispose controllers
  @override
  void onClose() {
    nameController.dispose();
    amountController.dispose();
    descriptionController.dispose();
    super.onClose();
  }
}
