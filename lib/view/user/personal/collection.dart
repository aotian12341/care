import 'package:care/model/staff_list_info.dart';
import 'package:care/widget/loader.dart';
import 'package:care/widget/m_tab_bar.dart';
import 'package:care/widget/page_widget.dart';
import 'package:care/widget/view_ex.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../home_page/tab_personnel_library.dart';

/// 收藏
class Collection extends StatefulWidget {
  const Collection({Key? key}) : super(key: key);

  @override
  _CollectionState createState() => _CollectionState();
}

class _CollectionState extends State<Collection> {
  final tabIndex = 0.obs;

  int page = 1;

  final dataList = <String>[].obs;

  final loaderController = LoaderController();

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
        titleLabel: "收藏",
        isCustom: "short",
        body: Column(
          children: [getTab(), Expanded(child: getContent())],
        ));
  }

  Widget getTab() {
    return MTabBar(
        titles: ["全部", "家庭服务", "健康服务"],
        onChange: (index) {
          tabIndex(index);
          refresh();
        }).size(height: 50);
  }

  Widget getContent() {
    return Obx(() {
      return Loader(
          controller: loaderController,
          child: ListView.builder(
            itemCount: dataList.length,
            itemBuilder: (BuildContext context, int index) {
              return StaffItem(
                item: StaffListList(),
              );
            },
          ));
    });
  }
}
