import 'package:flutter/cupertino.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
// import 'package:location/location.dart';

class EnableLocationController extends GetxController {
  // Location location = Location();
  RxString currentAddress = "".obs;
  RxDouble currentLatitude = 0.0.obs;
  RxDouble currentLongitude = 0.0.obs;

  Position? currentPosition;


  // void enableLocationPermission() async {
  //   bool _serviceEnabled;
  //   PermissionStatus _permissionGranted;
  //   LocationData _locationData;
  //
  //   _serviceEnabled = await location.serviceEnabled();
  //   if (!_serviceEnabled) {
  //     _serviceEnabled = await location.requestService();
  //     if (!_serviceEnabled) {
  //       print("service enabled");
  //       return;
  //     }
  //   }
  //
  //   _permissionGranted = await location.hasPermission();
  //   if (_permissionGranted == PermissionStatus.denied) {
  //     _permissionGranted = await location.requestPermission();
  //     if (_permissionGranted != PermissionStatus.granted) {
  //       print("permission granted");
  //       _locationData = await location.getLocation();
  //       return;
  //     }
  //   }
  //
  // }

  Future<bool> handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      Get.snackbar("Enable Location", 'Location services are disabled. Please enable the services');
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        Get.snackbar("Location permission denied", 'Location permissions are denied');
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      Get.snackbar("Location permission denied permanently", 'Location permissions are permanently denied, we cannot request permissions.');
      return false;
    }
    return true;
  }

  Future<void> getCurrentPosition() async {
    final hasPermission = await handleLocationPermission();

    if (!hasPermission) return;
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) async {
      currentPosition = position;

      currentLatitude.value = currentPosition!.latitude;
      currentLongitude.value = currentPosition!.longitude;

      await getAddressFromLatLng(currentPosition);
    }).catchError((e) {
      debugPrint(e);
    });

    update();
  }

  Future<void> getCurrentPositionHome(Position position) async {
    currentPosition = position;

    currentLatitude.value = currentPosition!.latitude;
    currentLongitude.value = currentPosition!.longitude;

    await getAddressFromLatLng(currentPosition);
    update();
  }

  Future<void> getAddressFromLatLng(Position? position) async {
    await placemarkFromCoordinates(
        currentPosition!.latitude, currentPosition!.longitude)
        .then((List<Placemark> placemarks) {
      Placemark place = placemarks[0];
      print(place.name!+place.locality!);
        currentAddress.value =
        '${place.name!}, ${place.locality!}, ${place.street}, ${place.postalCode}';
        print("Current add: ${currentAddress.value}");
    }).catchError((e) {
      debugPrint(e);
    });

    update();
  }
}