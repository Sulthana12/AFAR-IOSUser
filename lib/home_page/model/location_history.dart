import 'dart:convert';

List<GetAllSaveLocation> getAllSaveLocationFromJson(String str) => List<GetAllSaveLocation>.from(json.decode(str).map((x) => GetAllSaveLocation.fromJson(x)));

String getAllSaveLocationToJson(List<GetAllSaveLocation> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class GetAllSaveLocation {
  GetAllSaveLocation({
    this.userId,
    this.locationId,
    this.locationType,
    this.locationAddress,
    this.locationStreet,
    this.pincode,
    this.locationLandmark,
    this.status,
  });

  int? userId;
  int? locationId;
  String? locationType;
  String? locationAddress;
  String? locationStreet;
  String? pincode;
  String? locationLandmark;
  dynamic status;

  factory GetAllSaveLocation.fromJson(Map<String, dynamic> json) => GetAllSaveLocation(
    userId: json["user_id"],
    locationId: json["location_id"],
    locationType: json["location_type"],
    locationAddress: json["location_address"],
    locationStreet: json["location_street"],
    pincode: json["pincode"],
    locationLandmark: json["location_landmark"],
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "user_id": userId,
    "location_id": locationId,
    "location_type": locationType,
    "location_address": locationAddress,
    "location_street": locationStreet,
    "pincode": pincode,
    "location_landmark": locationLandmark,
    "status": status,
  };
}
