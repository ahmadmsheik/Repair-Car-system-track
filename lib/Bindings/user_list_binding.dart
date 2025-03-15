import 'package:get/get.dart';
import 'package:inter_repair_car/Controllers/user_list_controller.dart';

class UserListBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<UserListController>(() => UserListController());
  }
}
