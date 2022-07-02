import 'package:card_swiper/card_swiper.dart';
import 'package:care/controller/demand_controller.dart';
import 'package:care/model/demand_page.dart';
import 'package:care/model/staff_list_info.dart';
import 'package:care/widget/loader.dart';
import 'package:care/widget/m_tab_bar.dart';
import 'package:care/widget/main_button.dart';
import 'package:care/widget/navigator_ex.dart';
import 'package:care/widget/page_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:care/widget/view_ex.dart';
import 'package:care/common/time_helper.dart';

import '../../common/colors.dart';
import '../../constants/app_config.dart';
import '../home_page/tab_personnel_library.dart';
import 'demand_details.dart';
import 'demand_history.dart';

/// 需求单列表
class DemandList extends StatefulWidget {
  const DemandList({Key? key, this.type}) : super(key: key);

  final int? type;

  @override
  _DemandListState createState() => _DemandListState();
}

class _DemandListState extends State<DemandList> {
  int page = 1;

  final showDemand = true.obs;
  final showHistory = false.obs;

  final demandLoader = LoaderController();
  final stuffLoader = LoaderController();

  final dataList = <DemandPagesList>[].obs;

  final stuffList = <String>[].obs;
  int stuffPage = 1;

  int tabIndex = 0;

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () {
      refresh();
    });
  }

  Future<bool> refresh() async {
    await getData(isRefresh: true);

    return true;
  }

  Future<void> getData({bool isRefresh = false}) async {
    if (isRefresh) {
      page = 1;
      dataList.clear();
      demandLoader.loading();
    } else {
      page += 1;
    }

    /// 进行中105091，105092，历史传105093，105094
    DemandController().getDemandList(
        status: tabIndex == 0 ? "105091,105092" : "105093,105094",
        success: (DemandPage value) {
          dataList.addAll(value.list ?? []);
          if (widget.type == 1) {
            showDemand(false);
            refreshGoldMedalStuffList();
            return;
          }
          if (dataList.isEmpty && tabIndex == 0) {
            showDemand(false);
            refreshGoldMedalStuffList();
          } else {
            demandLoader.loadFinish(
                data: dataList.length,
                noMore: dataList.length >= (value.totalCount ?? 0));
          }
        },
        fail: (error) {
          demandLoader.loadError(msg: error);
        });
  }

  Future<void> refreshGoldMedalStuffList() async {
    getGoldMedalStuffList(isRefresh: true);

    /// 判断是否有历史需求
    DemandController().getDemandList(
      status: "105093,105094",
      success: (DemandPage value) {
        if ((value.list ?? []).isNotEmpty) {
          showHistory(true);
        }
      },
    );
  }

  void getGoldMedalStuffList({bool isRefresh = false}) {
    if (isRefresh) {
      stuffPage = 1;
      stuffList.clear();
      stuffLoader.loading();
    } else {
      stuffPage += 1;
    }

    final temp = <String>[];
    for (int i = 0; i < 10; i++) {
      temp.add(i.toString());
    }

    stuffList.addAll(temp);

    stuffLoader.loadFinish(
        data: stuffList.length, noMore: stuffList.length > 10);
  }

  @override
  Widget build(BuildContext context) {
    return PageWidget(
        titleLabel: "需求列表",
        isCustom: "short",
        body: Obx(() {
          if (showDemand.value) {
            return getContentView();
          } else {
            return getDefaultView();
          }
        }));
  }

  Widget getContentView() {
    return Column(
      children: [
        Container(
          height: 48,
          alignment: Alignment.center,
          child: MTabBar(
            titles: const ["运行中的需求", "历史需求"],
            onChange: (int index) {
              tabIndex = index;
              refresh();
            },
          ),
        ),
        Expanded(
          child: Obx(() {
            return Loader(
                onRefresh: refresh,
                onLoad: getData,
                controller: demandLoader,
                child: ListView.builder(
                    itemCount: dataList.length,
                    itemBuilder: (BuildContext context, int index) {
                      final item = dataList[index];
                      return DemandItem(item: item).onTap(() {
                        const Navigator()
                            .pushRoute(
                                context,
                                DemandDetails(
                                  demandNo: item.demandNo ?? "",
                                  memberDemandNo: item.memberDemandNo ?? "",
                                ))
                            .then((value) {
                          if (value ?? false) {
                            refresh();
                          }
                        });
                      });
                    }));
          }),
        ),
      ],
    );
  }

  Widget getDefaultView() {
    return Column(
      children: [
        Expanded(child: Obx(() {
          return Loader(
              controller: stuffLoader,
              child: ListView.builder(
                itemCount: stuffList.length,
                itemBuilder: (BuildContext context, int index) {
                  if (index == 0) {
                    return Column(
                      children: [
                        Swiper(
                          itemCount: 2,
                          itemBuilder: (BuildContext context, int index) {
                            return ClipRRect(
                              borderRadius: BorderRadius.circular(18),
                              child: Image.network(
                                AppConfig.image,
                                fit: BoxFit.cover,
                              ),
                            );
                          },
                        ).size(height: 180),
                        14.v,
                        Row(
                          children: [
                            Icon(
                              Icons.beenhere_outlined,
                              color: DSColors.primaryColor,
                              size: 25,
                            ),
                            10.h,
                            const MainText(
                              "金牌优选",
                              size: 16,
                            ).expanded(),
                            Obx(() {
                              return "历史需求"
                                  .t
                                  .s(16)
                                  .c(DSColors.subTitle)
                                  .onTap(() {
                                const Navigator()
                                    .pushRoute(context, const DemandHistory());
                              }).when(showHistory.value);
                            })
                          ],
                        ),
                        6.v,
                        StaffItem(
                          item: StaffListList(),
                        )
                      ],
                    );
                  }
                  return StaffItem(
                    item: StaffListList(),
                  );
                },
              )).margin(margin: const EdgeInsets.all(12));
        }))
      ],
    );
  }
}

