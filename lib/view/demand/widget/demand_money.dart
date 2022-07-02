import 'package:care/model/form_info.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../common/colors.dart';
import '../../../widget/bottom_shell.dart';
import '../../../widget/key_input_view.dart';
import '../../../widget/m_toast.dart';

class DemandMoney extends StatelessWidget {
  DemandMoney({Key? key, required this.item}) : super(key: key);

  final FormItem item;

  final type = "".obs;

  @override
  Widget build(BuildContext context) {
    if ((item.list ?? []).isNotEmpty) {
      type(item.list![0].name);
      item.value2 = item.list![0].code;
    }

    return KeyInputView(
      title: item.title ?? "",
      valueSize: 18,
      valueColor: DSColors.primaryColor,
      hintSize: 18,
      controller: item.controller,
      showIcon: true,
      textAlign: TextAlign.end,
      hint: item.hint,
      icon: Obx(() {
        return InkWell(
          onTap: () {
            BottomShell.show(
                items: item.list!.asMap().keys.map((index) {
                  return BottomShellItem(title: item.list![index].name ?? "");
                }).toList(),
                onChoose: (index) {
                  type(item.list![index].name ?? "");
                  item.value2 = item.list![index].code;
                  Navigator.pop(context);
                });
          },
          child: Row(
            children: [
              Text(
                type.value,
                style: TextStyle(color: DSColors.title, fontSize: 14),
              ),
              Icon(
                Icons.keyboard_arrow_down,
                size: 15,
                color: DSColors.title,
              )
            ],
          ),
        );
      }),
      onChange: (value) {
        if (value.isNotEmpty) {
          try {
            final temp = double.parse(value.toString());
            item.value1 = value;
          } catch (e) {
            MToast.show("请输入正确的金额");
          }
        }
      },
    );
  }
}
