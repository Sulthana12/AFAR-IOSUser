// To parse this JSON data, do
//
//     final getUserDetails = getUserDetailsFromJson(jsonString);

import 'dart:convert';

List<GetUserDetails?>? getUserDetailsFromJson(String str) => json.decode(str) == null ? [] : List<GetUserDetails?>.from(json.decode(str)!.map((x) => GetUserDetails.fromJson(x)));

String getUserDetailsToJson(List<GetUserDetails?>? data) => json.encode(data == null ? [] : List<dynamic>.from(data.map((x) => x!.toJson())));

class GetUserDetails {
  GetUserDetails({
    this.userId,
    this.phoneNum,
    this.emailId,
    this.userTypeFlg,
    this.name,
    this.notificationToken,
  });

  int? userId;
  String? phoneNum;
  String? emailId;
  String? userTypeFlg;
  String? name;
  String? notificationToken;

  factory GetUserDetails.fromJson(Map<String, dynamic> json) => GetUserDetails(
    userId: json["user_id"],
    phoneNum: json["phone_num"],
    emailId: json["email_id"],
    userTypeFlg: json["user_type_flg"],
    name: json["name"],
    notificationToken: json["notification_token"],
  );

  Map<String, dynamic> toJson() => {
    "user_id": userId,
    "phone_num": phoneNum,
    "email_id": emailId,
    "user_type_flg": userTypeFlg,
    "name": name,
    "notification_token": notificationToken,
  };
}
