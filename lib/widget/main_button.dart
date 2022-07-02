import 'package:flutter/material.dart';

import '../common/colors.dart';

/// App主要按钮
class MainButton extends StatelessWidget {
  ///
  const MainButton({
    Key? key,
    this.width = double.infinity,
    this.height = 44,
    this.padding,
    this.margin,
    this.radius,
    this.title,
    this.titleColor,
    this.titleSize = 15,
    this.child,
    this.onTap,
    this.enable = true,
    this.color,
    this.isOutline = false,
    this.outlineColor,
  }) : super(key: key);

  /// 圆角
  final double? radius;

  /// 边距
  final EdgeInsetsGeometry? padding;

  /// 外边距
  final EdgeInsetsGeometry? margin;

  /// 宽
  final double width;

  /// 高
  final double height;

  /// 标题
  final String? title;

  /// 标题颜色
  final Color? titleColor;

  /// 标题文字大小
  final double titleSize;

  /// 子组件
  final Widget? child;

  /// 是否可用
  final bool enable;

  /// 展示颜色
  final Color? color;

  /// 边框颜色
  final Color? outlineColor;

  /// 是否外边框
  final bool isOutline;

  /// 点击
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(radius ?? (height / 2)),
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
        if (enable && onTap != null) {
          onTap!();
        }
      },
      child: Container(
        width: width,
        height: height,
        padding: padding,
        margin: margin,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(radius ?? (height / 2)),
          gradient: color == null
              ? LinearGradient(
                  colors: [DSColors.pinkYellow, DSColors.pinkRed],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                )
              : null,
          color: color,
        ),
        child: child ??
            Center(
              child: Text(
                title ?? "",
                style: TextStyle(
                    color: titleColor ?? DSColors.white, fontSize: titleSize),
              ),
            ),
      ),
    );
  }
}

class MainText extends StatelessWidget {
  const MainText(this.text, {Key? key, this.size}) : super(key: key);

  final String text;
  final double? size;

  @override
  Widget build(BuildContext context) {
    final gradient = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [DSColors.pinkYellow, DSColors.pinkRed]);

    return Text(
      text,
      style: TextStyle(
          fontSize: size ?? 14,
          foreground: Paint()
            ..shader = gradient.createShader(Rect.fromLTWH(0, 0, 1080, 60))),
    );
  }
}
