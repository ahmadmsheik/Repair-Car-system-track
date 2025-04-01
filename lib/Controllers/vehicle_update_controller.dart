import 'package:flutter/widgets.dart';

class VehicleUpdateController {
  final TextEditingController carMakerController = TextEditingController();
  final TextEditingController carModelController = TextEditingController();
  final TextEditingController carVINController = TextEditingController();
  final TextEditingController carPlateNumberController =
      TextEditingController();
  final TextEditingController carYearController = TextEditingController();
  final TextEditingController carEngineTypeController = TextEditingController();
  final TextEditingController carMileageController = TextEditingController();
  final GlobalKey<FormState> editFormKey = GlobalKey<FormState>();
}
