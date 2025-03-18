import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inter_repair_car/Widgets/car_cart.dart';
import 'package:inter_repair_car/Controllers/car_listing_controller.dart';

class CarListPage extends StatelessWidget {
  final CarListingController carListingController = Get.put(
    CarListingController(),
  );
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[850]!,
        foregroundColor: Colors.grey[800]!,
        shadowColor: Colors.grey[800]!,
        title: const Text("Cars", style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Get.back();
          },
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              const Color.fromARGB(255, 64, 83, 92),
              const Color.fromARGB(255, 92, 92, 92).withValues(alpha: .6),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          children: [
            // Search Bar
            Padding(
              padding: const EdgeInsets.all(16),
              child: TextField(
                controller: _searchController,
                onChanged: (query) {
                  carListingController.filterVehicles(query);
                },
                decoration: InputDecoration(
                  hintText: "Search cars...",
                  hintStyle: const TextStyle(color: Colors.white70),
                  prefixIcon: const Icon(Icons.search, color: Colors.white70),
                  filled: true,
                  fillColor: Colors.grey[800]!.withValues(alpha: .5),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: Colors.white.withValues(alpha: .3),
                      width: 1.0,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: Colors.white.withValues(alpha: .3),
                      width: 1.0,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: Colors.white.withValues(alpha: .5),
                      width: 1.5,
                    ),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 16,
                  ),
                ),
                style: const TextStyle(color: Colors.white),
              ),
            ),
            // List of Cars or Empty State
            Expanded(
              child: Obx(() {
                if (carListingController.isLoading.value) {
                  // Show loading indicator while data is being fetched
                  return const Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  );
                } else {
                  final filteredVehicles =
                      carListingController.filteredVehicles;

                  return filteredVehicles.isEmpty
                      ? Center(
                        child: Text(
                          "No cars found",
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white.withValues(alpha: .7),
                          ),
                        ),
                      )
                      : ListView.builder(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        itemCount: filteredVehicles.length,
                        itemBuilder: (context, index) {
                          final vehicle = filteredVehicles[index];
                          return GestureDetector(
                            onTap: () async {
                              // Navigate to the CarDetailPage with the selected vehicle ID
                              Get.toNamed('/carDetail', arguments: vehicle.id);
                            },
                            child: CarCart(
                              name: "${vehicle.make} ${vehicle.model}",
                              imagePath: vehicle.imagePath,
                              year: vehicle.year,
                              vehicleId: vehicle.id!,
                            ),
                          );
                        },
                      );
                }
              }),
            ),
          ],
        ),
      ),
    );
  }
}
