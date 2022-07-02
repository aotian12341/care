import 'package:care/widget/key_input_view.dart';
import 'package:care/widget/main_button.dart';
import 'package:care/widget/page_widget.dart';
import 'package:flutter/material.dart';
import 'package:care/widget/view_ex.dart';
import 'package:get/get.dart';

import '../../../common/colors.dart';

/// 充值
class Recharge extends StatefulWidget {
  const Recharge({Key? key}) : super(key: key);

  @override
  _RechargeState createState() => _RechargeState();
}

class _RechargeState extends State<Recharge> {
  final money = TextEditingController();

  final payment = 0.obs;
  @override
  Widget build(BuildContext context) {
    return PageWidget(
        titleLabel: "充值",
        isCustom: "short",
        body: Column(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                "充值金额".t.s(16).c(DSColors.primaryColor),
                30.v,
                KeyInputView(
                  title: "￥",
                  titleWidth: 40,
                  controller: money,
                  hint: "请输入充值金额，单位：元",
                  inputType: TextInputType.number,
                  showBorder: true,
                ),
                38.v,
                "请选择充值方式".t.s(14).c(DSColors.title),
                20.v,
                Obx(() {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.radio_button_checked,
                            size: 20,
                            color: DSColors.primaryColor,
                          ).or(
                              widget: Icon(
                                Icons.radio_button_unchecked,
                                size: 20,
                                color: DSColors.describe,
                              ),
                              condition: payment.value == 0),
                          4.h,
                          Image.asset(
                            "assets/images/icon_ali.png",
                            width: 36,
                            height: 36,
                          ),
                          4.h,
                          "支付宝".t.s(14).c(DSColors.title),
                        ],
                      ).onTap(() {
                        payment(0);
                      }),
                      Row(
                        children: [
                          Icon(
                            Icons.radio_button_checked,
                            size: 20,
                            color: DSColors.primaryColor,
                          ).or(
                              widget: Icon(
                                Icons.radio_button_unchecked,
                                size: 20,
                                color: DSColors.describe,
                              ),
                              condition: payment.value == 1),
                          4.h,
                          Image.asset(
                            "assets/images/icon_wx.png",
                            width: 36,
                            height: 36,
                          ),
                          4.h,
                          "微信".t.s(14).c(DSColors.title),
                        ],
                      ).onTap(() {
                        payment(1);
                      }),
                    ],
                  );
                })
              ],
            )
                .padding(padding: const EdgeInsets.all(30))
                .borderRadius(radius: 12)
                .color(DSColors.white),
            24.v,
            MainButton(
              width: 140,
              title: "确定",
              onTap: () {},
            )
          ],
        ).margin(margin: const EdgeInsets.all(12)));
  }
}
