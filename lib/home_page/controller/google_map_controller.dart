import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:afar_cabs_user/api_constants/api_services.dart';
import 'package:afar_cabs_user/constants/colors/colors.dart';
import 'package:afar_cabs_user/enable_location/controller/enable_location_controller.dart';
import 'package:afar_cabs_user/search_screen/controller/places_search_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:geolocator/geolocator.dart';

import '../../add_favourites_page/controller/save_location_controller.dart';
import '../../components/map_utils.dart';

class GoogleMapHomeController extends GetxController {
  final locController = Get.put(EnableLocationController());
  final searchScreenController = Get.put(PlacesSearchController());

  late CameraPosition initialPosition;
  late LatLng initialCameraPosition;

  CameraPosition? dragCameraPosition;
  RxString dragLocation = ''.obs;

  Completer<GoogleMapController> googleMainController = Completer();

  Map<PolylineId, Polyline> polylines = {};
  List<LatLng> polylineCoordinates = [];
  PolylinePoints polylinePoints = PolylinePoints();
  Set<Marker> startEndMarkers = <Marker>{};
  RxDouble distance = 0.0.obs;

  Map<String, dynamic> jsonResponse = {};
  RxList distanceKmAndTime = [].obs;
  RxString distanceKm = ''.obs;
  RxString distanceTime = ''.obs;

  RxBool mounted = false.obs;
  RxBool isLoading = false.obs;

  RxList<Marker> markers = <Marker>[].obs;

  @override
  void onInit() async {
    super.onInit();

    isLoading.value = true;

    // await apiService.getVehiclesData();
    if (locController.currentAddress.value.isEmpty) {
      await locController.getCurrentPosition();
    }

    if (locController.currentLatitude.value != 0.0) {
      searchScreenController.startSearchFieldController.text =
          locController.currentAddress.value;
    }

    print("Latitude" + locController.currentLatitude.value.toString());
    print("Longitude" + locController.currentLongitude.value.toString());
    initialCameraPosition =
        searchScreenController.startPositionLat.value != 0.0 &&
                searchScreenController.startPositionLong.value != 0.0
            ? LatLng(searchScreenController.startPositionLat.value,
                searchScreenController.startPositionLong.value)
            : LatLng(locController.currentLatitude.value,
                locController.currentLongitude.value);

    initialPosition = CameraPosition(
      target: initialCameraPosition,
      zoom: 14,
    );

    isLoading.value = false;
  }

  @override
  void dispose() {
    super.dispose();
  }

  void onMapCreated(GoogleMapController controller) async {
    if (!googleMainController.isCompleted) {
      googleMainController.complete(controller);
    } else {
      GoogleMapController googleMapController = controller;

      googleMainController = Completer();
      googleMainController.complete(googleMapController);
    }

    print(locController.currentLatitude.value);
    print(locController.currentLongitude.value);
    print(locController.currentAddress.value);

    startEndMarkers = {
      Marker(
        markerId: MarkerId('start'),
        position: LatLng(
          searchScreenController.startPositionLat.value != 0.0
              ? searchScreenController.startPositionLat.value
              : locController.currentLatitude.value,
          searchScreenController.startPositionLong.value != 0.0
              ? searchScreenController.startPositionLong.value
              : locController.currentLongitude.value,
        ),
        infoWindow: const InfoWindow(
          title: 'Pickup point',
        ),
      ),
      Marker(
        markerId: MarkerId('end'),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
        position: LatLng(
          searchScreenController.endPositionLat.value,
          searchScreenController.endPositionLong.value,
        ),
        infoWindow: const InfoWindow(
          title: 'Destination',
        ),
      ),
    };

    if ((searchScreenController.startPositionLat.value != 0.0 ||
            locController.currentLatitude.value != 0.0) &&
        searchScreenController.endPositionLat.value != 0.0) {
      print(startEndMarkers);
      Future.delayed(Duration(milliseconds: 2000), () {
        controller.animateCamera(CameraUpdate.newLatLngBounds(
            MapUtils.boundsFromLatLngList(
                startEndMarkers.map((loc) => loc.position).toList()),
            1));
        getPolyline();
      });
    }
  }

// created method for getting user current location
  Future<Position> getUserCurrentLocation() async {
    await Geolocator.requestPermission()
        .then((value) {})
        .onError((error, stackTrace) async {
      await Geolocator.requestPermission();
      print("ERROR" + error.toString());
    });
    return await Geolocator.getCurrentPosition();
  }

