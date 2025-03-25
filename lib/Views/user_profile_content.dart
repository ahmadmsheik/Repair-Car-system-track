import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inter_repair_car/Controllers/authentication_controller.dart';
import 'package:inter_repair_car/Controllers/back_up_controller.dart';
import 'package:intl/intl.dart';

final AuthenticationController authenticationController = Get.put(
  AuthenticationController(),
);

final BackUpController backUpController = Get.put(BackUpController());

class UserProfileContent extends StatelessWidget {
  const UserProfileContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CircleAvatar(
          radius: 60,
          backgroundImage: const AssetImage("assets/images/avatar.jpg"),
        ),
        const SizedBox(height: 20),
        Text(
          authenticationController.userName.value,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 10),
        _buildBackupButton(context),
        const SizedBox(height: 20), // Space between buttons
        _buildGetDataButton(context), // New "Get Data" button
        const SizedBox(height: 30),
        _buildProfileInfo(),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: authenticationController.logout,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blueGrey[800],
            foregroundColor: Colors.white,
          ),
          child: const Text("Logout"),
        ),
      ],
    );
  }

  Widget _buildBackupButton(BuildContext context) {
    return GestureDetector(
      onTap: () => _handleBackup(context),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.blueGrey[800],
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.white, width: 1),
        ),
        child: const Text(
          "Backup Data",
          style: TextStyle(fontSize: 16, color: Colors.white),
        ),
      ),
    );
  }

  void _handleRestore(BuildContext context) async {
    // Show loading dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (context) => const AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(color: Colors.white),
                SizedBox(height: 16),
                Text("Restoring data from cloud..."),
              ],
            ),
          ),
    );

    try {
      await backUpController.restoreFromCloud();
      Navigator.pop(context); // Close loading dialog

      // Show success
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Data restored successfully!"),
          backgroundColor: Colors.green,
        ),
      );

      // Optional: Refresh UI state
      // Get.find<YourDataController>().refreshData();
    } catch (e) {
      Get.back(); // Close loading dialog

      // Show error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Restore failed: ${e.toString()}"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Widget _buildGetDataButton(BuildContext context) {
    return GestureDetector(
      onTap: () => _handleRestore(context),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.blueGrey[800],
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.white, width: 1),
        ),
        child: const Text(
          "Get Data",
          style: TextStyle(fontSize: 16, color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildProfileInfo() {
    return Card(
      color: Colors.blueGrey[800],
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: _buildProfileItem(
          "Joined",
          DateFormat.yMMM().format(authenticationController.joinDate.value),
        ),
      ),
    );
  }

  Widget _buildProfileItem(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 16, color: Colors.white70),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  void _handleBackup(BuildContext context) async {
    // Show a loading dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (context) => const AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(color: Colors.white),
                SizedBox(height: 16),
                Text("Backing up data..."),
              ],
            ),
          ),
    );

    // Call the backup method
    try {
      await backUpController.backupData();
      Navigator.pop(context); // Close the loading dialog

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Backup completed successfully!"),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      Get.back();

      // Show an error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Backup failed: ${e.toString()}"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
