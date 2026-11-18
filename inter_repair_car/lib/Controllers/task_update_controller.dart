import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class TaskUpdateController extends GetxController {
  TextEditingController nameController = TextEditingController();

  TextEditingController costController = TextEditingController();

  TextEditingController detailsController = TextEditingController();

  TextEditingController currentMileage = TextEditingController();

  final GlobalKey<FormState> taskUpdateKey = GlobalKey<FormState>();
  
}
