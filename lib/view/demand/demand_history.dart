import 'package:care/view/demand/demand_list.dart';
import 'package:care/widget/navigator_ex.dart';
import 'package:care/widget/page_widget.dart';
import 'package:care/widget/view_ex.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/demand_controller.dart';
import '../../model/demand_page.dart';
import '../../widget/loader.dart';
import 'demand_details.dart';

/// 历史需求
class DemandHistory extends StatefulWidget {
  const DemandHistory({Key? key}) : super(key: key);

  @override
  State<DemandHistory> createState() => _DemandHistoryState();
}

class _DemandHistoryState extends State<DemandHistory> {
  int page = 1;

  final loaderController = LoaderController();

  final dataList = <DemandPagesList>[].obs;

  Future<bool> refresh() async {
    await getData(isRefresh: true);

    return true;
  }

  Future<void> getData({bool isRefresh = false}) async {
    if (isRefresh) {
      page = 1;
      dataList.clear();
      loaderController.loading();
    } else {
      page += 1;
    }

    /// 进行中105091，105092，历史传105093，105094
    DemandController().getDemandList(
        status: "105093,105094",
        success: (DemandPage value) {
          dataList.addAll(value.list ?? []);

          loaderController.loadFinish(
              data: dataList.length,
              noMore: dataList.length >= (value.totalCount ?? 0));
        },
        fail: (error) {
          loaderController.loadError(msg: error);
        });
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
        titleLabel: "历史需求",
        isCustom: "short",
        body: Obx(() {
          return Loader(
              onRefresh: refresh,
              onLoad: getData,
              controller: loaderController,
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
                        if (value) {
                          refresh();
                        }
                      });
                    });
                  }));
        }));
  }
}
