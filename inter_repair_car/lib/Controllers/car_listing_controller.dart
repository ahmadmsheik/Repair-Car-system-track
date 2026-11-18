import 'package:get/get.dart';
import 'package:inter_repair_car/Models/Entities/vehicle.dart';
import 'package:inter_repair_car/Models/repositories/DatabaseHelper.dart';

class CarListingController extends GetxController {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  var vehicles = <Vehicle>[].obs; // Observable list of vehicles
  var filteredVehicles =
      <Vehicle>[].obs; // Observable list of filtered vehicles
  var isLoading = true.obs; // Add this line

  @override
  void onInit() {
    super.onInit();
    fetchVehicles(); // Fetch vehicles when the controller is initialized
  }

  Future<void> fetchVehiclesByClient(int clientId) async {
    isLoading.value = true;
    try {
      final vehicles = await DatabaseHelper().getVehiclesByClientId(clientId);
      filteredVehicles.assignAll(vehicles);
    } catch (e) {
      Get.snackbar("Error", "Failed to load vehicles");
    } finally {
      isLoading.value = false;
    }
  }

  // Fetch vehicles from the database
  Future<void> fetchVehicles() async {
    isLoading(true);
    final List<Vehicle> loadedVehicles = await _dbHelper.getVehicles();
    vehicles.value = loadedVehicles;
    filteredVehicles.value =
        vehicles; // Initialize filtered list with all vehicles
    isLoading(false);
  }

  // Filter vehicles based on search query
  void filterVehicles(String query) {
    filteredVehicles.value =
        vehicles
            .where(
              (vehicle) =>
                  vehicle.make.toLowerCase().contains(query.toLowerCase()) ||
                  vehicle.model.toLowerCase().contains(query.toLowerCase()),
            )
            .toList();
  }
}
