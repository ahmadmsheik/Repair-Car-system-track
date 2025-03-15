import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inter_repair_car/Widgets/car_cart.dart';

class CarListPage extends StatefulWidget {
  const CarListPage({super.key});

  @override
  _CarListPageState createState() => _CarListPageState();
}

class _CarListPageState extends State<CarListPage> {
  final TextEditingController _searchController = TextEditingController();
  List<String> carNames = [
    "Tesla Model X",
    "Toyota Camry",
    "Ford Mustang",
    "BMW X5",
    "Audi A4",
    "Honda Civic",
  ]; // Dummy car names
  List<String> filteredCars = [];

  @override
  void initState() {
    super.initState();
    filteredCars = carNames; // Initialize with all cars
  }

  // Filter cars based on search query
  void _filterCars(String query) {
    setState(() {
      filteredCars = carNames
          .where((name) => name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

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
                onChanged: _filterCars,
                decoration: InputDecoration(
                  hintText: "Search cars...",
                  hintStyle: const TextStyle(color: Colors.white70),
                  prefixIcon: const Icon(Icons.search, color: Colors.white70),
                  filled: true,
                  fillColor: Colors.grey[800]!.withValues(alpha: .5),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: Colors.white.withValues(alpha: .3), // White border with low opacity
                      width: 1.0, // Border width
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: Colors.white.withValues(alpha: .3), // White border with low opacity
                      width: 1.0, // Border width
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: Colors.white.withValues(alpha: .5), // Slightly more opacity when focused
                      width: 1.5, // Slightly thicker border when focused
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
            // List of Cars
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 16),
                itemCount: filteredCars.length,
                itemBuilder: (context, index) {
                  return CarCart(name: filteredCars[index]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}