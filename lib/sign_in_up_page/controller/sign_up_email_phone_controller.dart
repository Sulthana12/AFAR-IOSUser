import 'package:get/get.dart';
import 'package:flutter/material.dart';

class MailPhoneController extends GetxController {
  final mailController = TextEditingController();
  final phoneController = TextEditingController();
  final referralController = TextEditingController();

  String? selected;
  List<String> verifyType = ["email", "phone"];

  RxString controllerMail = ''.obs;
  RxString controllerPhone = ''.obs;
  RxString controllerReferral = ''.obs;
  RxString controllerVerify = ''.obs;

  RxBool isReferralCorrect = false.obs;

  @override
  void onInit() {
    super.onInit();
    mailController.addListener(() {
      controllerMail.value = mailController.text;

      controllerMail.value.isNotEmpty && controllerPhone.value.isNotEmpty
          ? setVerifyType(verifyType[0])
          : controllerMail.value.isEmpty
              ? setVerifyType(verifyType[1])
              : setVerifyType(verifyType[0]);
    });
    phoneController.addListener(() {
      controllerPhone.value = phoneController.text;

      controllerMail.value.isNotEmpty && controllerPhone.value.isNotEmpty
          ? setVerifyType(verifyType[0])
          : controllerPhone.value.isEmpty
              ? setVerifyType(verifyType[0])
              : setVerifyType(verifyType[1]);
    });

    referralController.addListener(() {
      controllerReferral.value = referralController.text;
    });
  }

  void setVerifyType(String type) {
    selected = type;
    print("Selected $selected");
    update();
  }

  clearAllInputs() {
    mailController.clear();
    phoneController.clear();
    referralController.clear();
  }

  clearReferral() {
    referralController.clear();
  }
}
