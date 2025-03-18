import 'package:get/get.dart';
import 'package:inter_repair_car/Models/Entities/Task.dart';
import 'package:inter_repair_car/Models/Entities/User.dart';
import 'package:inter_repair_car/Models/Entities/vehicle.dart';
import 'package:inter_repair_car/Models/repositories/DatabaseHelper.dart';

class CarController extends GetxController {
  final DatabaseHelper dbHelper = DatabaseHelper();

  // Reactive variables
  var car = Rx<Vehicle?>(null); // Observable car (nullable)
  var owner = Rx<User?>(null); // Observable owner (nullable)
  var tasks = <Task>[].obs; // Observable tasks list

  // Fetch car, owner, and tasks from the database
  Future<void> fetchData(int carId) async {
    final fetchedCar = await dbHelper.getVehicleById(carId);
    final fetchedOwner = await dbHelper.getOwnerByVehicleId(carId);
    final fetchedTasks = await dbHelper.getTasksByVehicleId(carId);

    if (fetchedCar != null) {
      car.value = fetchedCar;
    } else {
      car.value = null; // Handle case where car is not found
    }

    if (fetchedOwner != null) {
      owner.value = fetchedOwner;
    } else {
      owner.value = null; // Handle case where owner is not found
    }

    tasks.value = fetchedTasks;
  }

  // Update car in the database and UI
  Future<void> updateCar(Vehicle updatedCar) async {
    await dbHelper.updateVehicle(updatedCar);
    car.value = updatedCar; // Update the observable car
  }

  // Add a new task to the database and UI
  Future<void> addTask(Task newTask) async {
    await dbHelper.insertTask(newTask);
    tasks.add(newTask); // Update the observable tasks list
  }
}
