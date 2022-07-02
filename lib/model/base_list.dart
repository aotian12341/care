import 'dart:convert';
import '../generated/json/base/json_convert_content.dart';

class BaseList<T> {
  int? totalCount;
  int? pageSize;
  int? totalPage;
  int? currPage;
  List<T>? list;

  BaseList();

  factory BaseList.fromJson(Map<String, dynamic> json) {
    BaseList<T> data = BaseList<T>();

    final int? totalCount = jsonConvert.convert<int>(json['totalCount']);
    if (totalCount != null) {
      data.totalCount = totalCount;
    }
    final int? pageSize = jsonConvert.convert<int>(json['pageSize']);
    if (pageSize != null) {
      data.pageSize = pageSize;
    }
    final int? totalPage = jsonConvert.convert<int>(json['totalPage']);
    if (totalPage != null) {
      data.totalPage = totalPage;
    }
    final int? currPage = jsonConvert.convert<int>(json['currPage']);
    if (currPage != null) {
      data.currPage = currPage;
    }

    return data;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['totalCount'] = totalCount;
    data['pageSize'] = pageSize;
    data['totalPage'] = totalPage;
    data['currPage'] = currPage;
    data['list'] = json.encode(list);
    return data;
  }

  @override
  String toString() {
    return jsonEncode(this);
  }
}
