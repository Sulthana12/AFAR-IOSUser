import 'package:afar_cabs_user/constants/colors/colors.dart';
import 'package:afar_cabs_user/express_delivery_page/controller/express_delivery_controller.dart';
import 'package:afar_cabs_user/home_page/controller/home_chip_controller.dart';
import 'package:afar_cabs_user/home_page/view/home_page_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../home_page/controller/user_controller.dart';
import '../../search_screen/controller/places_search_controller.dart';

class ExpressDeliveryConform extends StatelessWidget {
  ExpressDeliveryConform({Key? key}) : super(key: key);
  final placesSearchController = Get.put(PlacesSearchController());
  final userProfileController = Get.put(UserProfileController());
  final expressDelController = Get.put(ExpressDeliveryController());
  final homeChipController = Get.put(HomeChipController());

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
        title: Text("Express Delivery"),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          reverse: false,
          child: Form(
            key: formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: size.width * 0.03),
                    child: Text(
                      "Enter Receiver Details",
                      style: TextStyle(
                        color: primaryColor,
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  TextFormField(
                    controller: expressDelController.receiverNameController,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    cursorColor: Colors.black,
                    onChanged: (email) {},
                    validator: MultiValidator([
                      RequiredValidator(
                          errorText: "Must enter an receiver name"),
                      // EmailValidator(errorText: "Enter a valid email"),
                    ]),
                    decoration: const InputDecoration(
                      hintText: "Receiver Name",
                      hintStyle: TextStyle(color: Colors.grey),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(30.0)),
                      ),
                      prefixIcon: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Icon(Icons.person),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  TextFormField(
                    controller: expressDelController.receiverPhoneController,
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                    cursorColor: Colors.black,
                    onChanged: (phone) {},
                    validator: (phone) {
                      if (phone == null || phone.isEmpty) {
                        return "Must enter the receiver Phone number";
                      } else if (phone.length != 10) {
                        return "Phone number must be 10 digits";
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      hintText: "Receiver Contact Number",
                      hintStyle: TextStyle(color: Colors.grey),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(30.0)),
                      ),
                      prefixIcon: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Icon(Icons.phone),
                      ),
                    ),
                  ),

