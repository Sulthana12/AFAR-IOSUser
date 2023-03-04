import 'package:afar_cabs_user/confirmation_page/controller/ride_confirm_controller.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_contact_picker/flutter_native_contact_picker.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';

import '../constants/colors/colors.dart';

Future<void> myselfOrElseModelBtmSheet(BuildContext context) {
  final rideConfirmController = Get.put(RideConfirmController());
  final FlutterContactPicker contactPicker = FlutterContactPicker();

  return showModalBottomSheet<void>(
    context: context,
    // isDismissible: false,
    enableDrag: true,
    // isScrollControlled: true,

    shape: const RoundedRectangleBorder(
      // <-- SEE HERE
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(25.0),
      ),
    ),
    builder: (BuildContext context) {
      double width = MediaQuery.of(context).size.width;
      double height = MediaQuery.of(context).size.height;

      return SizedBox(
        height: height * 0.7,
        child: Center(
          child: Wrap(
            alignment: WrapAlignment.spaceEvenly,
            runAlignment: WrapAlignment.spaceEvenly,
            crossAxisAlignment: WrapCrossAlignment.center,
            // spacing: 20.0,
            runSpacing: 10.0,
            // mainAxisAlignment:
            // MainAxisAlignment
            //     .spaceEvenly,
            // crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // SizedBox(
              //   height: height * 0.03,
              // ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: AutoSizeText(
                  "Someone else taking this ride?",
                  maxLines: 1,
                  minFontSize: 16,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 25.0,
                  ),
                ),
              ),
              // SizedBox(
              //   height: height * 0.03,
              // ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: AutoSizeText(
                  "Choose a contact, so thatthey also get the\ndriver details, ride OTP and the live location of\nthe driver",
                  maxLines: 3,
                  textAlign: TextAlign.justify,
                  style: TextStyle(
                    fontSize: 18.0,
                  ),
                ),
              ),
              // SizedBox(
              //   height: height * 0.03,
              // ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GetBuilder<RideConfirmController>(builder: (controller) {
                    return Radio(
                      value: controller.verifyType[0],
                      groupValue: controller.selected,
                      activeColor: Colors.black,
                      onChanged: (value) {
                        controller.setVerifyType(value.toString());
                        print(value); //selected value
                      },
                    );
                  }),
                  Icon(
                    Icons.person,
                    color: Colors.grey,
                    size: 25,
                  ),
                  SizedBox(
                    width: 20.0,
                  ),
                  Expanded(
                    child: AutoSizeText(
                      "Myself",
                      maxLines: 1,
                      style: TextStyle(
                        fontSize: 20.0,
                        // fontWeight: FontWeight.bold,
                      ),
                    ),
                  ), // Divider(thickness: 10, color: Colors.grey,),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(left: width * 0.13),
                child: Divider(
                  thickness: 1.0,
                  color: Colors.grey,
                ),
              ),
              GetBuilder<RideConfirmController>(
                builder: (controller) =>
                    controller.contactPhoneNumber.value.isEmpty
                        ? Container()
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Radio(
                                value: controller.verifyType[1],
                                groupValue: controller.selected,
                                activeColor: Colors.black,
                                onChanged: (value) {
                                  controller.setVerifyType(value.toString());
                                  print(value); //selected value
                                },
                              ),
                              Icon(
                                Icons.person,
                                color: primaryColor,
                                size: 25,
                              ),
                              SizedBox(
                                width: 20.0,
                              ),
                              Expanded(
                                child: Obx(
                                  () => AutoSizeText(
                                    controller.contactFullName.value,
                                    maxLines: 1,
                                    style: TextStyle(
                                      fontSize: 20.0,
                                      color: primaryColor,
                                      // fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ), // Divider(thickness: 10, color: Colors.grey,),
                            ],
                          ),
              ),
              Obx(
                ()=> Visibility(
                  visible: rideConfirmController.contactPhoneNumber.value.isNotEmpty ? true : false,
                  child: Padding(
                    padding: EdgeInsets.only(left: width * 0.13),
                    child: Divider(
                      thickness: 1.0,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
              // SizedBox(
              //   height: height * 0.03,
              // ),
              Padding(
                padding: EdgeInsets.only(left: width * 0.1),
                child: GestureDetector(
                  onTap: () async {
                    print("pressed");
                    Contact? contact = await contactPicker.selectContact();
                    Contact? selectedContact = contact;

                    rideConfirmController.contactFullName.value =
                        selectedContact?.fullName!.toString() ?? '';
                    rideConfirmController.contactPhoneNumber.value =
                        selectedContact?.phoneNumbers![0].toString() ?? '';

                    if (rideConfirmController.contactPhoneNumber.value.isNotEmpty) {
                      rideConfirmController.setVerifyType("else");
                    }

                    print(selectedContact?.fullName!.toString());
                    print(selectedContact?.phoneNumbers!.toString());
                  },
                  child: Row(
                    // mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Icon(Icons.contacts_rounded,
                          size: 30, color: primaryColor),
                      AutoSizeText(
                        "Choose another contact",
                        maxLines: 1,
                        style: TextStyle(
                          fontSize: 20.0,
                          color: primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Icon(Icons.chevron_right, size: 30, color: primaryColor),
                    ],
                  ),
                ),
              ),
              // SizedBox(
              //   height: height * 0.05,
              // ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: 18.0,
                  ),
                  Expanded(
                    child: Material(
                      color: Colors.grey.shade300,
                      elevation: 0,
                      borderRadius: BorderRadius.circular(10),
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      child: InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Container(
                          padding: EdgeInsets.all(8.0),
                          height: height * 0.08,
                          width: width / 2,
                          child: Center(
                            child: AutoSizeText(
                              "Skip",
                              maxLines: 1,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 20.0,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 18.0,
                  ),
                  Expanded(
                    child: Material(
                      color: primaryColor,
                      elevation: 0,
                      borderRadius: BorderRadius.circular(10),
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      child: InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Container(
                          padding: EdgeInsets.all(8.0),
                          height: height * 0.08,
                          width: width / 2,
                          child: Center(
                            child: AutoSizeText(
                              "Continue",
                              maxLines: 1,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20.0,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 18.0,
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}
