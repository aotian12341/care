import 'package:care/model/form_info.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:care/widget/view_ex.dart';

import '../../../common/colors.dart';
import '../../../widget/key_value_view.dart';
import '../../../widget/m_radio.dart';

class DemandRadio extends StatelessWidget {
  DemandRadio({Key? key, required this.item}) : super(key: key);

  final FormItem item;
  final selectIndex = 0.obs;

  @override
  Widget build(BuildContext context) {
    final count = (item.list ?? []).length;
    if (count == 0) {
      return Container();
    }

    double spacing = 12;
    double cellWidth =
        (MediaQuery.of(context).size.width - 16 * 2 - spacing * 4) / 4;
    if (count == 2) {
      spacing =
          ((MediaQuery.of(context).size.width - 16 * 2) - cellWidth * 2) / 3;
    } else if (count == 3) {
      spacing =
          ((MediaQuery.of(context).size.width - 16 * 2) - cellWidth * 3) / 4;
    }

    item.value = item.list![0].code ?? "";
    item.selectIndex = 0;

    return Obx(() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          16.v,
          Row(
            children: [(item.title ?? "").t.s(16).c(DSColors.title)],
          ).paddingOnly(left: 16),
          16.v,
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Wrap(
                spacing: spacing,
                runSpacing: 8,
                children: (item.list ?? []).asMap().keys.map((index) {
                  final temp = item.list![index];
                  return (temp.name ?? "")
                      .t
                      .s(14)
                      .c(selectIndex.value == index
                          ? DSColors.white
                          : DSColors.primaryColor)
                      .center()
                      .size(height: 45, width: cellWidth)
                      .borderRadius(radius: 5)
                      .color(selectIndex.value == index
                          ? DSColors.primaryColor
                          : DSColors.white)
                      .border(
                          color: selectIndex.value == index
                              ? DSColors.white
                              : DSColors.primaryColor)
                      .onTap(() {
                    selectIndex(index);
                    item.value = temp.code;
                  });
                }).toList(),
              ).flexible()
            ],
          ),
        ],
      );
    });
  }
}
