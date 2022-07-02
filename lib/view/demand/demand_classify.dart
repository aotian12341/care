import 'package:care/constants/app_config.dart';
import 'package:care/widget/loader.dart';
import 'package:care/widget/main_button.dart';
import 'package:care/widget/navigator_ex.dart';
import 'package:care/widget/page_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../common/colors.dart';
import '../../common/util.dart';
import '../../controller/user_controller.dart';
import '../../model/dictionary_item.dart';
import '../../widget/m_image.dart';
import 'demand_form.dart';

class DemandClassify extends StatefulWidget {
  const DemandClassify({Key? key}) : super(key: key);

  @override
  _DemandClassifyState createState() => _DemandClassifyState();
}

class _DemandClassifyState extends State<DemandClassify> {
  final loaderController = LoaderController();

  final dataList = <DictionaryItem>[].obs;
  int page = 1;

  final widgetList = <Widget>[];

  final selectIndex = 9999.obs;

  Future<void> getData({bool isRefresh = false}) async {
    final temp = UserController().dictionaryOption["demandType"];

    if (temp != null) {
      selectIndex(9999);
      dataList.addAll(temp);
      loaderController.loadFinish(data: dataList, noMore: true);
    } else {
      loaderController.loadError();
    }
  }

  Future<bool> refresh() async {
    dataList.clear();
    await getData();
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
      isCustom: "short",
      title: Column(
        children: [
          Text(
            "发布需求",
            style: TextStyle(color: DSColors.white, fontSize: 18),
          ),
          Text(
            "你需要什么样的照顾？",
            style: TextStyle(color: DSColors.white, fontSize: 14),
          ),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          children: [Expanded(child: getView()), getAction()],
        ),
      ),
    );
  }

  Widget getView() {
    return Obx(() {
      if (widgetList.isEmpty) {
        for (int index = 0; index < dataList.length; index++) {
          final item = dataList[index];
          widgetList.add(Row(
            children: [
              MImage.network(
                Util.getImage(id: item.icon),
                width: 50,
                height: 70,
                fit: BoxFit.cover,
              ),
              const SizedBox(width: 30),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.value ?? "",
                      style: TextStyle(
                          color: DSColors.title,
                          fontWeight: FontWeight.bold,
                          fontSize: 14),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            "全职保姆为提供全日或者定期性的日常护理，全职保姆为提供全日或者定期性的日常护理",
                            style: TextStyle(
                              color: DSColors.title,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                              overflow: TextOverflow.ellipsis,
                            ),
                            maxLines: 2,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              )
            ],
          ));
        }
      }
      return Loader(
        onRefresh: refresh,
        controller: loaderController,
        child: Column(
          children: dataList.asMap().keys.map((index) {
            return InkWell(
                onTap: () {
                  selectIndex(index);
                },
                child: Container(
                  padding: const EdgeInsets.all(2),
                  margin: const EdgeInsets.only(bottom: 10),
                  height: 104,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    gradient: index == selectIndex.value
                        ? LinearGradient(
                            colors: [DSColors.pinkYellow, DSColors.pinkRed],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          )
                        : null,
                  ),
                  child: Container(
                    height: 100,
                    padding: const EdgeInsets.only(
                        left: 25, right: 15, top: 18, bottom: 18),
                    decoration: BoxDecoration(
                        color:
                            index == selectIndex.value ? null : DSColors.white,
                        borderRadius: BorderRadius.circular(12),
                        gradient: index == selectIndex.value
                            ? LinearGradient(
                                colors: [
                                    DSColors.white,
                                    const Color(0xfffbe5e9),
                                  ],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter)
                            : null),
                    child: widgetList[index],
                  ),
                ));
          }).toList(),
        ),
      );
    });
  }

  Widget getAction() {
    return MainButton(
      margin: EdgeInsets.only(bottom: Util.getBottomPadding(), top: 10),
      title: "下一步",
      width: 160,
      onTap: () {
        const Navigator().pushRoute(
            context,
            DemandForm(
              code: dataList[selectIndex.value].code ?? "",
            ));
      },
    );
  }
}
