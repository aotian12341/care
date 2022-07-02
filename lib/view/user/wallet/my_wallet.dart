import 'package:care/controller/user_controller.dart';
import 'package:care/view/user/wallet/recharge.dart';
import 'package:care/view/user/wallet/transaction_record.dart';
import 'package:care/view/user/wallet/withdrawal.dart';
import 'package:care/widget/main_button.dart';
import 'package:care/widget/navigator_ex.dart';
import 'package:care/widget/page_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../common/colors.dart';
import '../../../widget/loader.dart';
import 'package:care/widget/view_ex.dart';

/// 钱包
class MyWallet extends StatefulWidget {
  const MyWallet({Key? key}) : super(key: key);

  @override
  _MyWalletState createState() => _MyWalletState();
}

class _MyWalletState extends State<MyWallet> {
  final loaderController = LoaderController();

  @override
  void initState() {
    super.initState();
    loaderController.loadFinish();
  }

  Future<bool> refresh() async {
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return PageWidget(
        titleLabel: "钱包",
        isCustom: "short",
        body: Obx(() {
          print(UserController.instance.userInfo);
          return Loader(
            controller: loaderController,
            child: Column(
              children: [
                Column(
                  children: [
                    Row(
                      children: [
                        "我的余额".t.c(DSColors.primaryColor).s(16).expanded(),
                        "交易记录".t.c(DSColors.describe).s(16).onTap(() {
                          const Navigator()
                              .pushRoute(context, const TransactionRecord());
                        }),
                        4.h,
                        Icon(
                          Icons.keyboard_arrow_right,
                          size: 20,
                          color: DSColors.describe,
                        )
                      ],
                    ),
                    20.v,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        "￥".t.s(16).c(DSColors.primaryColor),
                        4.h,
                        "120".t.c(DSColors.primaryColor).s(42)
                      ],
                    ),
                    30.v,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.check,
                              size: 20,
                              color: DSColors.color_6AC259,
                            ),
                            "担保交易".t.s(16).c(DSColors.color_6AC259),
                          ],
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.check,
                              size: 20,
                              color: DSColors.color_6AC259,
                            ),
                            "随时退款".t.s(16).c(DSColors.color_6AC259),
                          ],
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.check,
                              size: 20,
                              color: DSColors.color_6AC259,
                            ),
                            "安全保障".t.s(16).c(DSColors.color_6AC259),
                          ],
                        ),
                      ],
                    ),
                    30.v,
                    Row(
                      children: [
                        Expanded(
                            child: MainButton(
                          title: "充值",
                          onTap: () {
                            const Navigator()
                                .pushRoute(context, const Recharge());
                          },
                        )),
                        55.h,
                        Expanded(
                            child: MainButton(
                          title: "申请提现",
                          onTap: () {
                            const Navigator()
                                .pushRoute(context, const Withdrawal());
                          },
                        )),
                      ],
                    )
                  ],
                ).borderRadius(radius: 12).color(DSColors.white).padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 25)),
              ],
            ).margin(
                margin:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 12)),
          );
        }));
  }
}
