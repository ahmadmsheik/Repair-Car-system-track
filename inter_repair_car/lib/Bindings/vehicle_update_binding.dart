import 'package:get/get.dart';
import 'package:inter_repair_car/Controllers/vehicle_update_controller.dart';

class VehicleUpdateBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<VehicleUpdateController>(() => VehicleUpdateController());
  }
}
