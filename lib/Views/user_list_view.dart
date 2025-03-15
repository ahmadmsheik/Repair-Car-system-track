import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inter_repair_car/Controllers/user_list_controller.dart';
import 'package:inter_repair_car/Widgets/user_cart.dart';

class UserListView extends StatefulWidget {
  const UserListView({super.key});

  @override
  _UserListViewState createState() => _UserListViewState();
}

class _UserListViewState extends State<UserListView> {
  final UserListController controller = UserListController();
  List<String> clientNames = [
    "John Doe",
    "Jane Smith",
    "Alice Johnson",
    "Bob Brown",
    "Charlie Davis",
    "Eva Wilson",
  ]; // Dummy client names
  List<String> filteredClients = [];

  @override
  void initState() {
    super.initState();
    filteredClients = clientNames; // Initialize with all clients
  }

  // Filter clients based on search query
  void _filterClients(String query) {
    setState(() {
      filteredClients =
          clientNames
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
        title: const Text("Clients", style: TextStyle(color: Colors.white)),
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
                controller: controller.searchController,
                onChanged: _filterClients,
                decoration: InputDecoration(
                  hintText: "Search clients...",
                  hintStyle: const TextStyle(color: Colors.white70),
                  prefixIcon: const Icon(Icons.search, color: Colors.white70),
                  filled: true,
                  fillColor: Colors.grey[800]!.withValues(alpha: .5),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: Colors.white.withValues(
                        alpha: .3,
                      ), // White border with low opacity
                      width: 1.0, // Border width
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: Colors.white.withValues(
                        alpha: .3,
                      ), // White border with low opacity
                      width: 1.0, // Border width
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: Colors.white.withValues(
                        alpha: .5,
                      ), // Slightly more opacity when focused
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
            // List of Clients
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 16),
                itemCount: filteredClients.length,
                itemBuilder: (context, index) {
                  return UserCart(name: filteredClients[index]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
