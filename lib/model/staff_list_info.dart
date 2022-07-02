import 'dart:convert';
import 'package:care/generated/json/base/json_field.dart';
import 'package:care/generated/json/staff_list_info.g.dart';

@JsonSerializable()
class StaffListInfo {
  int? totalCount;
  int? pageSize;
  int? totalPage;
  int? currPage;
  List<StaffListList>? list;

  StaffListInfo();

  factory StaffListInfo.fromJson(Map<String, dynamic> json) =>
      $StaffListInfoFromJson(json);

  Map<String, dynamic> toJson() => $StaffListInfoToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class StaffListList {
  String? userNo;
  String? name;
  dynamic sex;
  int? age;
  int? experience;
  dynamic skillType;
  String? workType;
  dynamic hasInHome;
  dynamic autograph;
  dynamic personalProfile;
  dynamic nation;
  dynamic nativePlace;
  String? province;
  String? city;
  String? district;
  String? address;
  dynamic storeNo;
  dynamic status;
  int? score;
  int? hourAmount;
  int? monthAmount;

  StaffListList();

  factory StaffListList.fromJson(Map<String, dynamic> json) =>
      $StaffListListFromJson(json);

  Map<String, dynamic> toJson() => $StaffListListToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}
