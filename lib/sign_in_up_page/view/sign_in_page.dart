import 'package:afar_cabs_user/api_constants/api_services.dart';
import 'package:afar_cabs_user/sign_in_up_page/controller/sign_in_controller.dart';
import 'package:afar_cabs_user/sign_in_up_page/view/login_using_otp_page.dart';
import 'package:afar_cabs_user/sign_in_up_page/view/sign_up_page.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../components/already_have_account.dart';
import '../../components/custom_rounded_button.dart';
import '../../components/or_divider.dart';
import '../../components/rounded_form_field.dart';
import '../../forgot_password_page/view/forgot_password_view.dart';
import '../controller/google_signin_controller.dart';
import 'email_or_phone_veri_page.dart';

class SignInPage extends StatelessWidget {
  SignInPage({Key? key}) : super(key: key);

  final controller = Get.put(LoginMailPhoneController());
  final LoginController googleController = Get.put(LoginController());
  final formKey = GlobalKey<FormState>();

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
                padding: const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 20.0),
                child: GetBuilder<LoginMailPhoneController>(
                  builder: (controller) => Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    // crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(
                        height: 30.0,
                      ),
                      Image.asset(
                        "assets/sign_in_up/login_img.png",
                        height: size.height * 0.35,
                        width: size.width * 0.6,
                      ),
                      const SizedBox(
                        height: 10.0,
                      ),
                      const Text(
                        "Welcome Back!",
                        style: TextStyle(
                          fontSize: 25.0,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 0.8,
                        ),
                      ),
                      const Text(
                        "Login to your existing account",
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 20.0,
                          letterSpacing: 0.8,
                        ),
                      ),
                      const SizedBox(
                        height: 20.0,
                      ),
                      TextFormField(
                        controller: controller.loginMailController,
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        cursorColor: Colors.black,
                        onChanged: (email) {},
                        validator: MultiValidator([
                          RequiredValidator(
                              errorText: "Must enter an email address/phone number"),
                          // EmailValidator(errorText: "Enter a valid email"),
                        ]),
                        decoration: const InputDecoration(
                          hintText: "Email Address or Phone number",
                          hintStyle: TextStyle(color: Colors.grey),
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(30.0)),
                          ),
                          prefixIcon: Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Icon(Icons.email_outlined),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20.0,
                      ),
                      TextFormField(
                        controller: controller.loginPassController,
                        textInputAction: TextInputAction.next,
                        obscureText: controller.isHidden.value,
                        cursorColor: Colors.black,
                        onChanged: (password) {},
                        validator: MultiValidator([
                          RequiredValidator(
                              errorText: "Must enter correct password"),
                        ]),
                        decoration: InputDecoration(
                          hintText: "Password",
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
                            onTap: controller.togglePasswordView,
                            child: Icon(
                              controller.isHidden.value
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
                        padding: const EdgeInsets.only(right: 32.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            GestureDetector(
                              onTap: () => Get.to(() => ForgotPasswordPage()),
                              child: const Text(
                                "Forgot password?",
                                style: TextStyle(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 10.0,
                      ),
                      Obx(
                        () => RoundedButtonCustom(
                          pressed: () async {
                            final isValidForm =
                                formKey.currentState!.validate();

                            if (isValidForm) {
                              await controller.logInUser();
                              controller.clearInputText();
                            }
                          },
                          child: controller.isLoading.value
                              ? const Center(
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                  ),
                                )
                              : const Text("Sign In"),
                        ),
                      ),
                      const OrDivider(),
                      TextButton(
                        onPressed: () => Get.to(() => LoginUsingOtp()),
                        child: const Text(
                          "Login using OTP",
                          style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                            fontSize: 20.0,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 13.0,
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
      ),
    );
  }
}
