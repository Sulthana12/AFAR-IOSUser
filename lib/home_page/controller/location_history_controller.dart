import 'dart:developer';

import 'package:afar_cabs_user/home_page/controller/user_controller.dart';
import 'package:afar_cabs_user/search_screen/controller/places_search_controller.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../api_constants/api_constants_manager.dart';
import '../model/location_history.dart';

class LocationHistoryController extends GetxController {
  RxList<GetAllSaveLocation>? saveLocationModel = <GetAllSaveLocation>[].obs;
  final userProfileController = Get.put(UserProfileController());
  final searchScreenController = Get.put(PlacesSearchController());

  RxString selectedAddress = ''.obs;
  RxBool isLocLoading = false.obs;

  @override
  void onInit() async {
    super.onInit();
    print("User INTITSAIAD: ${userProfileController.userInitialized.value}");
    await getAllSavedLocationData();
  }

  Future<List<GetAllSaveLocation?>?> getAllSavedLocation() async {
    try {
      await userProfileController.updateHomeProfile();
      print("In get all saved loc: ${userProfileController.userID.value}");

      var url = Uri.parse("${ApiConstants.baseUrl}${ApiConstants.getSavedLocation}${userProfileController.userID.value}&Location_type=0");
      var response = await http.get(url);
      print(response.body);
      if (response.statusCode == 200) {
        print("In GetALLSAVEDLOCATIONS${response.body}");
        List<GetAllSaveLocation?>? model = getAllSaveLocationFromJson(response.body);
        return model;
      } else {
        print(response.body);
        return null;
      }
    } catch (e) {
      log(e.toString());
      Get.snackbar("Some error occurred.", e.toString());
    }
    return null;
  }

  Future<String> getAllSavedLocationData() async {
    print("executed");
    isLocLoading.value = true;

    var res = "error";
    var result = await getAllSavedLocation();
    if (result != null) {
      saveLocationModel?.value = result.cast<GetAllSaveLocation>();

      res = "success";
      // Get.snackbar("Logged in successfully.", "Welcome to afar cabs!");
      print(saveLocationModel![0].locationAddress.toString());
      print(saveLocationModel![0].locationStreet.toString());
      print(saveLocationModel!.length);

      update();

      isLocLoading.value = false;
      saveLocationModel?.refresh();
      return res;
    } else {
      saveLocationModel?.value = [];
      print("error");
      res = "error";
      // Get.snackbar("Some server side error",
      //     "Can't able to fetch the locations history");
      isLocLoading.value = false;
      return res;
    }
  }

  Future<void> findLocLatLongAndSet() async {
    searchScreenController.endSearchFieldController.text =
        selectedAddress.value;

    List<Location> selectedHisLoc = await locationFromAddress(
        searchScreenController.controllerEndSearchField.value);
    print(
        "Latitude: ${selectedHisLoc.first.latitude} Longitude: ${selectedHisLoc.first.longitude}");

    searchScreenController.endPositionLat.value = selectedHisLoc.first.latitude;
    searchScreenController.endPositionLong.value = selectedHisLoc.first.longitude;

    print(searchScreenController.controllerEndSearchField.value);
  }

}