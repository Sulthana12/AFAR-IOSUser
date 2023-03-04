import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../confirmation_page/controller/ride_confirm_controller.dart';
import '../constants/colors/colors.dart';

final rideConfirmController = Get.put(RideConfirmController());

cancelRideModalBottomSheet(BuildContext context, String RideOrExpress) async {
  showModalBottomSheet<void>(
    context: context,
    isDismissible: false,
    enableDrag: false,

    shape: const RoundedRectangleBorder( // <-- SEE HERE
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(25.0),
      ),
    ),
    builder: (BuildContext context) {
      double width = MediaQuery.of(context).size.width;
      double height = MediaQuery.of(context).size.height;

      return SizedBox(
        height: height * 0.5,
        child: Center(
          child: Column(
            mainAxisAlignment:
            MainAxisAlignment
                .spaceEvenly,
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset("assets/images/cancel_ride.png",
                // height: height * 0.3,
                width: width * 0.6,
              ),
              AutoSizeText(
                "Hold on!! We are trying to locate a driver\nnearby",
                maxLines: 2,
                maxFontSize: 20,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 16.0,
                ),
              ),
              LinearProgressIndicator(),
              Material(
                color: primaryColor,
                borderRadius:
                BorderRadius.circular(
                    15),
                child: InkWell(
                  onTap: () async {
                    Navigator.pop(context);
                    await rideConfirmController.cancelRide();
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
                    child: Text(
                      RideOrExpress,
                      style: const TextStyle(
                          fontSize: 20,
                          color: Colors
                              .white,
                      ),
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
}
