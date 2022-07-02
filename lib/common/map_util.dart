import 'dart:io';
import 'dart:ui';

import 'package:url_launcher/url_launcher.dart';

import '../widget/m_toast.dart';

class MapUtil {
  /// 高德地图
  static Future<bool> gotoAMap(
      {required double longitude, required double latitude}) async {
    var url =
        '${Platform.isAndroid ? 'android' : 'ios'}amap://navi?sourceApplication=amap&lat=$latitude&lon=$longitude&dev=0&style=2';

    bool canLaunchUrl = await canLaunch(url);

    if (!canLaunchUrl) {
      MToast.show('未检测到高德地图~');
      return false;
    }

    await launch(url);

    return true;
  }

  /// 腾讯地图
  static Future<bool> gotoTencentMap(
      {required double longitude, required double latitude}) async {
    var url =
        'qqmap://map/routeplan?type=drive&fromcoord=CurrentLocation&tocoord=$latitude,$longitude&referer=IXHBZ-QIZE4-ZQ6UP-DJYEO-HC2K2-EZBXJ';
    bool canLaunchUrl = await canLaunch(url);

    if (!canLaunchUrl) {
      MToast.show('未检测到腾讯地图~');
      return false;
    }

    await launch(url);

    return canLaunchUrl;
  }

  /// 百度地图
  static Future<bool> gotoBaiduMap(
      {required double longitude, required double latitude}) async {
    var url =
        'baidumap://map/direction?destination=$latitude,$longitude&coord_type=bd09ll&mode=driving';

    bool canLaunchUrl = await canLaunch(url);

    if (!canLaunchUrl) {
      MToast.show('未检测到百度地图~');
      return false;
    }

    await launch(url);

    return canLaunchUrl;
  }

  /// 苹果地图
  static Future<bool> gotoGoogleMap(
      {required double longitude, required double latitude}) async {
    String url = 'http://maps.apple.com/?&daddr=$latitude,$longitude';
    bool canLaunchUrl = await canLaunch(url);

    if (!canLaunchUrl) {
      MToast.show('未检测到谷歌地图~');
      return false;
    }

    await launch(url);

    return canLaunchUrl;
  }

  /// 跳转到第三方地图
  /// [url]跳转地址
  /// [toInstallCallBack]地图未安装回调
  static Future<bool> gotoMap(
      {required String url, VoidCallback? toInstallCallBack}) async {
    bool canLaunchUrl = await isMapInstall(url);

    if (!canLaunchUrl) {
      if (null != toInstallCallBack) {
        toInstallCallBack();
      }

      return false;
    }

    await launch(url);

    return true;
  }

  static void toInstallMap(String url) {
    launch(url);
  }

  static Future<bool> isBaiduMapInstall() async {
    return await canLaunch('baidumap://map/direction');
  }

  static Future<bool> isTencentMapInstall() async {
    return await canLaunch('qqmap://map/routeplan');
  }

  static Future<bool> isAmapMapInstall() async {
    return await canLaunch(
        '${Platform.isAndroid ? 'android' : 'ios'}amap://navi');
  }

  /// 判断地图是否有安装
  static Future<bool> isMapInstall(String url) async {
    return await canLaunch(url);
  }
}
