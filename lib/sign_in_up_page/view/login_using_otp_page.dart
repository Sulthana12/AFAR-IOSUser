import 'package:afar_cabs_user/sign_in_up_page/view/verify_otp_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../components/custom_rounded_button.dart';
import '../../components/rounded_form_field.dart';
import '../controller/otp_page_controller.dart';
import '../controller/sign_up_email_phone_controller.dart';

class LoginUsingOtp extends StatelessWidget {
  LoginUsingOtp({Key? key}) : super(key: key);

  final controller = Get.put(MailPhoneController());
  final otpController = Get.put(OtpPageController());
  final formKey = GlobalKey<FormState>();

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
          reverse: true,
          child: Form(
            key: formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: SizedBox(
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 30.0,
                    ),
                    Image.asset(
                      "assets/sign_in_up/phone_verify.png",
                      height: size.height * 0.3,
                      width: size.width * 0.7,
                    ),
                    const SizedBox(
                      height: 30.0,
                    ),
                    const Text(
                      "Login using OTP",
                      style: TextStyle(
                        fontSize: 25.0,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 0.8,
                      ),
                    ),
                    Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: size.height * 0.03,
                          vertical: size.width * 0.02,
                        ),
                        child: const Text(
                          "Enter your phone number to receive the OTP",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 20.0,
                            letterSpacing: 0.8,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    TextFormField(
                      controller: controller.phoneController,
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                      cursorColor: Colors.black,
                      onChanged: (phone) {},
                      validator: (phone) {
                        if (phone == null || phone.isEmpty) {
                          return "Enter valid phone number";
                        } else if (phone.length != 10) {
                          return "Phone number must be 10 digits";
                        } else {
                          return null;
                        }
                      },
                      decoration: const InputDecoration(
                        hintText: "Phone number",
                        hintStyle: TextStyle(color: Colors.grey),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(30.0)),
                        ),
                        prefixIcon: Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Icon(Icons.phone_android_outlined),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 30.0,
                    ),
                    Obx(
                      () => RoundedButtonCustom(
                        pressed: () async {
                          final isValidForm = formKey.currentState!.validate();

                          if (isValidForm) {
                            otpController.isLoading.value = true;

                            await otpController.sendOtpPhoneNumber("login");
                            if (otpController.otpSendFlag.value) {
                              otpController.isLoading.value = false;
                              otpController.loginOtpFlag.value = true;

                              Get.to(
                                    () => VerifyOtpPage(
                                  title: "Verification Code",
                                  message: "OTP received in the given phone number",
                                  imagePath: "assets/images/mob-otp-ver.png",
                                ),
                              );
                            }
                          }
                        },
                        child: otpController.isLoading.value
                            ? const Center(
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                ),
                              )
                            : const Text("Send OTP"),
                      ),
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
