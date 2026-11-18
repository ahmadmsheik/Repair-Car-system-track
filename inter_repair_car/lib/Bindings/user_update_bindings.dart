import 'package:get/get_instance/get_instance.dart';
import 'package:get/state_manager.dart';
import 'package:inter_repair_car/Controllers/user_update_controller.dart';

class UserUpdateBindings extends Bindings{
  @override
  void dependencies() {
     Get.lazyPut<UserUpdateController>(() => UserUpdateController());
  }
}