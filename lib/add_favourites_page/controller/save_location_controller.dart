import 'dart:async';
import 'dart:convert';

import 'package:afar_cabs_user/add_favourites_page/model/save_location.dart';
import 'package:afar_cabs_user/add_favourites_page/view/my_locations_view.dart';
import 'package:afar_cabs_user/api_constants/api_services.dart';
import 'package:afar_cabs_user/confirmation_page/controller/distance_sending_api_controller.dart';
import 'package:afar_cabs_user/confirmation_page/controller/ride_confirm_controller.dart';
import 'package:afar_cabs_user/home_page/controller/user_controller.dart';
import 'package:afar_cabs_user/search_screen/view/search_screen_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:getwidget/types/gf_social_type.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_place_picker_mb/google_maps_place_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;

import '../../confirmation_page/view/confirmation_page.dart';
import '../../enable_location/controller/enable_location_controller.dart';
import '../../express_delivery_page/view/express_delivery_page.dart';
import '../../home_page/controller/google_map_controller.dart';
import '../../home_page/controller/home_chip_controller.dart';
import '../../home_page/view/home_page_view.dart';
import '../../search_screen/controller/places_search_controller.dart';
import '../view/add_favourites_page_view.dart';

class SaveLocationController extends GetxController {
  final searchScreenController = Get.put(PlacesSearchController());
  final googleHomeController = Get.put(GoogleMapHomeController());
  final locController = Get.put(EnableLocationController());
  final userProfileController = Get.put(UserProfileController());
  final homeChipController = Get.put(HomeChipController());

  ApiService apiService = ApiService();

  final comAddFieldController = TextEditingController();
  final streetFieldController = TextEditingController();
  final landmkFieldController = TextEditingController();

  RxString controllerComAddField = "".obs;
  RxString controllerStreetField = "".obs;
  RxString controllerLandmkField = "".obs;

  RxString currentLocation = "".obs;
  RxString googleApikey = "".obs;
  Timer? debounce;
  RxBool isVisible = false.obs;
  RxBool isMapLocationLoading = false.obs;
  RxBool isMyLocationsLoading = true.obs;

  RxDouble comAddPositionLat = 0.0.obs;
  RxDouble comAddPositionLong = 0.0.obs;

  RxBool homeChoosed = false.obs;
  RxBool workChoosed = false.obs;
  RxBool othersChoosed = false.obs;

  RxString homeAddress = ''.obs;
  RxString workAddress = ''.obs;
  RxString othersAddress = ''.obs;

  RxString choosedString = ''.obs;
  RxBool onCameraMoveStarted = false.obs;

  RxString homeOrSearchScreen = ''.obs;
  RxBool favHomeSet = false.obs;
  RxBool favWorkSet = false.obs;
  RxBool favOthersSet = false.obs;
  RxString favLocSet = ''.obs;

  LatLng initialCameraPosition = LatLng(20.5937, 78.9629);

  late FocusNode comAddFocusNode;
  late FocusNode streetFocusNode;
  late FocusNode landmkFocusNode;

  RxBool saveIsLoading = false.obs;

  var uuid = const Uuid();
  RxString sessionToken = "".obs;
  RxList<dynamic> placeList = [].obs;

  @override
  void onInit() async {
    super.onInit();

    isMapLocationLoading.value = true;

    await locController.getCurrentPosition();
    await getAllSavedLocations();

    initialCameraPosition =
        searchScreenController.startPositionLat.value != 0.0 &&
                searchScreenController.startPositionLong.value != 0.0
            ? LatLng(searchScreenController.startPositionLat.value,
                searchScreenController.startPositionLong.value)
            : LatLng(locController.currentLatitude.value,
                locController.currentLongitude.value);

    googleApikey.value = "AIzaSyBgN0yLHwbJFqiDJFnNZQAsHruCvUppE0Y";

    comAddFieldController.addListener(() {
      controllerComAddField.value = comAddFieldController.text;
      // onChanged();
    });
    streetFieldController.addListener(() {
      controllerStreetField.value = streetFieldController.text;
    });
    landmkFieldController.addListener(() {
      controllerLandmkField.value = landmkFieldController.text;
    });

    comAddFocusNode = FocusNode();
    comAddFocusNode = FocusNode();
    landmkFocusNode = FocusNode();

    isMapLocationLoading.value = false;
  }

  @override
  void dispose() {
    super.dispose();
    comAddFocusNode.dispose();
    comAddFocusNode.dispose();
    landmkFocusNode.dispose();
  }

  Future<void> getAllSavedLocations() async {
    isMyLocationsLoading.value = true;
    await getSavedLocationDetails("Home");
    await getSavedLocationDetails("Work");
    await getSavedLocationDetails("Others");
    isMyLocationsLoading.value = false;
  }

  void onChanged(String value) {
    print("executed");
    if (sessionToken.value.isEmpty) {
      sessionToken.value = uuid.v4();
    }
    getSuggestion(value);
  }

