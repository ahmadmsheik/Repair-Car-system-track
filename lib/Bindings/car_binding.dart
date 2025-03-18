import 'package:get/get.dart';
import 'package:inter_repair_car/Controllers/car_controller.dart';

class CarBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CarController>(() => CarController());
  }
}
