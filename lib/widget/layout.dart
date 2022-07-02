import 'package:flutter/material.dart';

///
class Layout {
  /// 子组件
  Widget? _widget;

  /// 子组件数组
  List<Widget>? _widgets;

  /// 行组件
  bool _isRow = false;

  /// 列组件
  bool _isColumn = false;

  /// 帧布局
  bool _isStack = false;

  /// 主轴大小
  MainAxisSize _mainAxisSize = MainAxisSize.max;

  ///
  TextDirection? _textDirection;

  ///
  VerticalDirection? _verticalDirection;

  /// 帧布局对齐方式
  Alignment? _alignment;

  // ///
  // TextBaseline? _textBaseline;

  /// 主轴对齐
  MainAxisAlignment? _mainAxisAlignment;

  /// 交叉轴对齐
  CrossAxisAlignment? _crossAxisAlignment;

  /// 内边距
  EdgeInsets? _padding;

  /// 外边距
  EdgeInsets? _margin;

  /// 边框
  BoxBorder? _boxBorder;

  /// 圆角
  BorderRadiusGeometry? _borderRadius;

  /// 颜色
  Color? _color;

  /// 宽
  double? _width;

  /// 高
  double? _height;

  /// 最小宽
  double? _minWidth;

  /// 最小高
  double? _minHeight;

  /// 最大宽
  double? _maxWidth;

  /// 最大高
  double? _maxHeight;

  /// 裁剪圆角
  BorderRadius? _clipRadius;

  /// 单机
  VoidCallback? _tap;

  /// 长按
  VoidCallback? _longPress;

  /// 双击
  VoidCallback? _doubleTap;

  /// 定位布局的左上右下
  double? pLeft, pTop, pRight, pBottom;

  /// 透明度
  double? _opacity;

  /// 是否显示 true为不显示
  bool? _offstage;

  /// 是否居中
  bool? _center;

  /// 基准线类型
  TextBaseline? _textBaseline;

  /// 基准线数值
  double? _baseLine;

  /// 填充布局 大
  int? _expanded;

  /// 填充布局 小
  int? _flexible;

  ///
  Layout();

  Layout.row() {
    _isRow = true;
  }

  Layout.column() {
    _isColumn = true;
  }

  Layout child(Widget widget) {
    _widget = widget;
    return this;
  }

  Layout children(List<Widget>? widgets) {
    _widgets = widgets;
    return this;
  }

  Layout.stack({List<Widget>? widgets}) {
    _widgets = widgets;
    _isStack = true;
  }

  Layout alignment(Alignment alignment) {
    _alignment = alignment;
    return this;
  }

  Layout mainAlign(MainAxisAlignment mainAxisAlignment) {
    _mainAxisAlignment = mainAxisAlignment;
    return this;
  }

  Layout crossAlign(CrossAxisAlignment crossAxisAlignment) {
    _crossAxisAlignment = crossAxisAlignment;
    return this;
  }

  Layout mainSize(MainAxisSize? mainAxisSize) {
    _mainAxisSize = mainAxisSize ?? MainAxisSize.max;
    return this;
  }

  Layout textDirection(TextDirection textDirection) {
    _textDirection = textDirection;
    return this;
  }

  Layout verticalDirection(VerticalDirection verticalDirection) {
    _verticalDirection = verticalDirection;
    return this;
  }

  /// 内边距
  Layout padding(
      {double left = 0, double right = 0, double top = 0, double bottom = 0}) {
    _padding =
        EdgeInsets.only(left: left, right: right, top: top, bottom: bottom);
    return this;
  }

  /// 内边距
  Layout paddingAll(double? padding) {
    _padding = EdgeInsets.all(padding ?? 0);
    return this;
  }

  /// 内边距
  Layout paddingSymmetric({double horizontal = 0, double vertical = 0}) {
    _padding = EdgeInsets.symmetric(horizontal: horizontal, vertical: vertical);
    return this;
  }

  /// 外边距
  Layout margin(
      {double left = 0, double right = 0, double top = 0, double bottom = 0}) {
    _margin =
        EdgeInsets.only(left: left, right: right, top: top, bottom: bottom);
    return this;
  }

  /// 外边距
  Layout marginAll(double? padding) {
    _margin = EdgeInsets.all(padding ?? 0);
    return this;
  }

