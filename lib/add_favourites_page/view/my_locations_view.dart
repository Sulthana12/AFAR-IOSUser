import 'package:afar_cabs_user/add_favourites_page/controller/save_location_controller.dart';
import 'package:afar_cabs_user/constants/colors/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_place_picker_mb/google_maps_place_picker.dart';

import '../../components/custom_address_show_dialog.dart';
import '../../enable_location/controller/enable_location_controller.dart';
import '../../home_page/controller/google_map_controller.dart';
import '../../search_screen/controller/places_search_controller.dart';

class MyLocationsPage extends StatelessWidget {
  MyLocationsPage({Key? key}) : super(key: key);
  final searchScreenController = Get.put(PlacesSearchController());
  final googleHomeController = Get.put(GoogleMapHomeController());
  final locController = Get.put(EnableLocationController());
  final saveLocationController = Get.put(SaveLocationController());

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: const Text("My Locations"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: Colors.white,
          onPressed: () {
            // Get.off(HomePage());
            Navigator.pop(context);
          },
        ),
        elevation: 0.0,
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          reverse: true,
          child: Form(
            // key: formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: SizedBox(
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child:
                    GetBuilder<SaveLocationController>(builder: (controller) {
                  return controller.isMyLocationsLoading.value
                      ? const Center(
                          child: CircularProgressIndicator(color: primaryColor),
                        )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(
                              height: 30.0,
                            ),
                            Obx(
                              () => ListTile(
                                title: const Text(
                                  "Home",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 18.0,
                                  ),
                                ),
                                subtitle: controller.homeAddress.value.isNotEmpty?Text(
                                  controller.homeAddress.value,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 15.0,
                                  ),
                                ):null,
                                trailing: IconButton(
                                  icon: const Icon(
                                    Icons.edit,
                                  ),
                                  color: Colors.black,
                                  onPressed: () {
                                    controller.homeChoosed.value = true;
                                    controller.workChoosed.value = false;
                                    controller.othersChoosed.value = false;

                                    controller.choosedString.value = "Home";

                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => Obx(
                                          () => controller
                                                  .isMapLocationLoading.value
                                              ? const Center(
                                                  child:
                                                      CircularProgressIndicator(
                                                    color: primaryColor,
                                                  ),
                                                )
                                              : PlacePicker(
                                                  enableMyLocationButton: true,
                                                  usePlaceDetailSearch: true,
                                                  autocompleteRadius: 5000,
                                                  // strictbounds: true,
                                                  // autocompleteOffset: 5000,
                                                  region: "in",
                                                  apiKey: controller
                                                      .googleApikey.value,
                                                  onTapBack: () {
                                                    if (controller
                                                        .onCameraMoveStarted
                                                        .value) {
                                                      customAddressShowDialog(
                                                          context);
                                                    } else {
                                                      Navigator.pop(context);
                                                    }
                                                  },
                                                  onPlacePicked: (result) {
                                                    controller.afterPlacePicked(
                                                        result);
                                                  },
                                                  onCameraMoveStarted:
                                                      (someValue) {
                                                    controller
                                                        .onCameraMoveStarted
                                                        .value = true;
                                                  },
                                                  initialPosition: controller
                                                      .initialCameraPosition,
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
                                shape: RoundedRectangleBorder(
                                  side: const BorderSide(color: Colors.grey),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                onTap: () async {
                                  if (saveLocationController
                                          .homeOrSearchScreen.value ==
                                      "homepage") {
                                    saveLocationController.setFavouriteLocation(
                                      context: context,
                                      favLocName: "home",
                                    );
                                  } else {
                                    saveLocationController.setFavouriteLocation(
                                      context: context,
                                      favLocName: "home",
                                    );
                                  }
                                },
                              ),
                            ),
                            const SizedBox(
                              height: 30.0,
                            ),
                            Obx(
                              () => ListTile(
                                title: const Text(
                                  "Work",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 20.0,
                                  ),
                                ),
                                subtitle: controller.workAddress.value.isNotEmpty?Text(
                                  controller.workAddress.value,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 15.0,
                                  ),
                                ):null,
                                trailing: IconButton(
                                    icon: const Icon(
                                      Icons.edit,
                                    ),
                                    color: Colors.black,
                                    onPressed: () {
                                      controller.workChoosed.value = true;
                                      controller.homeChoosed.value = false;
                                      controller.othersChoosed.value = false;

                                      controller.choosedString.value = "Work";

                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => Obx(
                                            () => controller
                                                    .isMapLocationLoading.value
                                                ? const Center(
                                                    child:
                                                        CircularProgressIndicator(
                                                      color: primaryColor,
                                                    ),
                                                  )
                                                : PlacePicker(
                                                    enableMyLocationButton:
                                                        false,
                                                    usePlaceDetailSearch: true,
                                                    autocompleteRadius: 5000,
                                                    // strictbounds: true,
                                                    // autocompleteOffset: 5000,
                                                    region: "in",
                                                    apiKey: controller
                                                        .googleApikey.value,
                                                    onTapBack: () {
                                                      customAddressShowDialog(
                                                          context);
                                                    },
                                                    onPlacePicked: (result) {
                                                      controller
                                                          .afterPlacePicked(
                                                              result);
                                                    },
                                                    initialPosition: controller
                                                        .initialCameraPosition,
                                                    useCurrentLocation: true,
                                                    // selectInitialPosition: true,
                                                    resizeToAvoidBottomInset:
                                                        false, // only works in page mode, less flickery, remove if wrong offsets
                                                  ),
                                          ),
                                        ),
                                      );
                                    }),
                                shape: RoundedRectangleBorder(
                                  side: const BorderSide(color: Colors.grey),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                onTap: () {
                                  if (saveLocationController
                                          .homeOrSearchScreen.value ==
                                      "homepage") {
                                    saveLocationController.setFavouriteLocation(
                                      context: context,
                                      favLocName: "work",
                                    );
                                  } else {
                                    saveLocationController.setFavouriteLocation(
                                      context: context,
                                      favLocName: "work",
                                    );
                                  }
                                },
                              ),
                            ),
                            const SizedBox(
                              height: 30.0,
                            ),
                            Obx(
                              () => ListTile(
                                title: const Text(
                                  "Others",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 20.0,
                                  ),
                                ),
                                subtitle: controller.othersAddress.value.isNotEmpty?Text(
                                  controller.othersAddress.value,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 15.0,
                                  ),
                                ):null,
                                trailing: IconButton(
                                  icon: const Icon(
                                    Icons.edit,
                                  ),
                                  color: Colors.black,
                                  onPressed: () {
                                    controller.workChoosed.value = false;
                                    controller.homeChoosed.value = false;
                                    controller.othersChoosed.value = true;

                                    controller.choosedString.value = "Others";

                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => Obx(
                                          () => controller
                                                  .isMapLocationLoading.value
                                              ? const Center(
                                                  child:
                                                      CircularProgressIndicator(
                                                    color: primaryColor,
                                                  ),
                                                )
                                              : PlacePicker(
                                                  enableMyLocationButton: false,
                                                  usePlaceDetailSearch: true,
                                                  autocompleteRadius: 5000,
                                                  // strictbounds: true,
                                                  // autocompleteOffset: 5000,
                                                  region: "in",
                                                  apiKey: controller
                                                      .googleApikey.value,
                                                  onTapBack: () {
                                                    customAddressShowDialog(
                                                        context);
                                                  },
                                                  onPlacePicked: (result) {
                                                    controller.afterPlacePicked(
                                                        result);
                                                  },
                                                  initialPosition: controller
                                                      .initialCameraPosition,
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
                                shape: RoundedRectangleBorder(
                                  side: const BorderSide(color: Colors.grey),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                onTap: () {
                                  if (saveLocationController
                                          .homeOrSearchScreen.value ==
                                      "homepage") {
                                    saveLocationController.setFavouriteLocation(
                                      context: context,
                                      favLocName: "others",
                                    );
                                  } else {
                                    saveLocationController.setFavouriteLocation(
                                      context: context,
                                      favLocName: "others",
                                    );
                                  }
                                },
                              ),
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
