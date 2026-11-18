import 'package:get/get.dart';
import 'package:inter_repair_car/Controllers/back_up_controller.dart';

class BackUpBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut<BackUpController>(() => BackUpController());
  }
}