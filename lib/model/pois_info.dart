import 'dart:convert';
import 'package:care/generated/json/base/json_field.dart';
import 'package:care/generated/json/pois_info.g.dart';

@JsonSerializable()
class PoisInfo {
  String? status;
  String? info;
  String? infocode;
  List<PoisPois>? pois;
  String? count;

  PoisInfo();

  factory PoisInfo.fromJson(Map<String, dynamic> json) =>
      $PoisInfoFromJson(json);

  Map<String, dynamic> toJson() => $PoisInfoToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class PoisPois {
  String? name;
  String? id;
  String? location;
  String? type;
  String? typecode;
  String? pname;
  String? cityname;
  String? adname;
  String? address;
  String? pcode;
  String? citycode;
  String? adcode;

  PoisPois();

  factory PoisPois.fromJson(Map<String, dynamic> json) =>
      $PoisPoisFromJson(json);

  Map<String, dynamic> toJson() => $PoisPoisToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}