                  /// PICKUP LOCATION DETAILS
                  const SizedBox(
                    height: 20.0,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: size.width * 0.03),
                    child: Text(
                      "PICKUP LOCATION",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: size.width * 0.03),
                    child: Text(
                      placesSearchController.controllerStartSearchField.value,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 14.0,
                        // fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 5.0,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: size.width * 0.03),
                    child: Text(
                      userProfileController.userName.value.isNotEmpty
                          ? "${userProfileController.userName.value} - +91 ${userProfileController.mobileNum.value}"
                          : "AFAR User",
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 14.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  /// DROP LOCATION DETAILS
                  const SizedBox(
                    height: 20.0,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: size.width * 0.03),
                    child: Text(
                      "DROP LOCATION",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: size.width * 0.03),
                    child: Text(
                      placesSearchController.controllerEndSearchField.value,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 14.0,
                        // fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 5.0,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: size.width * 0.03),
                    child: Obx(
                      () => Text(
                        expressDelController
                                    .controllerReceiverName.value.isNotEmpty &&
                                expressDelController
                                    .controllerReceiverPhone.value.isNotEmpty
                            ? "${expressDelController.controllerReceiverName.value} - +91 ${expressDelController.controllerReceiverPhone.value}"
                            : "Type receiver name and number above",
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 14.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: size.width * 0.03),
                    child: Text(
                      "What do you want to send?",
                      style: TextStyle(
                        color: primaryColor,
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  GetBuilder<ExpressDeliveryController>(
                    builder: (controller) {
                      return Padding(
                        padding: EdgeInsets.only(left: size.width * 0.03),
                        child: Container(
                          // padding: EdgeInsets.symmetric(),
                          height: size.height * 0.15,
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: [
                              InkWell(
                                onTap: () {
                                  controller.itemSelected.value = "food";
                                },
                                child: Obx(
                                  () => Container(
                                    width: size.width * 0.25,
                                    child: Card(
                                      color: controller.itemSelected.value ==
                                              "food"
                                          ? vehiclesContainerColor3
                                          : primaryColor,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Container(
                                            child: Center(
                                              child: Image.asset(
                                                "assets/images/food.png",
                                                height: size.height * 0.08,
                                                width: size.width * 0.2,
                                                // fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                          Text(
                                            "Food",
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 14.0,
                                              // fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  controller.itemSelected.value = "documents";
                                },
                                child: Obx(
                                  () => Container(
                                    width: size.width * 0.25,
                                    child: Card(
                                      color: controller.itemSelected.value ==
                                              "documents"
                                          ? vehiclesContainerColor3
                                          : primaryColor,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Container(
                                            child: Center(
                                              child: Image.asset(
                                                "assets/images/documents.png",
                                                height: size.height * 0.08,
                                                width: size.width * 0.2,
                                                // fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                          Text(
                                            "Documents",
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 14.0,
                                              // fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  controller.itemSelected.value = "logistics";
                                },
                                child: Obx(
                                  () => Container(
                                    width: size.width * 0.25,
                                    child: Card(
                                      color: controller.itemSelected.value ==
                                              "logistics"
                                          ? vehiclesContainerColor3
                                          : primaryColor,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Container(
                                            child: Center(
                                              child: Image.asset(
                                                "assets/images/logistics.png",
                                                height: size.height * 0.08,
                                                width: size.width * 0.2,
                                                // fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                          Text(
                                            "Logistics",
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 14.0,
                                              // fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  controller.itemSelected.value = "others";
                                },
                                child: Obx(
                                  () => Container(
                                    width: size.width * 0.25,
                                    child: Card(
                                      color: controller.itemSelected.value ==
                                              "others"
                                          ? vehiclesContainerColor3
                                          : primaryColor,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Container(
                                            child: Center(
                                              child: Image.asset(
                                                "assets/images/more.png",
                                                height: size.height * 0.08,
                                                width: size.width * 0.2,
                                                // fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                          Text(
                                            "Others",
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 14.0,
                                              // fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
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
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: size.width * 0.03),
                    child: Text(
                      "Note to the delivery partner",
                      style: TextStyle(
                        color: primaryColor,
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  TextFormField(
                    controller: expressDelController.noteController,
                    textInputAction: TextInputAction.next,
                    cursorColor: Colors.black,
                    onChanged: (password) {},
                    // validator: expressDelController.itemSelected.value == "others" ?
                    // MultiValidator([
                    //   RequiredValidator(
                    //       errorText: "Must enter receiver contact number"),
                    // ]) : (note) {
                    //   if (note == null || note.isEmpty) {
                    //     return null;
                    //   }
                    // },
                    decoration: InputDecoration(
                      hintText: "Note to the delivery partner",
                      hintStyle: TextStyle(color: Colors.grey),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(30.0)),
                      ),
                      prefixIcon: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Icon(Icons.note_add),
                      ),
                      suffixIcon: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Icon(Icons.camera_alt_rounded),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 30.0,
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: primaryColor,
                      minimumSize: const Size.fromHeight(50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    onPressed: () {
                      final isValidForm = formKey.currentState!.validate();
                      print(expressDelController.controllerNote.value);

                      if (isValidForm &&
                          expressDelController.itemSelected.value == "others" &&
                          expressDelController
                              .controllerNote.value.isNotEmpty) {

                        homeChipController.rideConfirmed.value = true;
                        Get.off(() => HomePage());
                      } else if (isValidForm && expressDelController.itemSelected.value.isNotEmpty && expressDelController.itemSelected.value != "others") {

                        homeChipController.rideConfirmed.value = true;
                        Get.off(() => HomePage());
                      } else if (isValidForm &&
                          expressDelController.itemSelected.value == "others" &&
                          expressDelController
                              .controllerNote.value.isEmpty) {
                        Get.snackbar("Enter the note for others", "Must enter the note for others that you want to send");
                      } else {
                        Get.snackbar("Enter receiver name and number", "Must enter the receiver name and number to proceed");
                      }
                    },
                    child: Text(
                      'PAY 150.65',
                      style: TextStyle(fontSize: 24),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
