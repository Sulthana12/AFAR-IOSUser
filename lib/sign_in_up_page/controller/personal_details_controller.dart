import 'dart:convert';
import 'dart:typed_data';

import 'package:afar_cabs_user/enable_location/view/enable_location_page.dart';
import 'package:afar_cabs_user/home_page/controller/user_controller.dart';
import 'package:afar_cabs_user/home_page/view/home_page_view.dart';
import 'package:afar_cabs_user/sign_in_up_page/controller/otp_page_controller.dart';
import 'package:afar_cabs_user/sign_in_up_page/controller/sign_up_email_phone_controller.dart';
import 'package:afar_cabs_user/sign_in_up_page/model/sign_up_details.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../api_constants/api_services.dart';
import 'package:http/http.dart' as http;

import '../../components/auth_methods.dart';

class PersonalDetailsController extends GetxController {
  final mailPhoneController = Get.put(MailPhoneController());
  final userProfileController = Get.put(UserProfileController());
  final otpPageController = Get.put(OtpPageController());
  final ApiService apiService = ApiService();

  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final locController = TextEditingController();
  final pinController = TextEditingController();
  final passwordController = TextEditingController();
  final conPasswordController = TextEditingController();
  final phoneController = TextEditingController();

  RxString controllerFirstName = ''.obs;
  RxString controllerLastName = ''.obs;
  RxString controllerLoc = ''.obs;
  RxString controllerPin = ''.obs;
  RxString controllerPassword = ''.obs;
  RxString controllerConPassword = ''.obs;
  RxString controllerPhone = ''.obs;
  RxBool isHiddenPass = true.obs;
  RxBool isHiddenConPass = true.obs;
  RxBool isAlreadyRegis = false.obs;

  RxString img64 = ''.obs;

  bool? checked = true;
  final Rxn<int> selected = Rxn<int>();
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();

    phoneController.text = mailPhoneController.controllerPhone.value;

