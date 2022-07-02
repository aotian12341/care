import 'package:care/model/form_info.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:care/widget/view_ex.dart';

import '../../../common/colors.dart';
import '../../../widget/calendar.dart';
import '../../../widget/key_value_view.dart';
import '../../../widget/m_radio.dart';

class DemandServiceDate extends StatelessWidget {
  DemandServiceDate({Key? key, required this.item}) : super(key: key);

  final FormItem item;

  final isSingle = true.obs;

  final selectIndex = 0.obs;

  @override
  Widget build(BuildContext context) {
    if ((item.list ?? []).isEmpty) {
      return Container();
    }

    final list = <Map<String, dynamic>>[];

    for (final temp in item.list!) {
      list.add({"key": temp.code, "value": temp.name});
    }

    item.value1 = item.list![selectIndex.value].code;
    isSingle(item.list![selectIndex.value].code == "105241");
    final temp = MRadio(
      data: list,
      value: item.list![selectIndex.value].code,
      onChange: (int index, dynamic key) {
        item.value1 = key.toString();
        isSingle(key.toString() == "105241");
      },
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        KeyValueView(
          title: item.title1 ?? "",
          titleSize: 16,
          valueView: temp,
          valueLeft: false,
        ),
        Obx(() {
          return Calendar(
              isSingle: isSingle.value,
              onChoose: (date) {
                item.value2 = date;
              });
        })
      ],
    );
  }
}
