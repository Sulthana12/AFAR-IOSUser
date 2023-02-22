import 'package:afar_cabs_user/components/background.dart';
import 'package:afar_cabs_user/components/custom_rounded_button.dart';
import 'package:afar_cabs_user/enable_location/view/enable_location_page.dart';
import 'package:afar_cabs_user/forgot_password_page/view/change_password_page.dart';
import 'package:afar_cabs_user/home_page/view/home_page_view.dart';
import 'package:afar_cabs_user/sign_in_up_page/controller/personal_details_controller.dart';
import 'package:afar_cabs_user/sign_in_up_page/controller/sign_up_email_phone_controller.dart';
import 'package:afar_cabs_user/sign_in_up_page/view/personal_details_page.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_countdown_timer/current_remaining_time.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:neon_circular_timer/neon_circular_timer.dart';
import 'package:pinput/pinput.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../components/otp_form.dart';
import '../../forgot_password_page/controller/forgot_password_controller.dart';
import '../controller/otp_page_controller.dart';

class VerifyOtpPage extends StatefulWidget {
  final String title, message, imagePath;

  VerifyOtpPage({
    Key? key,
    required this.title,
    required this.message,
    required this.imagePath,
  }) : super(key: key);

  @override
  State<VerifyOtpPage> createState() => _VerifyOtpPageState();
}

class _VerifyOtpPageState extends State<VerifyOtpPage> {
  final otpController = Get.put(OtpPageController());
  final personalController = Get.put(PersonalDetailsController());
  final mailPhoneController = Get.put(MailPhoneController());
  final forgotPassController = Get.put(ForgotPasswordController());