  /// 外边距
  Layout marginSymmetric({double horizontal = 0, double vertical = 0}) {
    _margin = EdgeInsets.symmetric(horizontal: horizontal, vertical: vertical);
    return this;
  }

  /// 边框
  Layout borderAll({Color? color, double? width}) {
    _boxBorder = Border.all(color: color ?? Colors.black, width: width ?? 1);
    return this;
  }

  /// 边框
  Layout borderOnly({
    BorderSide top = BorderSide.none,
    BorderSide bottom = BorderSide.none,
    BorderSide left = BorderSide.none,
    BorderSide right = BorderSide.none,
  }) {
    _boxBorder = Border(top: top, left: left, right: right, bottom: bottom);
    return this;
  }

  /// 圆角
  Layout borderRadiusAll(double radius) {
    _borderRadius = BorderRadius.circular(radius);
    return this;
  }

  /// 圆角
  Layout borderRadiusOnly({
    double topLeft = 0,
    double topRight = 0,
    double bottomLeft = 0,
    double bottomRight = 0,
  }) {
    _borderRadius = BorderRadius.only(
      topLeft: Radius.circular(topLeft),
      topRight: Radius.circular(topRight),
      bottomLeft: Radius.circular(bottomLeft),
      bottomRight: Radius.circular(bottomRight),
    );
    return this;
  }

  /// 颜色
  Layout color(Color color) {
    _color = color;
    return this;
  }

  /// 宽
  Layout width(double width) {
    _width = width;
    return this;
  }

  /// 高
  Layout height(double height) {
    _height = height;
    return this;
  }

  /// 最大宽
  Layout maxWidth(double maxWidth) {
    _maxWidth = maxWidth;
    return this;
  }

  /// 最大高
  Layout maxHeight(double maxHeight) {
    _maxHeight = maxHeight;
    return this;
  }

  /// 最小宽
  Layout minWidth(double minWidth) {
    _minWidth = minWidth;
    return this;
  }

  /// 最小高
  Layout minHeight(double minHeight) {
    _minHeight = minHeight;
    return this;
  }

  /// 裁剪圆角
  Layout clipRRectAll(double radius) {
    _clipRadius = BorderRadius.circular(radius);
    return this;
  }

  /// 裁剪圆角
  Layout clipRRectOnly(
      {double topLeft = 0,
      double topRight = 0,
      double bottomLeft = 0,
      double bottomRight = 0}) {
    _clipRadius = BorderRadius.only(
        topLeft: Radius.circular(topLeft),
        topRight: Radius.circular(topRight),
        bottomLeft: Radius.circular(bottomLeft),
        bottomRight: Radius.circular(bottomRight));
    return this;
  }

  /// 基准线
  Layout baseLine(
      {required double baseLine, required TextBaseline textBaseline}) {
    _baseLine = baseLine;
    _textBaseline = textBaseline;
    return this;
  }

  /// 填充布局
  Layout expanded({int expanded = 1}) {
    _expanded = expanded;
    return this;
  }

  /// 填充布局
  Layout flexible({int flexible = 1}) {
    _flexible = flexible;
    return this;
  }

  /// 居中
  Layout center() {
    _center = true;
    return this;
  }

  /// 是否显示 true 为不显示
  Layout offstage(bool offstage) {
    _offstage = offstage;
    return this;
  }

  /// 单击
  Layout tap(VoidCallback tap) {
    _tap = tap;
    return this;
  }

  /// 双击
  Layout doubleTap(VoidCallback doubleTap) {
    _doubleTap = doubleTap;
    return this;
  }

  /// 长按
  Layout longPress(VoidCallback longPress) {
    _longPress = longPress;
    return this;
  }

  /// 定位
  Layout positioned(
      {double? left, double? right, double? top, double? bottom}) {
    pLeft = left;
    pTop = top;
    pRight = right;
    pBottom = bottom;
    return this;
  }

  /// 透明度，0透明，1不透明
  Layout opacity(double opacity) {
    _opacity = opacity;
    return this;
  }

