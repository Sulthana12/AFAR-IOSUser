import 'dart:convert';

PostUserPwdUpdate postUserPwdUpdateFromJson(String str) => PostUserPwdUpdate.fromJson(json.decode(str));

String postUserPwdUpdateToJson(PostUserPwdUpdate data) => json.encode(data.toJson());

class PostUserPwdUpdate {
  PostUserPwdUpdate({
    required this.phoneNum,
    required this.userPassword,
    this.userTypeFlg,
  });

  String phoneNum;
  String userPassword;
  String? userTypeFlg;

  factory PostUserPwdUpdate.fromJson(Map<String, dynamic> json) => PostUserPwdUpdate(
    phoneNum: json["phone_num"],
    userPassword: json["user_password"],
    userTypeFlg: json["user_type_flg"],
  );

  Map<String, dynamic> toJson() => {
    "phone_num": phoneNum,
    "user_password": userPassword,
    "user_type_flg": userTypeFlg ?? "U",
  };
}