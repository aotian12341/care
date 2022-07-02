import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../common/colors.dart';

///
// ignore: must_be_immutable
class MRadio extends StatefulWidget {
  ///
  MRadio({
    Key? key,
    required this.data,
    this.value,
    this.onChange,
    this.icon,
    this.checkIcon,
    this.spacing = 30,
  }) : super(key: key);

  /// 数据，key，value键值对
  final List<Map<String, dynamic>> data;

  ///
  final Function(int index, dynamic key)? onChange;

  ///
  final Widget? icon;

  ///
  final Widget? checkIcon;

  /// 间距
  final double spacing;

  /// 值
  String? value;

  @override
  _MRadioState createState() => _MRadioState();
}

class _MRadioState extends State<MRadio> {
  final index = 99.obs;

  @override
  void initState() {
    super.initState();

    if (widget.value != null) {
      final list = widget.data;
      for (int i = 0; i < list.length; i++) {
        final temp = list[i];
        if (temp["key"].toString() == widget.value.toString()) {
          index(i);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final list = <Widget>[];
    final data = widget.data;
    for (int i = 0; i < data.length; i++) {
      final temp = data[i];
      list.add(InkWell(
        onTap: () {
          index(i);
          widget.value = temp["key"].toString();
          if (widget.onChange != null) {
            widget.onChange!(i, temp["key"]);
          }
        },
        child: Obx(() {
          return Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              index.value != i
                  ? Icon(
                      Icons.radio_button_unchecked,
                      size: 20,
                      color: DSColors.subTitle,
                    )
                  : Icon(
                      Icons.check_circle,
                      size: 20,
                      color: DSColors.primaryColor,
                    ),
              const SizedBox(width: 6),
              Text(
                temp["value"].toString(),
                style: TextStyle(color: DSColors.title, fontSize: 13),
              )
            ],
          );
        }),
      ));
    }
    return Wrap(
      spacing: widget.spacing,
      children: list,
    );
  }
}
