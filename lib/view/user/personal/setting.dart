import 'package:care/widget/page_widget.dart';
import 'package:care/widget/view_ex.dart';
import 'package:flutter/material.dart';

import '../../../common/colors.dart';
import '../../../widget/key_value_view.dart';

/// 设置
class Setting extends StatefulWidget {
  const Setting({Key? key}) : super(key: key);

  @override
  _SettingState createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  @override
  Widget build(BuildContext context) {
    return PageWidget(
        titleLabel: "设置",
        isCustom: "short",
        body: SingleChildScrollView(
          child: Column(
            children: [
              Column(
                children: [
                  KeyValueView(
                    height: 66,
                    title: "清理缓存",
                    value: "100M",
                    valueLeft: false,
                    showBorder: true,
                    showIcon: true,
                  ),
                  KeyValueView(
                    title: "昵称",
                    showBorder: true,
                    showIcon: true,
                  ),
                  KeyValueView(
                    title: "推送设置",
                    valueLeft: false,
                    showBorder: true,
                  ),
                  KeyValueView(
                    title: "语言设置",
                    valueLeft: false,
                    showBorder: true,
                  ),
                ],
              )
                  .padding(padding: const EdgeInsets.symmetric(horizontal: 15))
                  .color(DSColors.white)
                  .borderRadius(radius: 12),
              12.v,
              Column(
                children: [
                  KeyValueView(
                    height: 66,
                    title: "版本更新",
                    value: "1.0.0",
                    valueLeft: false,
                    showBorder: true,
                    showIcon: true,
                  ),
                  KeyValueView(
                    title: "关于我们",
                    valueLeft: false,
                    showBorder: true,
                  ),
                ],
              )
                  .padding(padding: const EdgeInsets.symmetric(horizontal: 15))
                  .color(DSColors.white)
                  .borderRadius(radius: 12),
              12.v,
              KeyValueView(
                height: 66,
                title: "",
                titleWidth: 0,
                valueView: Center(
                  child: Text(
                    "注销账户",
                    style:
                        TextStyle(color: DSColors.primaryColor, fontSize: 16),
                  ),
                ),
                titleColor: DSColors.primaryColor,
                showBorder: false,
              )
                  .color(DSColors.white)
                  .padding(padding: const EdgeInsets.symmetric(horizontal: 12))
                  .borderRadius(radius: 12)
            ],
          ).margin(
              margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 12)),
        ));
  }
}
