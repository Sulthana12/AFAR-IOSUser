import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:afar_cabs_user/confirmation_page/controller/distance_sending_api_controller.dart';
import 'package:afar_cabs_user/constants/sms_config/sms_config.dart';
import 'package:afar_cabs_user/forgot_password_page/model/forgot_pass.dart';
import 'package:afar_cabs_user/forgot_password_page/view/change_password_page.dart';
import 'package:afar_cabs_user/home_page/controller/google_map_controller.dart';
import 'package:afar_cabs_user/home_page/controller/home_chip_controller.dart';
import 'package:afar_cabs_user/home_page/controller/user_controller.dart';
import 'package:afar_cabs_user/home_page/model/updated_profile.dart';
import 'package:afar_cabs_user/sign_in_up_page/controller/otp_page_controller.dart';
import 'package:afar_cabs_user/sign_in_up_page/controller/sign_in_controller.dart';
import 'package:afar_cabs_user/sign_in_up_page/model/get_user_details_model.dart';
import 'package:afar_cabs_user/sign_in_up_page/model/sign_up_details.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../add_favourites_page/model/save_location.dart';
import '../confirmation_page/model/fare_details.dart';
import '../enable_location/controller/enable_location_controller.dart';
import '../home_page/model/location_history.dart';
import '../home_page/model/vehicles.dart';
import '../search_screen/controller/places_search_controller.dart';
import '../sign_in_up_page/controller/sign_up_email_phone_controller.dart';
import '../sign_in_up_page/view/email_or_phone_veri_page.dart';
import 'api_constants_manager.dart';

class ApiService {
  final mailPhoneController = Get.put(MailPhoneController());
  final loginController = Get.put(LoginMailPhoneController());
  final userProfileController = Get.put(UserProfileController());
  final searchScreenController = Get.put(PlacesSearchController());
  final locController = Get.put(EnableLocationController());
  final googleMapHomController = Get.put(GoogleMapHomeController());
  final homeChipController = Get.put(HomeChipController());

  Future<List<GetUserDetails?>?> getUserDetails() async {
    try {
      var url = Uri.parse(
          '${ApiConstants.baseUrl}/GetUserDetails?PhoneNumber=${loginController.controllerLoginMail.value}&Password=${loginController.controllerLoginPass.value}');
      var response = await http.get(url);
      print(response.body);
      if (response.statusCode == 200) {
        List<GetUserDetails?>? model = getUserDetailsFromJson(response.body);
        return model;
      }
    } catch (e) {
      log(e.toString());
      Get.snackbar("Some error occurred.", e.toString());
    }
    return null;
  }

  Future<List<GetMasterVehicleSettings?>?> getMasterVehiclesSettings() async {
    try {
      var url = Uri.parse('${ApiConstants.baseUrl}${ApiConstants.vehiclesUrl}');
      var response = await http.get(url);
      print(response.body);
      if (response.statusCode == 200) {
        List<GetMasterVehicleSettings?>? model =
            getMasterVehicleSettingsFromJson(response.body);
        print(response.body);
        return model;
      }
    } catch (e) {
      log(e.toString());
      Get.snackbar("Some error occurred.", e.toString());
    }
    return null;
  }

