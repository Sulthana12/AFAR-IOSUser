import 'package:afar_cabs_user/api_constants/api_services.dart';
import 'package:afar_cabs_user/components/custom_rounded_button.dart';
import 'package:afar_cabs_user/components/or_divider.dart';
import 'package:afar_cabs_user/components/rounded_form_field.dart';
import 'package:afar_cabs_user/sign_in_up_page/controller/sign_up_email_phone_controller.dart';
import 'package:afar_cabs_user/sign_in_up_page/view/email_or_phone_veri_page.dart';
import 'package:afar_cabs_user/sign_in_up_page/view/sign_in_page.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../components/already_have_account.dart';
import '../../components/custom_referral_container.dart';
import '../controller/google_signin_controller.dart';

class SignUpPage extends StatelessWidget {
  SignUpPage({Key? key}) : super(key: key);

  final controller = Get.put(MailPhoneController());
  final LoginController googleController = Get.put(LoginController());
  ApiService apiService = ApiService();
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
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
                    const SizedBox(
                      height: 30.0,
                    ),
                    Text(
                      "letStart".tr,
                      style: TextStyle(
                        fontSize: 25.0,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 0.4,
                      ),
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    Text(
                      "createAcc".tr,
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
                      controller: controller.mailController,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      cursorColor: Colors.black,
                      // textAlign: TextAlign.center,
                      onChanged: (email) {},
                      validator: MultiValidator([
                        EmailValidator(errorText: "emailErr".tr),
                      ]),
                      decoration: InputDecoration(
                        hintText: "email".tr,
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
                      controller: controller.phoneController,
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                      cursorColor: Colors.black,
                      onChanged: (phone) {},
                      validator: (phone) {
                        if (phone == null || phone.isEmpty) {
                          return null;
                        } else if (phone.length != 10) {
                          return "phoneErr".tr;
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        hintText: "phone".tr,
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
                    // ReferralContainer(size: size),
                    RichText(
                      maxLines: 2,
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: "referCode".tr,
                            style: TextStyle(
                                fontSize: 15.0,
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                          TextSpan(
                            text: "clickHere".tr,
                            style: TextStyle(
                              fontSize: 15.0,
                              color: Colors.blue,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      AlertDialog(
                                        actionsAlignment: MainAxisAlignment.center,
                                        title: Text('referCodeText'.tr, textAlign: TextAlign.center,),
                                        content: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: <Widget>[
                                            ReferralContainer(size: size),
                                          ],
                                        ),
                                        actions: <Widget>[
                                          ElevatedButton(
                                            onPressed: () async {
                                              if (controller.controllerReferral.value.isNotEmpty) {
                                                if (await apiService.getChkReferralCode()) {
                                                  controller.isReferralCorrect.value = true;
                                                }
                                              } else {
                                                Get.snackbar("enterRefCode".tr, "referCodeErr".tr);
                                              }

                                              Navigator.pop(context);
                                            },
                                            child: Text('apply'.tr,),
                                          ),
                                        ],
                                      ),
                                );
                              },
                          ),
                          TextSpan(
                            text: "toEnterRef".tr,
                            style: TextStyle(
                              fontSize: 15.0,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(
                      height: 30.0,
                    ),
                    RoundedButtonCustom(
                      pressed: () async {
                        final isValidForm = formKey.currentState!.validate();

                        if (isValidForm &&
                            (controller.controllerPhone.value.isNotEmpty ||
                                controller.controllerMail.value.isNotEmpty)) {
                          /// To check whether the user already exist or not.
                          await apiService.getUserByPhoneOrEmail();
                        } else {
                          Get.snackbar("signUpFormErr".tr,
                              "signUpFormErrDesc".tr);
                        }
                      },
                      child: Text("signUp".tr),
                    ),
                    const OrDivider(),
                    googleController.isLoading.value
                        ? const Center(
                            child: CircularProgressIndicator(
                              color: Colors.blue,
                            ),
                          )
                        : TextButton(
                            onPressed: () => googleController.loginWithGoogle(),
                            child: Image.asset(
                              "assets/images/google-logo.png",
                              height: 50.0,
                              width: 100.0,
                            ),
                          ),
                    const SizedBox(
                      height: 7.0,
                    ),
                    AlreadyHaveAnAccountCheck(
                      press: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SignInPage(),
                          ),
                        );
                      },
                      login: false,
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
