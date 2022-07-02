import 'package:flutter/foundation.dart';
import 'package:fluwx/fluwx.dart' as fluwx;
// import 'package:military_training/model/income/pay_info.dart';
import 'package:tobias/tobias.dart' as tobias;

import '../model/pay_info.dart';
import '../widget/m_toast.dart';

class PayController {
  ///
  factory PayController() => _getInstance();

  ///
  static PayController get instance => _getInstance();

  // 静态私有成员，没有初始化
  static PayController? _instance;

  // 私有构造函数
  PayController._internal() {
    fluwx.registerWxApi(
        appId: "wxca1a7e8bf2a0b7bf", //"wx00576fe3e302467a",
        doOnAndroid: true,
        doOnIOS: true,
        universalLink:
            "https://trainoss.vicpalm.com/.well-known/apple-app-site-association");
  }

  // 静态、同步、私有访问点
  static PayController _getInstance() {
    _instance ??= PayController._internal();
    return _instance!;
  }

  /// 初始化
  Future<void> init() async {}

  /// 销毁
  void dispose() {
    _instance = null;
  }

  /// payment=0,微信，1支付宝
  Future<bool> pay({
    required int payment,
    required PayInfo info,
    Function? success,
  }) async {
    if (payment == 1 && info.appId != null) {
      fluwx.weChatResponseEventHandler.listen((event) async {
        if (event.errCode == 0 && success != null) {
          success(true);
        } else {
          debugPrint(event.toString());
          MToast.show("支付失败");
        }
      });

      final result = await fluwx.payWithWeChat(
        appId: info.appId!,
        partnerId: info.mchId!,
        prepayId: info.prepayId ?? "",
        packageValue: info.signType!,
        nonceStr: info.nonceStr!,
        timeStamp: info.timestamp!,
        sign: info.sign!,
      );
      // final result = await fluwx.payWithWeChat(
      //   appId: "wxca1a7e8bf2a0b7bf",
      //   partnerId: "1625438679",
      //   prepayId: "wx30153434783711dd09d9b6f921cd050000",
      //   packageValue: info.signType!,
      //   nonceStr: "a858765fe265548f59b6783141cd4efe",
      //   timeStamp: 1656574474,
      //   sign:
      //       "buU9mtEJ05YiBxjv+1dwRjQFcXUf3P7wIQpeRaUZcnFlhrXxqzpmToF/MU6zh9hTWYyfwIcc1sBBYM3afuaWWoxWtQGttTzoriQ7rGFe4FBBKsfOpXQYSBo+pYow2/GqBohN005MQaDCOYyhhxpAhg0qYBg7UbXgTXIng1jpIpVsf6BPOC5RgwWndlvinqPbvoPkyq8PfQW6prHhZSTfu5OpszE37IMW9JRFQKSVc+8N3O3tkB9LIxh33mNiIiXQklP1P170hmgQ8mNBrJ0vsn5qtAwXd1ZGdkWXWtXLVdpdKAuPb/qJGxZmSqdzwRJE77XFMN/Th4l1+H5DnSQS4w==",
      // );
      print(result);

      return result;
    }
    // else if (payment == 0 && info.params?.channelAlipayApp != null) {
    //   //检测是否安装支付宝
    //   var result = await tobias.isAliPayInstalled();
    //   if (result) {
    //     var payResult = await tobias.aliPay(info.params!.channelAlipayApp!);
    //
    //     if (payResult['result'] != null) {
    //       if (payResult['resultStatus'] == '9000') {
    //         MToast.show("支付宝支付成功");
    //         if (success != null) {
    //           success(true);
    //         }
    //       } else if (payResult['resultStatus'] == '6001') {
    //         MToast.show("支付宝支付失败");
    //       } else {
    //         MToast.show("未知错误");
    //       }
    //     }
    //   } else {
    //     MToast.show("未安装支付宝");
    //   }
    // }
    return false;
  }
}
