import 'package:care/model/form_info.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:care/widget/view_ex.dart';

import '../../../common/colors.dart';

class DemandMultiple extends StatelessWidget {
  DemandMultiple({Key? key, required this.item}) : super(key: key);

  final FormItem item;

  final indexList = <int>[].obs;

  final codeList = <String>[];

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
    indexList.add(0);
    codeList.add(item.list![0].code ?? "");
    item.value = item.list![0].code ?? "";

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
                      .c(indexList.contains(index)
                          ? DSColors.white
                          : DSColors.primaryColor)
                      .center()
                      .size(height: 45, width: cellWidth)
                      .borderRadius(radius: 5)
                      .color(indexList.contains(index)
                          ? DSColors.primaryColor
                          : DSColors.white)
                      .border(
                          color: indexList.contains(index)
                              ? DSColors.white
                              : DSColors.primaryColor)
                      .onTap(() {
                    if (indexList.contains(index)) {
                      indexList.remove(index);
                      codeList.remove(temp.code);
                    } else {
                      indexList.add(index);
                      codeList.add(temp.code ?? "");
                    }

                    String codes = "";
                    for (final code in codeList) {
                      codes += code.toString() + ",";
                    }
                    codes = codes.isNotEmpty
                        ? codes.substring(0, codes.length - 1)
                        : codes;
                    item.value = codes;
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
