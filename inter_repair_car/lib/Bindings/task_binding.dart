import 'package:get/get.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:inter_repair_car/Controllers/task_controller.dart';

class TaskBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut<TaskController>(() => TaskController(),);
  }
}