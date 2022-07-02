import 'dart:ui';

import 'package:care/constants/app_config.dart';
import 'package:care/controller/staff_controller.dart';
import 'package:care/model/staff_info.dart';
import 'package:care/widget/loader.dart';
import 'package:care/widget/main_button.dart';
import 'package:care/widget/navigator_ex.dart';
import 'package:care/widget/page_widget.dart';
import 'package:care/widget/rate.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../common/colors.dart';
import '../../common/my_icon.dart';
import '../../common/util.dart';
import '../../controller/demand_controller.dart';
import '../../widget/alert_dialogs.dart';
import '../../widget/custom_sliver_delegate.dart';
import '../../widget/m_image.dart';
import '../../widget/view_ex.dart';
import '../user/order/order_list.dart';

/// 雇员详情
class StaffDetails extends StatefulWidget {
  const StaffDetails(
      {Key? key,
      required this.type,
      required this.staffId,
      this.memberDemandNo})
      : super(key: key);

  final int type;
  final String staffId;
  final String? memberDemandNo;

  /// 0 是正常进入，1是需求单进入

  @override
  _StaffDetailsState createState() => _StaffDetailsState();
}

class _StaffDetailsState extends State<StaffDetails> {
  final opacity = 0.0.obs;

  final showAppbar = false.obs;

  final loaderController = LoaderController();

  final data = StaffInfo().obs;

