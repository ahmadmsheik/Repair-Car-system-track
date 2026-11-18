import 'package:get/get.dart';
import 'package:inter_repair_car/Controllers/task_update_controller.dart';

class TaskUpdateBindings extends Bindings{
  @override
  void dependencies(){
    Get.lazyPut<TaskUpdateController>(() => TaskUpdateController());
  }
}