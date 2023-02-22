import 'dart:convert';

List<SaveLocation> saveLocationFromJson(String str) => List<SaveLocation>.from(json.decode(str).map((x) => SaveLocation.fromJson(x)));

String saveLocationToJson(SaveLocation data) => json.encode(data.toJson());

class SaveLocation {
  SaveLocation({
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
  String? status;

  factory SaveLocation.fromJson(Map<String, dynamic> json) => SaveLocation(
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
    "location_id": locationId ?? 0,
    "location_type": locationType,
    "location_address": locationAddress,
    "location_street": locationStreet ?? "",
    "pincode": pincode ?? "",
    "location_landmark": locationLandmark ?? "",
    "status": status,
  };
}
