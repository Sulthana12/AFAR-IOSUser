import 'package:afar_cabs_user/api_constants/api_services.dart';
import 'package:afar_cabs_user/confirmation_page/view/confirmation_page.dart';
import 'package:afar_cabs_user/constants/colors/colors.dart';
import 'package:afar_cabs_user/express_delivery_page/view/express_delivery_page.dart';
import 'package:afar_cabs_user/home_page/controller/home_chip_controller.dart';
import 'package:afar_cabs_user/home_page/controller/location_history_controller.dart';
import 'package:afar_cabs_user/home_page/controller/search_controller.dart';
import 'package:afar_cabs_user/home_page/controller/user_controller.dart';
import 'package:afar_cabs_user/home_page/controller/vehicles_controller.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';

import '../../components/custom_app_bar.dart';
import '../../components/custom_navigation_drawer.dart';
import '../../enable_location/controller/enable_location_controller.dart';
import '../../search_screen/controller/places_search_controller.dart';
import '../../search_screen/view/search_screen_view.dart';
import '../controller/google_map_controller.dart';

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);

  final locController = Get.put(EnableLocationController());
  final userController = Get.put(UserProfileController());
  final googleMapController = Get.put(GoogleMapHomeController());
  final searchScreenController = Get.put(PlacesSearchController());
  final mapSearchController = Get.put(MapSearchController());
  final homeChipController = Get.put(HomeChipController());
  final vehiclesController = Get.put(VehiclesController());
  final locationHistoryController = Get.put(LocationHistoryController());
  ApiService apiService = ApiService();

  final List<String> _chipRideOrExLabel = ['Ride', 'Express'];
  final List<String> _chipNextLabel = ['Daily', 'Rental', 'Pre-book'];
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      drawer: CustomNavigationDrawer(),
      body: Obx(
        () => Stack(
          children: <Widget>[
            LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
              return SizedBox(
                  height: constraints.maxHeight / 1.9,
                  child: Obx(() {
                    if (googleMapController.isLoading.value) {
                      return SizedBox(
                        height: height * 0.25,
                        child: const Center(
                            child: CircularProgressIndicator(
                          color: primaryColor,
                        )),
                      );
                    }

                    return GoogleMap(
                      onMapCreated: googleMapController.onMapCreated,
                      initialCameraPosition:
                          googleMapController.initialPosition!,
                      polylines: Set<Polyline>.of(
                          googleMapController.polylines.values),
                      // on below line setting user location enabled.
                      myLocationEnabled: true,
                      myLocationButtonEnabled: false,
                      onCameraMove:
                          // searchScreenController.endPositionLat.value == 0
                          (CameraPosition cameraPosition) {
                        googleMapController.dragCameraPosition =
                            cameraPosition; //when map is dragging
                      },
                      // : (CameraPosition cameraPosition) {},
                      onCameraIdle:
                          // searchScreenController.endPositionLat.value == 0
                          () async {
                        //when map drag stops
                        await googleMapController.onCameraDrag();
                      },
                      // : () {},

                        // on below line we are setting markers on the map
                        markers: (searchScreenController
                                            .startPositionLat.value !=
                                        0.0 ||
                                    locController.currentLatitude.value !=
                                        0.0) &&
                                searchScreenController.endPositionLat.value !=
                                    0.0 &&
                                homeChipController.rideConfirmed.value
                            ? Set.from(googleMapController.startEndMarkers)
                            : {},
                      );
                    }),
                  );
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
                            ? const Icon(
                                Icons.person_pin_circle,
                                size: 40,
                                color: Colors.red,
                              )
                            : Container(),
                      ),
                    ),
              // : Container(),
              CustomAppBar(),
              DraggableScrollableSheet(
                  initialChildSize: 0.47,
                  minChildSize: 0.47,
                  maxChildSize: 1,
                  snapSizes: const [0.47, 1],
                  snap: true,
                  builder: (BuildContext context, scrollSheetController) {
                    return Container(
                      color: Colors.white,
                      child: ListView(
                        padding: EdgeInsets.zero,
                        physics: const ClampingScrollPhysics(),
                        controller: scrollSheetController,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: const [
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
                                      side:
                                          homeChipController.rideSelected.value
                                              ? BorderSide.none
                                              : const BorderSide(width: 2.0),
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
                                        color: homeChipController
                                                .rideSelected.value
                                            ? Colors.white
                                            : primaryColor),
                                    backgroundColor:
                                        homeChipController.rideSelected.value
                                            ? primaryColor
                                            : Colors.white,
                                    selectedColor: primaryColor,
                                    onSelected: (bool selected) {
                                      homeChipController.rideSelected.value =
                                          !homeChipController
                                              .rideSelected.value;
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
                                      side: homeChipController
                                              .expressSelected.value
                                          ? BorderSide.none
                                          : const BorderSide(width: 2.0),
                                    ),
                                    selected: homeChipController
                                        .expressSelected.value,
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
                              visible: homeChipController.rideSelected.value,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  ChoiceChip(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 15, horizontal: 20),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        side: homeChipController
                                                .dailySelected.value
                                            ? BorderSide.none
                                            : const BorderSide(width: 2.0),
                                      ),
                                      selected: homeChipController
                                          .dailySelected.value,
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
                                        homeChipController
                                            .rentalSelected.value = false;
                                        homeChipController
                                            .preBookSelected.value = false;
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
                                            : const BorderSide(width: 2.0),
                                      ),
                                      selected: homeChipController
                                          .rentalSelected.value,
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
                                      backgroundColor: homeChipController
                                              .rentalSelected.value
                                          ? primaryColor
                                          : Colors.white,
                                      selectedColor: primaryColor,
                                      onSelected: (bool selected) {
                                        homeChipController
                                                .rentalSelected.value =
                                            !homeChipController
                                                .rentalSelected.value;
                                        homeChipController.dailySelected.value =
                                            false;
                                        homeChipController
                                            .preBookSelected.value = false;
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
                                            : const BorderSide(width: 2.0),
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
                                      backgroundColor: homeChipController
                                              .preBookSelected.value
                                          ? primaryColor
                                          : Colors.white,
                                      selectedColor: primaryColor,
                                      onSelected: (bool selected) {
                                        homeChipController
                                                .preBookSelected.value =
                                            !homeChipController
                                                .preBookSelected.value;
                                        homeChipController.dailySelected.value =
                                            false;
                                        homeChipController
                                            .rentalSelected.value = false;
                                      }),
                                ],
                              ),
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
                                        homeChipController
                                            .rentalSelected.value ||
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
                                  Get.snackbar(
                                      "Select ride or express delivery",
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
                                    const Icon(
                                      Icons.search,
                                      color: primaryColor,
                                    ),
                                    SizedBox(
                                      width: width * 0.03,
                                    ),
                                    const Text(
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
                                                      const Text(
                                                        'Schedule a trip',
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            fontSize: 25),
                                                      ),
                                                      const Divider(
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

                                                          if (picked !=
                                                              null) {
                                                            homeChipController
                                                                .datePicked
                                                                .value = DateFormat(
                                                                    "E, d MMM")
                                                                .format(
                                                                    picked);

                                                            homeChipController
                                                                .datePickedForApi
                                                                .value = DateFormat(
                                                                    "dd/MM/yyyy")
                                                                .format(
                                                                    picked);

                                                            print(homeChipController
                                                                .datePickedForApi
                                                                .value);
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
                                                          style:
                                                              const TextStyle(
                                                                  fontSize:
                                                                      20),
                                                        ),
                                                      ),
                                                    ),
                                                    const Divider(
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
                                                                      hour: TimeOfDay.now()
                                                                          .hour,
                                                                      minute:
                                                                          TimeOfDay.now().minute));
                                                          if (timePicked !=
                                                              null) {
                                                            print(
                                                                "${timePicked.hour}:${timePicked.minute}:00");
                                                            homeChipController
                                                                    .timePicked
                                                                    .value =
                                                                timePicked
                                                                    .format(
                                                                        context);

                                                            homeChipController
                                                                    .timePickedForApi
                                                                    .value =
                                                                "${timePicked.hour}:${timePicked.minute}:00";

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
                                                          style:
                                                              const TextStyle(
                                                                  fontSize:
                                                                      20),
                                                        ),
                                                      ),
                                                    ),
                                                    const Divider(
                                                      thickness: 2.0,
                                                    ),
                                                    Material(
                                                      color: primaryColor,
                                                      borderRadius:
                                                          BorderRadius
                                                              .circular(15),
                                                      child: InkWell(
                                                        onTap: () {
                                                          homeChipController
                                                                  .dateTimePicked
                                                                  .value =
                                                              "${homeChipController.timePicked.value}, ${homeChipController.datePicked.value}";

                                                          homeChipController
                                                                  .dateTimePickedForApi
                                                                  .value =
                                                              "${homeChipController.datePickedForApi.value} ${homeChipController.timePickedForApi.value}";

                                                          print(homeChipController
                                                              .dateTimePickedForApi
                                                              .value);

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
                                                          print(homeChipController
                                                              .dateTimePicked
                                                              .value);
                                                        },
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(0),
                                                        child: Container(
                                                          width: width * 0.9,
                                                          height:
                                                              height * 0.08,
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        15),
                                                          ),
                                                          alignment: Alignment
                                                              .center,
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
                                        backgroundColor: Colors.white,
                                      ),
                                      icon: const Icon(
                                        Icons.access_time_filled_outlined,
                                        color: Colors.black,
                                      ),
                                      label: Obx(
                                        () => AutoSizeText(
                                          homeChipController
                                                          .datePicked.value ==
                                                      DateFormat("E, d MMM")
                                                          .format(DateTime
                                                              .now()) ||
                                                  homeChipController
                                                      .datePicked
                                                      .value
                                                      .isEmpty
                                              ? "Now"
                                              : homeChipController
                                                  .datePicked.value,
                                          style: const TextStyle(
                                              color: Colors.black),
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
                        Obx(
                          () {
                            if (locationHistoryController
                                .isLocLoading.value) {
                              return SizedBox(
                                height: height * 0.25,
                                child: const Center(
                                    child: CircularProgressIndicator(
                                  color: primaryColor,
                                )),
                              );
                            }
                            return locationHistoryController
                                            .saveLocationModel ==
                                        null ||
                                    locationHistoryController
                                        .saveLocationModel!.isEmpty
                                ? SizedBox(
                                    height: height * 0.25,
                                    child: const Center(
                                      child: Text(
                                        "Set your favourite location and check here",
                                        style: TextStyle(
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  )
                                : SizedBox(
                                    height: height * 0.25,
                                    child: ListView.builder(
                                      itemCount: locationHistoryController
                                          .saveLocationModel!.length,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return ListTile(
                                          title: AutoSizeText(
                                            locationHistoryController
                                                .saveLocationModel![index]
                                                .locationAddress!,
                                            maxLines: 1,
                                            minFontSize: 12,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.w500,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          leading: const Icon(Icons.history),
                                          onTap: () async {
                                            if (((homeChipController
                                                    .rideSelected.value) &&
                                                (homeChipController
                                                        .dailySelected.value ||
                                                    homeChipController
                                                        .rentalSelected
                                                        .value ||
                                                    homeChipController
                                                        .preBookSelected
                                                        .value))) {
                                              homeChipController
                                                  .vehicleSelected
                                                  .value = true;

                                              /// setting the location address
                                              locationHistoryController
                                                      .selectedAddress.value =
                                                  locationHistoryController
                                                      .saveLocationModel![
                                                          index]
                                                      .locationAddress!;

                                              await locationHistoryController
                                                  .findLocLatLongAndSet();

                                              await googleMapController
                                                  .getDistanceDetailsForApi();

                                              Get.to(
                                                  () => ConfirmationPage());
                                            } else if (homeChipController
                                                .expressSelected.value) {
                                              homeChipController
                                                  .vehicleSelected
                                                  .value = true;

                                              /// setting the location address
                                              locationHistoryController
                                                      .selectedAddress.value =
                                                  locationHistoryController
                                                      .saveLocationModel![
                                                          index]
                                                      .locationAddress!;

                                              locationHistoryController
                                                  .findLocLatLongAndSet();

                                              Get.to(() =>
                                                  ExpressDeliveryConform());
                                            } else {
                                              Get.snackbar(
                                                  "Select ride and its category",
                                                  "Select ride, category and then choose vehicle");
                                              homeChipController
                                                  .vehicleSelected
                                                  .value = false;
                                            }
                                          },
                                        );
                                      },
                                    ),
                                  );
                          },
                        ),
                      ],
                    ),
                  );
                }),
            GetBuilder<GoogleMapHomeController>(
              builder: (controller) {
                return controller.distanceKm.value.isNotEmpty &&
                        controller.distanceTime.value.isNotEmpty &&
                        homeChipController.rideConfirmed.value
                    ? Positioned(
                        bottom: height * 0.5,
                        left: width * 0.07,
                        child: Container(
                          child: Card(
                            child: Container(
                              padding: const EdgeInsets.all(20),
                              child: Text(
                                "Total Distance: ${controller.distanceKm.value}\nTotal Time: ${controller.distanceTime.value}",
                                style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold),
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
    );
  }
}
