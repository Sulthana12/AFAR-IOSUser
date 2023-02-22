import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../enable_location/controller/enable_location_controller.dart';
import '../home_page/controller/home_chip_controller.dart';
import '../search_screen/view/search_screen_view.dart';

class CustomAppBar extends StatelessWidget {
  CustomAppBar({
    Key? key,
  }) : super(key: key);

  final locController = Get.put(EnableLocationController());
  final homeChipController = Get.put(HomeChipController());

  @override
  Widget build(BuildContext context) {
    return GetBuilder<EnableLocationController>(
      builder: (controller) {
        return Positioned(
          top: 10,
          right: 15,
          left: 15,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Row(
              children: <Widget>[
                IconButton(
                  splashColor: Colors.grey,
                  icon: Icon(Icons.menu),
                  onPressed: () {
                    Scaffold.of(context).openDrawer();
                  },
                ),
                Expanded(
                  child: InkWell(
                    onTap: () {
                      if ((((homeChipController.rideSelected.value) &&
                          (homeChipController
                              .dailySelected.value ||
                              homeChipController
                                  .rentalSelected.value ||
                              homeChipController
                                  .preBookSelected.value)) ||
                          homeChipController
                              .expressSelected.value)) {

                        homeChipController.vehicleSelected.value =
                        true;
                        Get.to(() => SearchScreen());
                      } else {
                        Get.snackbar("Select ride and its category",
                            "Select ride, category and then choose vehicle");
                        homeChipController.vehicleSelected.value =
                        false;
                      }
                    },
                    child: Obx(
                      ()=> AutoSizeText(
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
          ),
        );
      }
    );
  }
}
