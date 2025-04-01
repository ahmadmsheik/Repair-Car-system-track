import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:inter_repair_car/Controllers/user_controller.dart';
import 'package:inter_repair_car/Controllers/user_update_controller.dart';
import 'package:inter_repair_car/Models/Entities/Client.dart';
import 'package:inter_repair_car/Views/car_list_page.dart';

final UserUpdateController updateController = UserUpdateController();

class UserCart extends StatelessWidget {
  final Client client;

  const UserCart({super.key, required this.client});

  @override
  Widget build(BuildContext context) {
    final UserController userController = Get.find<UserController>();

    return GestureDetector(
      onTap: () {
        // Navigate to CarListPage and filter by this client's vehicles
        Get.to(() => CarListPage(clientId: client.id!));
      },
      child: Dismissible(
        key: Key(client.id.toString()),
        direction: DismissDirection.horizontal,
        background: Container(
          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          height: 100,
          decoration: BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.circular(10),
          ),
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.only(left: 20),
          child: const Icon(Icons.edit, color: Colors.white, size: 30),
        ),
        secondaryBackground: Container(
          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          height: 100,
          decoration: BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.circular(10),
          ),
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.only(right: 20),
          child: const Icon(Icons.delete, color: Colors.white, size: 30),
        ),
        confirmDismiss: (direction) async {
          if (direction == DismissDirection.endToStart) {
            return await _confirmDelete(context, userController);
          } else if (direction == DismissDirection.startToEnd) {
            _showEditBottomSheet(context, userController);
            return false;
          }
          return false;
        },
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.grey[900]!,
                Colors.grey[800]!.withValues(alpha: .6),
              ],
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          height: 100,
          width: double.infinity,
          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          padding: const EdgeInsets.fromLTRB(7, 0, 20, 0),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(12, 0, 0, 0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                Text(
                  client.name,
                  style: GoogleFonts.montserrat(
                    fontSize: 24,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  client.phone.toString(),
                  style: GoogleFonts.montserrat(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: const Color.fromARGB(95, 255, 255, 255),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Helper method to show the edit bottom sheet
  void _showEditBottomSheet(
    BuildContext context,
    UserController userController,
  ) {
    updateController.nameController = TextEditingController(text: client.name);
    updateController.phoneController = TextEditingController(
      text: client.phone.toString(),
    );

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Container(
            color: Colors.grey[800],
            padding: const EdgeInsets.all(16),
            child: Form(
              key: updateController.updateUserKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Edit User Details",
                    style: GoogleFonts.montserrat(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Name is required";
                      }
                      return null;
                    },
                    controller: updateController.nameController,
                    decoration: const InputDecoration(
                      labelText: "Name",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Phone Number is required';
                      }
                      if (int.tryParse(value) == null) {
                        return "Enter a valid phone number";
                      }
                      return null;
                    },
                    maxLength: 8,
                    keyboardType: TextInputType.phone,
                    controller: updateController.phoneController,

                    decoration: const InputDecoration(
                      labelText: "Phone",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () async {
                      // Create an updated user object
                      if (updateController.updateUserKey.currentState!
                          .validate()) {
                        final updatedUser = Client(
                          id: client.id,
                          name: updateController.nameController.text,
                          phone: int.parse(
                            updateController.phoneController.text,
                          ),
                        );

                        // Update the user in the database
                        await userController.updateUser(updatedUser);

                        // Close the bottom sheet
                        Get.back();
                      }
                    },
                    child: const Text(
                      "Save Changes",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // Helper method to confirm deletion
  Future<bool> _confirmDelete(
    BuildContext context,
    UserController userController,
  ) async {
    final bool confirmDelete = await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            "Delete User",
            style: TextStyle(color: Colors.white),
          ),
          content: const Text(
            "Are you sure you want to delete this user? All related cars will also be deleted.",
          ),
          actions: [
            TextButton(
              onPressed: () => Get.back(result: false),
              child: const Text(
                "Cancel",
                style: TextStyle(color: Colors.white),
              ),
            ),
            TextButton(
              onPressed: () => Get.back(result: true),
              child: const Text(
                "Delete",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );

    if (confirmDelete) {
      // Delete the user
      await userController.deleteUser(client.id!);
    }

    return confirmDelete;
  }
}
