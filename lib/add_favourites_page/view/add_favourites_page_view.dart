import 'dart:async';

import 'package:afar_cabs_user/add_favourites_page/controller/save_location_controller.dart';
import 'package:afar_cabs_user/components/custom_rounded_button.dart';
import 'package:afar_cabs_user/constants/colors/colors.dart';
import 'package:afar_cabs_user/home_page/controller/google_map_controller.dart';
import 'package:afar_cabs_user/search_screen/controller/places_search_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:getwidget/components/floating_widget/gf_floating_widget.dart';
import 'package:google_api_headers/google_api_headers.dart';
import 'package:google_maps_webservice/places.dart';

import '../../home_page/controller/location_history_controller.dart';
import '../controller/chip_controller.dart';

class AddFavouritesPage extends StatelessWidget {
  AddFavouritesPage({Key? key}) : super(key: key);

  final chipController = Get.put(ChipController());
  final saveLocationController = Get.put(SaveLocationController());
  final searchController = Get.put(PlacesSearchController());
  final googleHomeController = Get.put(GoogleMapHomeController());
  final locationHistoryController = Get.put(LocationHistoryController());

  final List<String> _chipLabel = ['Home', 'Office', 'School', 'Others'];
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        // leading: IconButton(
        //   icon: Icon(Icons.arrow_back),
        //   color: Colors.black,
        //   onPressed: () {
        //
        //   },
        // ),
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          reverse: false,
          child: Form(
            key: formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: SizedBox(
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child:
                    GetBuilder<SaveLocationController>(builder: (controller) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: const Text(
                          "Save location as,",
                          style: TextStyle(
                            fontSize: 25.0,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.8,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20.0,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Obx(
                          () => Text(
                            saveLocationController.choosedString.value,
                            style: TextStyle(
                              fontSize: 25.0,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.8,
                            ),
                          ),
                        ),
                      ),
                      // Padding(
                      //   padding: const EdgeInsets.symmetric(
                      //       vertical: 20, horizontal: 0),
                      //   child: Obx(
                      //     () => Wrap(
                      //       spacing: 20,
                      //       children: List<Widget>.generate(4, (int index) {
                      //         return ChoiceChip(
                      //           label: Text(
                      //             _chipLabel[index],
                      //             style: TextStyle(color: Colors.white),
                      //           ),
                      //           // padding: EdgeInsets.symmetric(horizontal: 5.0),
                      //           selectedColor: primaryColor,
                      //           backgroundColor: Colors.grey,
                      //           selected: chipController.selectedChip == index,
                      //           onSelected: (bool selected) {
                      //             if (saveLocationController.homeChoosed.value) {
                      //
                      //             }
                      //             // chipController.selectedChip =
                      //             //     selected ? index : 0;
                      //           },
                      //         );
                      //       }),
                      //     ),
                      //   ),
                      // ),
                      const SizedBox(
                        height: 20.0,
                      ),
                      TextFormField(
                        controller: controller.comAddFieldController,
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.next,
                        cursorColor: Colors.black,
                        autofocus: false,
                        focusNode: controller.comAddFocusNode,
                        validator: (comAdd) {
                          if (comAdd == null || comAdd.isEmpty) {
                            return "Must enter your Completed address";
                          } else {
                            return null;
                          }
                        },
                        decoration: const InputDecoration(
                          hintText: "Completed address*",
                          hintStyle: TextStyle(color: Colors.grey),
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(15.0)),
                          ),
                        ),
                        onChanged: (value) {
                          controller.isVisible.value = true;

                          if (controller.debounce?.isActive ?? false) {
                            controller.debounce!.cancel();
                          }
                          controller.debounce =
                              Timer(const Duration(milliseconds: 500), () {
                            if (value.isNotEmpty) {
                              //places api
                              controller.onChanged(value);
                            } else {
                              //clear out the results
                              controller.placeList.value = [];
                              controller.comAddPositionLat.value = 0.0;
                              controller.comAddPositionLong.value = 0.0;
                            }
                          });
                        },
                      ),
                      Obx(
                        () => Visibility(
                          visible: controller.isVisible.value,
                          child: Container(
                            child: ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: controller.placeList.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: size.width * 0.04),
                                  child: ListTile(
                                    leading: Icon(
                                      Icons.location_on_outlined,
                                      color: primaryColor,
                                    ),
                                    title: Text(controller.placeList[index]
                                        ["structured_formatting"]["main_text"]),
                                    subtitle: Text(controller.placeList[index]
                                        ["description"]),
                                    onTap: () async {
                                      /// Clearing all the old routes
                                      googleHomeController.clearOldRoutes();

                                      controller.isVisible.value = false;

                                      final placeId = controller
                                          .placeList[index]["place_id"]!;
                                      final plist = GoogleMapsPlaces(
                                        apiKey: controller.googleApikey.value,
                                        apiHeaders: await GoogleApiHeaders()
                                            .getHeaders(),
                                        //from google_api_headers package
                                      );

                                      final details = await plist
                                          .getDetailsByPlaceId(placeId);
                                      if (details.result != null) {
                                        if (controller
                                            .comAddFocusNode.hasFocus) {
                                          controller.comAddPositionLat.value =
                                              details.result.geometry!.location
                                                  .lat;
                                          controller.comAddPositionLong.value =
                                              details.result.geometry!.location
                                                  .lng;

                                          print("Start lat: " +
                                              controller.comAddPositionLat.value
                                                  .toString());
                                          print("Start lng: " +
                                              controller
                                                  .comAddPositionLong.value
                                                  .toString());

                                          controller
                                                  .comAddFieldController.text =
                                              details.result.formattedAddress!;

                                          print("Start place name: " +
                                              controller
                                                  .controllerComAddField.value);
                                          controller.placeList.clear();
                                        }

                                        // if ((searchScreenController
                                        //     .startPositionLat.value !=
                                        //     0.0 ||
                                        //     locController.currentLatitude.value !=
                                        //         0.0) &&
                                        //     searchScreenController.endPositionLat.value !=
                                        //         0.0) {
                                        //   print('navigate');
                                        //   googleHomeController.initialCameraPosition =
                                        //   searchScreenController
                                        //       .startPositionLat.value !=
                                        //       0.0 &&
                                        //       searchScreenController
                                        //           .startPositionLong.value !=
                                        //           0.0
                                        //       ? LatLng(
                                        //       searchScreenController
                                        //           .startPositionLat.value,
                                        //       searchScreenController
                                        //           .startPositionLong.value)
                                        //       : LatLng(
                                        //       locController.currentLatitude.value,
                                        //       locController.currentLongitude.value);
                                        //
                                        //   googleHomeController.initialPosition =
                                        //       CameraPosition(
                                        //         target:
                                        //         googleHomeController.initialCameraPosition,
                                        //         zoom: 14,
                                        //       );
                                        //   Get.offAll(() => HomePage());
                                        // }
                                      }
                                    },
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20.0,
                      ),
                      TextFormField(
                        controller: controller.streetFieldController,
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.next,
                        cursorColor: Colors.black,
                        onChanged: (email) {},
                        // validator: (firstname) {
                        //   if (firstname == null || firstname.isEmpty) {
                        //     return "Must enter your Completed address";
                        //   } else {
                        //     return null;
                        //   }
                        // },
                        decoration: const InputDecoration(
                          hintText: "Street / Area",
                          hintStyle: TextStyle(color: Colors.grey),
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(15.0)),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20.0,
                      ),
                      TextFormField(
                        controller: controller.landmkFieldController,
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.next,
                        cursorColor: Colors.black,
                        onChanged: (email) {},
                        // validator: (firstname) {
                        //   if (firstname == null || firstname.isEmpty) {
                        //     return "Must enter your Completed address";
                        //   } else {
                        //     return null;
                        //   }
                        // },
                        decoration: const InputDecoration(
                          hintText: "Landmark (Optional)",
                          hintStyle: TextStyle(color: Colors.grey),
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(15.0)),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: size.height * 0.2,
                      ),
                      Obx(
                        ()=> ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: primaryColor,
                            minimumSize: const Size.fromHeight(50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          onPressed: () async {
                            if (controller.choosedString.value == "Home") {
                              await controller.saveLocationDetails("Home", context);

                              await controller.getSavedLocationDetails("Home");
                            } else if (controller.choosedString.value == "Work") {
                              await controller.saveLocationDetails("Work", context);

                              await controller.getSavedLocationDetails("Work");
                            } else if (controller.choosedString.value ==
                                "Others") {
                              await controller.saveLocationDetails("Others", context);

                              await controller.getSavedLocationDetails("Others");
                            }

                            await locationHistoryController.getAllSavedLocationData();
                          },
                          child: controller.saveIsLoading.value
                              ? Center(
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                  ),
                                )
                              : Text(
                                  'Save address',
                                  style: TextStyle(fontSize: 24),
                                ),
                        ),
                      ),
                      const SizedBox(
                        height: 10.0,
                      ),
                    ],
                  );
                }),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
