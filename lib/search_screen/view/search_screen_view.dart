import 'dart:async';

import 'package:afar_cabs_user/add_favourites_page/view/my_locations_view.dart';
import 'package:afar_cabs_user/constants/colors/colors.dart';
import 'package:afar_cabs_user/home_page/controller/google_map_controller.dart';
import 'package:afar_cabs_user/home_page/controller/home_chip_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_api_headers/google_api_headers.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_place_picker_mb/google_maps_place_picker.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:intl/intl.dart';

import '../../add_favourites_page/controller/save_location_controller.dart';
import '../../confirmation_page/view/confirmation_page.dart';
import '../../enable_location/controller/enable_location_controller.dart';
import '../../express_delivery_page/view/express_delivery_page.dart';
import '../controller/places_search_controller.dart';

class SearchScreen extends StatelessWidget {
  SearchScreen({Key? key}) : super(key: key);
  final searchScreenController = Get.put(PlacesSearchController());
  final googleHomeController = Get.put(GoogleMapHomeController());
  final locController = Get.put(EnableLocationController());
  final saveLocationController = Get.put(SaveLocationController());
  final homeChipController = Get.put(HomeChipController());

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: Colors.black,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          reverse: false,
          child: Obx(
            () => Column(
              children: [
                homeChipController.datePicked.value ==
                        DateFormat("E, d MMM").format(DateTime.now()) || homeChipController.datePicked.value.isEmpty
                    ? Container()
                    : Container(
                        padding: EdgeInsets.only(left: width * 0.15),
                        width: double.infinity,
                        height: height * 0.04,
                        child: Text(
                          "${homeChipController.timePicked.value}, ${homeChipController.datePicked.value}",
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 20.0,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                Material(
                  elevation: 5.0,
                  borderRadius: const BorderRadius.only(
                    bottomRight: Radius.circular(20.0),
                    bottomLeft: Radius.circular(20.0),
                  ),
                  child: Container(
                    alignment: Alignment.topCenter,
                    width: width * 0.9,
                    height: height * 0.2,
                    padding: EdgeInsets.symmetric(vertical: height * 0.02),
                    margin: EdgeInsets.symmetric(horizontal: width * 0.05),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(10.0),
                        bottomLeft: Radius.circular(10.0),
                      ),
                    ),
                    child: Stack(
                      children: [
                        GetBuilder<PlacesSearchController>(
                            builder: (controller) {
                          return Column(
                            children: [
                              Expanded(
                                flex: 1,
                                child: TextField(
                                  controller:
                                      controller.startSearchFieldController,
                                  autofocus: false,
                                  focusNode: controller.startFocusNode,
                                  style: const TextStyle(fontSize: 23),
                                  decoration: InputDecoration(
                                    hintText: 'Enter Starting Point',
                                    hintStyle: const TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 22),
                                    filled: true,
                                    // fillColor: Colors.grey[200],
                                    fillColor: Colors.white,
                                    border: InputBorder.none,
                                    prefixIcon: IconButton(
                                      onPressed: () {},
                                      icon: const Icon(
                                        Icons.circle,
                                        size: 18.0,
                                      ),
                                    ),
                                  ),
                                  onChanged: (value) {
                                    if (controller.debounce?.isActive ?? false) {
                                      controller.debounce!.cancel();
                                    }
                                    controller.debounce = Timer(
                                        const Duration(milliseconds: 500), () {
                                      if (value.isNotEmpty) {
                                        //places api
                                        controller.onChanged(value);
                                      } else {
                                        //clear out the results
                                        controller.placeList.value = [];
                                        controller.startPositionLat.value = 0.0;
                                        controller.startPositionLong.value =
                                            0.0;
                                      }
                                    });
                                  },
                                ),
                              ),
                              // SizedBox(height: 10),
                              const Divider(
                                thickness: 1.0,
                                height: 0,
                              ),
                              Expanded(
                                flex: 1,
                                child: TextField(
                                  controller:
                                      controller.endSearchFieldController,
                                  autofocus: false,
                                  focusNode: controller.endFocusNode,
                                  // enabled: _startSearchFieldController.text.isNotEmpty &&
                                  //     startPosition != null,
                                  style: const TextStyle(fontSize: 23),
                                  decoration: InputDecoration(
                                    hintText: 'Enter Destination',
                                    hintStyle: const TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 22),
                                    filled: true,
                                    // fillColor: Colors.grey[200],
                                    fillColor: Colors.white,
                                    border: InputBorder.none,
                                    prefixIcon: IconButton(
                                      onPressed: () {},
                                      icon: const Icon(
                                        Icons.square_rounded,
                                        size: 18.0,
                                      ),
                                    ),
                                    // suffixIcon: IconButton(
                                    //   onPressed: () {},
                                    //   icon: Icon(Icons.clear_outlined),
                                    // ),
                                  ),
                                  onChanged: (value) {
                                    if (controller.debounce?.isActive ?? false) {
                                      controller.debounce!.cancel();
                                    }
                                    controller.debounce = Timer(
                                        const Duration(milliseconds: 500), () {
                                      if (value.isNotEmpty) {
                                        //places api
                                        controller.onChanged(value);
                                      } else {
                                        //clear out the results
                                        controller.placeList.value = [];
                                        controller.endPositionLat.value = 0.0;
                                        controller.endPositionLong.value = 0.0;
                                      }
                                    });
                                  },
                                ),
                              ),
                            ],
                          );
                        }),
                        Positioned(
                          left: width * 0.05,
                          top: height * 0.05,
                          child: const Icon(
                            Icons.circle,
                            size: 7.0,
                            color: Colors.grey,
                          ),
                        ),
                        Positioned(
                          left: width * 0.05,
                          top: height * 0.065,
                          child: const Icon(
                            Icons.circle,
                            size: 7.0,
                            color: Colors.grey,
                          ),
                        ),
                        Positioned(
                          left: width * 0.05,
                          top: height * 0.080,
                          child: const Icon(
                            Icons.circle,
                            size: 7.0,
                            color: Colors.grey,
                          ),
                        ),
                        Positioned(
                          left: width * 0.05,
                          top: height * 0.095,
                          child: const Icon(
                            Icons.circle,
                            size: 7.0,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding:
                      EdgeInsets.only(left: width * 0.035, right: width * 0.03),
                  child: ListTile(
                        leading: CircleAvatar(
                          radius: 15.0,
                          backgroundColor: Colors.lightBlue.shade100,
                          child: const Icon(
                            Icons.map_outlined,
                            color: primaryColor,
                            size: 20.0,
                          ),
                        ),
                        title: const Text('Pick on Map'),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Obx(
                                () => saveLocationController.isMapLocationLoading.value
                                    ? const Center(
                                  child: CircularProgressIndicator(
                                    color: primaryColor,
                                  ),
                                )
                                    :
                                    PlacePicker(
                                  enableMyLocationButton: true,
                                  zoomControlsEnabled: true,
                                  usePlaceDetailSearch: true,
                                  autocompleteRadius: 5000,
                                  // strictbounds: true,
                                  // autocompleteOffset: 5000,
                                  pickArea: CircleArea(center: saveLocationController.initialCameraPosition, radius: 20000),
                                  outsideOfPickAreaText: 'We do not provide service for this Area',
                                  region: "in",
                                  apiKey: saveLocationController.googleApikey.value,
                                  onTapBack: () {
                                    if (saveLocationController.onCameraMoveStarted.value) {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: const Text('Address not saved'),
                                            content: const Text('Are you sure you want to continue without saving?'),
                                            actions: [
                                              TextButton(
                                                onPressed: () {
                                                  searchScreenController.endSearchFieldController.text =
                                                  '';

                                                  searchScreenController.endPositionLat.value = 0.0;
                                                  searchScreenController.endPositionLong.value = 0.0;

                                                  Navigator.pop(context);
                                                  Navigator.pop(context);
                                                  Get.off(() => SearchScreen());
                                                },
                                                child: const Text('YES',
                                                  style: TextStyle(
                                                    color: Colors.red,
                                                  ),
                                                ),
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                child: const Text("NO",
                                                  style: TextStyle(
                                                    color: Colors.red,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    } else {
                                      Navigator.pop(context);
                                    }
                                  },
                                  onPlacePicked: (result) async {
                                    await saveLocationController
                                        .afterDestinationPicked(result);
                                  },
                                  onCameraMoveStarted: (someValue) {
                                    saveLocationController.onCameraMoveStarted.value = true;
                                  },
                                  initialPosition:
                                  saveLocationController.initialCameraPosition,
                                  useCurrentLocation: true,
                                  // selectInitialPosition: true,
                                  resizeToAvoidBottomInset:
                                      false, // only works in page mode, less flickery, remove if wrong offsets
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: width * 0.2),
                  child: const Divider(thickness: 1.0, height: 0),
                ),
                Padding(
                  padding:
                      EdgeInsets.only(left: width * 0.035, right: width * 0.03),
                  child: ListTile(
                    leading: CircleAvatar(
                      radius: 15.0,
                      backgroundColor: Colors.lightBlue.shade100,
                      child: const Icon(
                        Icons.star_border_outlined,
                        color: primaryColor,
                        size: 20.0,
                      ),
                    ),
                    title: const Text('My Favorites'),
                    trailing: const Icon(
                      Icons.chevron_right_outlined,
                      color: primaryColor,
                    ),
                    onTap: () {
                      saveLocationController.homeOrSearchScreen.value = "searchpage";

                      print(saveLocationController.homeOrSearchScreen.value);

                      Get.to(() => MyLocationsPage());
                    },
                  ),
                ),
                const Divider(thickness: 5.0, height: 0),
                ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: searchScreenController.placeList.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: EdgeInsets.symmetric(horizontal: width * 0.04),
                      child: ListTile(
                        leading: const Icon(
                          Icons.location_on_outlined,
                          color: primaryColor,
                        ),
                        title: Text(searchScreenController.placeList[index]
                            ["structured_formatting"]["main_text"]),
                        subtitle: Text(searchScreenController.placeList[index]
                            ["description"]),
                        onTap: () async {
                          /// Clearing all the old routes
                          googleHomeController.clearOldRoutes();

                          final placeId = searchScreenController
                              .placeList[index]["place_id"]!;
                          final plist = GoogleMapsPlaces(
                            apiKey: searchScreenController.googleApikey.value,
                            apiHeaders: await const GoogleApiHeaders().getHeaders(),
                            //from google_api_headers package
                          );

                          final details =
                              await plist.getDetailsByPlaceId(placeId);
                          if (searchScreenController
                              .startFocusNode.hasFocus) {
                            searchScreenController.startPositionLat.value =
                                details.result.geometry!.location.lat;
                            searchScreenController.startPositionLong.value =
                                details.result.geometry!.location.lng;

                            print("Start lat: ${searchScreenController.startPositionLat.value}");
                            print("Start lng: ${searchScreenController.startPositionLong.value}");

                            searchScreenController.startSearchFieldController
                                .text = details.result.name;
                            print("Start place name: ${searchScreenController
                                    .controllerStartSearchField.value}");
                            searchScreenController.placeList.clear();
                          } else {
                            searchScreenController.endPositionLat.value =
                                details.result.geometry!.location.lat;
                            searchScreenController.endPositionLong.value =
                                details.result.geometry!.location.lng;

                            print("End lat: ${searchScreenController.endPositionLat.value}");
                            print("End lng: ${searchScreenController.endPositionLong.value}");

                            searchScreenController.endSearchFieldController
                                .text = details.result.name;

                            print("End place name: ${searchScreenController
                                    .controllerEndSearchField.value}");

                            searchScreenController.placeList.clear();
                          }

                          if ((searchScreenController
                                          .startPositionLat.value !=
                                      0.0 ||
                                  locController.currentLatitude.value !=
                                      0.0) &&
                              searchScreenController.endPositionLat.value !=
                                  0.0) {
                            print('navigate');
                            googleHomeController.initialCameraPosition =
                                searchScreenController
                                                .startPositionLat.value !=
                                            0.0 &&
                                        searchScreenController
                                                .startPositionLong.value !=
                                            0.0
                                    ? LatLng(
                                        searchScreenController
                                            .startPositionLat.value,
                                        searchScreenController
                                            .startPositionLong.value)
                                    : LatLng(
                                        locController.currentLatitude.value,
                                        locController.currentLongitude.value);

                            googleHomeController.initialPosition =
                                CameraPosition(
                              target:
                                  googleHomeController.initialCameraPosition,
                              zoom: 14,
                            );
                            if (homeChipController.expressSelected.value) {
                              Get.to(() => ExpressDeliveryConform());
                            } else {
                              await googleHomeController.getDistanceDetailsForApi();

                              Get.to(() => ConfirmationPage());
                            }
                          }
                        },
                      ),
                    );
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
