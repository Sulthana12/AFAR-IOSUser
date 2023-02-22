import 'package:afar_cabs_user/api_constants/api_services.dart';
import 'package:afar_cabs_user/constants/colors/colors.dart';
import 'package:afar_cabs_user/sign_in_up_page/view/sign_in_page.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../components/already_have_account.dart';
import '../../components/custom_rounded_button.dart';
import '../../components/or_divider.dart';
import '../../sign_in_up_page/controller/otp_page_controller.dart';
import '../../sign_in_up_page/controller/sign_up_email_phone_controller.dart';
import '../../sign_in_up_page/view/sign_up_page.dart';
import '../../sign_in_up_page/view/verify_otp_page.dart';
import '../controller/forgot_password_controller.dart';

class ForgotPasswordPage extends StatelessWidget {
  ForgotPasswordPage({Key? key}) : super(key: key);
  final formKey = GlobalKey<FormState>();
  final mailPhoneController = Get.put(MailPhoneController());
  final otpController = Get.put(OtpPageController());
  final forgotPassController = Get.put(ForgotPasswordController());
  ApiService apiService = ApiService();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
        title: Text(
          "Forgot Password",
          style: TextStyle(
            fontSize: 25.0,
            fontWeight: FontWeight.w900,
            color: primaryColor,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          reverse: true,
          child: Form(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            key: formKey,
            child: SizedBox(
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  // crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      "assets/sign_in_up/forgot_pass_edited.png",
                      height: size.height * 0.35,
                      width: size.width * 0.6,
                    ),
                    const Text(
                      "Enter either email address or phone number",
                      style: TextStyle(
                        fontSize: 15.0,
                        color: Colors.grey,
                        letterSpacing: 0.4,
                      ),
                    ),
                    const SizedBox(
                      height: 30.0,
                    ),
                    TextFormField(
                      controller: mailPhoneController.mailController,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      cursorColor: Colors.black,
                      // textAlign: TextAlign.center,
                      onChanged: (email) {},
                      validator: MultiValidator([
                        EmailValidator(errorText: "Enter a valid email"),
                      ]),
                      decoration: const InputDecoration(
                        hintText: "Email Address",
                        // contentPadding:
                        //     EdgeInsets.fromLTRB(20.0, 17.5, 20.0, 10.0),
                        hintStyle: TextStyle(color: Colors.grey),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(30.0)),
                        ),
                        prefixIcon: Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Icon(Icons.email_outlined),
                        ),
                      ),
                    ),
                    const OrDivider(),
                    TextFormField(
                      controller: mailPhoneController.phoneController,
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                      cursorColor: Colors.black,
                      onChanged: (phone) {},
                      validator: (phone) {
                        if (phone == null || phone.isEmpty) {
                          return null;
                        } else if (phone.length != 10) {
                          return "Phone number must be 10 digits";
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        hintText: "Phone",
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
                      height: 20.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "Back to ",
                          style: const TextStyle(color: Colors.black),
                        ),
                        GestureDetector(
                          onTap: () => Get.to(() => SignInPage()),
                          child: Text(
                            "Sign in",
                            style: const TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 30.0,
                    ),
                    Obx(
                      () => RoundedButtonCustom(
                        pressed: () async {
                          bool validate;
                          final isValidForm = formKey.currentState!.validate();
                          forgotPassController.forgotPass.value = true;
                          validate  = await apiService.getUserByPhoneOrEmailForgot();

                          if (isValidForm && validate) {
                            if (mailPhoneController
                                .controllerMail.value.isNotEmpty) {
                              forgotPassController.verifyMailOrPhone.value =
                                  "email";

                              /// Sending OTP to the given mail
                              if (await otpController.sendOtp()) {
                                Get.to(
                                      () => VerifyOtpPage(
                                    title: "Verify your Email",
                                    message:
                                    "   Please check your email account and enter the OTP received",
                                    imagePath:
                                    "assets/sign_in_up/mail_verify.png",
                                  ),
                                );
                              }
                            } else if (mailPhoneController
                                .controllerPhone.value.isNotEmpty) {
                              forgotPassController.verifyMailOrPhone.value =
                                  "phone";

                              /// Sending OTP to the given phone number
                              await otpController.sendOtpPhoneNumber("forgot");

                              if (otpController.otpSendFlag.value) {
                                otpController.isLoading.value = false;
                                Get.to(
                                  () => VerifyOtpPage(
                                    title: "Verification",
                                    message:
                                        "OTP received in the given phone number",
                                    imagePath: "assets/images/mob-otp-ver.png",
                                  ),
                                );
                              } else {
                                print("Got some error");
                              }
                            } else {
                              Get.snackbar("Must give anyone correctly",
                                  "You must give either email or phone number.");
                            }
                          }
                        },
                        child: otpController.isLoading.value
                            ? const Center(
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                ),
                              )
                            : const Text("Send"),
                      ),
                    ),
                    const SizedBox(
                      height: 30.0,
                    ),
                    AlreadyHaveAnAccountCheck(
                      press: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SignUpPage(),
                          ),
                        );
                      },
                      login: true,
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
