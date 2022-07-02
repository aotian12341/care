import 'package:care/common/my_icon.dart';
import 'package:care/common/time_helper.dart';
import 'package:care/constants/app_config.dart';
import 'package:care/controller/staff_controller.dart';
import 'package:care/widget/loader.dart';
import 'package:care/widget/navigator_ex.dart';
import 'package:flutter/material.dart';
import 'package:flutter_picker/Picker.dart';
import 'package:get/get.dart';

import '../../common/colors.dart';
import '../../model/staff_list_info.dart';
import '../../widget/bottom_shell.dart';
import '../../widget/main_button.dart';
import '../../widget/rate.dart';
import '../staff/staff_details.dart';

class TabPersonnelLibrary extends StatefulWidget {
  const TabPersonnelLibrary({Key? key}) : super(key: key);

  @override
  _TabPersonnelLibraryState createState() => _TabPersonnelLibraryState();
}

class _TabPersonnelLibraryState extends State<TabPersonnelLibrary> {
  final keyword = TextEditingController();
  final loaderController = LoaderController();

  final dataList = <StaffListList>[].obs;

  int sortFilterIndex = 0;
  int page = 1;
  final sortFilterData = [
    {"title": "综合排序"},
    {"title": "好评优先"},
    {"title": "经验最多"},
  ];
  int typeFilterIndex = 0;
  final typeFilterData = [
    {"title": "全部"},
  ];

  final isOnline = false.obs;

  final serviceTime = "".obs;

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
      page++;
    }

    StaffController().getStaffList(
      page: page,
      district: "450107",
      success: (StaffListInfo value) {
        if (page == 1) {
          dataList.clear();
        }
        dataList.addAll(value.list ?? []);
        loaderController.loadFinish(
            data: dataList, noMore: dataList.length >= (value.totalCount ?? 0));
      },
      fail: (error) {
        loaderController.loadError(msg: error);
      },
    );

    // final temp = <String>[].obs;
    // for (int i = 0; i < 10; i++) {
    //   temp.add(i.toString());
    // }

    // dataList(temp);
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
    return Container(
      padding: const EdgeInsets.only(left: 15, right: 15, top: 20, bottom: 10),
      child: Column(
        children: [
          getSearch(),
          const SizedBox(height: 8),
          getFilter(),
          const SizedBox(height: 8),
          getServiceTime(),
          const SizedBox(height: 8),
          Expanded(child: getContent()),
        ],
      ),
    );
  }

  Widget getSearch() {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 30,
            padding: const EdgeInsets.symmetric(horizontal: 15),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: DSColors.white,
            ),
            child: Row(
              children: [
                Icon(MyIcon.icon_search_outline,
                    size: 18, color: DSColors.describe),
                const SizedBox(width: 12),
                Expanded(
                    child: TextField(
                  controller: keyword,
                  onChanged: (value) {},
                  decoration: const InputDecoration(
                      contentPadding: EdgeInsets.all(0),
                      border: OutlineInputBorder(borderSide: BorderSide.none),
                      hintText: "请输入关键字"),
                ))
              ],
            ),
          ),
        ),
        const SizedBox(width: 12),
        const MainText(
          "金牌优选",
          size: 16,
        )
      ],
    );
  }

  Widget getFilter() {
    return Obx(() {
      return Row(
        children: [
          Expanded(
            child: InkWell(
              onTap: showSortFilter,
              child: Container(
                height: 30,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: DSColors.white,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      sortFilterIndex == 0
                          ? "综合排序"
                          : sortFilterData[sortFilterIndex]["title"].toString(),
                      style: TextStyle(color: DSColors.title, fontSize: 14),
                    ),
                    const SizedBox(width: 6),
                    const Icon(
                      Icons.keyboard_arrow_down,
                      size: 20,
                    )
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: InkWell(
              onTap: showTypeFilter,
              child: Container(
                height: 30,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: DSColors.white,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      typeFilterIndex == 0
                          ? "护理类型"
                          : typeFilterData[typeFilterIndex]["title"].toString(),
                      style: TextStyle(color: DSColors.title, fontSize: 14),
                    ),
                    const SizedBox(width: 6),
                    const Icon(
                      Icons.keyboard_arrow_down,
                      size: 20,
                    )
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: InkWell(
              onTap: () {
                isOnline(!isOnline.value);
              },
              child: Container(
                height: 30,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: DSColors.white,
                ),
                alignment: Alignment.center,
                child: isOnline.value
                    ? const MainText(
                        "只看在线",
                        size: 14,
                      )
                    : Text(
                        "只看在线",
                        style:
                            TextStyle(color: DSColors.subTitle, fontSize: 14),
                      ),
              ),
            ),
          ),
        ],
      );
    });
  }

  Widget getServiceTime() {
    return InkWell(
      onTap: () {
        Picker(
            adapter: DateTimePickerAdapter(
              type: PickerDateTimeType.kYMD,
              isNumberMonth: true,
              yearSuffix: "年",
              monthSuffix: "月",
              daySuffix: "日",
              value: serviceTime.value.isEmpty
                  ? DateTime.now()
                  : DateTime.parse(serviceTime.value),
            ),
            confirmText: "确定",
            cancelText: "重置",
            confirmTextStyle:
                TextStyle(color: DSColors.primaryColor, fontSize: 14),
            cancelTextStyle: TextStyle(color: DSColors.title, fontSize: 14),
            onCancel: () {
              serviceTime("");
              getData();
            },
            onConfirm: (picker, selectIndex) {
              DateTime temp = (picker.adapter as DateTimePickerAdapter).value!;
              serviceTime(temp.format(format: "yyyy-MM-dd"));
              getData();
            }).showModal<dynamic>(context);
      },
      child: Container(
        height: 30,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: DSColors.white,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(serviceTime.value.isEmpty ? "服务时间" : serviceTime.value,
                style: TextStyle(color: DSColors.title, fontSize: 16)),
            const SizedBox(width: 8),
            Icon(
              Icons.calendar_today_outlined,
              size: 20,
              color: DSColors.pinkRed,
            ),
          ],
        ),
      ),
    );
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
              return InkWell(
                  onTap: () {
                    const Navigator().pushRoute(
                        context,
                        const StaffDetails(
                          type: 0,
                          staffId: "0",
                        ));
                  },
                  child: StaffItem(item: item));
            },
          ));
    });
  }

  void showSortFilter() {
    BottomShell.show(
        items: sortFilterData.map((item) {
          return BottomShellItem(title: item["title"].toString());
        }).toList(),
        select: sortFilterIndex,
        onChoose: (index) {
          sortFilterIndex = index;
          getData(isRefresh: true);
          Navigator.pop(context);
        });
  }

  void showTypeFilter() {
    BottomShell.show(
        items: typeFilterData.map((item) {
          return BottomShellItem(title: item["title"].toString());
        }).toList(),
        select: typeFilterIndex,
        onChoose: (index) {
          typeFilterIndex = index;
          getData(isRefresh: true);
          Navigator.pop(context);
        });
  }
}

