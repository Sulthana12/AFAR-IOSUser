import 'dart:developer';

import 'package:afar_cabs_user/api_constants/api_services.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../api_constants/api_constants_manager.dart';
import '../../enable_location/controller/enable_location_controller.dart';
import '../../home_page/controller/google_map_controller.dart';
import '../../home_page/controller/home_chip_controller.dart';
import '../../home_page/controller/user_controller.dart';
import '../../search_screen/controller/places_search_controller.dart';
import '../model/fare_details.dart';

class DistanceCalApiController extends GetxController {
  ApiService apiService = ApiService();

  RxList<GetBaseVehicleFareDetails>? fareDetailsModel = <GetBaseVehicleFareDetails>[].obs;
  RxInt selectedVehicleIndex = 8.obs;
  RxString selectedVehicleName = ''.obs;

  @override
  void onInit() async {
    super.onInit();
    await getFareDetailsData();
  }

  Future<String> getFareDetailsData() async {
    var res = "error";

    fareDetailsModel?.value = (await apiService.getBaseVehicleFareDetails())!.cast<GetBaseVehicleFareDetails>();

    if (fareDetailsModel == null) {
      print("error");
      res = "error";
      Get.snackbar("Some server side error",
          "Can't able to fetch the vehicles");
      return res;
    } else {
      res = "success";
      // Get.snackbar("Logged in successfully.", "Welcome to afar cabs!");
      print(fareDetailsModel![0].calFare.toString());
      print(fareDetailsModel![0].fileLocation.toString());
      print(fareDetailsModel!.length);

      update();

      return res;
    }
  }

}