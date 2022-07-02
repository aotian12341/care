import 'package:flutter/material.dart';
import '../controller/user_controller.dart';

import '../controller/user_controller.dart';

/// 路由扩展
extension NavigatorEx on Navigator {
  /// 跳转路由
  Future<T?> pushRoute<T>(BuildContext context, Widget widget) async {
    return await Navigator.of(context)
        .push(MaterialPageRoute<T>(builder: (_) => widget));
  }

  Future<void> pushReplace(BuildContext context, Widget widget) async {
    Navigator.pushReplacement(context, MaterialPageRoute<void>(
      builder: (BuildContext context) {
        return widget;
      },
    ));
  }

  /// 跳转路由判断登陆
  static Future<T?> pushRouteCheck<T>(
      BuildContext context, Widget widget) async {
    if (!UserController.instance.isLogin) {
      // await _toLogin(context);
      if (!UserController.instance.isLogin) {
        Navigator.pop(context);
      }
    }

    return Navigator.of(context)
        .push(MaterialPageRoute<T>(builder: (_) => widget));
  }

  /// 跳转登陆
  // static Future<void> _toLogin(BuildContext context) {
  //   return Navigator.of(context)
  //       .push(MaterialPageRoute<dynamic>(builder: (_) => const Login()));
  // }
}
