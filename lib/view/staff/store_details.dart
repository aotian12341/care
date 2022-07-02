import 'package:card_swiper/card_swiper.dart';
import 'package:care/model/staff_list_info.dart';
import 'package:care/widget/key_value_view.dart';
import 'package:care/widget/loader.dart';
import 'package:care/widget/m_tab_bar.dart';
import 'package:care/widget/navigator_ex.dart';
import 'package:care/widget/page_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:care/widget/view_ex.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../common/colors.dart';
import '../../constants/app_config.dart';
import '../../widget/m_toast.dart';
import '../home_page/tab_personnel_library.dart';
import 'staff_details.dart';

/// 门店详情
class StoreDetails extends StatefulWidget {
  const StoreDetails({Key? key}) : super(key: key);

  @override
  State<StoreDetails> createState() => _StoreDetailsState();
}

class _StoreDetailsState extends State<StoreDetails> {
  final tabIndex = 0.obs;

  final dataList = <String>[].obs;

  final list = <Widget>[];

  final loaderController = LoaderController();

  Future<void> refresh() async {
    loaderController.loading();
    getData();
    getStaffList();
  }

  void getData() {}

  void getStaffList() {
    final temp = <String>[];
    for (int i = 0; i < 10; i++) {
      temp.add(i.toString());
    }
    dataList(temp);

    loaderController.loadFinish();
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
    if (list.isEmpty) {
      list.add(getSwiper());
      list.add(getContent());
    }
    return PageWidget(
        titleLabel: "门店详情",
        isCustom: "short",
        body: Loader(
            controller: loaderController,
            child: SingleChildScrollView(
              child: Column(
                children: list,
              ),
            )));
  }

  Widget getSwiper() {
    return Swiper(
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
    ).size(height: 180);
  }

  Widget getContent() {
    return Obx(() {
      return Column(
        children: [
          Row(
            children: [
              MTabBar(
                  titles: const ["人员", "商家"],
                  onChange: (value) {
                    tabIndex(value);
                  }).size(width: MediaQuery.of(context).size.width / 2)
            ],
          ).size(height: 50).color(DSColors.white),
          12.v,
          IndexedStack(
            children: [
              getStaff(),
              getStore(),
            ],
            index: tabIndex.value,
          ),
        ],
      );
    });
  }

  Widget getStaff() {
    return MediaQuery.removePadding(
      context: context,
      removeTop: true,
      removeBottom: true,
      child: ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: dataList.length,
        itemBuilder: (BuildContext context, int index) {
          return InkWell(
              onTap: () {
                const Navigator().pushRoute(
                    context,
                    const StaffDetails(
                      type: 0,
                      staffId: "0",
                    ));
              },
              child: StaffItem(item:StaffListList(),)
                  .padding(padding: const EdgeInsets.symmetric(horizontal: 12)));
        },
      ),
    );
  }

  Widget getStore() {
    return Column(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                "门店地址：我是门店地址我是门店地址我是门店地址我是门店地址我是门店地址我是门店地址我是门店地址我是门店地址我是门店地址我是门店地址"
                    .t
                    .s(16)
                    .c(DSColors.title)
                    .padding(padding: const EdgeInsets.symmetric(vertical: 12))
                    .borderOnly(bottom: BorderSide(color: DSColors.divider))
                    .flexible()
              ],
            ),
            KeyValueView(
              height: 44,
              showBorder: true,
              showIcon: true,
              title: "联系电话",
              value: "0771-3333333",
              icon: Container(
                width: 25,
                height: 25,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.5),
                  border: Border.all(color: DSColors.primaryColor),
                ),
                child: Icon(
                  Icons.call_outlined,
                  size: 20,
                  color: DSColors.primaryColor,
                ),
              ),
              onTap: () async {
                String url = 'tel:0771-3333333';
                if (await canLaunch(url)) {
                  await launch(url);
                } else {
                  MToast.show("无法创建通话，请自行拨号");
                }
              },
            ),
            KeyValueView(
                height: 44,
                showBorder: true,
                showIcon: true,
                title: "",
                titleWidth: 0,
                value: "查看上架资质档案",
                onTap: () {}),
            12.v,
            "门店展示".t.s(16).c(DSColors.title),
            12.v,
            Row(
              children: [
                Expanded(
                    child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Wrap(
                    spacing: 10,
                    children: List.generate(5, (index) {
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: Image.network(
                          AppConfig.image,
                          width: 120,
                          height: 90,
                          fit: BoxFit.cover,
                        ),
                      );
                    }),
                  ),
                )),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.menu,
                          size: 20,
                          color: DSColors.subTitle,
                        ),
                        4.h,
                        Icon(
                          Icons.chevron_right,
                          size: 15,
                          color: DSColors.subTitle,
                        ),
                      ],
                    ),
                    4.v,
                    "查看更多".t.s(12).c(DSColors.subTitle),
                  ],
                ).size(height: 90, width: 80).onTap(() {}),
                24.v,
              ],
            ),
            12.v,
            "营业时间：09:00 —— 18:30".t.s(16).c(DSColors.subTitle),
            24.v,
          ],
        )
            .color(DSColors.white)
            .padding(padding: const EdgeInsets.symmetric(horizontal: 12))
            .margin(margin: const EdgeInsets.symmetric(horizontal: 12))
            .borderRadius(radius: 8),
        12.v,
        Column(
          children: [
            KeyValueView(
              height: 44,
              showBorder: true,
              title: "商家加盟电话: 02988888888",
              showIcon: true,
              icon: Container(
                width: 25,
                height: 25,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.5),
                    color: DSColors.primaryColor),
                child: Icon(
                  Icons.call_outlined,
                  size: 20,
                  color: DSColors.white,
                ),
              ),
              onTap: () async {
                String url = 'tel:0771-3333333';
                if (await canLaunch(url)) {
                  await launch(url);
                } else {
                  MToast.show("无法创建通话，请自行拨号");
                }
              },
            ),
            KeyValueView(
              title: "查看上架加盟手册",
              showIcon: true,
              showBorder: false,
              onTap: () {},
            )
          ],
        )
            .borderRadius(radius: 8)
            .color(DSColors.white)
            .margin(margin: const EdgeInsets.symmetric(horizontal: 12)),
      ],
    );
  }
}