  Future<bool> refresh() async {
    StaffController().getStaffDetails(
        staffId: widget.staffId,
        success: (value) {
          data(value);
          showAppbar(false);
          loaderController.loadFinish();
        },
        fail: (error) {
          loaderController.loadError(msg: error);
          showAppbar(true);
          setState(() {});
        });
    return true;
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
        titleLabel: "雇员详情",
        isCustom: "short",
        showAppBar: showAppbar.value,
        backgroundColor: DSColors.white,
        body: Obx(() {
          print(data);
          return Column(
            children: [
              Expanded(
                  child: Loader(
                onRefresh: refresh,
                controller: loaderController,
                child: CustomScrollView(
                  slivers: [
                    getHeader(),
                    getIntroduction(),
                    getSkill(),
                    getOther(),
                    getGuarantee(),
                    getEvaluate(),
                  ],
                ),
              )),
              20.v,
              getAction(),
            ],
          );
        }));
  }

  Widget getHeader() {
    return SliverPersistentHeader(
      delegate: MerchantHeaderDelegate(
          minHeight:
              MediaQueryData.fromWindow(window).padding.top + kToolbarHeight,
          maxHeight: 500,
          maxWidget: Obx(() {
            final style =
                TextStyle(color: DSColors.white, fontSize: 12, shadows: [
              BoxShadow(
                  offset: const Offset(0, 1),
                  blurRadius: 1,
                  spreadRadius: 1,
                  color: DSColors.primaryColor)
            ]);

            return Opacity(
              opacity: 1 - opacity.value,
              child: Stack(
                children: [
                  SizedBox(
                    height: 270,
                    child: Stack(
                      children: [
                        Column(
                          children: [
                            Image.network(
                              AppConfig.image,
                              height: 270,
                              width: MediaQuery.of(context).size.width,
                              fit: BoxFit.cover,
                            ),
                          ],
                        ),
                        Positioned(
                            bottom: 0,
                            right: 30,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      "￥",
                                      style: style,
                                    ),
                                    Text(
                                      "3000",
                                      style: style.copyWith(fontSize: 18),
                                    ),
                                    Text(
                                      "·月",
                                      style: style,
                                    )
                                  ],
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      "￥",
                                      style: style,
                                    ),
                                    Text(
                                      "500",
                                      style: style.copyWith(fontSize: 18),
                                    ),
                                    Text(
                                      "·天",
                                      style: style,
                                    )
                                  ],
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      "￥",
                                      style: style,
                                    ),
                                    Text(
                                      "50",
                                      style: style.copyWith(fontSize: 18),
                                    ),
                                    Text(
                                      "·时",
                                      style: style,
                                    )
                                  ],
                                )
                              ],
                            ))
                      ],
                    ),
                  ),
                  Positioned(
                      child: Container(
                    padding: EdgeInsets.only(
                        top: MediaQueryData.fromWindow(window).padding.top),
                    height: kToolbarHeight +
                        MediaQueryData.fromWindow(window).padding.top,
                    child: Row(
                      children: [
                        12.h,
                        InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Icon(
                            MyIcon.icon_arrow_left,
                            size: 20,
                            color: DSColors.white,
                          ),
                        ),
                      ],
                    ),
                  )),
                  Positioned(
                      left: 0,
                      right: 0,
                      child: Column(
                        children: [
                          ClipRRect(
                              borderRadius: BorderRadius.circular(40),
                              child: MImage.network(
                                data.value.faceUrl ?? "",
                                width: 78,
                                height: 78,
                                fit: BoxFit.cover,
                              )),
                          6.v,
                          (data.value.name ?? "").t.s(16).c(DSColors.title),
                          6.v,
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              MainText(data.value.workType ?? "", size: 14),
                              8.h,
                              Rate(
                                max: 5,
                                rate: 4.8,
                                selectedColor: DSColors.primaryColor,
                              ),
                              4.h,
                              "4.8".t.s(14).c(DSColors.primaryColor),
                              4.h,
                              "(50)".t.s(12).c(DSColors.describe),
                            ],
                          ),
                          24.v,
                          Column(
                            children: [
                              Row(
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          "性别:".t.c(DSColors.title).s(12).w(),
                                          "女".t.c(DSColors.title).s(12),
                                        ],
                                      ),
                                      10.v,
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          "年龄:".t.c(DSColors.title).s(12).w(),
                                          "36".t.c(DSColors.title).s(12),
                                        ],
                                      ),
                                    ],
                                  )
                                      .padding(
                                          padding:
                                              const EdgeInsets.only(left: 60))
                                      .expanded(),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          "民族:".t.c(DSColors.title).s(12).w(),
                                          "汉族".t.c(DSColors.title).s(12),
                                        ],
                                      ),
                                      10.v,
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          "经验:".t.c(DSColors.title).s(12).w(),
                                          "3年".t.c(DSColors.title).s(12),
                                        ],
                                      ),
                                    ],
                                  )
                                      .padding(
                                          padding:
                                              const EdgeInsets.only(left: 20))
                                      .expanded(),
                                ],
                              ),
                              10.v,
                              Row(
                                children: [
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      "籍贯:".t.c(DSColors.title).s(12).w(),
                                      "${data.value.province ?? ""}${data.value.city ?? ""}"
                                          .t
                                          .c(DSColors.title)
                                          .s(12)
                                    ],
                                  ),
                                ],
                              ).padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 60)),
                              10.v,
                              Row(
                                children: [
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      "学历:".t.c(DSColors.title).s(12).w(),
                                      "本科(广西大学，家政学士学位)"
                                          .t
                                          .c(DSColors.title)
                                          .s(12),
                                    ],
                                  ),
                                ],
                              ).padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 60)),
                              10.v,
                            ],
                          )
                              .margin(
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 20))
                              .padding(
                                  padding: const EdgeInsets.only(bottom: 15)),
                        ],
                      ).margin(margin: const EdgeInsets.only(top: 224)))
                ],
              ),
            );
          }),
          minWidget: Obx(() {
            return Opacity(
              opacity: opacity.value,
              child: SizedBox(
                height: MediaQueryData.fromWindow(window).padding.top +
                    kToolbarHeight,
                child: Stack(
                  children: [
                    Container(
                      padding: EdgeInsets.only(
                          top: MediaQueryData.fromWindow(window).padding.top),
                      width: MediaQuery.of(context).size.width,
                      height: MediaQueryData.fromWindow(window).padding.top +
                          kToolbarHeight,
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [DSColors.pinkYellow, DSColors.pinkRed],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                          borderRadius: const BorderRadius.vertical(
                              bottom: Radius.circular(20))),
                      child: Row(
                        children: [
                          12.h,
                          InkWell(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Icon(
                              MyIcon.icon_arrow_left,
                              size: 20,
                              color: DSColors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
          changeBack: (o, offset) {
            opacity(o);
          }),
      pinned: true,
    );
  }

  Widget getIntroduction() {
    return SliverToBoxAdapter(
      child: Column(
        children: [
          18.v,
          Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                    color: DSColors.primaryColor, shape: BoxShape.circle),
              ),
              8.h,
              const MainText("个人简介", size: 14),
            ],
          ).margin(margin: const EdgeInsets.symmetric(horizontal: 16)),
          12.v,
          """你好，我的名字叫李美雅，广西大学家政专业。
          我只在星期五，偶尔周六和周日提供服务，我的价格是一个孩子100
          元，额外孩子150元。（可以商量）
          我有超过3年的带薪儿童保育经验，我还有很多志愿者经历。
          我喜欢看孩子们玩耍、学习和成长。我喜欢阅读、棋盘游戏、艺术品
          和手工拼和拼图。
          我是一个非吸烟者，可靠，精力充沛，准时和关怀。
          期待您的回音！"""
              .t
              .s(12)
              .c(DSColors.title)
              .margin(margin: const EdgeInsets.symmetric(horizontal: 30)),
        ],
      ).borderOnly(top: BorderSide(color: DSColors.divider)),
    );
  }

  Widget getSkill() {
    final tags = ["C1驾驶证", "非吸烟者", "心肺复苏/急救训练", "英语交流", "有用", "健康证"];
    return SliverToBoxAdapter(
      child: Column(
        children: [
          18.v,
          Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                    color: DSColors.primaryColor, shape: BoxShape.circle),
              ),
              8.h,
              const MainText("掌握技能", size: 14),
            ],
          ).margin(margin: const EdgeInsets.symmetric(horizontal: 16)),
          12.v,
          Wrap(
            spacing: 36,
            runSpacing: 12,
            children: tags.map((item) {
              return Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.check,
                    color: DSColors.color_6AC259,
                    size: 15,
                  ),
                  item.t.s(14).c(DSColors.title)
                ],
              );
            }).toList(),
          )
        ],
      ),
    );
  }

  Widget getOther() {
    final tags = ["照顾病人", "宠物照顾", "辅导孩子学习"];
    return SliverToBoxAdapter(
      child: Column(
        children: [
          18.v,
          Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                    color: DSColors.primaryColor, shape: BoxShape.circle),
              ),
              8.h,
              const MainText("其他能力", size: 14),
            ],
          ).margin(margin: const EdgeInsets.symmetric(horizontal: 16)),
          12.v,
          Wrap(
            spacing: 36,
            children: tags.map((item) {
              return Row(
                mainAxisSize: MainAxisSize.min,
                children: [item.t.s(12).c(DSColors.title)],
              );
            }).toList(),
          )
        ],
      ),
    );
  }

  Widget getGuarantee() {
    return SliverToBoxAdapter(
      child: Column(
        children: [
          18.v,
          Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                    color: DSColors.primaryColor, shape: BoxShape.circle),
              ),
              8.h,
              const MainText("人员保障", size: 14),
            ],
          ).margin(margin: const EdgeInsets.symmetric(horizontal: 16)),
        ],
      ),
    );
  }

  Widget getEvaluate() {
    final tags = [
      {"key": "聘用率", "value": "98%"},
      {"key": "好评率", "value": "98%"},
      {"key": "不知道", "value": "98%"}
    ];
    return SliverToBoxAdapter(
      child: Column(
        children: [
          18.v,
          Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                    color: DSColors.primaryColor, shape: BoxShape.circle),
              ),
              8.h,
              const MainText("雇主评价", size: 14),
            ],
          ).margin(margin: const EdgeInsets.symmetric(horizontal: 16)),
          16.v,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: tags.map((item) {
              return Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [DSColors.pinkYellow, DSColors.pinkRed],
                    )),
                padding: const EdgeInsets.all(2),
                child: Container(
                  width: 96,
                  height: 96,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: DSColors.white,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      MainText(
                        item["value"].toString(),
                        size: 26,
                      ),
                      MainText(
                        item["key"].toString(),
                        size: 12,
                      )
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
          34.v,
          Row(
            children: [
              Column(
                children: [
                  Icon(
                    Icons.face,
                    size: 35,
                    color: DSColors.primaryColor,
                  ),
                  14.v,
                  Row(
                    children: [
                      Rate(
                        max: 5,
                        rate: 4.6,
                        size: 12,
                        selectedColor: DSColors.primaryColor,
                      ),
                      4.h,
                      "4.8".t.c(DSColors.primaryColor).s(12)
                    ],
                  )
                ],
              ),
              Container(
                margin: const EdgeInsets.only(left: 24),
                height: 50,
                color: DSColors.describe,
                width: 1,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  "服务满意度:4.8".t.s(12).c(DSColors.title),
                  13.v,
                  "效果满意度:4.8".t.s(12).c(DSColors.title)
                ],
              )
                  .padding(padding: const EdgeInsets.only(left: 33))
                  .expanded(flex: 5)
            ],
          ).margin(margin: const EdgeInsets.symmetric(horizontal: 27)),
          15.v,
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 25),
            height: 1,
            color: DSColors.describe,
          ),
          12.v,
          Row(
            children: [
              ClipRRect(
                  borderRadius: BorderRadius.circular(28),
                  child: Image.network(
                    AppConfig.image,
                    width: 56,
                    height: 56,
                    fit: BoxFit.cover,
                  )),
              16.h,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      "匿名".t.s(16).c(DSColors.title),
                      "2020.04.05".t.s(12).c(DSColors.subTitle),
                    ],
                  ),
                  6.v,
                  "非常棒!感谢李阿姨！".t.s(12).c(DSColors.title),
                ],
              ).expanded(),
            ],
          ).margin(margin: const EdgeInsets.symmetric(horizontal: 24)),
          27.v,
          InkWell(
            child: Container(
              width: 83,
              height: 26,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(13),
                  color: DSColors.white,
                  boxShadow: [
                    BoxShadow(
                      color: DSColors.dc,
                      offset: const Offset(1, 1),
                      spreadRadius: 1,
                      blurRadius: 1,
                    )
                  ]),
              child: const Center(
                child: MainText(
                  "查看更多",
                  size: 12,
                ),
              ),
            ),
          ),
          26.v,
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              "查看李美雅家政人员信用档案报告".t.s(12).c(Colors.lightBlueAccent),
              "（公安部门提供）".t.s(12).c(DSColors.title)
            ],
          ),
          46.v,
        ],
      ),
    );
  }

  getAction() {
    return Container(
      margin:
          EdgeInsets.only(left: 15, right: 15, bottom: Util.getBottomPadding()),
      height: 54,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          color: DSColors.white,
          boxShadow: [
            BoxShadow(
              color: DSColors.f2,
              blurRadius: 10,
              spreadRadius: 5,
              offset: const Offset(1, 1),
            )
          ]),
      child: Row(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.favorite_border,
                    color: DSColors.primaryColor,
                  ),
                  "收藏".t,
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(MyIcon.icon_msg_outline, color: DSColors.primaryColor),
                  "联系".t,
                ],
              )
            ],
          ).expanded(flex: 1),
          MainButton(
            height: 54,
            title: widget.type == 0 ? "预约下单" : "确认雇员",
            onTap: submit,
          ).expanded(flex: 1),
        ],
      ),
    );
  }

  void submit() {
    if (widget.type == 0) {
    } else {
      showDialog(
          context: context,
          builder: (_) {
            return AlertDialogs(
              title: "提示",
              message: "确认选择该雇员?",
              leftAction: () {
                Navigator.pop(context);
              },
              leftText: "取消",
              rightText: "确认",
              rightAction: () {
                Navigator.pop(context);
                DemandController().demandConfirmStaff(
                    memberDemandNo: widget.memberDemandNo ?? "",
                    workerNo: widget.staffId,
                    success: (value) {
                      Navigator.of(context)
                        ..pop()
                        ..pop();
                      const Navigator()
                          .pushRoute(Get.context!, const OrderList());
                    });
              },
            );
          });
    }
  }

  void confirmBack() {
    showDialog(
        context: context,
        builder: (_) {
          return AlertDialogs(
            title: "提示",
            message: "确认成功",
            leftAction: () {
              Navigator.pop(context);
            },
            leftText: "取消",
            rightText: "确认",
            rightAction: () {
              Navigator.pop(context);
              DemandController().demandConfirmStaff(
                  memberDemandNo: widget.memberDemandNo ?? "",
                  workerNo: widget.staffId);
            },
          );
        });
  }
}
