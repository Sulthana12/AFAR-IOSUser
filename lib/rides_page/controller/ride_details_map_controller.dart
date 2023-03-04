import 'dart:async';

import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../components/map_utils.dart';
import '../../constants/colors/colors.dart';
import '../../enable_location/controller/enable_location_controller.dart';
import '../../home_page/controller/home_chip_controller.dart';
import '../../search_screen/controller/places_search_controller.dart';

class RideDetailsMapController extends GetxController {
  final locController = Get.put(EnableLocationController());
  final searchScreenController = Get.put(PlacesSearchController());
  final homeChipController = Get.put(HomeChipController());

  late CameraPosition initialPosition;
  late LatLng initialCameraPosition;

  CameraPosition? dragCameraPosition;
  RxString dragLocation = ''.obs;

  Completer<GoogleMapController> googleMainController = Completer();

  Map<PolylineId, Polyline> polylines = {};
  List<LatLng> polylineCoordinates = [];
  PolylinePoints polylinePoints = PolylinePoints();
  Set<Marker> startEndMarkers = <Marker>{};

  RxBool isLoading = false.obs;
  RxString googleApikey = ''.obs;

  @override
  void onInit() async {
    super.onInit();

    googleApikey.value = "AIzaSyBgN0yLHwbJFqiDJFnNZQAsHruCvUppE0Y";
    isLoading.value = true;

    // await apiService.getVehiclesData();
    if (locController.currentAddress.value.isEmpty) {
      await locController.getCurrentPosition();
    }

    print("Latitude" + locController.currentLatitude.value.toString());
    print("Longitude" + locController.currentLongitude.value.toString());
    initialCameraPosition =
    locController.currentLatitude.value != 0.0 &&
        locController.currentLongitude.value != 0.0
        ? LatLng(locController.currentLatitude.value,
        locController.currentLongitude.value)
        : LatLng(10.0079, 77.4735);

    initialPosition = CameraPosition(
      target: initialCameraPosition,
      zoom: 14,
    );

    isLoading.value = false;
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
          locController.currentLatitude.value != 0.0
              ? locController.currentLatitude.value
              : 10.0079,
          locController.currentLongitude.value != 0.0
              ? locController.currentLongitude.value
              : 77.4735,
        ),
        infoWindow: const InfoWindow(
          title: 'Pickup point',
        ),
      ),
      Marker(
        markerId: MarkerId('end'),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
        position: LatLng(
          10.7905,
          78.7047,
        ),
        infoWindow: const InfoWindow(
          title: 'Destination',
        ),
      ),
    };

      Future.delayed(Duration(milliseconds: 2000), () {
        controller.animateCamera(CameraUpdate.newLatLngBounds(
            MapUtils.boundsFromLatLngList(
                startEndMarkers.map((loc) => loc.position).toList()),
            1));
        getPolyline();
      });
  }

  getPolyline() async {
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        googleApikey.value,
        PointLatLng(
          locController.currentLatitude.value != 0.0
              ? locController.currentLatitude.value
              : 10.0079,
          locController.currentLongitude.value != 0.0
              ? locController.currentLongitude.value
              : 77.4735,
        ),
        PointLatLng(
          10.7905,
          78.7047,
        ),
        travelMode: TravelMode.driving);
    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    }
    print("get polyline");
    print(result.points);

    await addPolyLine();

    update();
  }

  addPolyLine() {
    print("add polyline");
    PolylineId id = PolylineId("poly");
    Polyline polyline = Polyline(
        polylineId: id,
        color: primaryColor,
        points: polylineCoordinates,
        width: 5);
    polylines[id] = polyline;

    update();
  }

}