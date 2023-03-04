import 'package:afar_cabs_user/add_favourites_page/controller/save_location_controller.dart';
import 'package:afar_cabs_user/home_page/controller/google_map_controller.dart';
import 'package:afar_cabs_user/home_page/controller/location_history_controller.dart';
import 'package:afar_cabs_user/search_screen/controller/places_search_controller.dart';
import 'package:get/get.dart';

import '../../enable_location/controller/enable_location_controller.dart';
import '../../home_page/controller/home_chip_controller.dart';

class RideConfirmController extends GetxController {
  final homeChipController = Get.put(HomeChipController());
  final googleMapController = Get.put(GoogleMapHomeController());
  final locController = Get.put(EnableLocationController());
  final saveLocationController = Get.put(SaveLocationController());
  final searchScreenController = Get.put(PlacesSearchController());
  final locationHistoryController = Get.put(LocationHistoryController());

  String? selected;
  List<String> verifyType = ["myself", "else"];

  RxString contactFullName = ''.obs;
  RxString contactPhoneNumber = ''.obs;

  @override
  void onInit() {
    setVerifyType(verifyType[0]);
    super.onInit();
  }

  void setVerifyType(String type) {
    selected = type;
    print("Selected $selected");
    update();
  }

  Future<void> cancelRide() async {
    googleMapController.clearOldRoutes();

    homeChipController.rideConfirmed.value = false;

    homeChipController.rideSelected.value = false;
    homeChipController.expressSelected.value = false;
    homeChipController.dailySelected.value = false;
    homeChipController.rentalSelected.value = false;
    homeChipController.preBookSelected.value = false;

    homeChipController.vehicleSelected.value = false;

    saveLocationController.favHomeSet.value = false;
    saveLocationController.favWorkSet.value = false;
    saveLocationController.favOthersSet.value = false;

    saveLocationController.favLocSet.value = '';

    searchScreenController.endSearchFieldController.clear();
    searchScreenController.endPositionLat.value = 0.0;
    searchScreenController.endPositionLong.value = 0.0;

    locationHistoryController.selectedAddress.value = '';

    await googleMapController.getCurrentAnimatePosi();

    update();
  }

  Future<void> clearDetailsSignOut() async {
    googleMapController.clearOldRoutes();

    homeChipController.rideConfirmed.value = false;

    homeChipController.rideSelected.value = false;
    homeChipController.expressSelected.value = false;
    homeChipController.dailySelected.value = false;
    homeChipController.rentalSelected.value = false;
    homeChipController.preBookSelected.value = false;

    homeChipController.vehicleSelected.value = false;

    saveLocationController.favHomeSet.value = false;
    saveLocationController.favWorkSet.value = false;
    saveLocationController.favOthersSet.value = false;

    saveLocationController.favLocSet.value = '';

    searchScreenController.endSearchFieldController.clear();
    searchScreenController.endPositionLat.value = 0.0;
    searchScreenController.endPositionLong.value = 0.0;

    locationHistoryController.selectedAddress.value = '';

    if (locationHistoryController.saveLocationModel != null && locationHistoryController.saveLocationModel!.isNotEmpty) {
      locationHistoryController.saveLocationModel?.clear();
    }

    update();
  }

}