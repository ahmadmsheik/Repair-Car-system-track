import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inter_repair_car/Controllers/expenditure_contorller.dart';
import 'package:inter_repair_car/Models/Entities/Expenditure.dart';

class AddExpenditureSheet extends StatelessWidget {
  final Function(Expenditure) onSave;
  final Expenditure? existingExpenditure;

  const AddExpenditureSheet({
    Key? key,
    required this.onSave,
    this.existingExpenditure,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ExpenditureController());
    controller.initExpenditure(existingExpenditure);

    return Container(
      padding: EdgeInsets.fromLTRB(0, 0, 0, 24),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SingleChildScrollView(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: controller.formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  existingExpenditure == null
                      ? 'Add New Expenditure'
                      : 'Update Expenditure',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: controller.nameController,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    labelText: 'Name',
                    labelStyle: TextStyle(color: Colors.white70),
                    border: OutlineInputBorder(),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white70),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                Obx(
                  () => DropdownButtonFormField<String>(
                    value: controller.selectedExpenseType.value,
                    dropdownColor: Colors.grey[800],
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      labelText: 'Expense Type',
                      labelStyle: TextStyle(color: Colors.white70),
                      border: OutlineInputBorder(),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white70),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                    ),
                    items:
                        controller.expenseTypes.map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(
                              value,
                              style: const TextStyle(color: Colors.white),
                            ),
                          );
                        }).toList(),
                    onChanged: (newValue) {
                      controller.selectedExpenseType.value = newValue!;
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select an expense type';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: controller.amountController,
                  style: const TextStyle(color: Colors.white),
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Amount',
                    labelStyle: TextStyle(color: Colors.white70),
                    prefixText: '\$',
                    prefixStyle: TextStyle(color: Colors.white),
                    border: OutlineInputBorder(),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white70),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter an amount';
                    }
                    if (double.tryParse(value) == null) {
                      return 'Please enter a valid number';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                // Replace the existing InkWell with this updated version
                InkWell(
                  onTap: () async {
                    final selectedDate = await showDatePicker(
                      context: context,
                      initialDate: controller.dueDate.value ?? DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                      builder: (context, child) {
                        return Theme(
                          data: Theme.of(context).copyWith(
                            colorScheme: ColorScheme.dark(
                              primaryContainer: Colors.white,
                              onPrimaryContainer: Colors.black,
                              onSurface: Colors.white,
                            ),
                            textButtonTheme: TextButtonThemeData(
                              style: TextButton.styleFrom(
                                foregroundColor: Colors.white,
                              ),
                            ),
                          ),
                          child: child!,
                        );
                      },
                    );
                    if (selectedDate != null) {
                      controller.updateDueDate(
                        selectedDate,
                      ); // Use the new method
                    }
                  },
                  child: Obx(
                    () => InputDecorator(
                      decoration: const InputDecoration(
                        labelText: 'Due Date (optional)',
                        labelStyle: TextStyle(color: Colors.white70),
                        border: OutlineInputBorder(),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white70),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            controller.dueDate.value != null
                                ? '${controller.dueDate.value!.day}/${controller.dueDate.value!.month}/${controller.dueDate.value!.year}'
                                : 'Select date',
                            style: const TextStyle(color: Colors.white),
                          ),
                          const Icon(Icons.calendar_today, color: Colors.white),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: controller.descriptionController,
                  style: const TextStyle(color: Colors.white),
                  maxLines: 3,
                  decoration: const InputDecoration(
                    labelText: 'Description (optional)',
                    labelStyle: TextStyle(color: Colors.white70),
                    border: OutlineInputBorder(),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white70),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueGrey[700],
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  onPressed: () {
                    final expenditure = controller.validateAndReturnExpenditure(
                      existingExpenditure?.id,
                    );
                    if (expenditure != null) {
                      onSave(expenditure);
                      Get.back();
                    }
                  },
                  child: Text(
                    existingExpenditure == null
                        ? 'Add Expenditure'
                        : 'Update Expenditure',
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
