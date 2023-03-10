import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../constants/colors/colors.dart';
import '../../enable_location/controller/enable_location_controller.dart';
import '../../home_page/controller/google_map_controller.dart';
import '../../home_page/controller/home_chip_controller.dart';
import '../../search_screen/controller/places_search_controller.dart';

class RideConfirmationPage extends StatelessWidget {
  RideConfirmationPage({Key? key}) : super(key: key);
  final googleMapController = Get.put(GoogleMapHomeController());
  final searchScreenController = Get.put(PlacesSearchController());
  final locController = Get.put(EnableLocationController());
  final homeChipController = Get.put(HomeChipController());

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return SafeArea(
      child: Scaffold(
        body: Stack(
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
                                myLocationButtonEnabled: false,
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
              Positioned(
                top: 15,
                child: Row(
                  children: [
                    Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: width * 0.02, bottom: height * 0.01),
                          child: Container(
                            width: width * 0.8,
                            height: height * 0.065,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(width: 4, color: Colors.black),
                              borderRadius: BorderRadius.all(Radius.circular(20)),
                            ),
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 20,
                                ),
                                Icon(Icons.circle, color: Colors.red,),
                                SizedBox(
                                  width: 20,
                                ),
                                Text(
                                  "Pick-up Location",
                                  style: TextStyle(
                                    fontSize: 16.0,
                                  ),
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: width * 0.02),
                          child: Container(
                            width: width * 0.8,
                            height: height * 0.065,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(width: 4, color: Colors.black),
                              borderRadius: BorderRadius.all(Radius.circular(20)),
                            ),
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 20,
                                ),
                                Icon(Icons.circle, color: Colors.green,),
                                SizedBox(
                                  width: 20,
                                ),
                                Text(
                                  "Drop-off Location",
                                  style: TextStyle(
                                    fontSize: 16.0,
                                  ),
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      width: width * 0.02,
                    ),
                    const CircleAvatar(
                      radius: 24,
                      backgroundColor: Colors.white,
                      backgroundImage: AssetImage("assets/images/default.png"),
                    ),
                    SizedBox(
                      width: width * 0.02,
                    ),
                  ],
                ),
              ),
              Positioned(
                top: height * 0.37,
                right: 10,
                child: Container(
                  padding: const EdgeInsets.all(8.0),
                  width: width * 0.4,
                  height: height * 0.08,

                  // Generic Designing of the sheet
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    color: Colors.white,
                  ),
                  child: Center(child: Text(
                    "OTP: 328932",
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),),
                ),
              ),
              DraggableScrollableSheet(
                  initialChildSize: 0.52,
                  minChildSize: 0.52,
                  maxChildSize: 1,
                  snapSizes: const [0.52, 1],
                  snap: true,
                  builder: (BuildContext context, scrollSheetController) {
                    return SingleChildScrollView(
                      child: Container(
                        padding: const EdgeInsets.all(8.0),
                        width: double.infinity,

                        // Generic Designing of the sheet
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.only(
                            topRight: Radius.circular(30.0),
                            topLeft: Radius.circular(30.0),
                          ),
                          color: Colors.white,
                        ),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(
                              child: SizedBox(
                                width: 50,
                                child: Divider(
                                  thickness: 5,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 20.0),
                              child: Text(
                                "Arun kumar is arriving in 2.50 mins",
                                style: TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.w500,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            SizedBox(
                              height: 8.0,
                            ),
                            Divider(
                              thickness: 1,
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                const CircleAvatar(
                                  radius: 35,
                                  backgroundColor: Colors.transparent,
                                  backgroundImage: AssetImage("assets/images/default.png"),
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Arun Kumar N",
                                      style: TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 7.0,
                                    ),
                                    Row(
                                      children: [
                                        Icon(Icons.star, color: Colors.yellow,),
                                        SizedBox(
                                          width: 5.0,
                                        ),
                                        Text(
                                          "4.8",
                                          style: TextStyle(
                                            fontSize: 14.0,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 7.0,
                                    ),
                                    Row(
                                      children: [
                                        Icon(Icons.location_on_outlined, color: Colors.blue,),
                                        SizedBox(
                                          width: 5.0,
                                        ),
                                        Text(
                                          "3 mins",
                                          style: TextStyle(
                                            fontSize: 14.0,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  width: 20.0,
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset("assets/images/Auto.png",
                                      height: height * 0.1,
                                      width: width * 0.2,
                                    ),
                                    SizedBox(
                                      height: 7.0,
                                    ),
                                    RichText(
                                      text: TextSpan(
                                        text: "Toyato Corolla:",
                                        style: TextStyle(
                                          color: Colors.grey,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 13.0,
                                        ),
                                        children: [
                                          TextSpan(
                                              text: "8CF4829",
                                            style: TextStyle(
                                                color: Colors.black,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 13.0,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 30.0,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(
                                  "Total cash to be paid",
                                  style: TextStyle(
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                SizedBox(
                                  width: 20.0,
                                ),
                                Text(
                                  "256.00",
                                  style: TextStyle(
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 8.0,
                            ),
                            Divider(
                              thickness: 1,
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            Row(
                              children: [
                                InkWell(
                                  onTap: () {},
                                  child: Container(
                                    width: width * 0.5,
                                    height: height * 0.08,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(30),
                                        color: Colors.redAccent),
                                    child: Center(child: Text("Cancel",textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 17.0,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    )),
                                  ),
                                ),
                                Container(
                                  width: width * 0.4,
                                  height: height * 0.08,
                                  child: GestureDetector(
                                    onTap: () {},
                                    child: Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: primaryColor,
                                          style: BorderStyle.solid,
                                          width: 1.5,
                                        ),
                                        color: Colors.transparent,
                                        borderRadius: BorderRadius.circular(30.0),
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: <Widget>[
                                          Center(
                                            child: Text(
                                              "Call",
                                              style: TextStyle(
                                                color: primaryColor,
                                                fontSize: 17,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
              ),
            ],
          ),
      ),
    );
  }
}
