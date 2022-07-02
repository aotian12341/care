import 'dart:convert';
import '../generated/json/base/json_field.dart';
import '../generated/json/shop_Info.g.dart';

@JsonSerializable()
class ShopInfo {
  ShopInfo();

  factory ShopInfo.fromJson(Map<String, dynamic> json) =>
      $ShopInfoFromJson(json);

  Map<String, dynamic> toJson() => $ShopInfoToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}
