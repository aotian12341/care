import 'dart:convert';

import 'package:care/controller/user_controller.dart';
import 'package:care/generated/json/base/json_convert_content.dart';
import 'package:care/model/base_list.dart';
import 'package:care/model/demand_info.dart';
import 'package:care/model/demand_page.dart';

import '../common/http_controller.dart';
import '../constants/api_keys.dart';
import '../model/form_info.dart';

class DemandController {
  ///
  factory DemandController() => _getInstance();

  ///
  static DemandController get instance => _getInstance();

  // 静态私有成员，没有初始化
  static DemandController? _instance;

  // 私有构造函数
  DemandController._internal();

  // 静态、同步、私有访问点
  static DemandController _getInstance() {
    _instance ??= DemandController._internal();
    return _instance!;
  }

  /// 需求单列表
  void getDemandList({
    String? demandType,
    String? status,
    String? startTime,
    String? endTime,
    String? orderType,
    String? orderKey,
    int pageSize = 15,
    int currPage = 1,
    Function? success,
    Function? fail,
  }) {
    final data = {
      "orderType": orderType,
      "orderKey": orderKey,
      "pageSize": pageSize,
      "currPage": currPage,
      "demandType": demandType,
      "status": status,
      "startTime": startTime,
      "endTime": endTime,
    };
    HttpController().get<DemandPage>(
      DemandApi.demandList,
      query: data,
      fail: fail,
      success: success,
    );
  }

  /// 获取需求单模板数据
  List<FormInfo> demandTemplate({required String code}) {
    final array = UserController().templateData[code] ?? [];
    final result = <FormInfo>[];
    for (final temp in array) {
      final map = temp.toJson();
      final str = json.encode(map);
      final value = json.decode(str);
      final info = FormInfo.fromJson(value);
      result.add(info);
    }
    return result;
  }

  ///
  void demandApply(
      {required List<FormInfo> dataList,
      required String code,
      Function? success}) {
    final data = handleData(dataList);
    HttpController().post<ResultInfo>(DemandApi.demandApply,
        query: {"demandInfo": data, "demandType": code},
        showErrorToast: true,
        showLoading: true,
        success: success);
  }

  /// 处理数据
  Map<String, dynamic> handleData(List<FormInfo> dataList) {
    Map<String, dynamic> data = <String, dynamic>{};
    for (final item in dataList) {
      if (item.children != null) {
        for (final temp in item.children ?? <FormItem>[]) {
          if (temp.type == "text") {
            continue;
          }
          if (temp.type == "money") {
            data[temp.key1!] = temp.value1;
            data[temp.key2!] = temp.value2;
          } else if (temp.type == "serviceDate") {
            data[temp.key1!] = temp.value1;
            data[temp.key2!] = temp.value2;
          } else if (temp.type == "duration") {
            data[temp.key!] = "${temp.value1}--${temp.value2}";
          } else if (temp.type == "interaction") {
            getInteractionData(data, temp);
          } else if (((temp.value ?? "").toString()).isNotEmpty) {
            data[temp.key.toString()] = temp.value;
          }
        }
      }
    }

    for (final temp in data.keys) {
      if (data[temp] is List) {
        data[temp] = json.encode(data[temp]);
      }
    }

    return data;
  }

  Map<String, dynamic> getInteractionData(
      Map<String, dynamic> data, FormItem temp) {
    data[temp.key ?? ""] = temp.value;
    if ((temp.list ?? []).isNotEmpty && temp.type == "interaction") {
      final item = temp.list![temp.selectIndex!].child;
      if (item?.code != null || item?.title != null) {
        data = getInteractionData(data, item!);
      }
    }
    return data;
  }

  void getDemandDetails(
      {required String demandNo, Function? success, Function? fail}) {
    HttpController().get<DemandInfo>(DemandApi.demandDetails + demandNo,
        success: success, fail: fail);
  }

  /// 关闭需求单
  void demandDel({required String demandNo, Function? success}) {
    HttpController().post<ResultInfo>(
      DemandApi.demandDel + demandNo,
      showErrorToast: true,
      showLoading: true,
      success: success,
    );
  }

  /// 雇主确认雇员
  void demandConfirmStaff(
      {required String memberDemandNo,
      required String workerNo,
      Function? success}) {
    HttpController().post<ResultInfo>(DemandApi.demandConfirmStaff,
        query: {"memberDemandNo": memberDemandNo, "workerNo": workerNo},
        success: success,
        showErrorToast: true,
        showLoading: true);
  }
}
