import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/state_manager.dart';

class UserProfileView extends StatelessWidget {
  final String name; // User's name (optional)

  const UserProfileView({
    super.key,
    this.name = "User", // Default name if not provided
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
        backgroundColor: Colors.blueGrey[900],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.grey[900]!,
              Colors.grey[800]!.withValues(alpha: .6),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Avatar
            CircleAvatar(
              radius: 60,
              backgroundImage: AssetImage(
                "assets/images/avatar.jpg",
              ), // Your avatar image
            ),
            const SizedBox(height: 20),
            // User Name
            Text(
              name,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 10),
            // Backup Button
            Container(
              margin: const EdgeInsets.symmetric(vertical: 20),
              child: InkWell(
                onTap: () {
                  _handleBackup(context); // Handle backup logic
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
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
              ),
            ),
            const SizedBox(height: 30),
            // Additional Information (Optional)
            Card(
              color: Colors.blueGrey[800],
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _buildProfileItem("Joined", "October 2023"), // Example data
                    const SizedBox(height: 10),
                    _buildProfileItem("Tasks Completed", "15"), // Example data
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to build profile items
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

  // Backup logic
  void _handleBackup(BuildContext context) {
    // Show a loading indicator
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return const AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text("Backing up data..."),
            ],
          ),
        );
      },
    );

    // Simulate a backup process (replace with actual logic)
    Future.delayed(const Duration(seconds: 2), () {
      // Close the loading dialog
      Get.back();

      // Show a success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "No Backup functionality for this version!",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.red,
        ),
      );
    });
  }
}
