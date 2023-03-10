import 'package:afar_cabs_user/api_constants/api_services.dart';
import 'package:afar_cabs_user/confirmation_page/controller/distance_sending_api_controller.dart';
import 'package:afar_cabs_user/confirmation_page/controller/payment_controller.dart';
import 'package:afar_cabs_user/confirmation_page/view/ride_confirmation_page.dart';
import 'package:afar_cabs_user/constants/colors/colors.dart';
import 'package:afar_cabs_user/home_page/controller/user_controller.dart';
import 'package:afar_cabs_user/home_page/controller/vehicles_controller.dart';
import 'package:afar_cabs_user/home_page/view/home_page_view.dart';
import 'package:afar_cabs_user/search_screen/controller/places_search_controller.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

import '../../components/cancel_ride_model_bsheet.dart';
import '../../components/myself_model_bsheet.dart';
import '../../components/or_divider.dart';
import '../../coupon_page/view/coupon_page.dart';
import '../../home_page/controller/home_chip_controller.dart';
import '../controller/ride_confirm_controller.dart';

class ConfirmationPage extends StatefulWidget {
  ConfirmationPage({Key? key}) : super(key: key);

  @override
  State<ConfirmationPage> createState() => _ConfirmationPageState();
}

class _ConfirmationPageState extends State<ConfirmationPage> {
  final placesSearchController = Get.put(PlacesSearchController());
  final paymentController = Get.put(PaymentController());
  final userController = Get.put(UserProfileController());
  final homeChipController = Get.put(HomeChipController());
  final distanceCalController = Get.put(DistanceCalApiController());

