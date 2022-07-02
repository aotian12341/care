import 'dart:convert';
import 'package:care/generated/json/base/json_field.dart';
import 'package:care/generated/json/demand_info.g.dart';
import 'package:care/model/demand_page.dart';

@JsonSerializable()
class DemandInfo {
  DemandAddressInfo? addressInfo;
  String? note;
  String? isInHome;
  String? workTimeRange;
  String? workExperience;
  String? serviceAddress;
  String? amountUnit;
  String? employerCount;
  String? demandType;
  String? timeRangeType;
  int? createTime;
  double? price;
  String? demandNo;
  String? workerAgeRange;
  String? workerSex;
  String? timeRange;
  String? status;
  String? workPlace; //服务场合
  String? workDay; //服务类型
  String? employerAgeRange; //护理对象
  String? employerSex; //护理人性别
  String? physicalCondition; // 身体情况
  String? serviceObj;
  String? cleanRegion;
  String? isNeedTool;
  String? cleanType;
  String? cleanDegree;
  List<DemandPagesListWorkers>? workers;

  DemandInfo();

  factory DemandInfo.fromJson(Map<String, dynamic> json) =>
      $DemandInfoFromJson(json);

  Map<String, dynamic> toJson() => $DemandInfoToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class DemandAddressInfo {
  int? id;
  String? addressNo;
  String? userNo;
  String? contacts;
  String? telephone;
  String? province;
  String? city;
  String? district;
  String? address;
  String? isDefalut;

  DemandAddressInfo();

  factory DemandAddressInfo.fromJson(Map<String, dynamic> json) =>
      $DemandAddressInfoFromJson(json);

  Map<String, dynamic> toJson() => $DemandAddressInfoToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}
