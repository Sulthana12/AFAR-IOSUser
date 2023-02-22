import 'dart:convert';

List<GetMasterVehicleSettings> getMasterVehicleSettingsFromJson(String str) => List<GetMasterVehicleSettings>.from(json.decode(str).map((x) => GetMasterVehicleSettings.fromJson(x)));

String getMasterVehicleSettingsToJson(List<GetMasterVehicleSettings> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class GetMasterVehicleSettings {
  GetMasterVehicleSettings({
    this.settingsId,
    this.settingsName,
    this.settingsValue,
    this.settingDesc,
    this.type,
    this.days,
    this.fileName,
    this.fileLocation,
    this.enFlg,
  });

  int? settingsId;
  String? settingsName;
  String? settingsValue;
  String? settingDesc;
  String? type;
  String? days;
  String? fileName;
  String? fileLocation;
  String? enFlg;

  factory GetMasterVehicleSettings.fromJson(Map<String, dynamic> json) => GetMasterVehicleSettings(
    settingsId: json["settings_id"],
    settingsName: json["settings_name"],
    settingsValue: json["settings_value"],
    settingDesc: json["setting_desc"],
    type: json["type"],
    days: json["days"],
    fileName: json["file_name"],
    fileLocation: json["file_location"],
    enFlg: json["en_flg"],
  );

  Map<String, dynamic> toJson() => {
    "settings_id": settingsId,
    "settings_name": settingsName,
    "settings_value": settingsValue,
    "setting_desc": settingDesc,
    "type": type,
    "days": days,
    "file_name": fileName,
    "file_location": fileLocation,
    "en_flg": enFlg,
  };
}
