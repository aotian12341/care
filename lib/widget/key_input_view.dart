import 'package:flutter/material.dart';

import '../common/colors.dart';
import 'key_value_view.dart';

///
class KeyInputView extends StatelessWidget {
  ///
  const KeyInputView({
    Key? key,
    required this.title,
    required this.controller,
    this.titleView,
    this.textAlign = TextAlign.start,
    this.hint,
    this.hintColor,
    this.hintSize,
    this.inputType,
    this.titleColor,
    this.titleSize,
    this.valueColor,
    this.valueSize,
    this.onChange,
    this.isPassword = false,
    this.titleWidth,
    this.showBorder = false,
    this.icon,
    this.showIcon = false,
    this.padding = 12,
    this.lines = 1,
  }) : super(key: key);

  /// 左标题
  final String title;

  /// 左组件
  final Widget? titleView;

  /// 标题宽
  final double? titleWidth;

  /// 文本框控制器
  final TextEditingController controller;

  /// 是否左对齐
  final TextAlign textAlign;

  /// 提示文字
  final String? hint;

  /// 提示文字大小
  final double? hintSize;

  /// 提示文字颜色
  final Color? hintColor;

  /// 输入类型
  final TextInputType? inputType;

  /// 标题颜色
  final Color? titleColor;

  /// 标题大小
  final double? titleSize;

  /// 文本框文字颜色
  final Color? valueColor;

  /// 文本框文字大小
  final double? valueSize;

  /// 边距
  final double padding;

  /// 是否密码
  final bool isPassword;

  /// 文字改变回调
  final Function(String)? onChange;

  /// icon
  final Widget? icon;

  /// 是否显示边框
  final bool showBorder;

  /// 是否显示图标
  final bool showIcon;

  /// 行数
  final int? lines;

  @override
  Widget build(BuildContext context) {
    return KeyValueView(
      title: title,
      titleView: titleView,
      showBorder: showBorder,
      padding: padding,
      showIcon: showIcon,
      titleSize: titleSize ?? 16,
      titleColor: titleColor ?? DSColors.title,
      titleWidth: titleWidth,
      valueView: TextField(
        obscureText: isPassword,
        controller: controller,
        textAlign: textAlign,
        keyboardType: inputType,
        maxLines: lines,
        style: TextStyle(color: valueColor ?? DSColors.title, fontSize: 16),
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hint,
          hintStyle: TextStyle(
              color: hintColor ?? DSColors.dc, fontSize: hintSize ?? 16),
        ),
        onChanged: onChange,
      ),
      icon: icon,
    );
  }
}
