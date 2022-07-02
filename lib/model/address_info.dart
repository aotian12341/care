import 'dart:convert';
import 'package:care/generated/json/base/json_field.dart';
import 'package:care/generated/json/address_info.g.dart';

@JsonSerializable()
class AddressInfo {
  int? id;

  String? addressName;
  String? addressNo;
  String? userNo;
  String? contacts;
  String? telephone;
  String? province;
  String? city;
  String? district;
  String? address;
  String? isDefault;
  String? latitude;
  String? longitude;
  String? houseno;

  AddressInfo();

  factory AddressInfo.fromJson(Map<String, dynamic> json) =>
      $AddressInfoFromJson(json);

  Map<String, dynamic> toJson() => $AddressInfoToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}
