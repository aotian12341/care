import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';

import 'colors.dart';

class PluginUtils {
  String channelName = "com.greenorange.carer";
  late MethodChannel _channel;

  ///
  factory PluginUtils() => _getInstance();

  ///
  static PluginUtils get instance => _getInstance();

  // 静态私有成员，没有初始化
  static PluginUtils? _instance;

  // 私有构造函数
  PluginUtils._internal() {
    _channel = MethodChannel(channelName);
  }

  // 静态、同步、私有访问点
  static PluginUtils _getInstance() {
    _instance ??= PluginUtils._internal();
    return _instance!;
  }

  ///
  Future<String?> aesDecode(String content) async {
    try {
      final res = await _channel.invokeMethod<String>("aesDecode", content);
      return res;
    } catch (e) {
      print("加密失败");
    }
    return null;
  }

  /// 获取实人认证
  Future<String?> getMetaInfo() async {
    try {
      final res = await _channel.invokeMethod<dynamic>("metaInfo");
      return res;
    } catch (e) {
      print("getMetaInfo:$e");
    }
    return null;
  }

  Future<dynamic> ocr(
      {required String certifyId, bool isVertical = true, Color? color}) async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.camera,
      Permission.storage,
      Permission.phone
    ].request();

    if (statuses[Permission.camera] == PermissionStatus.granted &&
        statuses[Permission.storage] == PermissionStatus.granted &&
        statuses[Permission.phone] == PermissionStatus.granted) {
      color ??= DSColors.primaryColor;
      try {
        final colorStr = color.value.toRadixString(16);
        final res = await _channel.invokeMethod<dynamic>("ocr", {
          "certifyId": certifyId,
          "isVertical": isVertical,
          "color": colorStr
        });
        print(res);

        if (!(res["result"] as bool)) {
          String msg = "";
          switch (res["reason"].toString()) {
            case "Z1000":
              msg = "其他异常。";
              break;
            case "Z1001":
              msg = "人脸识别算法初始化失败。";
              break;
            case "Z1003":
              msg = "不支持的CPU架构。";
              break;
            case "Z1004":
              msg = "Android系统版本过低。";
              break;
            case "Z1005":
              msg = "刷脸超时(单次)。";
              break;
            case "Z1006":
              msg = "多次刷脸超时。";
              break;
            case "Z1018":
              msg = "无前置摄像头。";
              break;
            case "Z1019":
              msg = "摄像头权限未赋予。";
              break;
            case "Z1020":
              msg = "打开摄像头失败。";
              break;
            case "Z1024":
              msg = "SDK认证流程正在进行中，请等待本地认证流程完成后再发起新调用。";
              break;
            case "Z5112":
              msg = "上传炫彩Meta信息失败。";
              break;
            case "Z5113":
              msg = "上传炫彩视频失败。";
              break;
            case "Z5114":
              msg = "认证视频上传失败";
              break;
            case "Z6001":
              msg = "OCR识别次数超限";
              break;
            case "Z6002":
              msg = "OCR图片上传网络超时";
              break;
            case "Z6003":
              msg = "OSS Token过期";
              break;
            case "Z6004":
              msg = "人脸照片处理失败";
              break;
            case "Z1008":
              msg = "用户主动退出认证。";
              break;
            case "Z1011":
              msg = "客户端初始化网络错误。";
              break;
            case "Z1012":
              msg = "客户端网络访问异常";
              break;
            case "Z1025":
              msg = "客户端初始化接口返回网络错误。";
              break;
            case "Z1026":
              msg = "信息上传网络错误。";
              break;
            case "Z1027":
              msg = "服务端认证接口网络错误。";
              break;
            case "Z5128":
              msg = "刷脸失败，认证未通过。可通过服务端查询接口获取认证未通过具体原因。";
              break;
          }
          res["msg"] = msg;
        }

        return res;
      } catch (e) {
        print("ocr:$e");
      }
    }
  }
}
