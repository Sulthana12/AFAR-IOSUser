import 'dart:convert';

List<GetBaseVehicleFareDetails> getBaseVehicleFareDetailsFromJson(String str) => List<GetBaseVehicleFareDetails>.from(json.decode(str).map((x) => GetBaseVehicleFareDetails.fromJson(x)));

String getBaseVehicleFareDetailsToJson(List<GetBaseVehicleFareDetails> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class GetBaseVehicleFareDetails {
  GetBaseVehicleFareDetails({
    this.userId,
    this.fromLocation,
    this.toLocation,
    this.fromLatitude,
    this.fromLongitude,
    this.toLatitude,
    this.toLongitude,
    this.fareDate,
    this.fareType,
    this.othersNum,
    this.kms,
    this.calFare,
    this.vehicleId,
    this.vehicleName,
    this.fileLocation,
    this.peakFlg,
    this.fareDateTime,
  });

  int? userId;
  dynamic fromLocation;
  dynamic toLocation;
  dynamic fromLatitude;
  dynamic fromLongitude;
  dynamic toLatitude;
  dynamic toLongitude;
  dynamic fareDate;
  dynamic fareType;
  dynamic othersNum;
  double? kms;
  double? calFare;
  int? vehicleId;
  String? vehicleName;
  String? fileLocation;
  dynamic peakFlg;
  String? fareDateTime;

  factory GetBaseVehicleFareDetails.fromJson(Map<String, dynamic> json) => GetBaseVehicleFareDetails(
    userId: json["user_id"],
    fromLocation: json["from_location"],
    toLocation: json["to_location"],
    fromLatitude: json["from_latitude"],
    fromLongitude: json["from_longitude"],
    toLatitude: json["to_latitude"],
    toLongitude: json["to_longitude"],
    fareDate: json["fare_date"],
    fareType: json["fare_type"],
    othersNum: json["others_num"],
    kms: json["kms"],
    calFare: json["cal_fare"].toDouble(),
    vehicleId: json["vehicle_id"],
    vehicleName: json["vehicle_name"],
    fileLocation: json["file_location"],
    peakFlg: json["peak_flg"],
    fareDateTime: json["fare_date_time"],
  );

  Map<String, dynamic> toJson() => {
    "user_id": userId,
    "from_location": fromLocation,
    "to_location": toLocation,
    "from_latitude": fromLatitude,
    "from_longitude": fromLongitude,
    "to_latitude": toLatitude,
    "to_longitude": toLongitude,
    "fare_date": fareDate,
    "fare_type": fareType,
    "others_num": othersNum,
    "kms": kms,
    "cal_fare": calFare,
    "vehicle_id": vehicleId,
    "vehicle_name": vehicleName,
    "file_location": fileLocation,
    "peak_flg": peakFlg,
    "fare_date_time": fareDateTime,
  };
}
