import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../common/colors.dart';

///
class CustomSliverDelegate extends SliverPersistentHeaderDelegate {
  ///
  final Widget child;

  ///
  final double minHeight;

  ///
  final double maxHeight;

  ///
  CustomSliverDelegate(
      {required this.child, required this.minHeight, required this.maxHeight});

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return child;
  }

  @override
  double get maxExtent => maxHeight;

  @override
  double get minExtent => minHeight;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}

///
class MerchantHeaderDelegate extends SliverPersistentHeaderDelegate {
  /// 最小高度
  final double minHeight;

  /// 最大高度
  final double maxHeight;

  /// 最小组件
  final Widget minWidget;

  /// 最大组件
  final Widget maxWidget;

  /// 高度变化回调
  final Function(double opacity, double offset)? changeBack;

  ///
  MerchantHeaderDelegate(
      {required this.minHeight,
      required this.maxHeight,
      required this.maxWidget,
      required this.minWidget,
      this.changeBack});

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    final double opacity =
        shrinkOffset / maxExtent >= 1 ? 1 : shrinkOffset / maxExtent;

    if (changeBack != null) {
      changeBack!(opacity, shrinkOffset);
    }

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value:
          opacity == 1 ? SystemUiOverlayStyle.dark : SystemUiOverlayStyle.light,
      child: Container(
        color: DSColors.white,
        height: maxExtent,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned(
                left: 0, right: 0, top: 0, height: maxExtent, child: maxWidget),
            Positioned(
                left: 0, right: 0, top: 0, height: minExtent, child: minWidget)
          ],
        ),
      ),
    );
  }

  @override
  double get maxExtent => maxHeight;

  @override
  double get minExtent => minHeight;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => true;
}
