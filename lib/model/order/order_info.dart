import 'dart:convert';
import 'package:care/generated/json/base/json_field.dart';
import 'package:care/generated/json/order_info.g.dart';

@JsonSerializable()
class OrderInfo {
  OrderAddressInfo? addressInfo;
  String? cleanRegion;
  String? cleanType;
  String? isNeedTool;
  String? serviceAddress;
  String? amountUnit;
  String? demandType;
  String? timeRangeType;
  String? serviceObj;
  double? price;
  String? demandNo;
  String? workerAgeRange;
  List<OrderWorkers>? workers;
  String? timeRange;
  String? status;

  OrderInfo();

  factory OrderInfo.fromJson(Map<String, dynamic> json) =>
      $OrderInfoFromJson(json);

  Map<String, dynamic> toJson() => $OrderInfoToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class OrderAddressInfo {
  String? isDefalut;
  String? address;
  String? addressName;
  String? province;
  String? addressNo;
  String? city;
  String? district;
  String? userNo;
  String? telephone;
  int? id;
  String? contacts;

  OrderAddressInfo();

  factory OrderAddressInfo.fromJson(Map<String, dynamic> json) =>
      $OrderAddressInfoFromJson(json);

  Map<String, dynamic> toJson() => $OrderAddressInfoToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class OrderWorkers {
  String? workerNo;
  String? workerName;

  OrderWorkers();

  factory OrderWorkers.fromJson(Map<String, dynamic> json) =>
      $OrderWorkersFromJson(json);

  Map<String, dynamic> toJson() => $OrderWorkersToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}
