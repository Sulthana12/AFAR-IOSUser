import 'package:afar_cabs_user/add_favourites_page/controller/save_location_controller.dart';
import 'package:afar_cabs_user/home_page/model/updated_profile.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../api_constants/api_services.dart';

class UserProfileController extends GetxController {
  String? localUserID;

  RxString userID = ''.obs;
  RxString userName = ''.obs;
  RxString mobileNum = ''.obs;
  RxString referralCode = ''.obs;

  @override
  void onInit() {
    super.onInit();
    updateHomeProfile();
  }

  Future<void> updateHomeProfile() async {
    await getLocalUserID();
    await getUpdatedProfileData();
  }

  Future<void> getLocalUserID() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    userID.value = prefs.getString("localUserID") ?? "";
    print("inside user cont localUserID: ${userID.value}");
    update();
  }

  Future<void> getUpdatedProfileData() async {
    late List<GetUpdatedProfile>? userModel = [];

    userModel = (await ApiService().getUpdatedProfile())?.cast<GetUpdatedProfile>();

    if (userModel == null) {
      print("user value null");
    } else {
      print(userModel[0].userId.toString());

      SharedPreferences prefs = await SharedPreferences.getInstance();
      localUserID = prefs.getString("localUserID");
      await prefs.setString("localUserID", userModel[0].userId.toString());

      userID.value = (prefs.getString("localUserID") ?? "");

      userName.value = userModel[0].name.toString();
      mobileNum.value = userModel[0].phoneNum.toString();
      referralCode.value = userModel[0].referralCode.toString();
      print(userName.value);
      print(mobileNum.value);
    }
  }
}