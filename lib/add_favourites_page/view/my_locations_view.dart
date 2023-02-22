import 'package:afar_cabs_user/add_favourites_page/controller/save_location_controller.dart';
import 'package:afar_cabs_user/constants/colors/colors.dart';
import 'package:afar_cabs_user/home_page/view/home_page_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_place_picker_mb/google_maps_place_picker.dart';

import '../../components/custom_address_show_dialog.dart';
import '../../enable_location/controller/enable_location_controller.dart';
import '../../home_page/controller/google_map_controller.dart';
import '../../search_screen/controller/places_search_controller.dart';
import 'add_favourites_page_view.dart';

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
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          color: Colors.black,
          onPressed: () {
            // Get.off(HomePage());
            Navigator.pop(context);
          },
        ),
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
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
                child: GetBuilder<SaveLocationController>(
                  builder: (controller) {
                    return controller.isMyLocationsLoading.value ?
                    Center(child: CircularProgressIndicator(color: primaryColor),) :
                      Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: const Text(
                            "My Locations",
                            style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.8,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 30.0,
                        ),
                        Obx(
                          ()=> ListTile(
                            title: Text(
                              "Home",
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 18.0,
                              ),
                            ),
                            subtitle: Text(
                              controller.homeAddress.value,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 15.0,
                              ),
                            ),
                            trailing: IconButton(
                                    icon: Icon(
                                      Icons.edit,
                                    ),
                                    color: Colors.black,
                                    onPressed: () {

                                      controller.homeChoosed.value = true;
                                      controller.workChoosed.value = false;
                                      controller.othersChoosed.value = false;

                                      controller.choosedString.value  = "Home";

                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => Obx(
                                                () => controller.isMapLocationLoading.value
                                                ? Center(
                                              child: CircularProgressIndicator(
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
                                              apiKey:
                                              controller.googleApikey.value,
                                              onTapBack: () {
                                                if (controller.onCameraMoveStarted.value) {
                                                  customAddressShowDialog(context);
                                                } else {
                                                  Navigator.pop(context);
                                                }
                                              },
                                              onPlacePicked: (result) {
                                                controller.afterPlacePicked(result);
                                              },
                                                  onCameraMoveStarted: (someValue) {
                                                controller.onCameraMoveStarted.value = true;
                                                  },
                                              initialPosition:
                                              controller.initialCameraPosition,
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
                              side: BorderSide(color: Colors.grey),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            onTap: () {},
                          ),
                        ),
                        const SizedBox(
                          height: 30.0,
                        ),
                        Obx(
                          ()=> ListTile(
                            title: Text(
                              "Work",
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 20.0,
                              ),
                            ),
                            subtitle: Text(
                              controller.workAddress.value,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 15.0,
                              ),
                            ),
                            trailing:IconButton(
                                  icon: Icon(
                                    Icons.edit,
                                  ),
                                  color: Colors.black,
                                  onPressed: () {

                                    controller.workChoosed.value = true;
                                    controller.homeChoosed.value = false;
                                    controller.othersChoosed.value = false;

                                    controller.choosedString.value  = "Work";

                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => Obx(
                                              () => controller.isMapLocationLoading.value
                                              ? Center(
                                            child: CircularProgressIndicator(
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
                                            apiKey:
                                            controller.googleApikey.value,
                                            onTapBack: () {
                                              customAddressShowDialog(context);
                                            },
                                            onPlacePicked: (result) {
                                              controller.afterPlacePicked(result);
                                            },
                                            initialPosition:
                                            controller.initialCameraPosition,
                                            useCurrentLocation: true,
                                            // selectInitialPosition: true,
                                            resizeToAvoidBottomInset:
                                            false, // only works in page mode, less flickery, remove if wrong offsets
                                          ),
                                        ),
                                      ),

                                );
                              }
                            ),
                            shape: RoundedRectangleBorder(
                              side: BorderSide(color: Colors.grey),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            onTap: () {},
                          ),
                        ),
                        const SizedBox(
                          height: 30.0,
                        ),
                        Obx(
                          ()=> ListTile(
                            title: Text(
                              "Others",
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 20.0,
                              ),
                            ),
                            subtitle: Text(
                              controller.othersAddress.value,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 15.0,
                              ),
                            ),
                            trailing: IconButton(
                                    icon: Icon(
                                      Icons.edit,
                                    ),
                                    color: Colors.black,
                                    onPressed: () {

                                      controller.workChoosed.value = false;
                                      controller.homeChoosed.value = false;
                                      controller.othersChoosed.value = true;

                                      controller.choosedString.value  = "Others";

                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => Obx(
                                                () => controller.isMapLocationLoading.value
                                                ? Center(
                                              child: CircularProgressIndicator(
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
                                              apiKey:
                                              controller.googleApikey.value,
                                              onTapBack: () {
                                                customAddressShowDialog(context);
                                              },
                                              onPlacePicked: (result) {
                                                controller.afterPlacePicked(result);
                                              },
                                              initialPosition:
                                              controller.initialCameraPosition,
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
                              side: BorderSide(color: Colors.grey),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            onTap: () {},
                          ),
                        ),
                      ],
                    );
                  }
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
