import 'package:care/common/colors.dart';
import 'package:care/constants/app_config.dart';
import 'package:care/view/demand/demand_list.dart';
import 'package:care/widget/loader.dart';
import 'package:care/widget/main_button.dart';
import 'package:care/widget/page_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:care/widget/view_ex.dart';
import 'package:care/widget/navigator_ex.dart';

/// 发布成功
class DemandSuccess extends StatefulWidget {
  const DemandSuccess({Key? key}) : super(key: key);

  @override
  _DemandSuccessState createState() => _DemandSuccessState();
}

class _DemandSuccessState extends State<DemandSuccess> {
  final loaderController = LoaderController();

  final dataList = <String>[].obs;

  Future<void> getData() async {
    loaderController.loadFinish();
  }

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () {
      getData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return PageWidget(
        isCustom: "short",
        body: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Column(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      "发布成功".t.s(24).c(DSColors.title),
                      24.v,
                      MainButton(
                        width: 190,
                        title: "提醒接单",
                        onTap: () {},
                      ),
                    ],
                  ).expanded(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      "继续发布".t.s(14).c(DSColors.title).onTap(() {
                        Navigator.pop(context);
                      }),
                      "我的需求单".t.s(14).c(DSColors.title).onTap(() {
                        NavigatorState navigator = Navigator.of(context)
                          ..pop()
                          ..pop();

                        navigator.widget.pushRoute(context, const DemandList());
                      })
                    ],
                  ).size(height: 50).padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16))
                ],
              ).size(height: 300),
            ),
            SliverToBoxAdapter(
              child: Loader(
                controller: loaderController,
                shrinkWrap: true,
                onRefresh: getData,
                onLoad: getData,
                physics: const NeverScrollableScrollPhysics(),
                child: Column(
                  children: [
                    24.v,
                    Row(
                      children: [
                        getItem().expanded(),
                        24.h,
                        Column(
                          children: [
                            getItem().expanded(),
                            12.v,
                            getItem().expanded()
                          ],
                        ).expanded()
                      ],
                    ).size(height: 300)
                  ],
                ).padding(padding: const EdgeInsets.symmetric(horizontal: 16)),
              ),
            )
          ],
        ));
  }

  Widget getItem() {
    return Column(
      children: [
        Row(
          children: ["优秀保姆".t.s(14).c(DSColors.title)],
        ),
        12.v,
        Expanded(
          child: Stack(
            children: [
              Row(),
              Positioned(
                left: 0,
                right: 0,
                top: 0,
                bottom: 0,
                child: Image.network(
                  AppConfig.image,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                  right: 0,
                  top: 0,
                  child: "GO>>"
                      .t
                      .s(12)
                      .c(DSColors.white)
                      .padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 2))
                      .borderRadius(radius: 3)
                      .color(DSColors.primaryColor))
            ],
          ),
        )
      ],
    );
  }
}
