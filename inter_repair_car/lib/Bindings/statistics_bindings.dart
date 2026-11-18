import 'package:get/get.dart';
import 'package:inter_repair_car/Controllers/statistics_controller.dart';

class StatisticsBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<StatisticsController>(() => StatisticsController());
  }
}
