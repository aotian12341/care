import 'dart:convert';
import 'package:care/generated/json/base/json_field.dart';
import 'package:care/generated/json/pay_info.g.dart';

@JsonSerializable()
class PayInfo {
  String? appId;
  String? mchId;
  String? prepayId;
  int? timestamp;
  String? nonceStr;
  String? sign;
  String? signType;

  PayInfo();

  factory PayInfo.fromJson(Map<String, dynamic> json) => $PayInfoFromJson(json);

  Map<String, dynamic> toJson() => $PayInfoToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}
