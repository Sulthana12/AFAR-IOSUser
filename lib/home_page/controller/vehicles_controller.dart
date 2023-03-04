import 'package:afar_cabs_user/api_constants/api_services.dart';
import 'package:get/get.dart';

import '../model/vehicles.dart';

class VehiclesController extends GetxController {

  ApiService apiService = ApiService();
  RxList<GetMasterVehicleSettings>? vehiclesModel = <GetMasterVehicleSettings>[].obs;
  RxInt selectedVehicleIndex = 0.obs;
  RxString selectedVehicleName = ''.obs;

  @override
  void onInit() async {
    super.onInit();
    await getVehiclesData();
  }

  Future<String> getVehiclesData() async {
    var res = "error";

    vehiclesModel?.value = (await apiService.getMasterVehiclesSettings())!.cast<GetMasterVehicleSettings>();

    if (vehiclesModel == null) {
      print("error");
      res = "error";
      Get.snackbar("Some server side error",
          "Can't able to fetch the vehicles");
      return res;
    } else {
      res = "success";
      // Get.snackbar("Logged in successfully.", "Welcome to afar cabs!");
      print(vehiclesModel![0].settingsValue.toString());
      print(vehiclesModel![0].fileLocation.toString());
      print(vehiclesModel!.length);

      update();

      return res;
    }

  }

}