  // late Razorpay _razorpay;
  //
  // @override
  // void initState() {
  //   super.initState();
  //   _razorpay = Razorpay();
  //   _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
  //   _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
  //   _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  // }
  //
  // @override
  // void dispose() {
  //   super.dispose();
  //   _razorpay.clear();
  // }
  //
  // Future<void> openCheckout() async {
  //   var options = {
  //     'key': 'rzp_test_4h7lOvu2b85gCF',
  //     'name': 'AfarTechnologies',
  //     'currency': 'INR',
  //     'amount': 100,
  //     'description': 'Demoing Charges',
  //     'send_sms_hash': true,
  //     'prefill': {
  //       'contact': userController.mobileNum.value,
  //       'email': 'afarcabs@gmail.com'
  //     },
  //   };
  //
  //   try {
  //     _razorpay.open(options);
  //   } catch (e) {
  //     print(e);
  //   }
  // }
  //
  // void _handlePaymentSuccess(PaymentSuccessResponse response) {
  //   Get.snackbar("SUCCESS", "SUCCESS: ${response.paymentId.toString()}");
  //   Get.offAll(()=>HomePage());
  //   showModalBottomSheet<void>(
  //     context: context,
  //     shape: const RoundedRectangleBorder( // <-- SEE HERE
  //       borderRadius: BorderRadius.vertical(
  //         top: Radius.circular(25.0),
  //       ),
  //     ),
  //     builder: (BuildContext context) {
  //       double width = MediaQuery.of(context).size.width;
  //       double height = MediaQuery.of(context).size.height;
  //
  //       return SizedBox(
  //         height: height * 0.5,
  //         child: Center(
  //           child: Column(
  //             mainAxisAlignment:
  //             MainAxisAlignment
  //                 .spaceEvenly,
  //             // crossAxisAlignment: CrossAxisAlignment.start,
  //             children: [
  //               Image.asset("assets/images/cancel_ride.png",
  //                 // height: height * 0.3,
  //                 width: width * 0.6,
  //               ),
  //               AutoSizeText(
  //                 "Hold on!! We are trying to locate a driver\nnearby",
  //                 maxLines: 2,
  //                 maxFontSize: 20,
  //                 style: TextStyle(
  //                   fontWeight: FontWeight.w500,
  //                   fontSize: 16.0,
  //                 ),
  //               ),
  //               LinearProgressIndicator(),
  //               Material(
  //                 color: primaryColor,
  //                 borderRadius:
  //                 BorderRadius.circular(
  //                     15),
  //                 child: InkWell(
  //                   onTap: () {
  //                     Navigator.pop(context);
  //                   },
  //                   borderRadius:
  //                   BorderRadius
  //                       .circular(0),
  //                   child: Container(
  //                     width: width * 0.9,
  //                     height: height * 0.08,
  //                     decoration:
  //                     BoxDecoration(
  //                       borderRadius:
  //                       BorderRadius
  //                           .circular(
  //                           15),
  //                     ),
  //                     alignment:
  //                     Alignment.center,
  //                     child: const Text(
  //                       'Cancel Ride',
  //                       style: TextStyle(
  //                           fontSize: 20,
  //                           color: Colors
  //                               .white),
  //                     ),
  //                   ),
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ),
  //       );
  //     },
  //   );
  // }
  //
  // void _handlePaymentError(PaymentFailureResponse response) {
  //   Get.snackbar("ERROR", "ERROR: ${response.code} - ${response.message}");
  // }
  //
  // void _handleExternalWallet(ExternalWalletResponse response) {
  //   Get.snackbar("EXTERNAL WALLET", "EXTERNAL WALLET: ${response.walletName}");
  // }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: GetBuilder<DistanceCalApiController>(builder: (controller) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.circle,
                        color: Colors.green,
                      ),
                      SizedBox(
                        width: size.width * 0.05,
                      ),
                      Expanded(
                        child: Text(
                          placesSearchController
                              .controllerStartSearchField.value,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 15.0,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 25.0,
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.circle,
                        color: Colors.red,
                      ),
                      SizedBox(
                        width: size.width * 0.05,
                      ),
                      Expanded(
                        child: Text(
                          placesSearchController.controllerEndSearchField.value,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 15.0,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 30.0,
                  ),
                  controller.fareDetailsModel!.isEmpty
                      ? Center(
                          child: CircularProgressIndicator(color: primaryColor),
                        )
                      : SizedBox(
                          height: size.height * 0.35,
                          child: ListView.separated(
                            itemCount: controller.fareDetailsModel!.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Obx(
                                () => ListTile(
                                  shape: RoundedRectangleBorder(
                                    side:
                                        controller.selectedVehicleIndex.value ==
                                                controller.fareDetailsModel![index]
                                                    .vehicleId
                                            ? BorderSide(
                                                width: 2, color: primaryColor)
                                            : BorderSide.none,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  onTap: () {
                                    controller.selectedVehicleIndex.value =
                                        controller
                                            .fareDetailsModel![index].vehicleId!;

                                    controller.selectedVehicleName.value =
                                        controller.fareDetailsModel![index]
                                            .vehicleName!;
                                    print(controller.selectedVehicleName.value);
                                  },
                                  leading: Image.network(
                                    controller
                                        .fareDetailsModel![index].fileLocation!,
                                    height: size.height * 0.08,
                                    width: size.width * 0.2,
                                  ),
                                  title: Padding(
                                    padding: EdgeInsets.only(left: 32.0),
                                    child: Text(
                                      controller
                                          .fareDetailsModel![index].vehicleName!,
                                      style: TextStyle(
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                  trailing: Text(
                                    '${controller
                                        .fareDetailsModel![index].calFare!}',
                                    style: TextStyle(
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              );
                            },
                            separatorBuilder:
                                (BuildContext context, int index) {
                              return SizedBox(
                                height: size.height * 0.03,
                              );
                            },
                          ),
                        ),
                  Text(
                    "Select Payment Type",
                    style: TextStyle(fontSize: 20, color: Colors.black, fontWeight: FontWeight.w500),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Obx( () => Container(
                    padding: const EdgeInsets.symmetric(horizontal: 23.0),
                    decoration: BoxDecoration(
                      color: primaryColor,
                    ),
                    child: DropdownButton(
                      isExpanded: true,
                      hint: Text(
                        'Payment type',
                      ),
                      dropdownColor: primaryColor,
                      style: const TextStyle(
                          color: Colors.white, //<-- SEE HERE
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                      ),
                      icon: Icon(
                        Icons.arrow_drop_down,
                        color: Colors.white, // <-- SEE HERE
                      ),
                      onChanged: (String? newValue) {
                        paymentController.setSelected(newValue!);
                      },
                      value: paymentController.selected.value,
                      items: paymentController.listType.map((selectedType) {
                        return DropdownMenuItem(
                          child: Text(
                            selectedType,
                          ),
                          value: selectedType,
                        );
                      }).toList(),
                    ),
                  )
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: Material(
                          color: Colors.white,
                          elevation: 0,
                          borderRadius: BorderRadius.circular(15),
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          child: InkWell(
                            onTap: () {
                              myselfOrElseModelBtmSheet(context);
                            },
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Icon(Icons.contact_phone_outlined,
                                    size: 35,
                                  ),
                                ),
                                SizedBox(
                                  width: 7,
                                ),
                                AutoSizeText(
                                  "Myself",
                                  maxLines: 1,
                                  style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
                                ),
                                SizedBox(
                                  width: 7,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Material(
                          color: Colors.white,
                          elevation: 0,
                          borderRadius: BorderRadius.circular(15),
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          child: InkWell(
                            onTap: () {
                              Get.to(() => CouponPage());
                            },
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Ink.image(
                                    image: AssetImage("assets/images/giftbox.png"),
                                    height: 30,
                                    width: 30,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                SizedBox(
                                  width: 7,
                                ),
                                AutoSizeText(
                                  "Coupon",
                                  maxLines: 1,
                                  style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
                                ),
                                SizedBox(
                                  width: 7,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  // SizedBox(
                  //   height: 20.0,
                  // ),
                  // Center(
                  //   child: Material(
                  //     color: Colors.white,
                  //     elevation: 0,
                  //     borderRadius: BorderRadius.circular(15),
                  //     clipBehavior: Clip.antiAliasWithSaveLayer,
                  //     child: InkWell(
                  //       onTap: () {
                  //         Get.offAll(() => HomePage());
                  //       },
                  //       child: Row(
                  //         mainAxisSize: MainAxisSize.min,
                  //         children: [
                  //           Padding(
                  //             padding: const EdgeInsets.all(8.0),
                  //             child: Ink.image(
                  //               image: AssetImage("assets/images/checked.png"),
                  //               height: 30,
                  //               width: 30,
                  //               fit: BoxFit.cover,
                  //             ),
                  //           ),
                  //           SizedBox(
                  //             width: 7,
                  //           ),
                  //           Text(
                  //             "CONFIRM RIDE",
                  //             style: TextStyle(fontSize: 20, color: Colors.black, fontWeight: FontWeight.w500),
                  //           ),
                  //           SizedBox(
                  //             width: 7,
                  //           ),
                  //         ],
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  Center(
                    child: Material(
                      color: Colors.white,
                      elevation: 0,
                      borderRadius: BorderRadius.circular(15),
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      child: InkWell(
                        onTap: () async {
                          print(paymentController.selected.value);
                          if (paymentController.selected.value == "UPI") {
                            // await openCheckout();
                            homeChipController.rideConfirmed.value = true;

                            /// Here you can change the new ride confirmation page
                            // Get.to(() => RideConfirmationPage());

                            Get.offAll(()=>HomePage());
                            await cancelRideModalBottomSheet(context, "Cancel Ride");
                          } else {
                            homeChipController.rideConfirmed.value = true;

                            /// Here you can change the new ride confirmation page
                            // Get.to(() => RideConfirmationPage());

                            Get.offAll(() => HomePage());
                            await cancelRideModalBottomSheet(context, "Cancel Ride");
                          }
                          // await apiService.getBaseVehicleFareDetails();
                          // Get.offAll(() => HomePage());
                        },
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Ink.image(
                                image: AssetImage("assets/images/checked.png"),
                                height: 30,
                                width: 30,
                                fit: BoxFit.cover,
                              ),
                            ),
                            SizedBox(
                              width: 7,
                            ),
                            AutoSizeText(
                              "CONFIRM RIDE",
                              maxLines: 1,
                              style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
                            ),
                            SizedBox(
                              width: 7,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                ],
              );
            }),
          ),
        ),
      ),
    );
  }
}
