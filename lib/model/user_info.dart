import 'dart:convert';
import '../generated/json/base/json_field.dart';
import '../generated/json/user_info.g.dart';

@JsonSerializable()
class UserInfo {
  int? id;
  String? userNo;
  String? name;
  String? nick;
  dynamic? tableau;
  String? sex;
  int? age;
  int? experience;
  dynamic? hasInsuranceFund;
  String? birthday;
  String? mobile;
  String? faceUrl;
  String? faceVideoUrl;
  dynamic? skillType;
  dynamic? workType;
  dynamic? hasInHome;
  dynamic? autograph;
  String? certificateNo;
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
  String? school;
  dynamic? storeNo;
  dynamic? status;
  int? score;
  int? hourAmount;
  int? monthAmount;

  UserInfo();

  factory UserInfo.fromJson(Map<String, dynamic> json) =>
      $UserInfoFromJson(json);

  Map<String, dynamic> toJson() => $UserInfoToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}
