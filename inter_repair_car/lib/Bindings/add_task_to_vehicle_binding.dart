import 'package:get/get.dart';
import 'package:inter_repair_car/Controllers/add_task_to_vehicle_controller.dart';

class VehicleUpdateBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AddTaskToVehicleController>(() => AddTaskToVehicleController());
  }
}
