import 'package:care/constants/api_keys.dart';
import 'package:care/constants/app_config.dart';
import 'package:care/controller/user_controller.dart';

import '../common/http_controller.dart';
import '../model/address_info.dart';
import '../model/pois_info.dart';

class AddressController {
  ///
  factory AddressController() => _getInstance();

  ///
  static AddressController get instance => _getInstance();

  // 静态私有成员，没有初始化
  static AddressController? _instance;

  // 私有构造函数
  AddressController._internal();

  // 静态、同步、私有访问点
  static AddressController _getInstance() {
    _instance ??= AddressController._internal();
    return _instance!;
  }

  /// 获取地址列表
  void getAddressList({Function? success}) async {
    HttpController().get(AddressApi.addressList, success: success);
  }

  void editAddress(
      {required String contact,
      required String phone,
      required String address,
      String? addressNo,
      required String provinceId,
      required String cityId,
      required String areaId,
      required String houseno,
      required String lat,
      required String lng,
      required String addressName,
      int? id,
      bool isDefault = false,
      Function? success}) async {
    Map<String, dynamic> data = {};
    data["contacts"] = contact;
    data["addressNo"] = addressNo;
    data["telephone"] = phone;
    data["province"] = provinceId;
    data["city"] = cityId;
    data["district"] = areaId;
    data["address"] = address;
    data["houseno"] = houseno;
    data["longitude"] = lng;
    data["latitude"] = lat;
    data["addressName"] = addressName;
    data["isDefault"] = isDefault.toString();

    HttpController().post<ResultInfo>(
        id != null ? AddressApi.addressUpdate : AddressApi.addressSave,
        query: data,
        showLoading: true,
        showErrorToast: true,
        success: success);
  }

  /// 地址详情
  void getAddressInfo(
      {required String addressNo, Function? success, Function? fail}) {
    HttpController().get<AddressInfo>(AddressApi.addressInfo + addressNo,
        success: success, fail: fail);
  }

  void delete({required String addressNo, Function? success}) {
    HttpController().post(AddressApi.addressDelete,
        query: {"addressNo": addressNo},
        showErrorToast: true,
        showLoading: true,
        success: success);
  }

  /// 根据gps获取附近地址
  void getLocationByGps(
      {required double lat,
      required double lng,
      Function? success,
      Function? fail}) {
    final data = {
      "key": AppConfig.webKey,
      "location": "$lng,$lat",
    };
    HttpController().get<Map<String, dynamic>>(
        "https://restapi.amap.com/v5/place/around",
        query: data, success: (res) {
      final temp = PoisInfo.fromJson(res);

      if (success != null) {
        success(temp);
      }
    }, fail: fail);
  }

  /// 根据关键字获取地址
  void getLocationByKeyword(
      {String? keyWord, String? city, Function? success, Function? fail}) {
    HttpController().get<Map<String, dynamic>>(
        "https://restapi.amap.com/v5/place/text",
        query: {
          "key": AppConfig.webKey,
          "region": city,
          "keywords": keyWord,
        }, success: (res) {
      final temp = PoisInfo.fromJson(res);

      if (success != null) {
        success(temp);
      }
    }, fail: fail);
  }
}