  Future<List<GetBaseVehicleFareDetails?>?> getBaseVehicleFareDetails() async {
    String dateTimePicked = homeChipController.dateTimePicked.value.isEmpty
        ? DateFormat("dd/MM/yyyy HH:mm:ss").format(DateTime.now())
        : homeChipController.dateTimePickedForApi.value;
    double fromLat = searchScreenController.startPositionLat.value != 0.0
        ? searchScreenController.startPositionLat.value
        : locController.currentLatitude.value;
    double fromLong = searchScreenController.startPositionLong.value != 0.0
        ? searchScreenController.startPositionLong.value
        : locController.currentLongitude.value;

    String kms = googleMapHomController.distanceKmForApi.value;
    List<String> corKms = kms.split("");
    corKms.removeLast();
    corKms.removeLast();
    corKms.removeLast();
    print(corKms.join());

    try {
      print('${ApiConstants.baseUrl}${ApiConstants.getBaseVehicleFareDetails}${userProfileController.userID.value}&frmloc=${searchScreenController.controllerStartSearchField.value}&toloc=${searchScreenController.controllerEndSearchField.value}&frmlat=${fromLat.toString()}&frmlong=${fromLong.toString()}&tolat=${searchScreenController.endPositionLat.value.toString()}&tolong=${searchScreenController.endPositionLong.value.toString()}&kms=${corKms.join()}&traveltime=$dateTimePicked');

      var url = Uri.parse(
          '${ApiConstants.baseUrl}${ApiConstants.getBaseVehicleFareDetails}${userProfileController.userID.value}&frmloc=${searchScreenController.controllerStartSearchField.value}&toloc=${searchScreenController.controllerEndSearchField.value}&frmlat=${fromLat.toString()}&frmlong=${fromLong.toString()}&tolat=${searchScreenController.endPositionLat.value.toString()}&tolong=${searchScreenController.endPositionLong.value.toString()}&kms=${corKms.join()}&traveltime=$dateTimePicked');
      // var url = Uri.parse(
      //     '${ApiConstants.baseUrl}${ApiConstants.getBaseVehicleFareDetails}${userProfileController.userID.value}&frmloc=${searchScreenController.controllerStartSearchField.value}&toloc=${searchScreenController.controllerEndSearchField.value}&frmlat=${fromLat.toString()}&frmlong=${fromLong.toString()}&tolat=${searchScreenController.endPositionLat.value.toString()}&tolong=${searchScreenController.endPositionLong.value.toString()}&kms=144.0&traveltime=$dateTimePicked');
      var response = await http.get(url);
      if (response.statusCode == 200) {
        print(response.body);
        List<GetBaseVehicleFareDetails?>? model = getBaseVehicleFareDetailsFromJson(response.body);
        return model;
      }
    } catch (e) {
      log(e.toString());
      Get.snackbar("Some error occurred.", e.toString());
    }
    return null;
  }

  List<GetMasterVehicleSettings?>? createVehiclesList(List? data) {
    List<GetMasterVehicleSettings?> vehiclesList = [];
    if (data != null) {
      for (int i = 0; i < data.length; i++) {
        String title = data[i]["settings_value"];
        String image = data[i]["file_location"];
        GetMasterVehicleSettings vehicles = GetMasterVehicleSettings(
          settingsValue: title,
          fileLocation: image,
        );
        vehiclesList.add(vehicles);
      }
      return vehiclesList;
    }
    return null;
  }

  Future<String?> validateUserMail() async {
    try {
      final response = await http.get(Uri.parse(ApiConstants.baseUrl +
          ApiConstants.validateUser +
          mailPhoneController.controllerMail.value));

      print(response.body);

      if (response.statusCode == 200) {
        return response.body;
      } else {
        return "";
      }
    } catch (e) {
      print(e);
    }
    return null;
  }

  Future<void> getUserByPhoneOrEmail() async {
    String userMailOrPhone = mailPhoneController.controllerMail.value.isNotEmpty
        ? mailPhoneController.controllerMail.value
        : mailPhoneController.controllerPhone.value;

    try {
      final response = await http.get(Uri.parse(ApiConstants.baseUrl +
          ApiConstants.getUserByMailOrPhone +
          userMailOrPhone));
      print(response.body);

      if (response.statusCode == 200) {
        Get.snackbar("User Already Exist",
            "Try to Login or if you forgot password then set a new password!");
      } else {
        Get.to(() => MailOrPhoneVerify());
      }
    } catch (e) {
      print(e);
    }
  }

