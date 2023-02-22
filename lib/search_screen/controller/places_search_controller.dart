import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:google_api_headers/google_api_headers.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;

import '../../enable_location/controller/enable_location_controller.dart';

class PlacesSearchController extends GetxController {
  final startSearchFieldController = TextEditingController();
  final endSearchFieldController = TextEditingController();
  final locController = Get.put(EnableLocationController());

  late FocusNode startFocusNode;
  late FocusNode endFocusNode;

  RxString controllerStartSearchField = "".obs;
  RxString controllerEndSearchField = "".obs;
  RxString currentLocation = "".obs;
  RxString googleApikey = "".obs;

  RxDouble startPositionLat = 0.0.obs;
  RxDouble startPositionLong = 0.0.obs;

  RxDouble endPositionLat = 0.0.obs;
  RxDouble endPositionLong = 0.0.obs;

  Timer? debounce;


  var uuid= const Uuid();
  RxString sessionToken = "".obs;
  RxList<dynamic> placeList = [].obs;

  @override
  void onInit() {
    super.onInit();

    googleApikey.value = "AIzaSyBgN0yLHwbJFqiDJFnNZQAsHruCvUppE0Y";

    // await currentLocationInStart();

    startSearchFieldController.addListener(() {
      controllerStartSearchField.value = startSearchFieldController.text;
      // onChanged();
    });
    endSearchFieldController.addListener(() {
      controllerEndSearchField.value = endSearchFieldController.text;
    });

    startFocusNode = FocusNode();
    endFocusNode = FocusNode();

  }

  @override
  void dispose(){
    super.dispose();
    startFocusNode.dispose();
    endFocusNode.dispose();
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
    Uri request =
        Uri.parse('$baseURL?input=$input&components=country:in&location=${locController.currentLatitude.value},${locController.currentLongitude.value}&radius=2000&key=$kPLACESAPIKEY&sessiontoken=${sessionToken.value}');
    var response = await http.get(request);
    if (response.statusCode == 200) {
      print(response.body);
        placeList.value = json.decode(response.body)['predictions'];
    } else {
      throw Exception('Failed to load predictions');
    }
    update();
  }

}