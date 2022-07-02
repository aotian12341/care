import 'dart:convert';
import 'package:care/generated/json/base/json_field.dart';
import 'package:care/generated/json/order_page_info.g.dart';

@JsonSerializable()
class OrderPageInfo {
  List<OrderPageRecords>? records;
  int? total;
  int? size;
  int? current;
  List<dynamic>? orders;
  bool? searchCount;
  int? pages;

  OrderPageInfo();

  factory OrderPageInfo.fromJson(Map<String, dynamic> json) =>
      $OrderPageInfoFromJson(json);

  Map<String, dynamic> toJson() => $OrderPageInfoToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class OrderPageRecords {
  String? orderNo;
  String? serviceName;
  String? employerNo;
  String? workerNo;
  String? serviceAddress;
  String? serviceTimeRange;
  String? status;
  String? statusText;
  double? price;
  String? amountUnit;
  dynamic totalAmount;
  dynamic payAmount;
  dynamic promotionAmount;
  dynamic integrationAmount;
  dynamic couponAmount;
  dynamic discountAmount;
  dynamic payType;
  dynamic valid;
  int? createTime;
  int? updateTime;

  OrderPageRecords();

  factory OrderPageRecords.fromJson(Map<String, dynamic> json) =>
      $OrderPageRecordsFromJson(json);

  Map<String, dynamic> toJson() => $OrderPageRecordsToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}
