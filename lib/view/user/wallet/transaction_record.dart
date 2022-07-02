import 'package:care/widget/loader.dart';
import 'package:care/widget/m_tab_bar.dart';
import 'package:care/widget/page_widget.dart';
import 'package:care/widget/view_ex.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../common/colors.dart';

/// 交易记录
class TransactionRecord extends StatefulWidget {
  const TransactionRecord({Key? key}) : super(key: key);

  @override
  _TransactionRecordState createState() => _TransactionRecordState();
}

class _TransactionRecordState extends State<TransactionRecord> {
  final tabIndex = 0.obs;

  final dataList = <String>[].obs;

  final loaderController = LoaderController();

  int page = 1;

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () {
      refresh();
    });
  }

  Future<bool> refresh() async {
    getData(isRefresh: true);
    return true;
  }

  void getData({bool isRefresh = false}) {
    if (isRefresh) {
      page = 1;
      dataList.clear();
      loaderController.loading();
    } else {
      page += 1;
    }

    final temp = <String>[];
    for (int i = 0; i < 10; i++) {
      temp.add(i.toString());
    }

    dataList.addAll(temp);

    loaderController.loadFinish(data: dataList, noMore: dataList.length > 20);
  }

  @override
  Widget build(BuildContext context) {
    return PageWidget(
        titleLabel: "交易记录",
        isCustom: "short",
        body: Column(
          children: [
            getTab(),
            Expanded(child: getContent()),
          ],
        ));
  }

  Widget getTab() {
    return MTabBar(
        titles: const ["全部", "消费", "提现", "充值"],
        isScroll: false,
        onChange: (value) {
          tabIndex(value);
          refresh();
        }).size(height: 50).color(DSColors.white);
  }

  Widget getContent() {
    return Obx(() {
      return Loader(
        controller: loaderController,
        child: ListView.builder(
          itemCount: dataList.length,
          itemBuilder: (BuildContext context, int index) {
            return Row(
              children: [
                20.h,
                Image.asset(
                  index % 3 == 0
                      ? "assets/images/icon_transaction_consumption.png"
                      : index % 3 == 1
                          ? "assets/images/icon_transaction_recharge.png"
                          : "assets/images/icon_transaction_withdrawal.png",
                  width: 28,
                  height: 22,
                ),
                18.h,
                Container(
                  decoration: BoxDecoration(
                      border:
                          Border(bottom: BorderSide(color: DSColors.divider))),
                  child: Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          "提现".t.c(DSColors.title).s(16),
                          6.v,
                          "今天 12:00".t.s(14).c(DSColors.describe)
                        ],
                      )
                          .padding(
                              padding: const EdgeInsets.symmetric(vertical: 22))
                          .expanded(),
                      "-200.00".t.c(DSColors.title).s(20),
                      20.h
                    ],
                  ),
                ).expanded()
              ],
            );
          },
        ),
      );
    })
        .color(DSColors.white)
        .borderRadius(radius: 12)
        .margin(margin: const EdgeInsets.all(12));
  }
}
