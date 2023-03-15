import 'dart:convert';
import 'dart:typed_data';

import 'package:afar_cabs_user/home_page/view/home_page_view.dart';
import 'package:afar_cabs_user/sign_in_up_page/controller/personal_details_controller.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../components/already_have_account.dart';
import '../../components/auth_methods.dart';
import '../../components/custom_rounded_button.dart';
import '../../components/or_divider.dart';
import '../../components/rounded_form_field.dart';
import '../controller/sign_up_email_phone_controller.dart';
import 'email_or_phone_veri_page.dart';

class PersonalDetails extends StatefulWidget {
  PersonalDetails({Key? key}) : super(key: key);

  @override
  State<PersonalDetails> createState() => _PersonalDetailsState();
}

class _PersonalDetailsState extends State<PersonalDetails> {
  final controller = Get.put(PersonalDetailsController());
  final mailPhoneController = Get.put(MailPhoneController());
  final formKey = GlobalKey<FormState>();

  Uint8List? _image;

  void selectImage() async {
    Uint8List image = await controller.pickImage(ImageSource.gallery);

    controller.img64.value = base64Encode(image);

    setState(() {
      _image = image;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          reverse: true,
          child: Form(
            key: formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: SizedBox(
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: GetBuilder<PersonalDetailsController>(
                  builder: (controller) => Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    // crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "personalDetails".tr,
                        style: TextStyle(
                          color: Colors.blue,
                          fontSize: 25.0,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 0.4,
                        ),
                      ),
                      const SizedBox(
                        height: 20.0,
                      ),
                      GestureDetector(
                        onTap: () {},
                        child: Stack(
                          children: [
                            _image != null
                                ? CircleAvatar(
                                    radius: 60,
                                    backgroundColor: Colors.grey.shade200,
                                    child: CircleAvatar(
                                      radius: 40,
                                      backgroundColor: Colors.grey.shade200,
                                      backgroundImage: MemoryImage(_image!),
                                    ),
                                  )
                                : CircleAvatar(
                                    radius: 60,
                                    backgroundColor: Colors.grey.shade200,
                                    child: CircleAvatar(
                                      radius: 40,
                                      backgroundColor: Colors.grey.shade200,
                                      backgroundImage: AssetImage(
                                          'assets/images/default.png'),
                                    ),
                                  ),
                            Positioned(
                              bottom: 1,
                              right: 1,
                              child: GestureDetector(
                                onTap: selectImage,
                                child: Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      width: 3,
                                      color: Colors.blue,
                                    ),
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(
                                        50,
                                      ),
                                    ),
                                    color: Colors.blue,
                                    boxShadow: [
                                      BoxShadow(
                                        offset: Offset(2, 4),
                                        color: Colors.black.withOpacity(
                                          0.3,
                                        ),
                                        blurRadius: 3,
                                      ),
                                    ],
                                  ),
                                  child: const Padding(
                                    padding: EdgeInsets.all(2.0),
                                    child: Icon(Icons.camera_alt_rounded,
                                        color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 20.0,
                      ),
                      TextFormField(
                        controller: controller.firstNameController,
                        maxLength: 50,
                        keyboardType: TextInputType.name,
                        textInputAction: TextInputAction.next,
                        cursorColor: Colors.black,
                        onChanged: (email) {},
                        validator: (firstname) {
                          if (firstname == null || firstname.isEmpty) {
                            return "firNameErr".tr;
                          } else {
                            return null;
                          }
                        },
                        decoration: InputDecoration(
                          hintText: "firName".tr,
                          hintStyle: TextStyle(color: Colors.grey),
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(30.0)),
                          ),
                          prefixIcon: Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Icon(Icons.account_circle_outlined),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20.0,
                      ),
                      TextFormField(
                        controller: controller.lastNameController,
                        maxLength: 50,
                        keyboardType: TextInputType.name,
                        textInputAction: TextInputAction.next,
                        cursorColor: Colors.black,
                        onChanged: (lastname) {},
                        validator: (lastname) {
                          if (lastname == null || lastname.isEmpty) {
                            return "lasNameErr".tr;
                          } else {
                            return null;
                          }
                        },
                        decoration: InputDecoration(
                          hintText: "lasName".tr,
                          hintStyle: TextStyle(color: Colors.grey),
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(30.0)),
                          ),
                          prefixIcon: Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Icon(Icons.account_circle_outlined),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20.0,
                      ),
                      Obx(
                        () => TextFormField(
                          controller: controller.phoneController,
                          enabled: mailPhoneController
                                      .controllerPhone.value.isEmpty ||
                                  controller.isAlreadyRegis.value
                              ? true
                              : false,
                          keyboardType: TextInputType.number,
                          textInputAction: TextInputAction.next,
                          cursorColor: Colors.black,
                          onChanged: (phone) {},
                          validator: (phone) {
                            if (phone == null || phone.isEmpty) {
                              return "phonNumberErr".tr;
                            } else if (phone.length != 10) {
                              return "phonNumberErr2".tr;
                            } else {
                              return null;
                            }
                          },
                          decoration: InputDecoration(
                            hintText: "phonNumber".tr,
                            hintStyle: TextStyle(color: Colors.grey),
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(30.0)),
                            ),
                            prefixIcon: Padding(
                              padding: EdgeInsets.all(16.0),
                              child: Icon(Icons.phone_android_outlined),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20.0,
                      ),
                      TextFormField(
                        controller: controller.locController,
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.next,
                        cursorColor: Colors.black,
                        onChanged: (email) {},
                        decoration: InputDecoration(
                          hintText: "location".tr,
                          hintStyle: TextStyle(color: Colors.grey),
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(30.0)),
                          ),
                          prefixIcon: Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Icon(Icons.location_on),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20.0,
                      ),
                      TextFormField(
                        controller: controller.pinController,
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.next,
                        cursorColor: Colors.black,
                        onChanged: (pincode) {},
                        validator: (pincode) {
                          if (pincode == null || pincode.isEmpty) {
                            return null;
                          } else if (pincode.length != 6) {
                            return "pinCodeErr".tr;
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          errorMaxLines: 2,
                          hintText: "pinCode".tr,
                          hintStyle: TextStyle(
                            color: Colors.grey,
                          ),
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(30.0)),
                          ),
                          prefixIcon: Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Icon(Icons.pin_drop_outlined),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20.0,
                      ),
                      TextFormField(
                        controller: controller.passwordController,
                        keyboardType: TextInputType.text,
                        obscureText: controller.isHiddenPass.value,
                        textInputAction: TextInputAction.next,
                        cursorColor: Colors.black,
                        onChanged: (password) {},
                        validator: (password) {
                          RegExp regex = RegExp(
                              r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$%^&*~(){}`<>,./]).{8,}$');
                          if (password == null || password.isEmpty) {
                            return 'passErr'.tr;
                          } else {
                            if (!regex.hasMatch(password)) {
                              return 'passErr2'.tr;
                            } else {
                              return null;
                            }
                          }
                        },
                        decoration: InputDecoration(
                          hintText: "pass".tr,
                          errorMaxLines: 3,
                          hintStyle: const TextStyle(color: Colors.grey),
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(30.0)),
                          ),
                          prefixIcon: const Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Icon(Icons.key),
                          ),
                          suffixIcon: GestureDetector(
                            onTap: controller.togglePasswordViewPass,
                            child: Icon(
                              controller.isHiddenPass.value
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20.0,
                      ),
                      TextFormField(
                        controller: controller.conPasswordController,
                        keyboardType: TextInputType.text,
                        obscureText: controller.isHiddenConPass.value,
                        textInputAction: TextInputAction.next,
                        cursorColor: Colors.black,
                        onChanged: (conpass) {},
                        validator: (conpass) {
                          RegExp regex = RegExp(
                              r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$%^&*~(){}`<>,./]).{8,}$');
                          if (conpass == null || conpass.isEmpty) {
                            return 'passErr'.tr;
                          } else {
                            if (!regex.hasMatch(conpass)) {
                              return 'passErr2'.tr;
                            } else {
                              return null;
                            }
                          }
                        },
                        decoration: InputDecoration(
                          hintText: "conPass".tr,
                          errorMaxLines: 3,
                          hintStyle: TextStyle(color: Colors.grey),
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(30.0)),
                          ),
                          prefixIcon: Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Icon(Icons.key),
                          ),
                          suffixIcon: GestureDetector(
                            onTap: controller.togglePasswordViewConPass,
                            child: Icon(
                              controller.isHiddenConPass.value
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20.0,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          // crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Obx(
                              () => Checkbox(
                                //only check box
                                value: controller.selected.value == 1,
                                onChanged: (val) {
                                  val ?? true
                                      ? controller.selected.value = 1
                                      : controller.selected.value = null;
                                },
                              ),
                            ),
                            Expanded(
                              child: RichText(
                                maxLines: 8,
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text:
                                          "conditions1".tr,
                                      style: TextStyle(
                                        fontSize: 15.0,
                                        color: Colors.black
                                      ),
                                    ),
                                    TextSpan(
                                      text:
                                      "conditions2".tr,
                                      style: TextStyle(
                                        fontSize: 15.0,
                                        color: Colors.blue,
                                      ),
                                        recognizer: TapGestureRecognizer()..onTap =  () async{
                                          Uri url = Uri.parse("https://afarstorage.blob.core.windows.net/mobile-app/TermsandCondition.html");
                                          if (!await launchUrl(url)) {
                                            throw Exception('Could not launch $url');
                                          }
                                        }
                                    ),
                                    TextSpan(
                                      text:
                                      "condition3".tr,
                                      style: TextStyle(
                                        fontSize: 15.0,
                                          color: Colors.black
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              width: size.width * 0.03,
                            )
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 20.0,
                      ),
                      Obx(
                        () => RoundedButtonCustom(
                          pressed: () async {
                            final isValidForm =
                                formKey.currentState!.validate();
                            controller.isLoading.value = true;

                            if (isValidForm &&
                                (controller.controllerPassword.value ==
                                        controller
                                            .controllerConPassword.value &&
                                    controller.selected.value == 1)) {
                              await controller.postData("register");

                              SharedPreferences prefs =
                                  await SharedPreferences.getInstance();
                              await prefs.setBool('isLoggedIn', true);
                            } else {
                              Get.snackbar(
                                  "chkPassAndConPass".tr,
                                  "chkPassAndConPassDesc".tr);
                              controller.isLoading.value = false;
                            }

                            // mailPhoneController.clearAllInputs();
                            controller.isLoading.value = false;
                          },
                          child: controller.isLoading.value
                              ? const Center(
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                  ),
                                )
                              : Text("signUp".tr),
                        ),
                      ),
                      const SizedBox(
                        height: 30.0,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
