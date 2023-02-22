import 'package:afar_cabs_user/api_constants/api_services.dart';
import 'package:afar_cabs_user/constants/colors/colors.dart';
import 'package:afar_cabs_user/home_page/controller/home_chip_controller.dart';
import 'package:afar_cabs_user/home_page/controller/search_controller.dart';
import 'package:afar_cabs_user/home_page/controller/vehicles_controller.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';

import '../../components/auth_methods.dart';
import '../../components/custom_app_bar.dart';
import '../../components/custom_navigation_drawer.dart';
import '../../enable_location/controller/enable_location_controller.dart';
import '../../search_screen/controller/places_search_controller.dart';
import '../../search_screen/view/search_screen_view.dart';
import '../../sign_in_up_page/view/sign_in_page.dart';
import '../controller/google_map_controller.dart';
import 'package:easy_search_bar/easy_search_bar.dart';

import '../model/vehicles.dart';

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);

  final locController = Get.put(EnableLocationController());
  final googleMapController = Get.put(GoogleMapHomeController());
  final searchScreenController = Get.put(PlacesSearchController());
  final mapSearchController = Get.put(MapSearchController());
  final homeChipController = Get.put(HomeChipController());
  final vehiclesController = Get.put(VehiclesController());
  ApiService apiService = ApiService();

  final List<String> _chipRideOrExLabel = ['Ride', 'Express'];
  final List<String> _chipNextLabel = ['Daily', 'Rental', 'Pre-book'];

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    final overlay = Overlay.of(context);
    OverlayEntry entry;

    return SafeArea(
      child: Scaffold(
        drawer: CustomNavigationDrawer(),
        body: Stack(
          children: <Widget>[
            LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
              return GetBuilder<GoogleMapHomeController>(builder: (controller) {
                return SizedBox(
                  height: constraints.maxHeight / 1.9,
                  child: Obx(
                    () => controller.isLoading.value
                        ? Center(
                            child: CircularProgressIndicator(
                              color: primaryColor,
                            ),
                          )
                        : GoogleMap(
                            onMapCreated: controller.onMapCreated,
                            initialCameraPosition: controller.initialPosition,
                            polylines:
                                Set<Polyline>.of(controller.polylines.values),
                            // on below line setting user location enabled.
                            myLocationEnabled: true,
                            onCameraMove:
                                // searchScreenController.endPositionLat.value == 0
                                (CameraPosition cameraPosition) {
                              controller.dragCameraPosition =
                                  cameraPosition; //when map is dragging
                            },
                            // : (CameraPosition cameraPosition) {},
                            onCameraIdle:
                                // searchScreenController.endPositionLat.value == 0
                                () async {
                              //when map drag stops
                              await controller.onCameraDrag();
                            },
                            // : () {},

                            // on below line we are setting markers on the map
                            markers: (searchScreenController
                                                .startPositionLat.value !=
                                            0.0 ||
                                        locController.currentLatitude.value !=
                                            0.0) &&
                                    searchScreenController
                                            .endPositionLat.value !=
                                        0.0
                                ? Set.from(controller.startEndMarkers)
                                : {},
                          ),
                  ),
                );
              });
            }),
            // searchScreenController.startPositionLat.value == 0 &&
            //         searchScreenController.endPositionLat.value == 0
            homeChipController.rideConfirmed.value
                ? Container()
                : Obx(
                    () => Positioned(
                      bottom: height / 1.40,
                      right: (width - 30) / 2.05,
                      child: googleMapController.isLoading.value == false
                          ? Icon(
                              Icons.person_pin_circle,
                              size: 40,
                              color: primaryColor,
                            )
                          : Container(),
                    ),
                  ),
            // : Container(),
            CustomAppBar(),
            Positioned(
              top: height * 0.1,
              right: 15,
              left: width * 0.7,
              child: GetBuilder<VehiclesController>(builder: (controller) {
                return Obx(
                  () => Visibility(
                    visible:
                        homeChipController.expressSelected.value ? false : true,
                    child: Container(
                      height: height * 0.4,
                      width: 100,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10.0),
                        // border: Border.all(color: primaryColor, width: 2.0),
                      ),
                      child: controller.vehiclesModel!.isEmpty
                          ? Center(
                              child: CircularProgressIndicator(
                                  color: primaryColor),
                            )
                          : ListView.builder(
                              itemCount: controller.vehiclesModel!.length,
                              itemBuilder: (BuildContext context, int index) {
                                return TextButton(
                                  onPressed: () async {
                                    // await apiService.getVehiclesData();

                                    if ((homeChipController
                                            .rideSelected.value) &&
                                        (homeChipController
                                                .dailySelected.value ||
                                            homeChipController
                                                .rentalSelected.value ||
                                            homeChipController
                                                .preBookSelected.value)) {
                                      controller.selectedVehicleIndex.value =
                                          controller.vehiclesModel![index]
                                              .settingsId!;

                                      /// setting the vehicle name
                                      controller.selectedVehicleName.value =
                                          controller.vehiclesModel![index]
                                              .settingsValue!;

                                      homeChipController.vehicleSelected.value =
                                          true;
                                    } else {
                                      Get.snackbar(
                                          "Select ride and its category",
                                          "Select ride, category and then choose vehicle");
                                      homeChipController.vehicleSelected.value =
                                          false;
                                    }
                                  },
                                  child: Obx(
                                    () => Container(
                                      decoration:
                                          (homeChipController
                                                      .rideSelected.value) &&
                                                  (homeChipController
                                                          .dailySelected
                                                          .value ||
                                                      homeChipController
                                                          .rentalSelected
                                                          .value ||
                                                      homeChipController
                                                          .preBookSelected
                                                          .value)
                                              ? BoxDecoration(
                                                  color: controller
                                                              .selectedVehicleIndex
                                                              .value ==
                                                          controller
                                                              .vehiclesModel![
                                                                  index]
                                                              .settingsId
                                                      ? vehiclesContainerColor3
                                                      : Colors.transparent,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.0),
                                                )
                                              : BoxDecoration(
                                                  color: Colors.transparent,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.0),
                                                ),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          Image.network(
                                            controller.vehiclesModel![index]
                                                .fileLocation!,
                                            height: height * 0.08,
                                            width: width * 0.2,
                                          ),
                                          Text(
                                            controller.vehiclesModel![index]
                                                .settingsValue!,
                                            style: TextStyle(
                                              color: primaryColor,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                    ),
                  ),
                );
              }),
            ),
            DraggableScrollableSheet(
                initialChildSize: 0.47,
                minChildSize: 0.47,
                maxChildSize: 1,
                snapSizes: [0.47, 1],
                snap: true,
                builder: (BuildContext context, scrollSheetController) {
                  return Container(
                    color: Colors.white,
                    child: ListView(
                      padding: EdgeInsets.zero,
                      physics: ClampingScrollPhysics(),
                      controller: scrollSheetController,
                      children: [
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              SizedBox(
                                width: 50,
                                child: Divider(
                                  thickness: 5,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Obx(
                          () => Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ChoiceChip(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 15, horizontal: width * 0.05),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    side: homeChipController.rideSelected.value
                                        ? BorderSide.none
                                        : BorderSide(width: 2.0),
                                  ),
                                  selected:
                                      homeChipController.rideSelected.value,
                                  label: Text(
                                    "Ride",
                                    style: TextStyle(
                                        fontSize: 20.0,
                                        color: homeChipController
                                                .rideSelected.value
                                            ? Colors.white
                                            : primaryColor),
                                  ),
                                  labelStyle: TextStyle(
                                      color:
                                          homeChipController.rideSelected.value
                                              ? Colors.white
                                              : primaryColor),
                                  backgroundColor:
                                      homeChipController.rideSelected.value
                                          ? primaryColor
                                          : Colors.white,
                                  selectedColor: primaryColor,
                                  onSelected: (bool selected) {
                                    homeChipController.rideSelected.value =
                                        !homeChipController.rideSelected.value;
                                    homeChipController.expressSelected.value =
                                        false;
                                  }),
                              SizedBox(
                                width: width * 0.05,
                              ),
                              ChoiceChip(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 15, horizontal: width * 0.01),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    side:
                                        homeChipController.expressSelected.value
                                            ? BorderSide.none
                                            : BorderSide(width: 2.0),
                                  ),
                                  selected:
                                      homeChipController.expressSelected.value,
                                  label: Text(
                                    'Express Delivery',
                                    style: TextStyle(
                                        fontSize: 20.0,
                                        color: homeChipController
                                                .expressSelected.value
                                            ? Colors.white
                                            : primaryColor),
                                  ),
                                  labelStyle: TextStyle(
                                      color: homeChipController
                                              .expressSelected.value
                                          ? Colors.white
                                          : primaryColor),
                                  backgroundColor:
                                      homeChipController.expressSelected.value
                                          ? primaryColor
                                          : Colors.white,
                                  selectedColor: primaryColor,
                                  onSelected: (bool selected) {
                                    homeChipController.expressSelected.value =
                                        !homeChipController
                                            .expressSelected.value;
                                    homeChipController.rideSelected.value =
                                        false;
                                  }),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: height * 0.02,
                        ),
                        Obx(
                          () => Visibility(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ChoiceChip(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 15, horizontal: 20),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      side:
                                          homeChipController.dailySelected.value
                                              ? BorderSide.none
                                              : BorderSide(width: 2.0),
                                    ),
                                    selected:
                                        homeChipController.dailySelected.value,
                                    label: Text(
                                      'Normal',
                                      style: TextStyle(
                                          color: homeChipController
                                                  .dailySelected.value
                                              ? Colors.white
                                              : primaryColor),
                                    ),
                                    labelStyle: TextStyle(
                                        color: homeChipController
                                                .dailySelected.value
                                            ? Colors.white
                                            : primaryColor),
                                    backgroundColor:
                                        homeChipController.dailySelected.value
                                            ? primaryColor
                                            : Colors.white,
                                    selectedColor: primaryColor,
                                    onSelected: (bool selected) {
                                      homeChipController.dailySelected.value =
                                          !homeChipController
                                              .dailySelected.value;
                                      homeChipController.rentalSelected.value =
                                          false;
                                      homeChipController.preBookSelected.value =
                                          false;
                                    }),
                                SizedBox(
                                  width: width * 0.05,
                                ),
                                ChoiceChip(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 15, horizontal: 20),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      side: homeChipController
                                              .rentalSelected.value
                                          ? BorderSide.none
                                          : BorderSide(width: 2.0),
                                    ),
                                    selected:
                                        homeChipController.rentalSelected.value,
                                    label: Text(
                                      'Rental',
                                      style: TextStyle(
                                          color: homeChipController
                                                  .rentalSelected.value
                                              ? Colors.white
                                              : primaryColor),
                                    ),
                                    labelStyle: TextStyle(
                                        color: homeChipController
                                                .rentalSelected.value
                                            ? Colors.white
                                            : primaryColor),
                                    backgroundColor:
                                        homeChipController.rentalSelected.value
                                            ? primaryColor
                                            : Colors.white,
                                    selectedColor: primaryColor,
                                    onSelected: (bool selected) {
                                      homeChipController.rentalSelected.value =
                                          !homeChipController
                                              .rentalSelected.value;
                                      homeChipController.dailySelected.value =
                                          false;
                                      homeChipController.preBookSelected.value =
                                          false;
                                    }),
                                SizedBox(
                                  width: width * 0.05,
                                ),
                                ChoiceChip(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 15, horizontal: 20),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      side: homeChipController
                                              .preBookSelected.value
                                          ? BorderSide.none
                                          : BorderSide(width: 2.0),
                                    ),
                                    selected: homeChipController
                                        .preBookSelected.value,
                                    label: Text(
                                      'Pre-book',
                                      style: TextStyle(
                                          color: homeChipController
                                                  .preBookSelected.value
                                              ? Colors.white
                                              : primaryColor),
                                    ),
                                    labelStyle: TextStyle(
                                        color: homeChipController
                                                .preBookSelected.value
                                            ? Colors.white
                                            : primaryColor),
                                    backgroundColor:
                                        homeChipController.preBookSelected.value
                                            ? primaryColor
                                            : Colors.white,
                                    selectedColor: primaryColor,
                                    onSelected: (bool selected) {
                                      homeChipController.preBookSelected.value =
                                          !homeChipController
                                              .preBookSelected.value;
                                      homeChipController.dailySelected.value =
                                          false;
                                      homeChipController.rentalSelected.value =
                                          false;
                                    }),
                              ],
                            ),
                            visible: homeChipController.rideSelected.value,
                          ),
                        ),
                        SizedBox(
                          height: height * 0.01,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: GestureDetector(
                            onTap: () {
                              if (((homeChipController.rideSelected.value) &&
                                  (homeChipController.dailySelected.value ||
                                      homeChipController.rentalSelected.value ||
                                      homeChipController
                                          .preBookSelected.value))) {
                                Get.snackbar(
                                    "${vehiclesController.selectedVehicleName.value} Selected",
                                    "You have choosed ${vehiclesController.selectedVehicleName.value} for your ride.");
                                Get.to(() => SearchScreen());
                              } else if (homeChipController
                                  .expressSelected.value) {
                                Get.snackbar("Express Delivery Selected",
                                    "You have choosed Express Delivery service.");
                                Get.to(() => SearchScreen());
                              } else {
                                Get.snackbar("Select ride or express delivery",
                                    "First select a ride or express delivery and then choose the destination");
                              }
                            },
                            child: Container(
                              padding: const EdgeInsets.only(left: 12.0),
                              height: 50.0,
                              decoration: BoxDecoration(
                                color: Colors.grey.shade300,
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.search,
                                    color: primaryColor,
                                  ),
                                  SizedBox(
                                    width: width * 0.03,
                                  ),
                                  Text(
                                    "Search Destination",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black),
                                  ),
                                  SizedBox(
                                    width: width * 0.03,
                                  ),
                                  Expanded(
                                    child: ElevatedButton.icon(
                                      onPressed: () {
                                        showModalBottomSheet<void>(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return SizedBox(
                                              height: height * 0.5,
                                              child: Center(
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  children: [
                                                    Text(
                                                      'Schedule a trip',
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontSize: 25),
                                                    ),
                                                    Divider(
                                                      thickness: 2.0,
                                                    ),
                                                    Obx(
                                                      () => GestureDetector(
                                                        onTap: () async {
                                                          final DateTime?
                                                              picked =
                                                              await showDatePicker(
                                                                  context:
                                                                      context,
                                                                  initialDate:
                                                                      DateTime
                                                                          .now(),
                                                                  firstDate:
                                                                      DateTime(
                                                                          2015,
                                                                          8),
                                                                  lastDate:
                                                                      DateTime(
                                                                          2101));

                                                          if (picked != null) {
                                                            homeChipController
                                                                    .datePicked
                                                                    .value =
                                                                DateFormat(
                                                                        "E, d MMM")
                                                                    .format(
                                                                        picked);
                                                            print(
                                                                homeChipController
                                                                    .datePicked
                                                                    .value);
                                                          }
                                                        },
                                                        child: Text(
                                                          homeChipController
                                                                  .datePicked
                                                                  .value
                                                                  .isNotEmpty
                                                              ? homeChipController
                                                                  .datePicked
                                                                  .value
                                                              : DateFormat(
                                                                      "E, d MMM")
                                                                  .format(DateTime
                                                                      .now()),
                                                          style: TextStyle(
                                                              fontSize: 20),
                                                        ),
                                                      ),
                                                    ),
                                                    Divider(
                                                      thickness: 2.0,
                                                    ),
                                                    Obx(
                                                      () => GestureDetector(
                                                        onTap: () async {
                                                          final TimeOfDay?
                                                              timePicked =
                                                              await showTimePicker(
                                                                  context:
                                                                      context,
                                                                  initialTime: TimeOfDay(
                                                                      hour: TimeOfDay
                                                                              .now()
                                                                          .hour,
                                                                      minute: TimeOfDay
                                                                              .now()
                                                                          .minute));
                                                          if (timePicked !=
                                                              null) {
                                                            homeChipController
                                                                    .timePicked
                                                                    .value =
                                                                timePicked
                                                                    .format(
                                                                        context);
                                                            print(
                                                                homeChipController
                                                                    .timePicked
                                                                    .value);
                                                          }
                                                        },
                                                        child: Text(
                                                          homeChipController
                                                                  .timePicked
                                                                  .value
                                                                  .isNotEmpty
                                                              ? homeChipController
                                                                  .timePicked
                                                                  .value
                                                              : DateFormat(
                                                                      'hh:mm a')
                                                                  .format(DateTime
                                                                      .now()),
                                                          style: TextStyle(
                                                              fontSize: 20),
                                                        ),
                                                      ),
                                                    ),
                                                    Divider(
                                                      thickness: 2.0,
                                                    ),
                                                    Material(
                                                      color: primaryColor,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15),
                                                      child: InkWell(
                                                        onTap: () {
                                                          homeChipController
                                                                  .dateTimePicked
                                                                  .value =
                                                              "${homeChipController.timePicked.value}, ${homeChipController.datePicked.value}";

                                                          Navigator.pop(
                                                              context);
                                                          print(
                                                              homeChipController
                                                                  .datePicked
                                                                  .value);
                                                          print(
                                                              homeChipController
                                                                  .timePicked
                                                                  .value);
                                                          print(
                                                              homeChipController
                                                                  .dateTimePicked
                                                                  .value);
                                                        },
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(0),
                                                        child: Container(
                                                          width: width * 0.9,
                                                          height: height * 0.08,
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        15),
                                                          ),
                                                          alignment:
                                                              Alignment.center,
                                                          child: const Text(
                                                            'SET PICK-UP TIME',
                                                            style: TextStyle(
                                                                fontSize: 20,
                                                                color: Colors
                                                                    .white),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            );
                                          },
                                        );
                                      },
                                      style: ElevatedButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        primary: Colors.white,
                                      ),
                                      icon: Icon(
                                        Icons.access_time_filled_outlined,
                                        color: Colors.black,
                                      ),
                                      label: Obx(
                                        () => AutoSizeText(
                                          homeChipController.datePicked.value ==
                                                      DateFormat("E, d MMM")
                                                          .format(
                                                              DateTime.now()) ||
                                                  homeChipController
                                                      .datePicked.value.isEmpty
                                              ? "Now"
                                              : homeChipController
                                                  .datePicked.value,
                                          style: TextStyle(color: Colors.black),
                                          maxLines: 1,
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: width * 0.02,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        ListTile(
                          title: const AutoSizeText(
                            'Postmaster, Post Office Chepauk (Sub Office), Chennai, Tamil Nadu (TN), India (IN)',
                            maxLines: 1,
                            minFontSize: 12,
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          leading: Icon(Icons.history),
                          onTap: () {},
                        ),
                        ListTile(
                          title: const AutoSizeText(
                            'Postmaster, Post Office Chepauk (Sub Office), Chennai, Tamil Nadu (TN), India (IN)',
                            maxLines: 1,
                            minFontSize: 12,
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          leading: Icon(Icons.history),
                          onTap: () {},
                        ),
                        ListTile(
                          title: const AutoSizeText(
                            'Postmaster, Post Office Chepauk (Sub Office), Chennai, Tamil Nadu (TN), India (IN)',
                            maxLines: 1,
                            minFontSize: 12,
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          leading: Icon(Icons.history),
                          onTap: () {},
                        ),
                      ],
                    ),
                  );
                }),
            GetBuilder<GoogleMapHomeController>(
              builder: (controller) {
                return controller.distanceKm.value.isNotEmpty &&
                        controller.distanceTime.value.isNotEmpty
                    ? Positioned(
                        bottom: 250,
                        left: 70,
                        child: Container(
                          child: Card(
                            child: Container(
                              padding: EdgeInsets.all(20),
                              child: Text(
                                "Total Distance: " +
                                    controller.distanceKm.value +
                                    "\nTotal Time: " +
                                    controller.distanceTime.value,
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                      )
                    : Container();
              },
            ),
          ],
        ),
        floatingActionButton:
            GetBuilder<GoogleMapHomeController>(builder: (controller) {
          return FloatingActionButton(
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            onPressed: () {
              controller.getCurrentAnimatePosi();
              print("pressed");
            },
            child: const Icon(Icons.my_location),
          );
        }),
      ),
    );
  }
}