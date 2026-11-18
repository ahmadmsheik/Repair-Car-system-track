import 'package:get/get_instance/get_instance.dart';
import 'package:get/utils.dart';
import 'package:inter_repair_car/Controllers/car_listing_controller.dart';

class CarListingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CarListingController>(() => CarListingController());
  }
}
