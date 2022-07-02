import 'dart:io';

import 'package:care/common/util.dart';
import 'package:care/controller/user_controller.dart';
import 'package:care/view/demand/demand_list.dart';
import 'package:care/view/home_page/tab_classify.dart';
import 'package:care/view/home_page/tab_home.dart';
import 'package:care/view/home_page/tab_personnel_library.dart';
import 'package:care/view/home_page/tab_talk.dart';
import 'package:care/view/user/address/address_list.dart';
import 'package:care/view/user/personal/personal_message.dart';
import 'package:care/view/user/personal/setting.dart';
import 'package:care/view/user/wallet/my_wallet.dart';
import 'package:care/widget/file_picker/upload_utils.dart';
import 'package:care/widget/m_toast.dart';
import 'package:care/widget/navigator_ex.dart';
import 'package:care/widget/page_widget.dart';
import 'package:city_pickers/city_pickers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../common/colors.dart';
import '../../widget/alert_dialogs.dart';
import '../staff/offline_stores.dart';
import '../user/login.dart';
import '../user/order/order_list.dart';
import '../user/personal/collection.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  final tabIndex = 0.obs;

  late TabController tabController;

  final titles = [
    {
      "title": "首页",
      "icon": "assets/images/tab_home.png",
      "icon_p": "assets/images/tab_home_grey.png"
    },
    {
      "title": "分类",
      "icon": "assets/images/tab_list.png",
      "icon_p": "assets/images/tab_list_grey.png"
    },
    {
      "title": "人员库",
      "icon": "assets/images/tab_user.png",
      "icon_p": "assets/images/tab_user_grey.png"
    },
    {
      "title": "对话",
      "icon": "assets/images/tab_talk.png",
      "icon_p": "assets/images/tab_talk_grey.png"
    },
  ];

  final userItem = [
    {
      "title": "收藏",
      "icon": "assets/images/icon_collection.png",
      "tag": "collection"
    },
    {"title": "订单", "icon": "assets/images/icon_order.png", "tag": "order"},
    {"title": "钱包", "icon": "assets/images/icon_wallet.png", "tag": "wallet"},
    {"title": "我的需求", "icon": "assets/images/icon_demand.png", "tag": "demand"},
    {
      "title": "地址管理",
      "icon": "assets/images/icon_address.png",
      "tag": "address"
    },
    {
      "title": "在线客服",
      "icon": "assets/images/icon_customer service.png",
      "tag": "customer"
    },
    {"title": "线下门店", "icon": "assets/images/icon_shop.png", "tag": "shop"},
    {"title": "招商加盟", "icon": "assets/images/icon_join_in.png", "tag": "join"},
    {"title": "设置", "icon": "assets/images/icon_setting.png", "tag": "setting"},
    {"title": "退出", "icon": "assets/images/icon_exit.png", "tag": "exit"},
  ];

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: titles.length, vsync: this);
  }

  final tabList = const [
    TabHome(),
    TabClassify(),
    TabPersonnelLibrary(),
    TabTalk(),
  ];

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return PageWidget(
          isCustom: tabIndex.value == 0 ? "big" : "short",
          title: getTitle(),
          drawer: getDrawer(),
          onResume: () {
            // Future.delayed(const Duration(seconds: 1), () {
            //   const Navigator().pushRoute(context, const Login());
            // });
          },
          onStart: () {
            // Future.delayed(const Duration(seconds: 1), () {
            //   const Navigator().pushRoute(context, const Login());
            // });
          },
          leading: Builder(
            builder: (BuildContext context) {
              return InkWell(
                onTap: () {
                  Scaffold.of(context).openDrawer();
                },
                child: Icon(
                  Icons.menu,
                  size: 30,
                  color: DSColors.white,
                ),
              );
            },
          ),
          action: [
            tabIndex.value == 0
                ? InkWell(
                    onTap: () async {
                      final temp = await CityPickers.showCityPicker(
                          context: context, showType: ShowType.pc);
                      UserController.instance.myCity(temp);
                    },
                    child: Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          size: 20,
                          color: DSColors.white,
                        ),
                        Text(
                          UserController.instance.myCity.value.cityName ??
                              "   ",
                          style: TextStyle(color: DSColors.white, fontSize: 14),
                        ),
                        Icon(
                          Icons.arrow_drop_down,
                          size: 20,
                          color: DSColors.white,
                        )
                      ],
                    ),
                  )
                : Container()
          ],
          body: Column(
            children: [
              Expanded(
                  child: TabBarView(
                controller: tabController,
                children: tabList,
              )),
              getAction(),
            ],
          ));
    });

    /*
    return Scaffold(
      body: Container(
        color: Colors.blue,
      ),
    );

     */
  }

  Widget getTitle() {
    return Obx(() {
      if (tabIndex.value == 0) {
        return Container();
      } else if (tabIndex.value == 1) {
        return Column(
          children: [
            Text("分类", style: TextStyle(color: DSColors.white, fontSize: 18)),
            const SizedBox(height: 2),
            Text("受到家庭的信赖，受照顾者的喜爱",
                style: TextStyle(color: DSColors.white, fontSize: 14)),
          ],
        );
      } else if (tabIndex.value == 2) {
        return Text("人员库",
            style: TextStyle(color: DSColors.white, fontSize: 18));
      } else {
        return Text("对话",
            style: TextStyle(color: DSColors.white, fontSize: 18));
      }
    });
  }

  Drawer getDrawer() {
    final bigList = <Widget>[];
    final itemList = <Widget>[];
    Widget last = Container();
    for (int i = 0; i < userItem.length; i++) {
      final item = userItem[i];
      if (i < 3) {
        bigList.add(InkWell(
            onTap: () {
              menuClick(i);
            },
            child: Column(children: [
              Image.asset(
                item["icon"].toString(),
                width: 35,
              ),
              const SizedBox(height: 2),
              Text(
                item["title"].toString(),
                style: TextStyle(color: DSColors.title, fontSize: 16),
              )
            ])));
      } else if (i == userItem.length - 1) {
        last = InkWell(
            onTap: () {
              menuClick(i);
            },
            child: SizedBox(
                height: 50,
                child: Row(children: [
                  Image.asset(
                    item["icon"].toString(),
                    width: 25,
                  ),
                  const SizedBox(width: 14),
                  Text(
                    item["title"].toString(),
                    style: TextStyle(color: DSColors.title, fontSize: 16),
                  )
                ])));
      } else {
        itemList.add(InkWell(
            onTap: () {
              menuClick(i);
            },
            child: SizedBox(
                height: 50,
                child: Row(children: [
                  Image.asset(
                    item["icon"].toString(),
                    width: 25,
                  ),
                  const SizedBox(width: 14),
                  Text(
                    item["title"].toString(),
                    style: TextStyle(color: DSColors.title, fontSize: 16),
                  )
                ]))));
      }
    }
    return Drawer(
      child: Container(
        color: DSColors.white,
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          children: [
            const SizedBox(height: 80),
            Obx(() {
              final user = UserController().userInfo.value;
              return Row(
                children: [
                  InkWell(
                    onTap: () {
                      if (user.id == null) {
                        const Navigator().pushRoute(context, const Login());
                      } else {
                        const Navigator()
                            .pushRoute(context, const PersonalMessage());
                      }
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(33),
                      child: user.faceUrl == null
                          ? Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                  border: Border.all(color: DSColors.title),
                                  shape: BoxShape.circle),
                              child: Icon(
                                Icons.person_outline,
                                size: 40,
                                color: DSColors.subTitle,
                              ),
                            )
                          : Image.network(
                              Util.getImage(id: user.faceUrl!),
                              width: 66,
                              height: 66,
                              fit: BoxFit.cover,
                            ),
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        if (user.id == null) {
                          const Navigator().pushRoute(context, const Login());
                        } else {
                          const Navigator()
                              .pushRoute(context, const PersonalMessage());
                        }
                      },
                      child: Text(
                        user.name ?? user.mobile ?? "点击登录",
                        style: TextStyle(color: DSColors.pinkRed, fontSize: 18),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: scan,
                    child: Image.asset(
                      "assets/images/icon_scan.png",
                      width: 20,
                      height: 20,
                    ),
                  )
                ],
              );
            }),
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: bigList,
            ),
            const SizedBox(height: 20),
            Column(
              children: itemList,
            ),
            const SizedBox(height: 45),
            last,
          ],
        ),
      ),
    );
  }

  Widget getAction() {
    return Obx(() {
      return Container(
        margin: EdgeInsets.only(
            left: 15, right: 15, bottom: Util.getBottomPadding()),
        height: 80,
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
          children: titles.asMap().keys.map((index) {
            final item = titles[index];
            return Expanded(
                child: InkWell(
              onTap: () {
                tabIndex(index);
                tabController.index = index;
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    tabIndex.value == index
                        ? item["icon"].toString()
                        : item["icon_p"].toString(),
                    width: 24,
                    height: 24,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item["title"].toString(),
                    style: TextStyle(
                        color: tabIndex.value == index
                            ? DSColors.primaryColor
                            : DSColors.subTitle,
                        fontSize: 10),
                  ),
                ],
              ),
            ));
          }).toList(),
        ),
      );
    });
  }

  void scan() {}

  void menuClick(int index) {
    final tag = userItem[index]["tag"].toString();

    if (tag == "setting") {
      const Navigator().pushRoute(context, const Setting());
    } else if (tag == "exit") {
      _handlePop();
    } else {
      if (UserController.instance.userInfo.value.id == null) {
        MToast.show("请先登录");
        const Navigator().pushRoute(context, const Login());
      } else {
        switch (tag) {
          case "collection":
            const Navigator().pushRoute(context, const Collection());
            break;
          case "order":
            const Navigator().pushRoute(context, const OrderList());
            break;
          case "wallet":
            const Navigator().pushRoute(context, const MyWallet());
            break;
          case "demand":
            const Navigator().pushRoute(context, const DemandList());
            break;
          case "address":
            const Navigator().pushRoute(context, const AddressList(type: 0));
            break;
          case "shop":
            const Navigator().pushRoute(context, const OfflineStores());
            break;
          case "join":
            const Navigator().pushRoute(
                context,
                const DemandList(
                  type: 1,
                ));
            break;
        }
      }
    }
  }

  /// 安卓物理按键返回
  void _handlePop() {
    showDialog<dynamic>(
        context: context,
        builder: (_) => AlertDialogs(
              title: "提示",
              view: const Text("是否退出心巢"),
              leftText: "确定",
              leftAction: () {
                exit(0);
              },
              rightAction: () {
                Navigator.pop(context);
              },
              rightText: "取消",
            ));
  }
}
