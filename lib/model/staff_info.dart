import 'dart:convert';
import 'package:care/generated/json/base/json_field.dart';
import 'package:care/generated/json/staff_info.g.dart';

@JsonSerializable()
class StaffInfo {
  int? id;
  String? userNo;
  String? name;
  String? nick;
  dynamic? tableau;
  String? sex;
  int? age;
  int? experience;
  dynamic? hasInsuranceFund;
  dynamic? birthday;
  String? mobile;
  String? faceUrl;
  String? faceVideoUrl;
  dynamic? skillType;
  String? workType;
  dynamic? hasInHome;
  dynamic? autograph;
  dynamic? certificateNo;
  String? idCardFront;
  String? idCardNo;
  String? idCardBack;
  dynamic? personalProfile;
  dynamic? nation;
  dynamic? nativePlace;
  String? province;
  String? city;
  String? district;
  String? address;
  dynamic? balance;
  dynamic? education;
  dynamic? major;
  dynamic? school;
  dynamic? storeNo;
  dynamic? status;
  int? score;
  int? hourAmount;
  int? monthAmount;

  StaffInfo();

  factory StaffInfo.fromJson(Map<String, dynamic> json) =>
      $StaffInfoFromJson(json);

  Map<String, dynamic> toJson() => $StaffInfoToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}