  void getSuggestion(String input) async {
    String kPLACESAPIKEY = googleApikey.value;
    String type = '(regions)';
    String baseURL =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json';
    Uri request = Uri.parse(
        '$baseURL?input=$input&components=country:in&location=${locController.currentLatitude.value},${locController.currentLongitude.value}&radius=2000&key=$kPLACESAPIKEY&sessiontoken=${sessionToken.value}');
    var response = await http.get(request);
    if (response.statusCode == 200) {
      print(response.body);
      placeList.value = json.decode(response.body)['predictions'];
    } else {
      throw Exception('Failed to load predictions');
    }
    update();
  }

  void afterPlacePicked(PickResult result) {
    googleHomeController.clearOldRoutes();

    print(result.formattedAddress);
    print(result.geometry!.location.lat);
    print(result.geometry!.location.lng);

    if (result.formattedAddress!.isNotEmpty &&
        result.formattedAddress != null) {
      comAddFieldController.text = result.formattedAddress!;

      print(comAddFieldController.text);
      print(controllerComAddField.value);
    }
    Get.to(() => AddFavouritesPage());
  }

  Future<void> afterDestinationPicked(PickResult result) async {
    googleHomeController.clearOldRoutes();

    print(result.formattedAddress);
    print(result.geometry!.location.lat);
    print(result.geometry!.location.lng);

    if (result.formattedAddress!.isNotEmpty &&
        result.formattedAddress != null) {
      searchScreenController.endSearchFieldController.text =
          result.formattedAddress!;

      searchScreenController.endPositionLat.value =
          result.geometry!.location.lat;
      searchScreenController.endPositionLong.value =
          result.geometry!.location.lng;

      print(searchScreenController.controllerEndSearchField.value);
      // print(controllerComAddField.value);

      if ((searchScreenController.startPositionLat.value != 0.0 ||
              locController.currentLatitude.value != 0.0) &&
          searchScreenController.endPositionLat.value != 0.0) {
        print('navigate');
        googleHomeController.initialCameraPosition =
            searchScreenController.startPositionLat.value != 0.0 &&
                    searchScreenController.startPositionLong.value != 0.0
                ? LatLng(searchScreenController.startPositionLat.value,
                    searchScreenController.startPositionLong.value)
                : LatLng(locController.currentLatitude.value,
                    locController.currentLongitude.value);

        googleHomeController.initialPosition = CameraPosition(
          target: googleHomeController.initialCameraPosition,
          zoom: 14,
        );

        if (homeChipController.expressSelected.value) {
          Get.to(() => ExpressDeliveryConform());
        } else {
          await googleHomeController.getDistanceDetailsForApi();
          Get.to(() => ConfirmationPage());
        }
      }
    }

    // googleHomeController.getPolyline();

    update();
  }

  Future<void> saveLocationDetails(
      String choosedText, BuildContext context) async {
    /// This is for personal details page
    SaveLocation body = SaveLocation(
        userId: int.parse(userProfileController.userID.value),
        locationType: choosedText,
        locationAddress: controllerComAddField.value,
        locationLandmark: controllerLandmkField.value,
        locationStreet: controllerStreetField.value,
        status: "U");

    saveIsLoading.value = true;
    http.Response response = (await apiService.saveLocation(body))!;
    print(body.toJson());
    if (response.statusCode == 200) {
      Get.snackbar("${choosedString.value} Address Saved",
          "${choosedString.value} Address Saved successfully!");

      Navigator.pop(context);
      Navigator.pop(context);
      Get.off(() => MyLocationsPage());

      clearInputText();
    } else {
      Get.snackbar("Server side error", "Some Server side error occurred.");
    }
    print(response.body);
    saveIsLoading.value = false;

    update();
  }

  Future<void> getSavedLocationDetails(String location) async {
    late List<SaveLocation>? savedLocation = [];

    savedLocation =
        (await ApiService().getSavedLocation(location))?.cast<SaveLocation>();

    if (savedLocation == null) {
      print("user value null");
      if (location == "Home") {
        homeAddress.value = '';
      } else if (location == "Work") {
        workAddress.value = '';
      } else {
        othersAddress.value = '';
      }
    } else {
      print(savedLocation[0].userId.toString());

      if (savedLocation[0].locationType.toString() == "Home") {
        homeAddress.value = savedLocation[0].locationAddress.toString();
      } else if (savedLocation[0].locationType.toString() == "Work") {
        workAddress.value = savedLocation[0].locationAddress.toString();
      } else {
        othersAddress.value = savedLocation[0].locationAddress.toString();
      }

      comAddFieldController.text = savedLocation[0].locationAddress.toString();
      streetFieldController.text = savedLocation[0].locationStreet.toString();
      landmkFieldController.text = savedLocation[0].locationLandmark.toString();
    }

    update();
  }

