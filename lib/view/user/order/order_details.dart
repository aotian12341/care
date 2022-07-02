import 'package:care/view/home_page/tab_personnel_library.dart';
import 'package:care/widget/key_value_view.dart';
import 'package:care/widget/loader.dart';
import 'package:care/widget/page_widget.dart';
import 'package:flutter/material.dart';
import 'package:care/widget/view_ex.dart';
import 'package:get/get.dart';

import '../../../common/colors.dart';
import '../../../controller/order_controller.dart';
import '../../../model/order/order_info.dart';
import '../../../model/staff_list_info.dart';

/// 订单详情
class OrderDetails extends StatefulWidget {
  const OrderDetails({Key? key, required this.orderNo}) : super(key: key);

  final String orderNo;

  @override
  State<OrderDetails> createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails> {
  final loaderController = LoaderController();

  final order = OrderInfo().obs;

  Future<void> refresh() async {
    OrderController().getOrderDetails(
        orderNo: widget.orderNo,
        success: (value) {
          order(value);
          loaderController.loadFinish();
        },
        fail: (error) {
          loaderController.loadError(msg: error);
        });
  }

  @override
  Widget build(BuildContext context) {
    return PageWidget(
        isCustom: "short",
        titleLabel: "订单详情页",
        onStart: () {
          refresh();
        },
        body: Obx(() {
          debugPrint(order.value.demandNo);
          return Column(
            children: [
              Loader(
                  controller: loaderController,
                  onRefresh: refresh,
                  onError: refresh,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        getAddress(),
                        getStaff(),
                        getDemandMessage(),
                        getOrderMessage(),
                      ],
                    ),
                  )).expanded(),
              getAction(),
            ],
          );
        }));
  }

  Widget getAction() {
    return Container();
  }

  Widget getAddress() {
    return Column(
      children: [
        12.v,
        (order.value.status ?? "").t.s(18).c(DSColors.title),
        12.v,
        KeyValueView(
          title: "服务时间：",
          value: order.value.timeRange ?? "",
        ),
        KeyValueView(
          title: "服务地址：",
          value:
              "${order.value.addressInfo?.province ?? ""}${order.value.addressInfo?.city ?? ""}${order.value.addressInfo?.district ?? ""}${order.value.addressInfo?.addressName ?? ""}${order.value.addressInfo?.address ?? ""}",
        )
      ],
    ).color(DSColors.white).margin(margin: EdgeInsets.only(bottom: 12));
  }

  Widget getStaff() {
    return StaffItem(item: StaffListList()..name = "李美雅");
  }

  Widget getDemandMessage() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            "需求信息:".t.s(16).c(DSColors.title),
            "全职保姆".t.s(16).c(DSColors.title),
          ],
        ),
        12.v,
        Row(
          children: [
            "服务场合:医院".t.s(14).c(DSColors.title).expanded(),
            "服务类型:全天".t.s(14).c(DSColors.title).expanded(),
          ],
        ),
        12.v,
        Row(
          children: [
            "谁需要护理:老年人".t.s(14).c(DSColors.title).expanded(),
            "性别:男性".t.s(14).c(DSColors.title).expanded(),
          ],
        ),
        12.v,
        Row(
          children: [
            "年龄:60岁".t.s(14).c(DSColors.title).expanded(),
            "身体情况:半自理".t.s(14).c(DSColors.title).expanded(),
          ],
        ),
        12.v,
        Row(
          children: [
            "对护工性别要求:女性".t.s(14).c(DSColors.title).expanded(),
            "护工年龄段:35-45岁".t.s(14).c(DSColors.title).expanded(),
          ],
        )
            .padding(padding: const EdgeInsets.only(top: 12))
            .borderOnly(top: BorderSide(color: DSColors.divider)),
        12.v,
        Row(
          children: [
            "薪资预计:".t.s(14).c(DSColors.title).expanded(),
            "${(order.value.price ?? "")}元"
                .t
                .s(14)
                .c(DSColors.pinkRed)
                .expanded(),
          ],
        ),
        12.v,
        "备注".t.s(16).c(DSColors.title),
        12.v,
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: ["阿姨".t.s(14).c(DSColors.title).flexible()],
        )
            .padding(padding: const EdgeInsets.all(16))
            .border(color: DSColors.divider)
      ],
    )
        .padding(padding: const EdgeInsets.all(12))
        .color(DSColors.white)
        .margin(margin: const EdgeInsets.only(bottom: 12));
  }

  Widget getOrderMessage() {
    return Column(
      children: [
        KeyValueView(
          title: "订单编号:",
          value: widget.orderNo,
        ),
        KeyValueView(
          title: "下单时间:",
          value: "2020-03-18 10:10:10",
        ),
      ],
    ).color(DSColors.white).margin(margin: EdgeInsets.only(bottom: 12));
  }
}