  Future<bool> getUserByPhoneOrEmailForgot() async {
    String userMailOrPhone = mailPhoneController.controllerMail.value.isNotEmpty
        ? mailPhoneController.controllerMail.value
        : mailPhoneController.controllerPhone.value;

    try {
      final response = await http.get(Uri.parse(ApiConstants.baseUrl +
          ApiConstants.getUserByMailOrPhone +
          userMailOrPhone));
      print(response.body);

      if (response.statusCode == 200) {
        return true;
      } else {
        Get.snackbar("Try to register first",
            "No user available for the given credentials");
        return false;
      }
    } catch (e) {
      print(e);
    }
    return false;
  }

  Future<bool> getChkReferralCode() async {
    String referralCode = mailPhoneController.controllerReferral.value;

    try {
      final response = await http.get(Uri.parse(
          "${ApiConstants.baseUrl}${ApiConstants.referralCheck}$referralCode&UserTypeFlg=U"));
      print(response.body);

      if (response.statusCode == 200) {
        Get.snackbar("Referral code added",
            "Referral code is added successfully to your account.");
        return true;
      } else {
        mailPhoneController.clearReferral();
        Get.snackbar("Referral code is invalid",
            "Check and enter a correct referral code.");
        return false;
      }
    } catch (e) {
      print(e);
    }
    return false;
  }

  Future<String?> mobileOtpGenerator() async {
    try {
      final response = await http
          .get(Uri.parse(ApiConstants.baseUrl + ApiConstants.otpGenerator));
      print(response.body);
      return response.body;
    } catch (e) {
      print(e);
    }
    return null;
  }

  Future<String?> validateUserPhoneNumber(
      String regOrSignin, String otp) async {
    // "OTP for Signup on AFAR Cabs is XXXXXX and valid till 2 minutes. Do not share this OTP to anyone for security purposes"
    String apiOtpMsg = "tjhsdkfgjhsld";
    String forgotOtpMsg =
        "OTP to Reset your Password on AFAR Cabs is $otp and valid till 2 minutes. Do not share this OTP to anyone for security purposes.";
    String signUpOtpMsg =
        "OTP for Signup on AFAR Cabs is $otp and valid till 2 minutes. Do not share this OTP to anyone for security purposes.";

    /// forgot page OTP handling
    if (regOrSignin == "forgot") {
      try {
        print("phone value: ${mailPhoneController.controllerPhone.value}");
        final response = await http.get(Uri.parse(
            "${ApiConstants.otpBaseUrl}/SendSMS?APIKey=7n425U10ZEyLf0BqP3Zzrw&senderid=${SmsConstants.forgotSenderID}&channel=2&DCS=0&flashsms=0&number=91${mailPhoneController.controllerPhone.value}&text=${forgotOtpMsg}&route=1&dlttemplateid=${SmsConstants.forgotTemplateID}"));
        print(
            "${ApiConstants.otpBaseUrl}/SendSMS?APIKey=7n425U10ZEyLf0BqP3Zzrw&senderid=${SmsConstants.forgotSenderID}&channel=2&DCS=0&flashsms=0&number=91${mailPhoneController.controllerPhone.value}&text=${forgotOtpMsg}&route=1&dlttemplateid=${SmsConstants.forgotTemplateID}");
        print(response.body);
        print("Status code: ${response.statusCode}");
        if (response.statusCode == 200) {
          return response.body;
        } else {
          Get.snackbar("Server error in sending OTP",
              "Some error in the server side while sending OTP.");
        }
      } catch (e) {
        print(e);
      }
    } else {
      /// signup and login using OTP page OTP handling
      try {
        print("phone value: ${mailPhoneController.controllerPhone.value}");
        final response = await http.get(Uri.parse(
            "${ApiConstants.otpBaseUrl}/SendSMS?APIKey=7n425U10ZEyLf0BqP3Zzrw&senderid=${SmsConstants.signUpSenderID}&channel=2&DCS=0&flashsms=0&number=91${mailPhoneController.controllerPhone.value}&text=$signUpOtpMsg&route=1&dlttemplateid=${SmsConstants.signUpTemplateID}"));
        print(
            "${ApiConstants.otpBaseUrl}/SendSMS?APIKey=7n425U10ZEyLf0BqP3Zzrw&senderid=${SmsConstants.signUpSenderID}&channel=2&DCS=0&flashsms=0&number=91${mailPhoneController.controllerPhone.value}&text=$signUpOtpMsg&route=1&dlttemplateid=${SmsConstants.signUpTemplateID}");
        print(response.body);
        print("Status code: ${response.statusCode}");
        if (response.statusCode == 200) {
          return response.body;
        } else {
          Get.snackbar("Server error in sending OTP",
              "Some error in the server side while sending OTP.");
        }
      } catch (e) {
        print(e);
      }
    }
    return null;
  }

