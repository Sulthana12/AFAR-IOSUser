import 'package:afar_cabs_user/add_favourites_page/controller/save_location_controller.dart';
import 'package:afar_cabs_user/api_constants/api_services.dart';
import 'package:afar_cabs_user/enable_location/view/enable_location_page.dart';
import 'package:afar_cabs_user/home_page/controller/location_history_controller.dart';
import 'package:afar_cabs_user/home_page/controller/user_controller.dart';
import 'package:afar_cabs_user/home_page/view/home_page_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../components/auth_methods.dart';

class LoginMailPhoneController extends GetxController {
  final userProfileController = Get.put(UserProfileController());
  final locationHistoryController = Get.put(LocationHistoryController());

  final loginMailController = TextEditingController();
  final loginPassController = TextEditingController();

  RxString controllerLoginMail = ''.obs;
  RxString controllerLoginPass = ''.obs;
  RxBool isLoading = false.obs;
  RxBool isHidden = true.obs;

  @override
  void onInit() {
    super.onInit();
    loginMailController.addListener(() {
      controllerLoginMail.value = loginMailController.text;
    });
    loginPassController.addListener(() {
      controllerLoginPass.value = loginPassController.text;
    });
  }

  Future<void> logInUser() async {
    isLoading.value = true;
    String res = await ApiService().getData();
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (res == "success") {
      int? enableLoc;

      enableLoc = prefs.getInt("enableLoc");
      print("enableLoc: " + enableLoc.toString());

      Get.offAll(() => enableLoc == 0 || enableLoc == null
          ? EnableLocation()
          : HomePage());

      await prefs.setInt("enableLoc", 1);

      await userProfileController.getUpdatedProfileData();

      await prefs.setBool('isLoggedIn', true);

      Get.snackbar("Logged in successfully.", "Welcome to afar cabs!");

      isLoading.value = false;

      await locationHistoryController.getAllSavedLocationData();

      update();
    } else {
      Get.snackbar("Register to AFAR CABS", "First register and then login to proceed");
      isLoading.value = false;
    }
  }

  void togglePasswordView() {
    isHidden.value = !isHidden.value;
    update();
  }

  clearInputText() {
    loginMailController.clear();
    loginPassController.clear();
  }
}