import 'package:get/get_instance/get_instance.dart';
import 'package:get/route_manager.dart';
import 'package:inter_repair_car/Controllers/expenditure_contorller.dart';

class ExpenditureBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ExpenditureController());
  }
}