  /// 构建
  Widget build() {
    BoxDecoration? decoration;
    if (_color != null || _boxBorder != null || _borderRadius != null) {
      decoration = BoxDecoration(
        color: _color,
        border: _boxBorder,
        borderRadius: _borderRadius,
      );
    }
    BoxConstraints? constraints;
    if (_minHeight != null ||
        _maxHeight != null ||
        _minWidth != null ||
        _maxWidth != null) {
      constraints = BoxConstraints(
          minHeight: _minHeight ?? 0,
          maxHeight: _maxHeight ?? double.infinity,
          minWidth: _minWidth ?? 0,
          maxWidth: _maxWidth ?? double.infinity);
    }

    Widget? content;
    if (_isRow) {
      content = Row(
        mainAxisAlignment: _mainAxisAlignment ?? MainAxisAlignment.start,
        crossAxisAlignment: _crossAxisAlignment ?? CrossAxisAlignment.start,
        verticalDirection: _verticalDirection ?? VerticalDirection.down,
        mainAxisSize: _mainAxisSize,
        textDirection: _textDirection,
        textBaseline: _textBaseline,
        children: _widgets!,
      );
    } else if (_isColumn) {
      content = Column(
        mainAxisAlignment: _mainAxisAlignment ?? MainAxisAlignment.start,
        crossAxisAlignment: _crossAxisAlignment ?? CrossAxisAlignment.start,
        verticalDirection: _verticalDirection ?? VerticalDirection.down,
        mainAxisSize: _mainAxisSize,
        textDirection: _textDirection,
        textBaseline: _textBaseline,
        children: _widgets!,
      );
    } else if (_isStack) {
      content = Stack(
        alignment: _alignment ?? Alignment.center,
        children: _widgets!,
      );
    } else {
      content = _widget;
    }

    Widget res = InkWell(
      onTap: _tap,
      onLongPress: _longPress,
      onDoubleTap: _doubleTap,
      child: Container(
        padding: _padding,
        margin: _margin,
        decoration: decoration,
        constraints: constraints,
        width: _width,
        height: _height,
        child: _center == null
            ? content
            : Center(
                child: content,
              ),
      ),
    );
    if (_baseLine != null && _textBaseline != null) {
      res = Baseline(
        baseline: _baseLine!,
        baselineType: _textBaseline!,
        child: res,
      );
    }
    if (_clipRadius != null) {
      res = ClipRRect(
        borderRadius: _clipRadius,
        child: res,
      );
    }
    if (_opacity != null) {
      res = Opacity(
        opacity: _opacity!,
        child: res,
      );
    }
    if (_offstage != null) {
      res = Offstage(
        offstage: _offstage!,
        child: res,
      );
    }
    if (pLeft != null || pRight != null || pTop != null || pBottom != null) {
      res = Positioned(
          left: pLeft, top: pTop, right: pRight, bottom: pBottom, child: res);
    }
    if (_expanded != null) {
      res = Expanded(
        child: res,
        flex: _expanded!,
      );
    }
    if (_flexible != null) {
      res = Flexible(
        child: res,
        flex: _flexible!,
      );
    }
    return res;
  }
}

///
class MText {
  /// 文字
  late String text;

  Color? _color;

  FontWeight? _weight;

  double? _size;

  TextBaseline? _textBaseline;

  Color? _backGroundColor;

  double? _lineHeight;

  int? _maxLine;

  TextOverflow? _overflow;

  ///
  MText(this.text);

  /// 颜色
  MText color(Color color) {
    _color = color;
    return this;
  }

  /// 粗细
  MText weight(int weight) {
    _weight = FontWeight.values[weight ~/ 100];
    return this;
  }

  /// 粗体
  MText bold() {
    _weight = FontWeight.bold;
    return this;
  }

  /// 文字大小
  MText size(double size) {
    _size = size;
    return this;
  }

  /// 基准线
  MText textBaseline(TextBaseline textBaseline) {
    _textBaseline = textBaseline;
    return this;
  }

  /// 背景颜色
  MText backGroundColor(Color color) {
    _backGroundColor = color;
    return this;
  }

  /// 行高
  MText lineHeight(double lineHeight) {
    _lineHeight = lineHeight;
    return this;
  }

  /// 最大行
  MText maxLine(int maxLine) {
    _maxLine = maxLine;
    return this;
  }

  /// 溢出
  MText overflow(TextOverflow overflow) {
    _overflow = overflow;
    return this;
  }

  /// 构建
  Widget build() {
    final style = TextStyle(
        color: _color,
        fontSize: _size,
        fontWeight: _weight,
        height: _lineHeight,
        backgroundColor: _backGroundColor,
        textBaseline: _textBaseline);
    return Text(
      text,
      style: style,
      maxLines: _maxLine,
      overflow: _overflow,
    );
  }
}
