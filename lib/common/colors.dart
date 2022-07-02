// ignore_for_file: public_member_api_docs

import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// 颜色常量
class DSColors {
  static final DSColors _singleton = DSColors._getInstance();

  ///
  factory DSColors() {
    return _singleton;
  }

  DSColors._getInstance();

  /// 黑
  static Color get black =>
      !Get.isDarkMode ? const Color(0xff000000) : const Color(0xffffffff);

  /// 白
  static Color get white =>
      !Get.isDarkMode ? const Color(0xffffffff) : const Color(0xff000000);

  /// 遮罩
  static Color get maskBg =>
      !Get.isDarkMode ? const Color(0x15000000) : const Color(0x15ffffff);

  /// 标题
  static Color get title =>
      !Get.isDarkMode ? const Color(0xff27292B) : const Color(0xffd8d6d4);

  /// 副标题
  static Color get subTitle =>
      !Get.isDarkMode ? const Color(0xff767676) : const Color(0xff676767);

  /// 描述
  static Color get describe =>
      !Get.isDarkMode ? const Color(0xffABB1B8) : const Color(0xff544e47);

  ///
  static Color get f2 =>
      !Get.isDarkMode ? const Color(0xfff2f2f2) : const Color(0xff0d0d0d);

  /// 背景
  static Color get f8 =>
      !Get.isDarkMode ? const Color(0xfff8f8f8) : const Color(0xff080808);

  ///
  static Color get ee =>
      !Get.isDarkMode ? const Color(0xffeeeeee) : const Color(0xff111111);

  ///
  static Color get color_80 =>
      !Get.isDarkMode ? const Color(0xff808080) : const Color(0xff7f7f7f);

  /// 分割线
  static Color get divider =>
      !Get.isDarkMode ? const Color(0xfff1f2f5) : const Color(0xff0e0d0a);

  ///
  static Color get dc =>
      !Get.isDarkMode ? const Color(0xffdcdcdc) : const Color(0xff232323);

  ///
  static Color get fc =>
      !Get.isDarkMode ? const Color(0xffdcdcdc) : const Color(0xfffcfcfc);

  static Color get color_6AC259 => const Color(0xff6AC259);

  /// 主题色
  static Color get primaryColor => Get.theme.primaryColor;

  static Color get pinkRed => const Color(0xffFD3A84);

  static Color get pinkYellow => const Color(0xffFFA68D);
}
