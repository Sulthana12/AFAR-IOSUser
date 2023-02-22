import 'package:afar_cabs_user/constants/colors/colors.dart';
import 'package:afar_cabs_user/forgot_password_page/controller/forgot_password_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';

import '../../components/custom_rounded_button.dart';

class ChangePasswordPage extends StatelessWidget {
  ChangePasswordPage({Key? key}) : super(key: key);
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
                padding: const EdgeInsets.all(20.0),
                child: GetBuilder<ForgotPasswordController>(
                  builder: (controller) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 20.0,
                        ),
                        const Center(
                          child: Text(
                            "New Password",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 25.0,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 0.4,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: size.height * 0.1,
                        ),
                        const Text(
                          "Enter New Password",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20.0,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.4,
                          ),
                        ),
                        const SizedBox(
                          height: 20.0,
                        ),
                        TextFormField(
                          controller: controller.forPassController,
                          keyboardType: TextInputType.text,
                          obscureText: controller.isHiddenPass.value,
                          textInputAction: TextInputAction.next,
                          cursorColor: Colors.black,
                          onChanged: (password) {},
                          validator: (password) {
                            RegExp regex = RegExp(
                                r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$%^&*~(){}`<>,./]).{8,}$');
                            if (password == null || password.isEmpty) {
                              return 'Please enter password';
                            } else {
                              if (!regex.hasMatch(password)) {
                                return 'Must contain 1 uppercase, lowercase, special character and minimum length of 8 characters';
                              } else {
                                return null;
                              }
                            }
                          },
                          decoration: InputDecoration(
                            hintText: "Password",
                            errorMaxLines: 3,
                            hintStyle: const TextStyle(color: Colors.grey),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(30.0)),
                            ),
                            prefixIcon: const Padding(
                              padding: EdgeInsets.all(16.0),
                              child: Icon(Icons.key),
                            ),
                            suffixIcon: GestureDetector(
                              onTap: controller.togglePasswordView,
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
                        const Text(
                          "Confirm Password",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20.0,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.4,
                          ),
                        ),
                        const SizedBox(
                          height: 20.0,
                        ),
                        TextFormField(
                          controller: controller.forConPassController,
                          keyboardType: TextInputType.text,
                          obscureText: controller.isHiddenConPass.value,
                          textInputAction: TextInputAction.next,
                          cursorColor: Colors.black,
                          onChanged: (conpass) {},
                          validator: (conpass) {
                            RegExp regex = RegExp(
                                r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$%^&*~(){}`<>,./]).{8,}$');
                            if (conpass == null || conpass.isEmpty) {
                              return 'Please enter password';
                            } else {
                              if (!regex.hasMatch(conpass)) {
                                return 'Must contain 1 uppercase, lowercase, special character and minimum length of 8 characters';
                              } else {
                                return null;
                              }
                            }
                          },
                          decoration: InputDecoration(
                            hintText: "Re-enter Password",
                            errorMaxLines: 3,
                            hintStyle: TextStyle(color: Colors.grey),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(30.0)),
                            ),
                            prefixIcon: Padding(
                              padding: EdgeInsets.all(16.0),
                              child: Icon(Icons.key),
                            ),
                            suffixIcon: GestureDetector(
                              onTap: controller.toggleConPasswordView,
                              child: Icon(
                                controller.isHiddenConPass.value
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: size.height * 0.27,
                        ),
                        Center(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: primaryColor,
                              minimumSize: const Size.fromHeight(50),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            onPressed: () async {
                              final isValidForm = formKey.currentState!.validate();
                              controller.isLoading.value = true;

                              if (isValidForm &&
                                  (controller.controllerForPass.value ==
                                      controller
                                          .controllerForConPass.value)) {
                                await controller.changePassword();
                              } else {
                                Get.snackbar(
                                    "Check password and confirm password",
                                    "Password and confirm password must be same.");
                                controller.isLoading.value = false;
                              }

                              controller.isLoading.value = false;
                            },
                            child: const Text(
                              'Submit',
                              style: TextStyle(fontSize: 24),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20.0,
                        ),
                      ],
                    );
                  }
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
