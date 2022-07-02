import 'package:care/constants/app_config.dart';
import 'package:care/widget/loader.dart';
import 'package:care/widget/navigator_ex.dart';
import 'package:care/widget/page_widget.dart';
import 'package:flutter/material.dart';
import 'package:care/widget/view_ex.dart';
import 'package:get/get.dart';

import '../../common/colors.dart';
import 'store_details.dart';

/// 线下门店
class OfflineStores extends StatefulWidget {
  const OfflineStores({Key? key}) : super(key: key);

  @override
  State<OfflineStores> createState() => _OfflineStoresState();
}

class _OfflineStoresState extends State<OfflineStores> {
  final loaderController = LoaderController();
  final dataList = <String>[].obs;
  int page = 1;

  final filterCount = 0.obs;

  Future<void> refresh() async {
    getData(isRefresh: true);
  }

  void getData({bool isRefresh = false}) {
    if (isRefresh) {
      page = 1;
      loaderController.loading();
    } else {
      page += 1;
    }

    final temp = <String>[];
    for (int i = 0; i < 10; i++) {
      temp.add(i.toString());
    }
    if (page == 1) {
      dataList.clear();
    }
    dataList.addAll(temp);
    loaderController.loadFinish(data: dataList, noMore: dataList.length > 10);
  }

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () {
      refresh();
    });
  }

  @override
  Widget build(BuildContext context) {
    return PageWidget(
        titleLabel: "线下门店",
        isCustom: "short",
        body: Column(
          children: [getFilter(), getContent().expanded()],
        ));
  }

  Widget getFilter() {
    return Obx(() {
      return Row(
        children: [
          InkWell(
            onTap: () {
              filterCount(0);
            },
            child: Container(
              height: 30,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                  color: DSColors.white,
                  boxShadow: [
                    BoxShadow(
                      color: DSColors.dc,
                      blurRadius: 1,
                      offset: const Offset(0, 1),
                      spreadRadius: 1,
                    ),
                  ],
                  borderRadius: BorderRadius.circular(20)),
              child: Row(
                children: [
                  "综合排序"
                      .t
                      .c(filterCount.value == 0
                          ? DSColors.primaryColor
                          : DSColors.title)
                      .s(14),
                ],
              ),
            ),
          ),
          12.h,
          InkWell(
            onTap: () {
              filterCount(1);
            },
            child: Container(
              height: 30,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                  color: DSColors.white,
                  boxShadow: [
                    BoxShadow(
                      color: DSColors.dc,
                      blurRadius: 1,
                      offset: const Offset(0, 1),
                      spreadRadius: 1,
                    ),
                  ],
                  borderRadius: BorderRadius.circular(20)),
              child: Row(
                children: [
                  "距离排序"
                      .t
                      .c(filterCount.value == 1
                          ? DSColors.primaryColor
                          : DSColors.title)
                      .s(14),
                ],
              ),
            ),
          ),
        ],
      )
          .size(height: 50)
          .padding(padding: const EdgeInsets.symmetric(horizontal: 12));
    });
  }

  Widget getContent() {
    return Obx(() {
      return Loader(
          onRefresh: refresh,
          onLoad: getData,
          controller: loaderController,
          child: ListView.builder(
            itemCount: dataList.length,
            itemBuilder: (BuildContext context, int index) {
              return Container(
                decoration: BoxDecoration(
                    border:
                        Border(bottom: BorderSide(color: DSColors.divider))),
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                child: Column(
                  children: [
                    Stack(
                      children: [
                        ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              AppConfig.image,
                              fit: BoxFit.cover,
                            )),
                        "武汉东湖高新店".t.s(16).c(DSColors.white).margin(
                            margin: const EdgeInsets.only(left: 12, top: 12))
                      ],
                    ),
                    8.v,
                    Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                "门店地址：啦啦啦啦啦啦啦啦我是门店地址啦啦啦啦啦啦啦啦"
                                    .t
                                    .s(14)
                                    .c(DSColors.subTitle)
                                    .flexible(),
                              ],
                            ),
                            4.v,
                            "联系电话：13333333333".t.c(DSColors.subTitle).s(14),
                          ],
                        ).expanded(),
                        12.h,
                        InkWell(
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 4),
                            decoration: BoxDecoration(
                                color: DSColors.white,
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: DSColors.dc,
                                    blurRadius: 1,
                                    offset: const Offset(0, 1),
                                    spreadRadius: 1,
                                  )
                                ]),
                            child: "一键导航".t.c(DSColors.primaryColor).s(14),
                          ),
                        )
                      ],
                    ),
                    8.v
                  ],
                ),
              ).onTap(() {
                const Navigator().pushRoute(context, const StoreDetails());
              });
            },
          ));
    });
  }
}