    firstNameController.addListener(() {
      controllerFirstName.value = firstNameController.text;
    });
    lastNameController.addListener(() {
      controllerLastName.value = lastNameController.text;
    });
    locController.addListener(() {
      controllerLoc.value = locController.text;
    });
    pinController.addListener(() {
      controllerPin.value = pinController.text;
    });
    passwordController.addListener(() {
      controllerPassword.value = passwordController.text;
    });
    conPasswordController.addListener(() {
      controllerConPassword.value = conPasswordController.text;
    });
    phoneController.addListener(() {
      controllerPhone.value = phoneController.text;
    });
  }

  void checkedOrNot(bool? type) {
    checked = type;
    print("Selected $checked");
    update();
  }

  pickImage(ImageSource source) async {
    final ImagePicker imagePicker = ImagePicker();

    XFile? file = await imagePicker.pickImage(source: source);

    if (file != null) {
      return await file.readAsBytes();
    }
    print("No Image selected");
  }

  Future<void> postData(String registerOrLogin) async {
    print(controllerFirstName.value);
    print(controllerLastName.value);
    print(controllerPassword.value);
    print(mailPhoneController.controllerMail.value);
    print(controllerPhone.value);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // print(img64.value.substring(0, 100) ?? "");

    if (registerOrLogin == "loginusotp") {
      SignUpDetails body = SignUpDetails(
        firstName: controllerFirstName.value,
        lastName: controllerLastName.value,
        emailId: mailPhoneController.controllerMail.value.isNotEmpty
            ? mailPhoneController.controllerMail.value
            : "-",
        phoneNum: controllerPhone.value.isEmpty
            ? mailPhoneController.controllerPhone.value
            : controllerPhone.value,
        userPassword: controllerPassword.value.isNotEmpty
            ? controllerPassword.value
            : "afar@123",
        imageData: img64.value,
        userTypeFlg: otpPageController.loginOtpFlag.value &&
                otpPageController.firstTimeLogin.value
            ? "U"
            : "E",
      );

      isLoading.value = true;
      http.Response response = (await apiService.registerUserDetails(body))!;
      if (response.statusCode == 200) {
        Get.snackbar("Registered successfully",
            "You've mobile number have been registered successfully!");

        print("Out user ID lUO" + json.decode(response.body)[0]["outUserId"]);

        int? enableLoc;

        enableLoc = prefs.getInt("enableLoc");
        print("enableLoc: " + enableLoc.toString());

        Get.offAll(() => enableLoc == 0 || enableLoc == null
            ? EnableLocation()
            : HomePage());

        await prefs.setInt("enableLoc", 1);

        /// Updating the user profile after registration complete
        userProfileController.userName.value = controllerFirstName.value;
        userProfileController.mobileNum.value = controllerPhone.value.isEmpty
            ? mailPhoneController.controllerPhone.value
            : controllerPhone.value;

        clearInputText();
      } else {
        // isAlreadyRegis.value = true;
        Get.snackbar("Welcome AFAR USER",
            "Welcome back AFAR User! We are pleased to have you here!!!");

        print("Out user ID lUO" + json.decode(response.body)[0]["outUserId"]);

        userProfileController.userID.value =
            json.decode(response.body)[0]["outUserId"];

        await userProfileController.getUpdatedProfileData();

        int? enableLoc;

        enableLoc = prefs.getInt("enableLoc");
        print("enableLoc: " + enableLoc.toString());

        Get.offAll(() => enableLoc == 0 || enableLoc == null
            ? EnableLocation()
            : HomePage());

        await prefs.setInt("enableLoc", 1);
      }
      print(response.body);
      isLoading.value = false;
    } else {
      /// This is for personal details page
      SignUpDetails body = SignUpDetails(
        firstName: controllerFirstName.value,
        lastName: controllerLastName.value,
        emailId: mailPhoneController.controllerMail.value.isNotEmpty
            ? mailPhoneController.controllerMail.value
            : "-",
        phoneNum: controllerPhone.value.isEmpty
            ? mailPhoneController.controllerPhone.value
            : controllerPhone.value,
        userPassword: controllerPassword.value.isNotEmpty
            ? controllerPassword.value
            : "afar@123",
        imageData: img64.value,
        screenType: "usersignup",
        referralCode: mailPhoneController.isReferralCorrect.value ?
            mailPhoneController.controllerReferral.value : "",
      );

      isLoading.value = true;
      http.Response response = (await apiService.registerUserDetails(body))!;
      print(body.toJson());
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        Get.snackbar(
            "Registered successfully", "You've been registered successfully!");

        String? localUserID;
        int? initScreen;

        SharedPreferences prefs = await SharedPreferences.getInstance();

        /// Setting the userID to the local storage if register successful
        print("User ID personal Detials Cont: " + data[0]["outUserId"]);
        localUserID = prefs.getString("localUserID");
        await prefs.setString("localUserID", data[0]["outUserId"].toString());

        /// Updating the userID value using the stored userID in the local storage
        userProfileController.userID.value = (prefs.getString("localUserID") ?? "");
        print("user profile cont userID: " + userProfileController.userID.value);

        /// Getting the initScreen value to check whether they already signed up or not
        initScreen = prefs.getInt("initScreen");

        Get.offAll(() => initScreen == 0 || initScreen == null
            ? EnableLocation()
            : HomePage());

        /// Updating the user profile after registration complete
        userProfileController.userName.value = controllerFirstName.value;
        userProfileController.mobileNum.value = controllerPhone.value.isEmpty
            ? mailPhoneController.controllerPhone.value
            : controllerPhone.value;

        clearInputText();
      } else {
        isAlreadyRegis.value = true;
        Get.snackbar("Email-ID / Phone Number already registered",
            "Please Sign-In Or Reset Your Password!!!");
      }
      print(response.body);
      isLoading.value = false;
    }

    update();
  }

  void togglePasswordViewPass() {
    isHiddenPass.value = !isHiddenPass.value;
    update();
  }

  void togglePasswordViewConPass() {
    isHiddenConPass.value = !isHiddenConPass.value;
    update();
  }

  clearInputText() {
    firstNameController.clear();
    lastNameController.clear();
    locController.clear();
    pinController.clear();
    passwordController.clear();
    conPasswordController.clear();
    phoneController.clear();
  }
}
