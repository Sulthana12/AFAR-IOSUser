// To parse this JSON data, do
//
//     final signUpDetails = signUpDetailsFromJson(jsonString);

import 'dart:convert';

SignUpDetails? signUpDetailsFromJson(String str) => SignUpDetails.fromJson(json.decode(str));

String signUpDetailsToJson(SignUpDetails? data) => json.encode(data!.toJson());

class SignUpDetails {
  SignUpDetails({
    this.firstName,
    this.lastName,
    this.emailId,
    this.phoneNum,
    this.userPassword,
    this.userTypeFlg,
    this.enFlg,
    this.notificationToken,
    this.userId,
    this.imageData,
    this.usrImgFileName,
    this.usrImgFileLocation,
    this.screenType,
    this.referralCode,
  });

  String? firstName;
  String? lastName;
  String? emailId;
  String? phoneNum;
  String? userPassword;
  String? userTypeFlg;
  String? enFlg;
  String? notificationToken;
  int? userId;
  String? imageData;
  String? usrImgFileName;
  String? usrImgFileLocation;
  String? screenType;
  String? referralCode;

  factory SignUpDetails.fromJson(Map<String, dynamic> json) => SignUpDetails(
    firstName: json["first_name"],
    lastName: json["last_name"],
    emailId: json["email_id"],
    phoneNum: json["phone_num"],
    userPassword: json["user_Password"],
    userTypeFlg: json["user_type_flg"],
    enFlg: json["en_flg"],
    notificationToken: json["notification_token"],
    userId: json["user_id"],
    imageData: json["image_data"],
    usrImgFileName: json["usr_img_file_name"],
    usrImgFileLocation: json["usr_img_file_location"],
    screenType: json["screen_type"],
    referralCode: json["referral_Code"],
  );

  Map<String, dynamic> toJson() => {
    "first_name": firstName ?? "",
    "last_name": lastName ?? "",
    "email_id": emailId ?? "-",
    "phone_num": phoneNum ?? "",
    "user_Password": userPassword ?? "",
    "user_type_flg": userTypeFlg ?? "U",
    "en_flg": enFlg ?? "s",
    "notification_token": notificationToken ?? "",
    "user_id": userId ?? 0,
    "image_data": imageData ?? "",
    "usr_img_file_name": usrImgFileName ?? "",
    "usr_img_file_location": usrImgFileLocation ?? "",
    "screen_type": screenType ?? "",
    "referral_Code": referralCode ?? "",
  };
}
