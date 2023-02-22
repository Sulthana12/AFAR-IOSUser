import 'package:afar_cabs_user/api_constants/api_services.dart';
import 'package:afar_cabs_user/sign_in_up_page/controller/sign_up_email_phone_controller.dart';
import 'package:email_auth/email_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:neon_circular_timer/neon_circular_timer.dart';

class OtpPageController extends GetxController {
  final pinController = TextEditingController();
  EmailAuth emailAuth = EmailAuth(sessionName: "Verify your email");
  FirebaseAuth auth = FirebaseAuth.instance;
  final ApiService apiService = ApiService();

  RxInt duration = 10.obs;
  RxBool otpTimeCompleted = true.obs;
  // late CountdownTimerController countDownController;
  // /// 3 minutes
  // int endTime = DateTime.now().millisecondsSinceEpoch + 1000 * 60;
  //
  final CountDownController otpTimeController = CountDownController();

  final mailPhoneController = Get.put(MailPhoneController());
  final String countryCode = "+91";

  RxBool otpSendFlag = false.obs;
  RxBool otpVerifyFlag = false.obs;
  RxString verifyId = "".obs;
  RxString otpSmsCode = "".obs;
  RxBool isLoading = false.obs;
  RxInt? resentTokenID;
  RxBool loginOtpFlag = false.obs;
  RxBool firstTimeLogin = false.obs;

  RxString controllerPin = ''.obs;

  RxString responseOtp = "".obs;
  RxString mobOtpGenerated = "".obs;

  @override
  void onInit() {
    super.onInit();
    // print(endTime);
    // countDownController = CountdownTimerController(endTime: endTime);
    pinController.addListener(() {
      controllerPin.value = pinController.text;
    });
  }

  Future<bool> sendOtp() async {
    responseOtp.value = (await apiService.validateUserMail())!;
    if (responseOtp.value == "" || responseOtp.value == null) {
      Get.snackbar("Server side error", "Can't able to send OTP.");
      print("send otp func: ${responseOtp.value}");
      isLoading.value = false;
      return false;
    } else {
      Get.snackbar("OTP sent", "OTP has been sent successfully.");
      isLoading.value = false;
      return true;
    }
  }

  bool verifyOtp() {
    if (responseOtp.value == controllerPin.value) {
      print(responseOtp.value);
      print(controllerPin.value);
      isLoading.value = false;
      return true;
    } else {
      isLoading.value = false;
      return false;
    }
  }

  Future<void> sendOtpPhoneNumber(String regOrForgot) async {
    mobOtpGenerated.value = (await apiService.mobileOtpGenerator())!;

    /// for release and apk launch purpose
    responseOtp.value = (await apiService.validateUserPhoneNumber(
        regOrForgot, mobOtpGenerated.value))!;

    /// for development and testing purpose
    // responseOtp.value = "testing";

    if (responseOtp.value.isNotEmpty) {
      Get.snackbar("OTP sent", "OTP has been sent successfully.");

      /// Starting the otp timer
      // countDownController.start();
      if (otpTimeCompleted.value == false) {
        otpTimeController.restart();
        otpTimeCompleted.value = true;
      }

      print("send otp func: ${responseOtp.value}");
      isLoading.value = false;
      otpSendFlag.value = true;
    } else {
      Get.snackbar("OTP sent error", "Some error occurred.");
      isLoading.value = false;
    }
  }

  bool verifyPhoneOtpCheck() {
    if (otpTimeCompleted.value) {
      if (mobOtpGenerated.value == controllerPin.value) {
        print(responseOtp.value);
        print(controllerPin.value);
        isLoading.value = false;
        otpTimeCompleted.value = true;
        return true;
      } else {
        isLoading.value = false;
        Get.snackbar("Wrong OTP", "Please enter the correct OTP which is send in +91 ${mailPhoneController.controllerPhone.value}");
        return false;
      }
    } else {
      isLoading.value = false;
      Get.snackbar("Time is exceeded", "Please try to enter the correct OTP on time!");
      return false;
    }
  }

  void change() => loginOtpFlag.value = true;
}
