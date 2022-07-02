import 'package:care/widget/view_ex.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../common/colors.dart';
import '../../../widget/key_input_view.dart';
import '../../../widget/main_button.dart';
import '../../../widget/page_widget.dart';

/// 提现
class Withdrawal extends StatefulWidget {
  const Withdrawal({Key? key}) : super(key: key);

  @override
  _WithdrawalState createState() => _WithdrawalState();
}

class _WithdrawalState extends State<Withdrawal> {
  final money = TextEditingController();

  final payment = 0.obs;
  @override
  Widget build(BuildContext context) {
    return PageWidget(
        titleLabel: "申请提现",
        isCustom: "short",
        body: Column(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                "提现金额".t.s(16).c(DSColors.primaryColor),
                30.v,
                KeyInputView(
                  title: "￥",
                  titleWidth: 40,
                  controller: money,
                  hint: "请输入提现金额，单位：元",
                  inputType: TextInputType.number,
                  showBorder: true,
                  showIcon: true,
                  icon: Row(
                    children: [
                      "余额:120.00".t.s(14).c(DSColors.title),
                      4.h,
                      "全部提现".t.s(14).c(DSColors.primaryColor).onTap(() {
                        money.text = "120";
                        setState(() {});
                      })
                    ],
                  ),
                ),
                38.v,
                "请选择提现账户".t.s(14).c(DSColors.title),
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
