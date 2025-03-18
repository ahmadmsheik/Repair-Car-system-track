import 'package:get/get.dart';
import 'package:inter_repair_car/Routes/AppRoutes.dart';
import 'package:inter_repair_car/Views/adding_a_vehicle_with_task_view.dart';
import 'package:inter_repair_car/Views/car_detail_page.dart';
import 'package:inter_repair_car/Views/car_list_page.dart';
import 'package:inter_repair_car/Views/home_view.dart';
import 'package:inter_repair_car/Views/register_view.dart';
import 'package:inter_repair_car/Views/settings_view.dart';
import 'package:inter_repair_car/Views/sign_in_view.dart';
import 'package:inter_repair_car/Views/type_task_view.dart';
import 'package:inter_repair_car/Views/user_list_view.dart';
import 'package:inter_repair_car/Views/user_profile_view.dart';

class Apppage {
  static List<GetPage> pages = [
    GetPage(name: Approutes.home, page: () => const HomeView()),
    GetPage(
      name: Approutes.typeTask,
      page: () => TypeTaskView(typeTask: Get.arguments),
    ),
    GetPage(name: Approutes.carDetail, page: () => CarDetailPage()),
    GetPage(name: Approutes.clientList, page: () => UserListView()),
    GetPage(name: Approutes.carsList, page: () => CarListPage()),
    GetPage(name: Approutes.settingsView, page: () => SettingsView()),
    GetPage(name: Approutes.signInView, page: () => SignInView()),
    GetPage(name: Approutes.registerView, page: () => RegisterView()),
    GetPage(name: Approutes.userProfileView, page: () => UserProfileView()),
    GetPage(
      name: Approutes.addtaskPage,
      page: () => AddingAVehicleWithTaskView(),
    ),
  ];
}
