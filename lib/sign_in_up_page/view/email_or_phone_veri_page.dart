import 'package:afar_cabs_user/api_constants/api_services.dart';
import 'package:afar_cabs_user/components/custom_rounded_button.dart';
import 'package:afar_cabs_user/sign_in_up_page/controller/otp_page_controller.dart';
import 'package:afar_cabs_user/sign_in_up_page/controller/sign_up_email_phone_controller.dart';
import 'package:afar_cabs_user/sign_in_up_page/view/verify_otp_page.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

class MailOrPhoneVerify extends StatelessWidget {
  MailOrPhoneVerify({Key? key}) : super(key: key);

  final mailPhoneController = Get.put(MailPhoneController());
  final otpController = Get.put(OtpPageController());
  final ApiService apiService = ApiService();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          reverse: false,
          child: SizedBox(
            // width: double.infinity,
            child: Padding(
              padding: EdgeInsets.only(
                left: size.width * 0.1,
                right: size.width * 0.08,
                top: size.width * 0.04,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 10.0,
                  ),
                  Text(
                    "letsVerify".tr,
                    style: TextStyle(
                      fontSize: 30.0,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 0.4,
                    ),
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  Text(
                    "emailOrMobileVeri".tr,
                    style: TextStyle(
                      fontSize: 15.0,
                      color: Colors.grey,
                      letterSpacing: 0.4,
                    ),
                  ),
                  const SizedBox(
                    height: 30.0,
                  ),
                  GetBuilder<MailPhoneController>(
                    builder: (controller) => controller.controllerMail.value ==
                            ""
                        ? Container()
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: AutoSizeText(
                                  controller.controllerMail.value,
                                  maxLines: 1,
                                  style: TextStyle(
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Radio(
                                value: controller.verifyType[0],
                                groupValue: controller.selected,
                                activeColor: Colors.blue,
                                onChanged: (value) {
                                  controller.setVerifyType(value.toString());
                                  print(value); //selected value
                                },
                              ),
                            ],
                          ),
                  ),
                  const SizedBox(
                    height: 30.0,
                  ),
                  GetBuilder<MailPhoneController>(
                    builder: (controller) => controller.controllerPhone.value ==
                            ""
                        ? Container()
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: AutoSizeText(
                                  "+91 ${controller.controllerPhone.value}",
                                  maxLines: 1,
                                  style: const TextStyle(
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Radio(
                                value: controller.verifyType[1],
                                groupValue: controller.selected,
                                activeColor: Colors.blue,
                                onChanged: (value) {
                                  controller.setVerifyType(value.toString());
                                  print(value); //selected value
                                },
                              ),
                            ],
                          ),
                  ),
                  const SizedBox(
                    height: 30.0,
                  ),
                  Center(
                    child: Obx(
                      () => RoundedButtonCustom(
                        pressed: () async {
                          otpController.isLoading.value = true;
                          if (mailPhoneController.selected == "email") {
                            // print("Send OTP: ${otpController.sendOtp()}");
                            if (await otpController.sendOtp()) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => VerifyOtpPage(
                                    title: "verifyEmail".tr,
                                    message:
                                    "verifyEmailDesc".tr,
                                    imagePath: "assets/sign_in_up/mail_verify.png",
                                  ),
                                ),
                              );
                            }
                          } else {
                            await otpController.sendOtpPhoneNumber("signup");

                            if (otpController.otpSendFlag.value) {
                              otpController.isLoading.value = false;
                              Get.to(
                                () => VerifyOtpPage(
                                  title: "verifyPhone".tr,
                                  message:
                                      "verifyPhoneDesc".tr,
                                  imagePath: "assets/images/mob-otp-ver.png",
                                ),
                              );
                            } else {
                              print("Got some error");
                            }
                          }
                        },
                        child: otpController.isLoading.value
                            ? const Center(
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                ),
                              )
                            : Text("continue".tr),
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
