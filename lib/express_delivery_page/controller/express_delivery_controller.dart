import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class ExpressDeliveryController extends GetxController {
  final receiverNameController = TextEditingController();
  final receiverPhoneController = TextEditingController();
  final noteController = TextEditingController();

  RxString controllerReceiverName = ''.obs;
  RxString controllerReceiverPhone = ''.obs;
  RxString controllerNote = ''.obs;

  RxString itemSelected = 'food'.obs;

  @override
  void onInit() {
    super.onInit();
    receiverNameController.addListener(() {
      controllerReceiverName.value = receiverNameController.text;
    });
    receiverPhoneController.addListener(() {
      controllerReceiverPhone.value = receiverPhoneController.text;
    });
    noteController.addListener(() {
      controllerNote.value = noteController.text;
    });
  }
}