  Future<String> getData() async {
    var res = "error";
    late List<GetUserDetails>? userModel = [];

    userModel = (await ApiService().getUserDetails())?.cast<GetUserDetails>();

    if (userModel == null) {
      print("error");
      res = "error";
      Get.snackbar("Register or enter correct credentials",
          "Enter correct credentials or else new user means register!");
      return res;
    } else {
      if (userModel[0].userTypeFlg.toString() == "U" ||
          userModel[0].userTypeFlg.toString() == "E") {
        res = "success";
        print(userModel[0].userId.toString());
        userProfileController.userID.value = userModel[0].userId.toString();
        return res;
      }
      res = "error";
      return res;
    }
  }

  Future<List<GetUpdatedProfile?>?> getUpdatedProfile() async {
    try {
      var url = Uri.parse(ApiConstants.baseUrl +
          ApiConstants.getUpdatedProfile +
          userProfileController.userID.value);
      var response = await http.get(url);
      print(response.body);
      if (response.statusCode == 200) {
        List<GetUpdatedProfile?>? model =
            getUpdatedProfileFromJson(response.body);
        return model;
      }
    } catch (e) {
      log(e.toString());
      Get.snackbar("Some error occurred.", e.toString());
    }
    return null;
  }

  Future<List<SaveLocation?>?> getSavedLocation(String location) async {
    try {
      var url = Uri.parse(ApiConstants.baseUrl +
          ApiConstants.getSavedLocation +
          userProfileController.userID.value +
          "&Location_type=" +
          location);
      var response = await http.get(url);
      print(response.body);
      if (response.statusCode == 200) {
        print(response.body);
        List<SaveLocation?>? model = saveLocationFromJson(response.body);
        return model;
      } else {
        print(response.body);
        return null;
      }
    } catch (e) {
      log(e.toString());
      Get.snackbar("Some error occurred.", e.toString());
    }
    return null;
  }

  Future<http.Response?> registerUserDetails(SignUpDetails data) async {
    http.Response? response;
    try {
      response = await http.post(
          Uri.parse(
              "https://afar-api.azurewebsites.net/api/PostUpdatedProfile/SignUpDetails"),
          headers: {
            HttpHeaders.contentTypeHeader: "application/json",
          },
          body: jsonEncode(data.toJson()));
    } catch (e) {
      log(e.toString());
    }
    return response;
  }

  Future<http.Response?> saveLocation(SaveLocation data) async {
    http.Response? response;
    try {
      response = await http.post(
          Uri.parse("https://afar-api.azurewebsites.net/api/SaveLocation"),
          headers: {
            HttpHeaders.contentTypeHeader: "application/json",
          },
          body: jsonEncode(data.toJson()));
    } catch (e) {
      log(e.toString());
    }
    return response;
  }

  Future<http.Response?> postUserPwdUpdate(PostUserPwdUpdate data) async {
    http.Response? response;
    try {
      response = await http.post(Uri.parse(ApiConstants.forgotPass),
          headers: {
            HttpHeaders.contentTypeHeader: "application/json",
          },
          body: jsonEncode(data.toJson()));
    } catch (e) {
      log(e.toString());
    }
    return response;
  }
}
