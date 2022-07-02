import 'dart:async';

import 'package:amap_flutter_location/amap_flutter_location.dart';
import 'package:amap_flutter_location/amap_location_option.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:get/get.dart';

import '../constants/app_config.dart';
import '../widget/loading/loading.dart';
import '../widget/m_toast.dart';

/// 定位管理工具类
class LocationManager {
  ///
  factory LocationManager() => _getInstance();

  // 静态私有成员，没有初始化
  static LocationManager? _instance;

  ///
  Loading? loading;

  // 私有构造函数
  LocationManager._internal() {
    init();
  }

  // 静态、同步、私有访问点
  static LocationManager _getInstance() {
    _instance ??= LocationManager._internal();
    return _instance!;
  }

  ///

  /// 定位监听器
  final List<Function(Map<String, Object> loc)?> _successList = [];

  /// 定位实体
  static final locationInfo = <String, Object>{}.obs;

  ///
  final _locationPlugin = AMapFlutterLocation();

  /// 定位回调
  StreamSubscription<Map<String, Object>>? _locationListener;

  /// 初始化
  Future<void> init() async {
    AMapFlutterLocation.updatePrivacyAgree(true);
    AMapFlutterLocation.updatePrivacyShow(true, true);

    AMapFlutterLocation.setApiKey(AppConfig.androidKey, AppConfig.iosKey);

    _locationListener = _locationPlugin
        .onLocationChanged()
        .listen((Map<String, Object> result) {
      if (loading != null) {
        hideLoading();
      }
      locationInfo(result);
      for (final success in _successList) {
        success!(result);
      }
    });
  }

  /// 定位权限
  Future<bool> checkPermission() async {
    final Map<Permission, PermissionStatus> statuses = await [
      Permission.location,
      Permission.locationWhenInUse,
    ].request();

    if (statuses[Permission.location]!.isGranted ||
        statuses[Permission.locationWhenInUse]!.isGranted) {
      return true;
    } else {
      MToast.show("定位失败，尚未允许使用定位权限，请设置");
      return false;
    }
  }

  /// 获取定位
  Future<void> getLocation(
      {bool isOnce = false,
      bool showLoading = false,
      int? locationInterval,
      Function(Map<String, Object> loc)? success}) async {
    final permission = await checkPermission();

    if (!_successList.contains(success)) {
      _successList.add(success);
    }

    if (permission) {
      _setLocationOption(
          isOnce: isOnce, locationInterval: locationInterval ?? 2000);

      if (isOnce && showLoading) {
        showLoadingDialog();
      }
      _startLocation();
    }
  }

  /// 开始定位
  void _startLocation() {
    _locationPlugin.startLocation();
  }

  ///停止定位
  void _stopLocation() {
    _locationPlugin.stopLocation();
  }

  void removeListener(Function(Map<String, Object> loc) listener) {
    _successList.remove(listener);
  }

  ///设置定位参数
  void _setLocationOption(
      {bool isOnce = false, required int locationInterval}) {
    final locationOption = AMapLocationOption();

    ///是否单次定位
    locationOption.onceLocation = isOnce;

    ///是否需要返回逆地理信息
    locationOption.needAddress = true;

    ///逆地理信息的语言类型
    locationOption.geoLanguage = GeoLanguage.DEFAULT;
    locationOption.desiredLocationAccuracyAuthorizationMode =
        AMapLocationAccuracyAuthorizationMode.ReduceAccuracy;
    locationOption.fullAccuracyPurposeKey = "AMapLocationScene";

    ///设置Android端连续定位的定位间隔
    locationOption.locationInterval = locationInterval;

    ///设置Android端的定位模式<br>
    ///可选值：<br>
    ///<li>[AMapLocationMode.Battery_Saving]</li>
    ///<li>[AMapLocationMode.Device_Sensors]</li>
    ///<li>[AMapLocationMode.Hight_Accuracy]</li>
    locationOption.locationMode = AMapLocationMode.Hight_Accuracy;

    ///设置iOS端的定位最小更新距离<br>
    locationOption.distanceFilter = -1;

    ///设置iOS端期望的定位精度
    /// 可选值：<br>
    /// <li>[DesiredAccuracy.Best] 最高精度</li>
    /// <li>[DesiredAccuracy.BestForNavigation] 适用于导航场景的高精度 </li>
    /// <li>[DesiredAccuracy.NearestTenMeters] 10米 </li>
    /// <li>[DesiredAccuracy.Kilometer] 1000米</li>
    /// <li>[DesiredAccuracy.ThreeKilometers] 3000米</li>
    locationOption.desiredAccuracy = DesiredAccuracy.Best;

    ///设置iOS端是否允许系统暂停定位
    locationOption.pausesLocationUpdatesAutomatically = false;

    ///将定位参数设置给定位插件
    _locationPlugin.setLocationOption(locationOption);
  }

  /// 销毁
  void dispose() {
    if (_locationListener != null) {
      _locationListener?.cancel();
    }

    ///销毁定位
    _locationPlugin.destroy();
  }

  /// 显示loading
  void showLoadingDialog() {
    if (Get.context != null) {
      if (loading == null) {
        loading = const Loading();
        showDialog<dynamic>(
          context: Get.context!,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return loading!;
          },
        );
      }
    }
  }

  /// 隐藏loading
  void hideLoading() {
    if (Get.context != null && loading != null) {
      loading!.hide(Get.context!);
      loading = null;
    }
  }
}
