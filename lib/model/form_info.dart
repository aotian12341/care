import 'package:flutter/material.dart';

class FormInfo {
  String? title;
  List<FormItem>? children;

  FormInfo.fromJson(Map<String, dynamic> item) {
    if (item["title"] != null) {
      title = item["title"].toString();
    }
    if (item["children"] != null) {
      final temp = <FormItem>[];
      for (final info in item["children"] as List) {
        final map = info as Map;
        temp.add(FormItem.fromJson(Map<String, dynamic>.from(map)));
      }
      children ??= [];
      children?.clear();
      children?.addAll(temp);
    }
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data["title"] = title;
    if ((children ?? []).isNotEmpty) {
      final array = <Map<String, dynamic>>[];
      for (final item in children ?? <FormItem>[]) {
        array.add(item.toJson());
      }
      data["children"] = array;
    }
    return data;
  }
}

class FormItem {
  String? code;
  String? title;
  String? hint;
  String? value;
  String? key;
  String? type;
  List<FormListItem>? list;

  String? title1;
  String? title2;
  String? hint1;
  String? hint2;
  String? key1;
  String? key2;
  String? value1;
  String? value2;
  bool? required;

  String? action;
  String? params;

  int? selectIndex;

  /*
  String? title;
  String? title1;
  String? title2;
  String? hint;
  String? hint1;
  String? hint2;
  dynamic? value;
  dynamic? value1;
  dynamic? value2;
  bool? required;
  String? type;
  String? code;
  String? key;
  String? key1;
  String? key2;
  String? action;
  String? params;

  List<FormItemOption>? list;
  List<FormItem>? children;

   */

  FormItem();

  TextEditingController controller = TextEditingController();

  FormItem.fromJson(Map<String, dynamic> item) {
    if (item["title"] != null) {
      title = item["title"].toString();
    }
    if (item["title1"] != null) {
      title1 = item["title1"].toString();
    }
    if (item["title2"] != null) {
      title2 = item["title2"].toString();
    }
    if (item["hint"] != null) {
      hint = item["hint"].toString();
    }
    if (item["hint1"] != null) {
      hint1 = item["hint1"].toString();
    }
    if (item["hint2"] != null) {
      hint2 = item["hint2"].toString();
    }
    if (item["value"] != null) {
      value = item["value"];
    }
    if (item["value1"] != null) {
      value1 = item["value1"];
    }
    if (item["value2"] != null) {
      value2 = item["value2"];
    }
    if (item["required"] != null) {
      required = item["required"] as bool;
    }
    if (item["type"] != null) {
      type = item["type"].toString();
    }
    if (item["code"] != null) {
      code = item["code"].toString();
    }
    if (item["key"] != null) {
      key = item["key"].toString();
    }
    if (item["key1"] != null) {
      key1 = item["key1"].toString();
    }
    if (item["key2"] != null) {
      key2 = item["key2"].toString();
    }
    if (item["selectIndex"] != null) {
      selectIndex = item["selectIndex"];
    }
    if (item["list"] != null) {
      final temp = <FormListItem>[];
      for (final info in item["list"] as List) {
        temp.add(FormListItem.fromJson(Map<String, dynamic>.from(info as Map)));
      }
      list ??= [];
      list?.clear();
      list?.addAll(temp);
    }
    if (item["action"] != null) {
      action = item["action"].toString();
    }
    if (item["params"] != null) {
      params = item["params"].toString();
    }
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['title'] = title;
    data['title1'] = title1;
    data['title2'] = title2;
    data['hint'] = hint;
    data['hint1'] = hint1;
    data['hint2'] = hint2;
    data['value'] = value;
    data['value1'] = value1;
    data['value2'] = value2;
    data['required'] = required;
    data['type'] = type;
    data['key'] = key;
    data['key1'] = key1;
    data['key2'] = key2;
    data['params'] = params;
    data['action'] = action;
    data['code'] = code;
    data['selectIndex'] = selectIndex;

    if (list != null) {
      final array = <Map<String, dynamic>>[];
      for (final item in list ?? <FormListItem>[]) {
        array.add(item.toJson());
      }
      data["list"] = array;
    }

    return data;
  }
}

class FormItemOption {
  String? key;
  String? value;

  FormItemOption.fromJson(Map<String, dynamic> item) {
    if (item["key"] != null) {
      key = item["key"].toString();
    }
    if (item["value"] != null) {
      value = item["value"].toString();
    }
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{"key": key, "value": value};
  }
}

class FormListItem {
  String? name;
  String? code;
  String? value;
  FormItem? child;

  FormListItem();

  FormListItem.fromJson(Map<String, dynamic> item) {
    if (item["name"] != null) {
      name = item["name"].toString();
    }
    if (item["value"] != null) {
      value = item["value"].toString();
    }
    if (item["code"] != null) {
      code = item["code"].toString();
    }
    if (item["child"] != null) {
      child = FormItem.fromJson(item["child"]);
    }
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      "name": name,
      "value": value,
      "code": code,
      "child": child == null ? {} : child!.toJson()
    };
  }
}
