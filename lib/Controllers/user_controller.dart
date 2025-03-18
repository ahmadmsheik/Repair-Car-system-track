import 'package:get/get.dart';
import 'package:inter_repair_car/Models/Entities/User.dart';
import 'package:inter_repair_car/Models/repositories/DatabaseHelper.dart';

class UserController extends GetxController {
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  // Observable list of users
  var users = <User>[].obs;

  // Fetch all users from the database
  Future<void> fetchUsers() async {
    final userList = await _databaseHelper.getUsers();
    users.assignAll(userList); // Update the observable list
  }

  // Add a new user
  Future<void> addUser(User user) async {
    await _databaseHelper.insertUser(user);
    await fetchUsers(); // Refresh the user list
  }

  // Update a user
  Future<void> updateUser(User user) async {
    await _databaseHelper.updateUser(user);
    await fetchUsers(); // Refresh the user list
  }

  // Delete a user
  Future<void> deleteUser(int id) async {
    await _databaseHelper.deleteUser(id);
    await fetchUsers(); // Refresh the user list
  }
}
