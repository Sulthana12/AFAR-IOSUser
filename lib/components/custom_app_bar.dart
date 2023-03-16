import 'package:afar_cabs_user/constants/colors/colors.dart';
import 'package:afar_cabs_user/home_page/controller/vehicles_controller.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../enable_location/controller/enable_location_controller.dart';
import '../home_page/controller/home_chip_controller.dart';
import '../search_screen/view/search_screen_view.dart';

class CustomAppBar extends StatelessWidget {
  CustomAppBar({
    Key? key,
  }) : super(key: key);

  final locController = Get.put(EnableLocationController());
  final homeChipController = Get.put(HomeChipController());
  final vehiclesController = Get.put(VehiclesController());

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Positioned(
      top: AppBar().preferredSize.height,
      right: 15,
      left: 15,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          GetBuilder<EnableLocationController>(builder: (controller) {
            return Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Row(
                children: <Widget>[
                  IconButton(
                    splashColor: Colors.grey,
                    icon: const Icon(Icons.menu),
                    onPressed: () {
                      Scaffold.of(context).openDrawer();
                    },
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        if ((((homeChipController.rideSelected.value) &&
                                (homeChipController.dailySelected.value ||
                                    homeChipController.rentalSelected.value ||
                                    homeChipController
                                        .preBookSelected.value)) ||
                            homeChipController.expressSelected.value)) {
                          homeChipController.vehicleSelected.value = true;
                          Get.to(() => SearchScreen());
                        } else {
                          Get.snackbar("Select ride and its category",
                              "Select ride, category and then choose vehicle");
                          homeChipController.vehicleSelected.value = false;
                        }
                      },
                      child: Obx(
                        () => AutoSizeText(
                          controller.currentAddress.value != ""
                              ? controller.currentAddress.value
                              : "Saved Location - as default",
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
          const SizedBox(
            height: 10,
          ),
          GetBuilder<VehiclesController>(builder: (controller) {
            return Obx(
              () => Visibility(
                visible:
                    homeChipController.expressSelected.value ? false : true,
                child: Container(
                  height: height * 0.38,
                  width: 100,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10.0),
                    // border: Border.all(color: primaryColor, width: 2.0),
                  ),
                  child: controller.vehiclesModel!.isEmpty
                      ? const Center(
                          child: CircularProgressIndicator(color: primaryColor),
                        )
                      : ListView.builder(
                          padding: EdgeInsets.zero,
                          itemCount: controller.vehiclesModel!.length,
                          itemBuilder: (BuildContext context, int index) {
                            return TextButton(
                              onPressed: () async {
                                // await apiService.getVehiclesData();

                                if ((homeChipController.rideSelected.value) &&
                                    (homeChipController.dailySelected.value ||
                                        homeChipController
                                            .rentalSelected.value ||
                                        homeChipController
                                            .preBookSelected.value)) {
                                  controller.selectedVehicleIndex.value =
                                      controller
                                          .vehiclesModel![index].settingsId!;

                                  /// setting the vehicle name
                                  controller.selectedVehicleName.value =
                                      controller
                                          .vehiclesModel![index].settingsValue!;

                                  homeChipController.vehicleSelected.value =
                                      true;
                                } else {
                                  Get.snackbar("Select ride and its category",
                                      "Select ride, category and then choose vehicle");
                                  homeChipController.vehicleSelected.value =
                                      false;
                                }
                              },
                              child: Obx(
                                () => Container(
                                  width: double.maxFinite,
                                  decoration:
                                      (homeChipController.rideSelected.value) &&
                                              (homeChipController
                                                      .dailySelected.value ||
                                                  homeChipController
                                                      .rentalSelected.value ||
                                                  homeChipController
                                                      .preBookSelected.value)
                                          ? BoxDecoration(
                                              border: controller
                                                          .selectedVehicleIndex
                                                          .value ==
                                                      controller
                                                          .vehiclesModel![index]
                                                          .settingsId
                                                  ? Border.all(
                                                      width: 2,
                                                      color:
                                                          Colors.grey.shade900,
                                                    )
                                                  : null,
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                            )
                                          : BoxDecoration(
                                              color: Colors.transparent,
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                            ),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      CachedNetworkImage(
                                        imageUrl: controller.vehiclesModel![index]
                                            .fileLocation!,
                                        height: height * 0.04,
                                        width: width * 0.1,
                                        placeholder: (context, url) => Container(color:Colors.black12),
                                        errorWidget: (context, url, error) => Icon(Icons.error),
                                      ),
                                      Text(
                                        controller.vehiclesModel![index]
                                            .settingsValue!,
                                        style: const TextStyle(
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
          })
        ],
      ),
    );
  }
}
