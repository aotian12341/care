import 'dart:convert';
import '../generated/json/base/json_field.dart';
import '../generated/json/dictionary_item.g.dart';

@JsonSerializable()
class DictionaryItem {
  int? id;
  String? code;
  String? name;
  String? value;
  dynamic? icon;
  dynamic? sketch;
  String? parentCode;
  String? codePath;
  int? seqNum;
  List<DictionaryItem>? items;

  DictionaryItem();

  factory DictionaryItem.fromJson(Map<String, dynamic> json) =>
      $DictionaryItemFromJson(json);

  Map<String, dynamic> toJson() => $DictionaryItemToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}