  Future<void> findFavLocLatLongStart(BuildContext context) async {
    List<Location> favLocation = await locationFromAddress(
        searchScreenController.controllerStartSearchField.value);
    print(
        "Latitude: ${favLocation.first.latitude} Longitude: ${favLocation.first.longitude}");

    searchScreenController.startPositionLat.value = favLocation.first.latitude;
    searchScreenController.startPositionLong.value =
        favLocation.first.longitude;

    print(searchScreenController.controllerStartSearchField.value);

    await googleHomeController.getFavoriteAnimatePosi();

    Navigator.pop(context);
  }

  Future<void> findFavLocLatLongEnd(BuildContext context) async {
    List<Location> favLocation = await locationFromAddress(
        searchScreenController.controllerEndSearchField.value);
    print(
        "Latitude: ${favLocation.first.latitude} Longitude: ${favLocation.first.longitude}");

    searchScreenController.endPositionLat.value = favLocation.first.latitude;
    searchScreenController.endPositionLong.value = favLocation.first.longitude;

    print(searchScreenController.controllerEndSearchField.value);

    Navigator.pop(context);

    if (homeChipController.expressSelected.value) {
      Get.to(() => ExpressDeliveryConform());
    } else {
      await googleHomeController.getDistanceDetailsForApi();
      Get.to(() => ConfirmationPage());
    }
  }

  Future<void> setFavouriteStart(
      BuildContext context, String favLocName) async {
    if (favLocName == "home" && homeAddress.value.isNotEmpty) {
      if (favLocSet.value != "home") {
        favLocSet.value = "home";

        favHomeSet.value = true;
        // favWorkSet.value = false;
        // favOthersSet.value = false;

        searchScreenController.startSearchFieldController.text =
            homeAddress.value;

        await findFavLocLatLongStart(context);
      } else {
        Get.snackbar("Already Home Address is set",
            "Home address is already been set for the destination. Try to change that or give another address here.");
      }
    } else if (favLocName == "work" && workAddress.value.isNotEmpty) {
      if (favLocSet.value != "work") {
        favLocSet.value = "work";

        // favHomeSet.value = false;
        favWorkSet.value = true;
        // favOthersSet.value = false;

        searchScreenController.startSearchFieldController.text =
            workAddress.value;

        await findFavLocLatLongStart(context);
      } else {
        Get.snackbar("Already Work Address is set",
            "Work address is already been set for the destination. Try to change that or give another address here.");
      }
    } else if (favLocName == "others" && othersAddress.value.isNotEmpty) {
      if (favLocSet.value != "others") {
        favLocSet.value = "others";

        // favHomeSet.value = false;
        // favWorkSet.value = false;
        favOthersSet.value = true;

        searchScreenController.startSearchFieldController.text =
            othersAddress.value;

        await findFavLocLatLongStart(context);
      } else {
        Get.snackbar("Already Others Address is set",
            "Others address is already been set for the destination. Try to change that or give another address here.");
      }
    } else {
      Get.snackbar("Set your favourite location first",
          "Please set your favourite location and then make it as your pickup point");
    }
  }

  Future<void> setFavouriteEnd(BuildContext context, String favLocName) async {
    if (favLocName == "home" && homeAddress.value.isNotEmpty) {
      if (favLocSet.value != "home") {
        favLocSet.value = "home";

        favHomeSet.value = true;
        // favWorkSet.value = false;
        // favOthersSet.value = false;

        searchScreenController.endSearchFieldController.text =
            homeAddress.value;

        await findFavLocLatLongEnd(context);
      } else {
        Get.snackbar("Already Home Address is set",
            "Home address is already been set for the pickup location. Try to change that or give another address here.");
      }
    } else if (favLocName == "work" && workAddress.value.isNotEmpty) {
      if (favLocSet.value != "work") {
        favLocSet.value = "work";

        // favHomeSet.value = false;
        favWorkSet.value = true;
        // favOthersSet.value = false;

        searchScreenController.endSearchFieldController.text =
            workAddress.value;

        await findFavLocLatLongEnd(context);
      } else {
        Get.snackbar("Already Work Address is set",
            "Work address is already been set for the pickup location. Try to change that or give another address here.");
      }
    } else if (favLocName == "others" && othersAddress.value.isNotEmpty) {
      if (favLocSet.value != "others") {
        favLocSet.value = "others";

        // favHomeSet.value = false;
        // favWorkSet.value = false;
        favOthersSet.value = true;

        searchScreenController.endSearchFieldController.text =
            othersAddress.value;

        await findFavLocLatLongEnd(context);
      } else {
        Get.snackbar("Already Others Address is set",
            "Others address is already been set for the pickup location. Try to change that or give another address here.");
      }
    } else {
      Get.snackbar("Set your favourite location first",
          "Please set your favourite location and then make it as your pickup point");
    }
  }

  Future<void> setFavouriteLocation({
    required BuildContext context,
    required String favLocName,
  }) async {
    print("In location func: " + homeOrSearchScreen.value);
    if (homeOrSearchScreen.value == "homepage") {
      await setFavouriteStart(context, favLocName);
    } else {
      await setFavouriteEnd(context, favLocName);
    }
  }

  clearInputText() {
    comAddFieldController.clear();
    streetFieldController.clear();
    landmkFieldController.clear();
  }
}
