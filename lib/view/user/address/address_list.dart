import 'package:care/model/address_info.dart';
import 'package:care/view/user/address/address_edit.dart';
import 'package:care/widget/loader.dart';
import 'package:care/widget/navigator_ex.dart';
import 'package:care/widget/page_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../common/colors.dart';
import '../../../common/my_icon.dart';
import '../../../controller/address_controller.dart';

class AddressList extends StatefulWidget {
  const AddressList({Key? key, required this.type}) : super(key: key);

  /// 页面类型，0是正常显示，1是选择
  final int type;

  @override
  _AddressListState createState() => _AddressListState();
}

class _AddressListState extends State<AddressList> {
  final loaderController = LoaderController();

  final dataList = <AddressInfo>[].obs;
  int page = 1;

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

    AddressController().getAddressList(success: (value) {
      dataList.addAll(value);
      loaderController.loadFinish();
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
      isCustom: "short",
      backgroundColor: DSColors.white,
      titleLabel: widget.type == 0 ? "地址列表" : "选择地址",
      action: [
        InkWell(
          onTap: () {
            const Navigator()
                .pushRoute(context, const AddressEdit())
                .then((value) {
              if (value) {
                refresh();
              }
            });
          },
          child: Row(
            children: [
              Icon(
                Icons.add,
                color: DSColors.white,
                size: 20,
              ),
              const SizedBox(width: 2),
              Text(
                "新增地址",
                style: TextStyle(color: DSColors.white, fontSize: 12),
              )
            ],
          ),
        )
      ],
      body: Obx(() {
        return Loader(
          controller: loaderController,
          onRefresh: refresh,
          child: ListView.builder(
            itemCount: dataList.length,
            itemBuilder: (BuildContext context, int index) {
              final item = dataList[index];
              return Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                    border:
                        Border(bottom: BorderSide(color: DSColors.divider))),
                margin: const EdgeInsets.only(bottom: 10),
                child: Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          if (widget.type == 1) {
                            Navigator.pop(context, item);
                          } else {
                            const Navigator()
                                .pushRoute(
                                    context,
                                    AddressEdit(
                                      info: item,
                                    ))
                                .then((value) {
                              if (value ?? false) {
                                refresh();
                              }
                            });
                          }
                        },
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  item.contacts ?? "",
                                  style: TextStyle(
                                      color: DSColors.title, fontSize: 14),
                                ),
                                Text(
                                  item.telephone ?? "",
                                  style: TextStyle(
                                      color: DSColors.title, fontSize: 14),
                                )
                              ],
                            ),
                            const SizedBox(height: 6),
                            Row(
                              children: [
                                Expanded(
                                    child: Text(
                                  "${item.province ?? ""}${item.city ?? ""}${item.district ?? ""}${item.address ?? ""}",
                                  style: TextStyle(
                                      color: DSColors.subTitle, fontSize: 14),
                                )),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        const Navigator()
                            .pushRoute(
                                context,
                                AddressEdit(
                                  info: item,
                                ))
                            .then((value) {
                          if (value ?? false) {
                            refresh();
                          }
                        });
                      },
                      child: Container(
                        width: 40,
                        alignment: Alignment.centerRight,
                        child: Icon(
                          MyIcon.icon_edit2,
                          size: 20,
                          color: DSColors.title,
                        ),
                      ),
                    )
                  ],
                ),
              );
            },
          ),
        );
      }),
    );
  }
}