  final focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    const focusedBorderColor = Color.fromRGBO(23, 171, 144, 1);
    const fillColor = Color.fromRGBO(243, 246, 249, 0);
    const borderColor = Color.fromRGBO(23, 171, 144, 0.4);

    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: const TextStyle(
        fontSize: 22,
        color: Color.fromRGBO(30, 60, 87, 1),
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(19),
        border: Border.all(color: borderColor),
      ),
    );

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          reverse: true,
          child: Background(
            child: Obx(
              ()=> Column(
                mainAxisAlignment: MainAxisAlignment.center,
                // crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset(
                    widget.imagePath,
                    height: size.height * 0.3,
                    width: size.width * 1.0,
                  ),
                  Text(
                    widget.title,
                    style: const TextStyle(
                      fontSize: 30.0,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 0.4,
                    ),
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  Text(
                    widget.message,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 15.0,
                      color: Colors.grey,
                      letterSpacing: 0.4,
                    ),
                  ),
                  const SizedBox(
                    height: 30.0,
                  ),
                  Pinput(
                    controller: otpController.pinController,
                    focusNode: focusNode,
                    length: 6,
                    androidSmsAutofillMethod:
                        AndroidSmsAutofillMethod.smsUserConsentApi,
                    listenForMultipleSmsOnAndroid: true,
                    defaultPinTheme: defaultPinTheme,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Enter received OTP to proceed";
                      } else {
                        return null;
                      }
                    },
                    hapticFeedbackType: HapticFeedbackType.lightImpact,
                    onCompleted: (pin) {
                      debugPrint('onCompleted: $pin');
                    },
                    onChanged: (value) {
                      debugPrint('onChanged: $value');
                      otpController.otpSmsCode.value = value;
                    },
                    cursor: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(bottom: 9),
                          width: 22,
                          height: 1,
                          color: focusedBorderColor,
                        ),
                      ],
                    ),
                    focusedPinTheme: defaultPinTheme.copyWith(
                      decoration: defaultPinTheme.decoration!.copyWith(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: focusedBorderColor),
                      ),
                    ),
                    submittedPinTheme: defaultPinTheme.copyWith(
                      decoration: defaultPinTheme.decoration!.copyWith(
                        color: fillColor,
                        borderRadius: BorderRadius.circular(19),
                        border: Border.all(color: focusedBorderColor),
                      ),
                    ),
                    errorPinTheme: defaultPinTheme.copyBorderWith(
                      border: Border.all(color: Colors.redAccent),
                    ),
                  ),
                  // const SizedBox(
                  //   height: 10.0,
                  // ),
                  GetBuilder<OtpPageController>(
                    builder: (controller) => SizedBox(
                      height: size.height * 0.18,
                      width: size.width * 0.18,
                      child: NeonCircularTimer(
                          onComplete: () {
                            print("completed");
                            controller.otpTimeCompleted.value = false;
                            // controller.otpTimeController.restart();
                            controller.otpTimeController.pause();
                          },
                          width: 100,
                          textStyle: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                          isReverse: true,
                          controller: controller.otpTimeController,
                          duration: 2 * 60,
                          strokeWidth: 3,
                          isTimerTextShown: true,
                          neumorphicEffect: true,
                          outerStrokeColor: Colors.grey.shade100,
                          innerFillGradient: LinearGradient(colors: [
                            Colors.greenAccent.shade200,
                            Colors.blueAccent.shade400
                          ]),
                          neonGradient: LinearGradient(colors: [
                            Colors.greenAccent.shade200,
                            Colors.blueAccent.shade400
                          ]),
                          strokeCap: StrokeCap.round,
                          innerFillColor: Colors.black12,
                          backgroudColor: Colors.grey.shade100,
                          neonColor: Colors.blue.shade900),
                    ),
                  ),
                  GetBuilder<OtpPageController>(builder: (controller) {
                    return RoundedButtonCustom(
                      pressed: () async {
                        controller.isLoading.value = true;
                        if (mailPhoneController.selected == "email") {
                          /// This will redirect user for registration (SIGN UP)
                          /// when EMAIL is given as OTP check
                          // print("Send OTP: ${otpController.sendOtp()}");
                          if (controller.verifyOtp()) {
                            Get.offAll(() => PersonalDetails());
                          } else {
                            Get.snackbar("Enter received OTP",
                                "Please enter the OTP received in ${mailPhoneController.controllerMail.value} to proceed.");
                            controller.isLoading.value = false;
                          }
                        } else {
                          if (controller.verifyPhoneOtpCheck()) {
                            if (controller.loginOtpFlag.value) {
                              /// This will redirect user for Home Page(LOGIN USING OTP)
                              /// when PHONE NUMBER is given as OTP check
                              print("Before : ${controller.loginOtpFlag.value}");

                              /// used to login and register accordingly(login using otp)
                              controller.firstTimeLogin.value = true;
                              await personalController.postData("loginusotp");

                              // Get.offAll(() => EnableLocation());
                              print("After : ${controller.loginOtpFlag.value}");
                              controller.loginOtpFlag.value = false;

                              SharedPreferences prefs =
                                  await SharedPreferences.getInstance();
                              await prefs.setBool('isLoggedIn', true);
                            } else {
                              /// This will redirect user for registration (SIGN UP)
                              /// when PHONE NUMBER is given as OTP check
                              Get.offAll(() => PersonalDetails());
                            }
                          } else {
                            Get.snackbar("Enter received OTP",
                                "Please enter the OTP received in +91 ${mailPhoneController.controllerPhone.value} to proceed.");
                            controller.isLoading.value = false;
                          }
                        }

                        /// Below code will handle all the FORGOT PASSWORD OTP stuffs
                        if (forgotPassController.forgotPass.value) {
                          if (forgotPassController.verifyMailOrPhone.value == "email") {
                            /// This will redirect user for change password (CHANGE PASSWORD)
                            /// when EMAIL is given as OTP check
                            // print("Send OTP: ${otpController.sendOtp()}");
                            if (controller.verifyOtp()) {
                              Get.offAll(() => ChangePasswordPage());
                            } else {
                              Get.snackbar("Enter received OTP",
                                  "Please enter the OTP received in ${mailPhoneController.controllerMail.value} to proceed.");
                              controller.isLoading.value = false;
                            }
                          } else {
                            /// This will redirect user for change password (CHANGE PASSWORD)
                            /// when PHONE NUMBER is given as OTP check
                            if (controller.verifyPhoneOtpCheck()) {
                              Get.offAll(() => ChangePasswordPage());
                            } else {
                              Get.snackbar("Enter received OTP",
                                  "Please enter the OTP received in +91 ${mailPhoneController.controllerPhone.value} to proceed.");
                              controller.isLoading.value = false;
                            }
                          }

                          // mailPhoneController.clearAllInputs();
                        }
                        controller.isLoading.value = false;
                      },
                      child: const Text("Verify"),
                    );
                  }),
                  otpController.otpTimeCompleted.value
                  ? Container() :
                  TextButton(
                    onPressed: () async {
                      if (mailPhoneController.selected == "email") {
                        await otpController.sendOtp();
                      } else {
                        await otpController.sendOtpPhoneNumber("login");
                      }
                    },
                    child: const Text(
                      "Resend",
                      style: TextStyle(
                        color: Colors.black,
                      ),
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
