import 'dart:convert';

import 'package:afar_cabs_user/api_constants/api_services.dart';
import 'package:afar_cabs_user/sign_in_up_page/view/sign_in_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../sign_in_up_page/controller/sign_up_email_phone_controller.dart';
import '../model/forgot_pass.dart';

class ForgotPasswordController extends GetxController {
  final forPassController = TextEditingController();
  final forConPassController = TextEditingController();
  final mailPhoneController = Get.put(MailPhoneController());
  ApiService apiService = ApiService();

  RxString controllerForPass = ''.obs;
  RxString controllerForConPass = ''.obs;

  RxString verifyMailOrPhone = "".obs;
  RxBool forgotPass = false.obs;

  RxBool isHiddenPass = true.obs;
  RxBool isHiddenConPass = true.obs;

  RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    forPassController.addListener(() {
      controllerForPass.value = forPassController.text;
    });
    forConPassController.addListener(() {
      controllerForConPass.value = forConPassController.text;
    });
  }

  void togglePasswordView() {
    isHiddenPass.value = !isHiddenPass.value;
    update();
  }

  void toggleConPasswordView() {
    isHiddenConPass.value = !isHiddenConPass.value;
    update();
  }

  Future<void> changePassword() async {
    print(controllerForPass.value);
    print(controllerForConPass.value);

    PostUserPwdUpdate body = PostUserPwdUpdate(
      userPassword: controllerForPass.value,
      phoneNum: mailPhoneController.controllerPhone.value.isNotEmpty
          ? mailPhoneController.controllerPhone.value
          : mailPhoneController.controllerMail.value,
    );

    isLoading.value = true;
    http.Response response = (await apiService.postUserPwdUpdate(body))!;
    if (response.statusCode == 200) {
      Get.snackbar("New Password has been set",
          "New password has been set successfully. Don't forgot this!");

      Get.off(() => SignInPage());
      mailPhoneController.clearAllInputs();
      clearAllPassInputs();
    } else {
      Get.snackbar("Server side error",
          "Sorry for the inconvenience. Some server side error occurred.");

      isLoading.value = false;
    }
    print(response.body);
    isLoading.value = false;

    update();
  }

  clearAllPassInputs() {
    forPassController.clear();
    forConPassController.clear();
  }
}
