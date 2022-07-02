import 'package:flutter/material.dart';
import '../common/colors.dart';

///评分
class Rate extends StatefulWidget {
  ///评分
  Rate({
    Key? key,
    this.max = 5,
    this.rate = 0,
    this.selectedImage,
    this.unSelectedImage,
    this.disable = true,
    this.readOnly = false,
    this.allowHalf = false,
    this.size = 20,
    this.spacing = 12,
    this.selectedColor,
    this.unSelectedColor,
    this.disableColor,
    this.onChange,
  })  : assert(rate <= max),
        super(key: key);

  ///最大数量
  final int max;

  /// 分数
  double rate;

  ///选中图标
  final Widget? selectedImage;

  ///未选中图标
  final Widget? unSelectedImage;

  ///禁用
  final bool disable;

  ///只读
  final bool readOnly;

  ///是否半星
  final bool allowHalf;

  ///间距
  final double spacing;

  ///大小
  final double size;

  ///选中颜色
  final Color? selectedColor;

  ///未选颜色
  final Color? unSelectedColor;

  ///禁用颜色
  final Color? disableColor;

  ///监听分数改变
  final Function(double?)? onChange;

  @override
  _RateState createState() => _RateState();
}

class _RateState extends State<Rate> {
  double totalLength = 0;

  @override
  Widget build(BuildContext context) {
    totalLength = widget.size * widget.max + widget.spacing * (widget.max - 1);
    return GestureDetector(
      // onHorizontalDragUpdate: _startDrag,
      child: Stack(
        children: [
          Row(
            children: getUnselectImage(),
          ),
          Row(
            children: getSelectImage(),
          )
        ],
      ),
    );
  }

  List<Widget> getUnselectImage() {
    final Widget unSelectImage = widget.unSelectedImage ??
        Icon(
          Icons.star_border,
          size: widget.size,
          color: widget.disable
              ? widget.unSelectedColor
              : widget.disableColor ?? DSColors.describe,
        );
    final List<Widget> unSelectList = [];
    for (var index = 0; index < widget.max; index++) {
      unSelectList.add(GestureDetector(
        onTapDown: (pos) {
          changeRate(index, pos.localPosition);
        },
        child: Row(
          children: [unSelectImage],
        ),
      ));
    }
    return unSelectList;
  }

  List<Widget> getSelectImage() {
    int solidCount = widget.rate.floor();
    double surplusCount = widget.rate - solidCount;

    final Widget selectedImage = widget.selectedImage ??
        Icon(
          Icons.star,
          size: widget.size,
          color: widget.disable
              ? widget.selectedColor
              : widget.selectedColor!.withOpacity(0.5),
        );

    final List<Widget> selectedList = [];
    for (int i = 0; i < solidCount; i++) {
      selectedList.add(GestureDetector(
        onTapDown: (pos) {
          changeRate(i, pos.localPosition);
        },
        child: Row(
          children: [selectedImage],
        ),
      ));
    }

    if (surplusCount > 0) {
      final Widget surplusStar = GestureDetector(
        onTap: () {},
        onTapDown: (pos) {
          changeRate(widget.rate.floor(), pos.localPosition);
        },
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          ClipRect(
            clipper: MyRectClipper(width: surplusCount * widget.size),
            child: Row(
              children: [selectedImage],
            ),
          )
        ]),
      );

      selectedList.add(surplusStar);
    }
    return selectedList;
  }

  void changeRate(int index, Offset loc) {
    if (!widget.disable || widget.readOnly) {
      return;
    }
    double count = 1;
    if (widget.allowHalf) {
      if (loc.dx < widget.size / 2) {
        count = 0.5;
      } else {
        count = 1;
      }
    }
    widget.rate = double.parse((index + count).toString());
    if (widget.onChange != null) {
      widget.onChange!(widget.rate);
    }
    setState(() {});
  }

  void _startDrag(DragUpdateDetails pos) {
    if (!widget.disable || widget.readOnly) {
      return;
    }
    if (pos.localPosition.dx > totalLength) {
      return;
    }
    widget.rate = pos.localPosition.dx / totalLength * widget.max;
    if (widget.allowHalf) {
      widget.rate = widget.rate.floor() +
          ((widget.rate - widget.rate.floor() > 0.5) ? 1 : 0.5);
    } else {
      widget.rate = widget.rate.floor() + 1;
    }
    if (widget.onChange != null) {
      widget.onChange!(widget.rate);
    }
    setState(() {});
  }
}

///裁剪
class MyRectClipper extends CustomClipper<Rect> {
  ///
  final double width;

  ///裁剪
  MyRectClipper({this.width = 0});

  @override
  Rect getClip(Size size) {
    return Rect.fromLTRB(0, 0, width, size.height);
  }

  @override
  bool shouldReclip(MyRectClipper oldClipper) {
    return width != oldClipper.width;
  }
}
