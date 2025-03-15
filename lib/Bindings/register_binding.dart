import 'package:get/get.dart';
import 'package:inter_repair_car/Controllers/register_controller.dart';

class RegisterBinding extends Bindings{

  @override
  void dependencies() {
    Get.lazyPut<RegisterController>(() =>RegisterController(),);
  }
}