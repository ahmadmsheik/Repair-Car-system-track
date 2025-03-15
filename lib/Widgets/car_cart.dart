import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class CarCart extends StatelessWidget {
  const CarCart({super.key, required this.name});

  final String name;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: const Key("carCart"), // Unique key for the Dismissible widget
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
      child: GestureDetector(
        onTap: () {
          Get.toNamed('/carDetail');
        },
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.grey[900]!,
                Colors.grey[800]!.withValues(alpha: 0.6),
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
                      Colors.grey[800]!.withValues(alpha: 0.6),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.asset(
                    "assets/images/car.png",
                    width: 160,
                    height: 130,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: 50),
              Column(
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
                  ),
                  Text(
                    "2008",
                    style: GoogleFonts.montserrat(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: const Color.fromARGB(95, 255, 255, 255),
                    ),
                  ),
                  RichText(
                    text: TextSpan(
                      style: GoogleFonts.montserrat(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                      children: const <TextSpan>[TextSpan(text: '\$180')],
                    ),
                  ),
                ],
              ),
            ],
          ),
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
      // Call the onDelete callback (if you have one)
      // Example: onDelete();
    }

    return confirmDelete;
  }
}