class StaffItem extends StatelessWidget {
  const StaffItem({Key? key, required this.item}) : super(key: key);

  final StaffListList item;

  @override
  Widget build(BuildContext context) {
    final tags = ["有爱心", "本科学历", "特级保姆", "有爱心", "本科学历", "特级保姆"];
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: DSColors.white,
      ),
      child: Row(
        children: [
          Container(
            height: 100,
            width: 75,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: DSColors.divider)),
            child: Column(
              children: [
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(left: 8, right: 8, top: 8),
                    child: Image.network(
                      AppConfig.image,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Container(
                  height: 35,
                  alignment: Alignment.center,
                  child: 0 % 2 == 0
                      ? const MainText(
                          "保姆 | 医院陪护",
                          size: 9,
                        )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const MainText(
                              "医院陪护",
                              size: 9,
                            ),
                            Container(
                              height: 0.5,
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 12),
                              decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                      colors: [
                                    DSColors.pinkYellow,
                                    DSColors.pinkRed
                                  ],
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter)),
                            ),
                            const MainText(
                              "病人护理",
                              size: 9,
                            ),
                          ],
                        ),
                )
              ],
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
              child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text("李美雅",
                            style: TextStyle(
                                color: DSColors.title,
                                fontSize: 16,
                                fontWeight: FontWeight.bold)),
                        const SizedBox(width: 12),
                        Text("28岁",
                            style: TextStyle(
                              color: DSColors.describe,
                              fontSize: 12,
                            )),
                      ],
                    ),
                  ),
                  Icon(Icons.shopping_bag_rounded,
                      size: 20, color: DSColors.pinkRed),
                  const SizedBox(width: 4),
                  const MainText("5年经验", size: 12),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                      child: Text(
                    "我是具有五年经验的兼职保姆，最喜欢带小孩",
                    style: TextStyle(
                        color: DSColors.title,
                        fontSize: 12,
                        overflow: TextOverflow.ellipsis),
                  )),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                      child: Wrap(
                    spacing: 3,
                    runSpacing: 3,
                    children: tags.map((item) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 1),
                        decoration: BoxDecoration(
                          border:
                              Border.all(color: DSColors.pinkRed, width: 0.5),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(item.toString(),
                            style:
                                TextStyle(fontSize: 9, color: DSColors.title)),
                      );
                    }).toList(),
                  ))
                ],
              ),
              const SizedBox(height: 5),
              Row(
                children: [
                  Rate(
                    max: 5,
                    rate: 4.6,
                    selectedColor: DSColors.pinkRed,
                    unSelectedColor: DSColors.white,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    "50条评价",
                    style: TextStyle(color: DSColors.describe, fontSize: 9),
                  ),
                  Expanded(child: Container()),
                  Row(
                    children: [
                      Text("￥",
                          style: TextStyle(
                              fontSize: 12, color: DSColors.subTitle)),
                      const MainText("1500", size: 22),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text("起",
                              style: TextStyle(
                                  fontSize: 9, color: DSColors.subTitle)),
                          Text("/月",
                              style: TextStyle(
                                  fontSize: 12, color: DSColors.subTitle)),
                        ],
                      )
                    ],
                  )
                ],
              )
            ],
          ))
        ],
      ),
    );
  }
}
