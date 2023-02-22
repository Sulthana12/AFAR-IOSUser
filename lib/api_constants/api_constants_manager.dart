class ApiConstants {
  static String baseUrl = 'https://afar-api.azurewebsites.net/api';
  static String validateUser = "/ValidateUser?emailId=";
  static String getUserByMailOrPhone = "/GetUserByPhoneOrEmail?PhoneNumber=";
  static String referralCheck = "/GetChkReferralCode?ReferralCode=";
  static String otpGenerator = "/OtpGenerator";
  static String getUpdatedProfile = "/GetUpdatedProfile?userId=";
  static String forgotPass = "https://afar-api.azurewebsites.net/api/PostUserPwdUpdate";
  static String vehiclesUrl = "/GetMasterSettings?settingsName=Vehicles";
  static String getSavedLocation = "/GetSavedLocation?User_id=";
  static String getBaseVehicleFareDetails = "/GetBaseVehicleFareDetails?userid=";

  static String otpBaseUrl = "https://www.smsgatewayhub.com/api/mt";
}