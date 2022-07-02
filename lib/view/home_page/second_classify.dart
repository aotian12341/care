import 'package:care/common/util.dart';
import 'package:care/constants/app_config.dart';
import 'package:care/widget/loader.dart';
import 'package:care/widget/main_button.dart';
import 'package:care/widget/page_widget.dart';
import 'package:flutter/material.dart';
import 'package:care/widget/view_ex.dart';
import 'package:get/get.dart';

import '../../common/colors.dart';
import '../../common/my_icon.dart';

/// 二级分类页
class SecondClassify extends StatefulWidget {
  const SecondClassify({Key? key, required this.title, required this.code})
      : super(key: key);

  final String title;
  final String code;

  @override
  State<SecondClassify> createState() => _SecondClassifyState();
}

class _SecondClassifyState extends State<SecondClassify> {
  final loaderController = LoaderController();

  final dataList = <String>[].obs;

  Future<void> refresh() async {
    final temp = <String>[];
    for (int i = 0; i < 10; i++) {
      temp.add(i.toString());
    }
    dataList.clear();
    dataList.addAll(temp);
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
    return PageWidget(
        titleLabel: widget.title,
        isCustom: "short",
        body: Stack(
          children: [
            getContent().padding(padding: const EdgeInsets.only(bottom: 50)),
            Positioned(left: 0, right: 0, bottom: 0, child: getAction())
          ],
        ));
  }

  Widget getContent() {
    return Obx(() {
      return Loader(
          onRefresh: refresh,
          controller: loaderController,
          child: ListView.builder(
            itemCount: dataList.length,
            itemBuilder: (BuildContext context, int index) {
              return Stack(
                children: [
                  Image.network(
                    AppConfig.image,
                    height: 200,
                    fit: BoxFit.cover,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      "做饭".t.s(16).c(DSColors.white),
                    ],
                  )
                      .padding(
                          padding: const EdgeInsets.symmetric(vertical: 12))
                      .color(DSColors.title.withOpacity(0.6)),
                  Positioned(
                      left: 0,
                      right: 0,
                      bottom: 0,
                      child: Column(
                        children: [
                          MainButton(
                            height: 30,
                            width: 120,
                            title: "查看",
                          ),
                          8.v,
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              "中餐、西餐、日式料理、韩国料理、川菜、".t.s(14).c(DSColors.white),
                            ],
                          ),
                          12.v
                        ],
                      ))
                ],
              )
                  .paddingAll(12)
                  .border(color: DSColors.divider)
                  .borderRadius(radius: 12)
                  .margin(margin: EdgeInsets.only(bottom: 12));
            },
          ));
    });
  }

  Widget getAction() {
    if (widget.code == "2") {
      return Stack(
        alignment: Alignment.topCenter,
        children: [
          Container(
            height: 45 + Util.getBottomPadding(),
            padding: EdgeInsets.only(bottom: Util.getBottomPadding()),
            margin: const EdgeInsets.only(top: 40),
            color: DSColors.title,
            child: "叫保洁".t.c(DSColors.white).s(14),
            alignment: Alignment.bottomCenter,
          ),
          Positioned(
              child: Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: DSColors.primaryColor,
              border: Border.all(width: 8, color: DSColors.white),
            ),
            child: Center(
              child: Icon(
                Icons.near_me,
                size: 20,
                color: DSColors.white,
              ),
            ),
          ))
        ],
      );
    } else {
      return Container();
    }
  }
}
