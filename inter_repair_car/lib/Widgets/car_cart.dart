import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:inter_repair_car/Models/repositories/DatabaseHelper.dart'; // Import DatabaseHelper

final dbHelper = DatabaseHelper();

class CarCart extends StatelessWidget {
  const CarCart({
    super.key,
    required this.name,
    required this.imagePath,
    required this.year,
    required this.vehicleId,
  });

  final String name;
  final String imagePath;
  final int year;
  final int vehicleId;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(name), // Use name as the key
      direction: DismissDirection.endToStart, // Swipe from right to left
      background: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        height: 150,
        decoration: BoxDecoration(
          color: Colors.red, // Red background for the delete action
          borderRadius: BorderRadius.circular(20),
        ),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: const Icon(Icons.delete, color: Colors.white, size: 30),
      ),
      confirmDismiss: (direction) async {
        // Show a confirmation dialog for deletion
        return await _confirmDelete(context);
      },
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.grey[900]!,
              Colors.grey[800]!.withValues(alpha: .6),
            ],
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        width: double.infinity,
        height: 150,
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        padding: const EdgeInsets.fromLTRB(7, 0, 20, 0),
        child: Row(
          children: [
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.grey[900]!,
                    Colors.grey[800]!.withValues(alpha: .6),
                  ],
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child:
                    (imagePath == 'assets/images/car.png')
                        ? Image.asset(
                          imagePath,
                          width: 160,
                          height: 130,
                          fit: BoxFit.cover,
                        )
                        : Image.file(
                          File(imagePath),
                          width: 160,
                          height: 130,
                          fit: BoxFit.cover,
                        ),
              ),
            ),
            const SizedBox(width: 50),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    name,
                    style: GoogleFonts.montserrat(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                    overflow:
                        TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  Text(
                    "$year",
                    style: GoogleFonts.montserrat(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: const Color.fromARGB(95, 255, 255, 255),
                    ),
                  ),
                  FutureBuilder<double>(
                    future: DatabaseHelper().calculateTotalCostForVehicle(
                      vehicleId,
                    ),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return Text(
                          'Error: ${snapshot.error}',
                          style: GoogleFonts.montserrat(
                            fontSize: 16,
                            color: Colors.red,
                          ),
                        );
                      } else {
                        final totalCost = snapshot.data ?? 0.0;
                        return RichText(
                          text: TextSpan(
                            style: GoogleFonts.montserrat(
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                            children: <TextSpan>[
                              TextSpan(
                                style: GoogleFonts.montserrat(
                                  fontSize: 16,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                ),
                                text: '\$${totalCost.toStringAsFixed(2)}',
                              ),
                            ],
                          ),
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to confirm deletion
  Future<bool> _confirmDelete(BuildContext context) async {
    final bool confirmDelete = await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            "Delete Car",
            style: TextStyle(color: Colors.white),
          ),
          content: const Text("Are you sure you want to delete this car?"),
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
      try {
        await dbHelper.deleteVehicle(vehicleId);
        Get.snackbar(
          'Success',
          'Car deleted successfully!',
          snackPosition: SnackPosition.BOTTOM,
        );
        return true;
      } catch (e) {
        Get.snackbar(
          'Error',
          'Failed to delete the car. Please try again.',
          snackPosition: SnackPosition.BOTTOM,
        );
        return false;
      }
    }

    return false;
  }
}