  Future<void> getCurrentAnimatePosi() async {
    GoogleMapController controller = await googleMainController.future;

    await locController.getCurrentPosition();

    markers.clear();

    markers.add(Marker(
      markerId: const MarkerId("1"),
      position: LatLng(locController.currentLatitude.value,
          locController.currentLongitude.value),
      infoWindow: const InfoWindow(
        title: 'My Current Location',
      ),
    ));
    // }

    print("getcurrent");
    controller.animateCamera(
      CameraUpdate.newLatLngZoom(
        LatLng(locController.currentLatitude.value,
            locController.currentLongitude.value),
        14,
      ),
    );

    /// if current location is there, then set it in the starting field of search bar
    if (locController.currentLatitude.value != 0.0) {
      searchScreenController.startSearchFieldController.text =
          locController.currentAddress.value;
    }

    update();
  }

  /// This method is used to calculate kms between starting and destination point
  double calculateDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var a = 0.5 -
        cos((lat2 - lat1) * p) / 2 +
        cos(lat1 * p) * cos(lat2 * p) * (1 - cos((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }

  addPolyLine() {
    PolylineId id = PolylineId("poly");
    Polyline polyline = Polyline(
        polylineId: id,
        color: primaryColor,
        points: polylineCoordinates,
        width: 5);
    polylines[id] = polyline;

    update();
  }

  getPolyline() async {
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        searchScreenController.googleApikey.value,
        PointLatLng(
          searchScreenController.startPositionLat.value != 0.0
              ? searchScreenController.startPositionLat.value
              : locController.currentLatitude.value,
          searchScreenController.startPositionLong.value != 0.0
              ? searchScreenController.startPositionLong.value
              : locController.currentLongitude.value,
        ),
        PointLatLng(
          searchScreenController.endPositionLat.value,
          searchScreenController.endPositionLong.value,
        ),
        travelMode: TravelMode.driving);
    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    }

    // /// polylineCoordinates is the List of longitute and latidtude.
    // /// This loop sends the coordinates of start and dest to get the km between them.
    // double totalDistance = 0;
    // for (var i = 0; i < polylineCoordinates.length - 1; i++) {
    //   totalDistance += calculateDistance(
    //       polylineCoordinates[i].latitude,
    //       polylineCoordinates[i].longitude,
    //       polylineCoordinates[i + 1].latitude,
    //       polylineCoordinates[i + 1].longitude);
    // }
    // print(totalDistance);

    // distance.value = totalDistance;

    jsonResponse = await rideDistanceText() ?? {};

    distanceTime.value =
        jsonResponse['rows'][0]['elements'][0]['duration']['text'];

    distanceKm.value =
        jsonResponse['rows'][0]['elements'][0]['distance']['text'];

    print("Km : " + distanceKm.value);

    addPolyLine();

    update();
  }

  Future<Map<String, dynamic>?> rideDistanceText() async {
    print("Starting place: " +
        searchScreenController.controllerStartSearchField.value);
    print("Destination: " +
        searchScreenController.controllerEndSearchField.value);

    double originLat = searchScreenController.startPositionLat.value != 0.0
        ? searchScreenController.startPositionLat.value
        : locController.currentLatitude.value;

    double originLong = searchScreenController.startPositionLong.value != 0.0
        ? searchScreenController.startPositionLong.value
        : locController.currentLongitude.value;

    var url = Uri.parse(
      'https://maps.googleapis.com/maps/api/distancematrix/json?destinations=${searchScreenController.endPositionLat},${searchScreenController.endPositionLong}&origins=$originLat,$originLong&key=${searchScreenController.googleApikey.value}',
    );
    var response = await http.get(url);

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
      //
      // print(jsonResponse);
      // print('MAP::$durationText');
      return jsonResponse;
    } else {
      print('ERROR in distance matrix API');
    }
    return null;
  }


  Future<void> onCameraDrag() async {
    if (dragCameraPosition != null) {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(
          dragCameraPosition!.target.latitude,
          dragCameraPosition!.target
              .longitude);

      Placemark place = placemarks[0];
      //get place name from lat and lang
      // if (searchScreenController.endPositionLat.value == 0.0) {
        dragLocation.value =
        '${place.name!}, ${place.locality!}, ${place.subLocality}, ${place.administrativeArea}, ${place.subAdministrativeArea}, ${place.street}, ${place.postalCode},';
        locController.currentAddress.value =
            dragLocation.value;

        /// Setting the starting location
        searchScreenController.startPositionLat.value = dragCameraPosition!.target.latitude;
        searchScreenController.startPositionLong.value = dragCameraPosition!.target.longitude;

        searchScreenController.startSearchFieldController.text = locController.currentAddress.value;
      // }

      update();

      print(locController.currentAddress.value);

    }

  }

  void clearOldRoutes() {
    /// Clearing all the old routes
    polylines.clear();
    polylineCoordinates.clear();
    markers.clear();
    startEndMarkers.clear();
  }
}
