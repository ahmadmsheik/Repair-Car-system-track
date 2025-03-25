import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inter_repair_car/Controllers/user_controller.dart'; // Import the controller
import 'package:inter_repair_car/Models/Entities/Client.dart';
import 'package:inter_repair_car/Widgets/user_cart.dart';

class UserListView extends StatefulWidget {
  const UserListView({super.key});

  @override
  _UserListViewState createState() => _UserListViewState();
}

class _UserListViewState extends State<UserListView> {
  final UserController _userController = Get.put(
    UserController(),
  ); // Initialize the controller
  final TextEditingController _searchController = TextEditingController();
  List<Client> filteredUsers = [];

  @override
  void initState() {
    super.initState();
    _userController.fetchUsers(); // Fetch users when the view initializes
  }

  // Filter users based on search query
  void _filterUsers(String query) {
    setState(() {
      filteredUsers =
          _userController.users
              .where(
                (user) => user.name.toLowerCase().contains(query.toLowerCase()),
              )
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
                controller: _searchController,
                onChanged: _filterUsers,
                decoration: InputDecoration(
                  hintText: "Search clients...",
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
            // List of Clients
            Expanded(
              child: Obx(() {
                if (_userController.users.isEmpty) {
                  return const Center(child: Text("No users found"));
                }
                return ListView.builder(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  itemCount:
                      _searchController.text.isEmpty
                          ? _userController.users.length
                          : filteredUsers.length,
                  itemBuilder: (context, index) {
                    final user =
                        _searchController.text.isEmpty
                            ? _userController.users[index]
                            : filteredUsers[index];
                    return UserCart(client: user);
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