class DemandItem extends StatelessWidget {
  const DemandItem({Key? key, required this.item}) : super(key: key);
  final DemandPagesList item;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            (item.demandTypeText ?? "").t.s(18).w().c(DSColors.title),
            "发布时间${DateTime.fromMillisecondsSinceEpoch(item.deployTime ?? 0).format(format: "yyyy.MM.dd HH:mm")}"
                .t
                .s(14)
                .c(DSColors.subTitle),
          ],
        ),
        12.v,
        Row(
          children: [
            "服务时间".t.c(DSColors.title).s(14),
            24.h,
            (item.serviceTime ?? "")
                .replaceAll("--", "至")
                .toString()
                .t
                .s(14)
                .c(DSColors.title)
          ],
        ),
        12.v,
        Row(
          children: [
            "您预计支付给服务人员的薪资".t.c(DSColors.title).s(14),
            24.h,
            ("${item.price ?? 0}元").toString().t.s(20).c(DSColors.primaryColor)
          ],
        ),
        12.v,
        Container(
          height: 1,
          color: DSColors.divider,
        ),
        12.v,
        Row(
          children: [
            "联系电话".t.c(DSColors.title).s(14),
            24.h,
            (item.telephone ?? "").t.s(14).c(DSColors.title)
          ],
        ),
        12.v,
        Row(
          children: [
            "服务地址".t.c(DSColors.title).s(14),
            24.h,
            (item.address ?? "").t.s(14).c(DSColors.title).flexible()
          ],
        ),
        12.v,
        Container(
          height: 1,
          color: DSColors.divider,
        ),
        12.v,
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ((item.workers ?? []).isEmpty
                    ? "正在等待服务人员投递..."
                    : "${item.workers!.length}人投递")
                .t
                .c(DSColors.title)
                .s(14)
                .or(
                    widget: "需求单已关闭".t.c(DSColors.title).s(14).or(
                        widget: "${(item.workers ?? []).length}人投递"
                            .t
                            .c(DSColors.title)
                            .s(14),
                        condition: (item.workers ?? []).isEmpty),
                    condition:
                        (item.status == "105091" || item.status == "105092")),
            if (item.status == "105091" || item.status == "105092")
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  SizedBox(
                    width: 100,
                    height: 30,
                    child: MainButton(
                      title: "刷新订单",
                      onTap: refreshAction,
                    ),
                  ),
                  4.v,
                  "每6小时可刷新一次".t.s(12).c(DSColors.describe)
                ],
              )
          ],
        ),
      ],
    ).paddingAll(12).border(color: DSColors.divider).borderRadius(radius: 8);
  }

  void refreshAction() {}
}
