import 'dart:convert';

List<GetUpdatedProfile> getUpdatedProfileFromJson(String str) => List<GetUpdatedProfile>.from(json.decode(str).map((x) => GetUpdatedProfile.fromJson(x)));

String getUpdatedProfileToJson(List<GetUpdatedProfile> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class GetUpdatedProfile {
  GetUpdatedProfile({
    required this.userId,
    required this.phoneNum,
    required this.emailId,
    required this.userTypeFlg,
    required this.name,
    this.notificationToken,
    required this.referralCode,
  });

  int userId;
  String phoneNum;
  String emailId;
  String userTypeFlg;
  String name;
  dynamic notificationToken;
  String referralCode;

  factory GetUpdatedProfile.fromJson(Map<String, dynamic> json) => GetUpdatedProfile(
    userId: json["user_id"],
    phoneNum: json["phone_num"],
    emailId: json["email_id"],
    userTypeFlg: json["user_type_flg"],
    name: json["name"],
    notificationToken: json["notification_token"],
    referralCode: json["referral_code"],
  );

  Map<String, dynamic> toJson() => {
    "user_id": userId,
    "phone_num": phoneNum,
    "email_id": emailId,
    "user_type_flg": userTypeFlg,
    "name": name,
    "notification_token": notificationToken,
    "referral_code": referralCode,
  };
}