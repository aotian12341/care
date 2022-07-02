import 'package:care/common/time_helper.dart';
import 'package:care/controller/order_controller.dart';
import 'package:care/controller/pay_controller.dart';
import 'package:care/model/order/order_page_info.dart';
import 'package:care/widget/bottom_shell.dart';
import 'package:care/widget/m_tab_bar.dart';
import 'package:care/widget/main_button.dart';
import 'package:care/widget/navigator_ex.dart';
import 'package:care/widget/page_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../common/colors.dart';
import '../../../common/util.dart';
import '../../../constants/app_config.dart';
import '../../../widget/alert_dialogs.dart';
import '../../../widget/loader.dart';
import '../../../model/order/order_page_info.dart';
import 'package:care/widget/view_ex.dart';

import 'order_details.dart';

/// 订单列表
class OrderList extends StatefulWidget {
  const OrderList({Key? key}) : super(key: key);

  @override
  State<OrderList> createState() => _OrderListState();
}

class _OrderListState extends State<OrderList> {
  final loaderController = LoaderController();

  final dataList = <OrderPageRecords>[].obs;

  int status = 0;

  int page = 1;

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

    OrderController().getOrderList(
        page: page,
        status: status,
        success: (OrderPageInfo value) {
          if (page == 1) {
            dataList.clear();
          }

          dataList.addAll(value.records ?? []);

          loaderController.loadFinish(
              data: dataList, noMore: dataList.length >= (value.total ?? 0));
        },
        fail: (error) {
          loaderController.loadError(msg: error);
        });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    Future.delayed(Duration.zero, () {
      refresh();
    });
  }

  @override
  Widget build(BuildContext context) {
    return PageWidget(
        titleLabel: "订单列表",
        isCustom: "short",
        body: Column(
          children: [
            getTabView(),
            Expanded(
                child: getContent().margin(margin: const EdgeInsets.all(12)))
          ],
        ));
  }

  Widget getTabView() {
    final titles = ["全部", "待确认", "待服务", "服务中", "待支付", "评价"];
    return MTabBar(
        titles: titles,
        onChange: (value) {
          status = value;
          refresh();
        }).size(height: 44);
  }

  Widget getContent() {
    return Obx(() {
      return Loader(
        controller: loaderController,
        onRefresh: refresh,
        onLoad: getData,
        child: ListView.builder(
          itemCount: dataList.length,
          itemBuilder: (BuildContext context, int index) {
            final item = dataList[index];
            return OrderItem(
              item: item,
              refresh: () {
                refresh();
              },
            ).onTap(() {
              const Navigator().pushRoute(
                  context,
                  OrderDetails(
                    orderNo: item.orderNo ?? "",
                  ));
            });
          },
        ),
      );
    });
  }
}

///
class OrderItem extends StatelessWidget {
  OrderItem({Key? key, required this.item, required this.refresh})
      : super(key: key);

  final OrderPageRecords item;

  final Function refresh;

  late BuildContext mContext;

  @override
  Widget build(BuildContext context) {
    mContext = context;
    return Column(
      children: [
        getMsg(),
        if (item.status == "105334") getMoney(),
        getAction(context)
      ],
    )
        .borderRadius(radius: 8)
        .color(DSColors.white)
        .margin(margin: const EdgeInsets.only(bottom: 12));
  }

