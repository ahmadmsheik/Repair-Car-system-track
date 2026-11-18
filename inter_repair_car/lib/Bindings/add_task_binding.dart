import 'package:get/get.dart';
import 'package:inter_repair_car/Controllers/add_task_controller.dart';

class AddTaskBinding extends Bindings{
  @override
  void dependencies(){
    Get.lazyPut<AddTaskController>(() => AddTaskController());
  }
}