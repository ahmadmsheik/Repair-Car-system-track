import 'package:get/get_instance/get_instance.dart';
import 'package:get/utils.dart';
import 'package:inter_repair_car/Controllers/authentication_controller.dart';

class AuthenticationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AuthenticationController>(() => AuthenticationController());
  }
}