  Widget getMsg() {
    return IntrinsicHeight(
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(50),
            child: Image.network(
              AppConfig.image,
              width: 100,
              height: 100,
              fit: BoxFit.cover,
            ),
          ),
          12.h,
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Row(
                children: [
                  (item.serviceName ?? "").t.c(DSColors.title).s(18).w(),
                  "李雅婷".t.c(DSColors.title).s(16).center().expanded(),
                  Util.getOrderStatusText(item.status ?? "")
                      .t
                      .c(DSColors.primaryColor)
                      .s(16)
                      .center()
                      .size(width: 60)
                ],
              ),
              Row(
                children: [
                  "服务时间：${item.serviceTimeRange ?? ""}"
                      .t
                      .s(14)
                      .c(DSColors.subTitle)
                      .expanded(),
                  Icon(
                    Icons.chevron_right,
                    size: 20,
                    color: DSColors.subTitle,
                  )
                ],
              )
            ],
          ).expanded()
        ],
      )
          .padding(padding: const EdgeInsets.symmetric(vertical: 8))
          .borderOnly(bottom: BorderSide(color: DSColors.divider)),
    );
  }

  Widget getMoney() {
    return Row(
      children: [
        "*二月份保姆工资".t.s(14).c(DSColors.title).expanded(),
        "实付 ￥${item.price ?? 0}元".t.s(14).c(DSColors.primaryColor)
      ],
    )
        .size(height: 44)
        .padding(padding: const EdgeInsets.symmetric(horizontal: 12))
        .borderOnly(bottom: BorderSide(color: DSColors.divider));
  }

  Widget getAction(BuildContext context) {
    if (item.status == "105331") {
      return getWaitConfirm();
    } else if (item.status == "105332") {
      return getWaitService();
    } else if (item.status == "105333") {
      return getServicing();
    } else if (item.status == "105334") {
      return getWaitPay();
    } else {
      return getServicing();
    }
  }

  /// 待确认
  Widget getWaitConfirm() {
    return Row(
      children: [
        (item.createTime == null
                ? ""
                : DateTime.fromMillisecondsSinceEpoch(item.createTime ?? 0)
                    .format(format: "yyyy-MM-dd"))
            .t
            .c(DSColors.subTitle)
            .s(14)
            .expanded(),
        "取消订单"
            .t
            .s(16)
            .c(DSColors.subTitle)
            .margin(margin: const EdgeInsets.only(right: 12))
            .onTap(cancel),
        MainButton(
          width: 100,
          height: 35,
          title: "提醒对方",
          onTap: remind,
        )
      ],
    )
        .size(height: 48)
        .padding(padding: const EdgeInsets.symmetric(horizontal: 12));
  }

  /// 待服务
  Widget getWaitService() {
    return Row(
      children: [
        (item.createTime == null
                ? ""
                : DateTime.fromMillisecondsSinceEpoch(item.createTime ?? 0)
                    .format(format: "yyyy-MM-dd"))
            .t
            .c(DSColors.subTitle)
            .s(14)
            .expanded(),
        "取消订单"
            .t
            .s(16)
            .c(DSColors.subTitle)
            .margin(margin: const EdgeInsets.only(right: 12))
            .onTap(cancel),
        MainButton(
          width: 100,
          height: 35,
          title: "联系对方",
          onTap: contact,
        )
      ],
    )
        .size(height: 48)
        .padding(padding: const EdgeInsets.symmetric(horizontal: 12));
  }

  /// 服务中
  Widget getServicing() {
    return Row(
      children: [
        (item.createTime == null
                ? ""
                : DateTime.fromMillisecondsSinceEpoch(item.createTime ?? 0)
                    .format(format: "yyyy-MM-dd"))
            .t
            .c(DSColors.subTitle)
            .s(14)
            .expanded(),
        MainButton(
          width: 100,
          height: 35,
          title: "联系对方",
          onTap: contact,
        )
      ],
    )
        .size(height: 48)
        .padding(padding: const EdgeInsets.symmetric(horizontal: 12));
  }

  /// 待支付
  Widget getWaitPay() {
    return Row(
      children: [
        (item.createTime == null
                ? ""
                : DateTime.fromMillisecondsSinceEpoch(item.createTime ?? 0)
                    .format(format: "yyyy-MM-dd"))
            .t
            .c(DSColors.subTitle)
            .s(14)
            .expanded(),
        MainButton(
          width: 100,
          height: 35,
          title: "立即支付",
          onTap: () {
            OrderController().getOrderPay(
                orderNo: item.orderNo ?? "",
                success: (value) {
                  PayController()
                      .pay(payment: 1, info: value, success: (value) {});
                });
          },
        )
      ],
    )
        .size(height: 48)
        .padding(padding: const EdgeInsets.symmetric(horizontal: 12));
  }

  void contact() async {
    BottomShell.show(
        items: [
          BottomShellItem(title: "在线对话"),
          BottomShellItem(title: "拨打电话"),
        ],
        onChoose: (index) async {
          if (index == 0) {
          } else if (index == 1) {
            String url = 'tel:' + "13333333333"; // item['phone']是需要拨号的手机号
//判断是否可以拨打电话
            if (await canLaunch(url)) {
              await launch(url); // 跳转到拨号页面
            } else {
              throw '手机号异常，不能拨打电话';
            }
          }
        });
  }

  void remind() {}

  void cancel() {
    showDialog(
        context: mContext,
        builder: (_) {
          return AlertDialogs(
            title: "提示",
            message: "确认取消？",
            leftText: "取消",
            rightText: "确认",
            leftAction: () {
              Navigator.pop(mContext);
            },
            rightAction: () {
              Navigator.pop(mContext);
              OrderController().orderCancel(
                  orderNo: item.orderNo ?? "",
                  success: (value) {
                    refresh();
                  });
            },
          );
        });
  }
}
