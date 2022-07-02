import 'package:care/constants/app_config.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../common/colors.dart';
import '../../controller/user_controller.dart';
import '../../model/dictionary_item.dart';
import '../../widget/loader.dart';

class TabClassify extends StatefulWidget {
  const TabClassify({Key? key}) : super(key: key);

  @override
  _TabClassifyState createState() => _TabClassifyState();
}

class _TabClassifyState extends State<TabClassify> {
  final tabIndex = 0.obs;

  final serviceItem = DictionaryItem().obs;

  final serviceList = <DictionaryItem>[].obs;

  final loaderController = LoaderController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    Future.delayed(Duration.zero, () {
      getData();
      // loaderController.loadFinish();
    });
  }

  Future<bool> getData() async {
    const code1 = "101000";
    const code2 = "102000";

    loaderController.loading();

    final value = UserController()
        .getDictionaryByCode(code: tabIndex.value == 0 ? code1 : code2);

    if ((value?.items ?? []).isNotEmpty) {
      serviceList.clear();
      serviceList.addAll(value!.items!);
    }

    loaderController.loadFinish();

    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 15, right: 15, top: 20, bottom: 24),
      child: Column(
        children: [
          Container(
            height: 48,
            width: 260,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              color: DSColors.white,
            ),
            child: Obx(() {
              return Stack(
                children: [
                  Row(
                    mainAxisAlignment: tabIndex.value == 0
                        ? MainAxisAlignment.start
                        : MainAxisAlignment.end,
                    children: [
                      Container(
                        height: 48,
                        width: 140,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(24),
                            gradient: LinearGradient(
                              colors: [DSColors.pinkYellow, DSColors.pinkRed],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            )),
                        alignment: Alignment.center,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 48,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: () {
                            tabIndex(0);
                            getData();
                          },
                          child: Text(
                            "家庭服务",
                            style: TextStyle(
                              color: tabIndex.value == 0
                                  ? DSColors.white
                                  : DSColors.describe,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            tabIndex(1);
                            getData();
                          },
                          child: Text(
                            "健康服务",
                            style: TextStyle(
                              color: tabIndex.value == 1
                                  ? DSColors.white
                                  : DSColors.describe,
                              fontSize: 16,
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              );
            }),
          ),
          const SizedBox(height: 12),
          Expanded(child: getContent()),
        ],
      ),
    );
  }

  Widget getContent() {
    return Obx(() {
      // print(serviceList.length);
      final temp = <DictionaryItem>[];
      for (final dic in serviceList) {
        for (final item in (dic.items ?? [])) {
          temp.add(item);
        }
      }
      return Loader(
        controller: loaderController,
        onRefresh: getData,
        child: GridView.builder(
          itemCount: temp.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 14,
              crossAxisSpacing: 8,
              childAspectRatio: 185 / 140),
          itemBuilder: (BuildContext context, int index) {
            final item = temp[index];

            return ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Container(
                color: DSColors.white,
                child: Column(
                  children: [
                    Expanded(
                        child: Image.network(
                      AppConfig.image,
                      fit: BoxFit.cover,
                    )),
                    Container(
                      height: 25,
                      alignment: Alignment.center,
                      child: Text(item.value ?? "",
                          style:
                              TextStyle(color: DSColors.title, fontSize: 12)),
                    )
                  ],
                ),
              ),
            );
          },
        ),
      );
    });
  }
}
