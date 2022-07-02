import 'package:care/common/util.dart';
import 'package:care/controller/demand_controller.dart';
import 'package:care/model/address_info.dart';
import 'package:care/view/demand/widget/demand_interaction.dart';
import 'package:care/view/demand/widget/demand_money.dart';
import 'package:care/view/demand/widget/demand_radio.dart';
import 'package:care/view/demand/widget/demand_service_date.dart';
import 'package:care/view/user/address/address_list.dart';
import 'package:care/widget/main_button.dart';
import 'package:care/widget/navigator_ex.dart';
import 'package:care/widget/page_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_picker/Picker.dart';
import 'package:get/get.dart';

import '../../common/colors.dart';
import '../../model/form_info.dart';
import '../../widget/alert_dialogs.dart';
import '../../widget/bottom_shell.dart';
import '../../widget/key_input_view.dart';
import '../../widget/key_value_view.dart';
import '../../widget/m_toast.dart';
import 'demand_success.dart';

class DemandForm extends StatefulWidget {
  const DemandForm({Key? key, required this.code}) : super(key: key);

  final String code;

  @override
  _DemandFormState createState() => _DemandFormState();
}

class _DemandFormState extends State<DemandForm> {
  final dataList = <FormInfo>[];

  final viewList = <List<Widget>>[];
  final tabBarViews = <Widget>[];

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () {
      getData();
    });
  }

  Future<void> getData() async {
    final value =
        DemandController().demandTemplate(code: widget.code /*"106005"*/);
    dataList.addAll(value);

    setState(() {});
  }

  final tabIndex = 0.obs;

  @override
  Widget build(BuildContext context) {
    return PageWidget(
        isCustom: "short",
        titleLabel: "需求发布",
        backgroundColor: DSColors.white,
        body: Column(
          children: [
            getAddressView(),
            getTab(),
            Expanded(child: getContent()),
          ],
        ));
  }

  Widget getTab() {
    final titles = dataList
        .asMap()
        .keys
        .map((int index) => (index + 1).toString())
        .toList();
    if (titles.isEmpty) {
      return Container();
    }
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: DSColors.divider))),
      child: Obx(() {
        if (titles.isEmpty) {
          return Container();
        }
        final list = <Widget>[];
        for (int index = 0; index < titles.length; index++) {
          list.add(Expanded(
            child: InkWell(
              onTap: () {
                if (index < tabIndex.value) {
                  tabIndex(index);
                } else if (nextCheck(dataList[tabIndex.value])) {
                  tabIndex(index);
                }
              },
              child: Container(
                height: 20,
                decoration: BoxDecoration(
                    color: tabIndex.value == index
                        ? DSColors.primaryColor
                        : DSColors.white,
                    border: Border.all(
                        color: DSColors.describe,
                        width: tabIndex.value == index ? 0 : 1),
                    borderRadius: BorderRadius.circular(8)),
                child: Center(
                  child: Text(
                    titles[index].toString(),
                    style: TextStyle(
                        color: tabIndex.value == index
                            ? DSColors.white
                            : DSColors.primaryColor),
                  ),
                ),
              ),
            ),
          ));
          list.add(Container(
            width: 30,
          ));
        }
        list.removeLast();
        return Container(
          alignment: Alignment.center,
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: list,
          ),
        );
      }),
    );
  }

  Widget getAddressView() {
    FormItem? item;
    for (final temp in dataList) {
      for (final child in temp.children ?? []) {
        if (child.type == "address") {
          item = child;
        }
      }
    }
    if (item == null) {
      return Container();
    } else {
      return getAddress(item);
    }
  }

  Widget getContent() {
    if (viewList.isEmpty) {
      for (final temp in dataList) {
        if ((temp.children ?? []).isNotEmpty) {
          final views = <Widget>[];
          for (final info in temp.children!) {
            if (info.type == "option") {
              views.add(getOption(info));
            } else if (info.type == "input") {
              views.add(getInput(info));
            } else if (info.type == "address") {
              // views.add(getAddress(info));
            } else if (info.type == "date") {
              views.add(getDate(info));
            } else if (info.type == "duration") {
              views.add(getDuration(info));
            } else if (info.type == "text") {
              views.add(getText(info));
            } else if (info.type == "money") {
              views.add(DemandMoney(item: info));
            } else if (info.type == "interaction") {
              views.add(DemandInteraction(item: info));
            } else if (info.type == "radio") {
              views.add(DemandRadio(item: info));
            } else if (info.type == "serviceDate") {
              views.add(DemandServiceDate(item: info));
            } else if (info.type == "area") {
              views.add(getArea(info));
            }
          }
          viewList.add(views);
        }
      }
    }

    return Obx(() {
      return IndexedStack(
        index: tabIndex.value,
        children: viewList.asMap().keys.map((index) {
          return getView(index);
        }).toList(),
      );
    });
  }

  Widget getView(int index) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: viewList[index],
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(
              horizontal: 16, vertical: Util.getBottomPadding()),
          child: getActon(index),
        ),
      ],
    );
  }

  Widget getActon(int index) {
    if (index == 0 && viewList.length > 1) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          MainButton(
            width: 200,
            margin: const EdgeInsets.symmetric(horizontal: 16),
            title: "下一步",
            onTap: () {
              if (nextCheck(dataList[index])) {
                tabIndex(tabIndex.value + 1);
              }
            },
          ),
        ],
      );
    } else if (viewList.length == 1) {
      return Row(
        children: [
          Expanded(
            child: MainButton(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              title: "发布",
              onTap: () {
                if (nextCheck(dataList[index])) {
                  submit();
                }
              },
            ),
          ),
        ],
      );
    } else if (index > 0 && index <= viewList.length - 1) {
      return Row(
        children: [
          Expanded(
            child: MainButton(
              title: "上一步",
              color: DSColors.describe,
              onTap: () {
                tabIndex(tabIndex.value - 1);
              },
            ),
          ),
          const SizedBox(width: 30),
          Expanded(
            flex: 2,
            child: MainButton(
              title: "发布",
              onTap: () {
                if (nextCheck(dataList[index])) {
                  submit();
                }
              },
            ),
          )
        ],
      );
    } else {
      return Row(
        children: [
          Expanded(
            child: MainButton(
              title: "上一步",
              onTap: () {
                tabIndex(tabIndex.value - 1);
              },
            ),
          ),
          const SizedBox(width: 30),
          Expanded(
            child: MainButton(
              title: "下一步",
              onTap: () {
                if (nextCheck(dataList[index])) {
                  tabIndex(tabIndex.value + 1);
                }
              },
            ),
          )
        ],
      );
    }
  }

  Widget getInput(FormItem item) {
    final text = item.controller;

    if (item.value != null) {
      text.text = item.value.toString();
    }

    return KeyInputView(
      title: item.title ?? "",
      controller: text,
      hint: item.hint ?? "",
      textAlign: TextAlign.end,
      lines: item.type == "area" ? 10 : 1,
      onChange: (value) {
        item.value = value;
      },
    );
  }

  Widget getArea(FormItem item) {
    final controller = TextEditingController();
    if (item.value != null) {
      controller.text = item.value!;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 12),
          Text(
            item.title ?? "",
            style: TextStyle(color: DSColors.title, fontSize: 16),
          ),
          const SizedBox(height: 12),
          Container(
            height: 150,
            padding: const EdgeInsets.all(8),
            decoration:
                BoxDecoration(border: Border.all(color: DSColors.divider)),
            child: TextField(
              maxLines: 20,
              controller: controller,
              decoration: InputDecoration(
                  border: InputBorder.none, hintText: item.hint ?? ""),
              onChanged: (value) {
                item.value = value;
              },
            ),
          )
        ],
      ),
    );
  }

  Widget getDate(FormItem item) {
    /*
    final value = "".obs;
    final array = UserController().dictionaryOption["timeRangeType"];
    final list = <FormItemOption>[];
    if (array != null) {
      for (final info in array) {
        list.add(
            FormItemOption.fromJson({"key": info.code, "value": info.value}));
      }
      item.list = list;
    }

    /// 当期日期
    return Column(
      children: [
        Calendar(onChoose: (start, end) {
          item.value2 = start + "--" + end;
        }),
        Obx(() {
          return KeyValueView(
            title: item.title1 ?? "",
            titleSize: 16,
            valueLeft: false,
            value: value.value.isEmpty ? item.hint1 : value.value,
            valueSize: 16,
            valueColor:
                value.value.isEmpty ? DSColors.describe : DSColors.title,
            showIcon: true,
            onTap: () {
              BottomShell.show(
                  items: item.list!.asMap().keys.map((index) {
                    return BottomShellItem(
                        title: item.list![index].value ?? "");
                  }).toList(),
                  onChoose: (index) {
                    value(item.list![index].value ?? "");
                    item.value1 = item.list![index].key;
                    Navigator.pop(context);
                  });
            },
          );
        })
      ],
    );

     */
    return Container();
  }

  Widget getDuration(FormItem item) {
    final value1 = "".obs;
    final value2 = "".obs;
    value1((item.value1 ?? "").toString());
    value2((item.value2 ?? "").toString());

    return Obx(() {
      return Column(
        children: [
          KeyValueView(
            valueLeft: false,
            title: item.title1.toString(),
            titleSize: 16,
            value: value1.value.isEmpty ? item.hint1 : value1.value,
            valueSize: 16,
            showIcon: true,
            valueColor:
                value1.value.isEmpty ? DSColors.describe : DSColors.title,
            onTap: () {
              /*
              DateTime value = DateTime.now();
              if (value1.isNotEmpty) {
                value = DateTime.now().copyWith(
                    hour: num.parse(value1.value.split(":")[0]).toInt(),
                    minute: num.parse(value1.value.split(":")[1]).toInt());
              }
              Picker(
                  adapter: DateTimePickerAdapter(
                    type: PickerDateTimeType.kHM,
                    isNumberMonth: true,
                    // yearSuffix: "年",
                    // monthSuffix: "月",
                    // daySuffix: "日",
                    hourSuffix: "时",
                    minuteSuffix: "分",
                    value: value,
                  ),
                  confirmText: "确定",
                  cancelText: "取消",
                  confirmTextStyle:
                      TextStyle(color: DSColors.primaryColor, fontSize: 14),
                  cancelTextStyle:
                      TextStyle(color: DSColors.title, fontSize: 14),
                  onConfirm: (picker, selectIndex) {
                    DateTime temp =
                        (picker.adapter as DateTimePickerAdapter).value!;
                    value1(temp.format(format: "HH:mm"));
                    item.value1 = value1.value;
                    value2("");
                    item.value2 = value2.value;
                  }).showModal<dynamic>(context);

               */

              final array = [
                [
                  "00",
                  "01",
                  "02",
                  "03",
                  "04",
                  "05",
                  "06",
                  "07",
                  "08",
                  "09",
                  "10",
                  "11",
                  "12",
                  "13",
                  "14",
                  "15",
                  "16",
                  "17",
                  "18",
                  "19",
                  "20",
                  "21",
                  "22",
                  "23"
                ],
                ["00", "30"]
              ];

              final select = <int>[];
              if (value1.isNotEmpty) {
                final temp = value1.split(":");
                for (int i = 0; i < temp.length; i++) {
                  if (i == 0) {
                    for (int j = 0; j < array[0].length; j++) {
                      if (temp[i] == array[0][j]) {
                        select.add(j);
                        break;
                      }
                    }
                  } else if (i == 1) {
                    for (int j = 0; j < array[1].length; j++) {
                      if (temp[i] == array[1][j]) {
                        select.add(j);
                        break;
                      }
                    }
                  }
                }
              }

              Picker(
                  adapter: PickerDataAdapter<String>(
                    pickerdata: array,
                    isArray: true,
                  ),
                  title: Text(
                    "请选择时间",
                    style: TextStyle(color: DSColors.title, fontSize: 16),
                  ),
                  selecteds: select,
                  confirmText: "确定",
                  cancelText: "取消",
                  confirmTextStyle:
                      TextStyle(color: DSColors.primaryColor, fontSize: 14),
                  cancelTextStyle:
                      TextStyle(color: DSColors.title, fontSize: 14),
                  onConfirm: (Picker picker, List value) {
                    final temp = array[0][value[0]] + ":" + array[1][value[1]];
                    value1(temp);
                    item.value1 = value1.value;
                    value2("");
                    item.value2 = value2.value;
                  }).showModal<dynamic>(context);
            },
          ),
          KeyValueView(
            valueLeft: false,
            title: item.title2 ?? "",
            titleSize: 16,
            value: value2.value.isEmpty ? item.hint2 : value2.value,
            valueSize: 16,
            showIcon: true,
            valueColor:
                value2.value.isEmpty ? DSColors.describe : DSColors.title,
            onTap: () {
              final array = [
                [
                  "00",
                  "01",
                  "02",
                  "03",
                  "04",
                  "05",
                  "06",
                  "07",
                  "08",
                  "09",
                  "10",
                  "11",
                  "12",
                  "13",
                  "14",
                  "15",
                  "16",
                  "17",
                  "18",
                  "19",
                  "20",
                  "21",
                  "22",
                  "23"
                ],
                ["00", "30"]
              ];

              final select = <int>[];
              if (value1.isNotEmpty && value2.isEmpty) {
                final value1Select = <int>[];
                final temp = value1.split(":");
                for (int i = 0; i < temp.length; i++) {
                  if (i == 0) {
                    for (int j = 0; j < array[0].length; j++) {
                      if (temp[i] == array[0][j]) {
                        value1Select.add(j);
                        break;
                      }
                    }
                  } else if (i == 1) {
                    for (int j = 0; j < array[1].length; j++) {
                      if (temp[i] == array[1][j]) {
                        value1Select.add(j);
                        break;
                      }
                    }
                  }
                }

                select.add(value1Select[0] + 1);
                select.add(value1Select[1]);
              }
              if (value2.isNotEmpty) {
                final temp = value2.split(":");
                for (int i = 0; i < temp.length; i++) {
                  if (i == 0) {
                    for (int j = 0; j < array[0].length; j++) {
                      if (temp[i] == array[0][j]) {
                        select.add(j);
                        break;
                      }
                    }
                  } else if (i == 1) {
                    for (int j = 0; j < array[1].length; j++) {
                      if (temp[i] == array[1][j]) {
                        select.add(j);
                        break;
                      }
                    }
                  }
                }
              }

              Picker(
                  adapter: PickerDataAdapter<String>(
                    pickerdata: array,
                    isArray: true,
                  ),
                  title: Text(
                    "请选择时间",
                    style: TextStyle(color: DSColors.title, fontSize: 16),
                  ),
                  selecteds: select,
                  confirmText: "确定",
                  cancelText: "取消",
                  confirmTextStyle:
                      TextStyle(color: DSColors.primaryColor, fontSize: 14),
                  cancelTextStyle:
                      TextStyle(color: DSColors.title, fontSize: 14),
                  onConfirm: (Picker picker, List value) {
                    final temp = array[0][value[0]] + ":" + array[1][value[1]];
                    value2(temp);
                    item.value2 = value2.value;
                  }).showModal<dynamic>(context);
              /*
              DateTime time = DateTime.now();
              if (value1.isNotEmpty) {
                time = DateTime.now().copyWith(
                    hour: num.parse(value1.value.split(":")[0]).toInt(),
                    minute: num.parse(value1.value.split(":")[1]).toInt());
              }
              final minValue = value1.isNotEmpty ? time : null;

              DateTime value = DateTime.now();
              if (value2.value.isEmpty) {
                value = time;
              } else {
                value = DateTime.now().copyWith(
                    hour: num.parse(value2.value.split(":")[0]).toInt(),
                    minute: num.parse(value2.value.split(":")[1]).toInt());
              }
              Picker(
                  adapter: DateTimePickerAdapter(
                    type: PickerDateTimeType.kHM,
                    isNumberMonth: true,
                    // yearSuffix: "年",
                    // monthSuffix: "月",
                    // daySuffix: "日",
                    hourSuffix: "时",
                    minuteSuffix: "分",
                    minValue: minValue,
                    value: value,
                  ),
                  confirmText: "确定",
                  cancelText: "取消",
                  confirmTextStyle:
                      TextStyle(color: DSColors.primaryColor, fontSize: 14),
                  cancelTextStyle:
                      TextStyle(color: DSColors.title, fontSize: 14),
                  onConfirm: (picker, selectIndex) {
                    DateTime temp =
                        (picker.adapter as DateTimePickerAdapter).value!;
                    value2(temp.format(format: "HH:mm"));
                    item.value2 = value2.toString();
                  }).showModal<dynamic>(context);

               */
            },
          )
        ],
      );
    });
  }

  Widget getOption(FormItem item) {
    final value = "".obs;
    if (item.value != null) {
      value(item.value);
    }
    return Obx(() {
      return KeyValueView(
        title: item.title ?? "",
        titleSize: 16,
        valueLeft: false,
        value: value.value.isEmpty ? item.hint : value.value,
        valueSize: 16,
        valueColor: value.value.isEmpty ? DSColors.describe : DSColors.title,
        showIcon: true,
        onTap: () {
          BottomShell.show(
              items: item.list!.asMap().keys.map((index) {
                return BottomShellItem(title: item.list![index].name ?? "");
              }).toList(),
              onChoose: (index) {
                value(item.list![index].name ?? "");
                item.value = item.list![index].code;
                Navigator.pop(context);
              });
        },
      );
    });
  }

  Widget getText(FormItem item) {
    return KeyValueView(
      title: item.title ?? "",
      value: item.value ?? "",
      valueLeft: false,
      onTap: () {
        if (item.action != null) {}
      },
    );
  }

  Widget getAddress(FormItem item) {
    final address = "".obs;
    final name = "".obs;
    return Obx(() {
      return Column(
        children: [
          KeyValueView(
            title: item.title ?? "",
            valueLeft: false,
            titleSize: 16,
            value: name.value.isNotEmpty ? name.value : "请选择地址",
            valueColor:
                name.value.isNotEmpty ? DSColors.title : DSColors.describe,
            showIcon: true,
            showBorder: false,
            onTap: () {
              const Navigator()
                  .pushRoute(context, const AddressList(type: 1))
                  .then((value) {
                if (value != null) {
                  final info = value as AddressInfo;
                  name("${info.telephone ?? ""}  ${info.contacts ?? ""}");
                  address(
                      "${info.province ?? ""}${info.city ?? ""}${info.district ?? ""}${info.address ?? ""}");
                  item.value = info.addressNo.toString();
                }
              });
            },
          ),
          Container(
              padding: const EdgeInsets.only(left: 12, right: 12, bottom: 12),
              decoration: BoxDecoration(
                  border: Border(
                      bottom: BorderSide(
                color: DSColors.divider,
              ))),
              child: Row(
                children: [
                  Flexible(
                      child: Text(
                    address.value,
                    style: TextStyle(color: DSColors.title, fontSize: 14),
                  ))
                ],
              ))
        ],
      );
    });
  }

  bool nextCheck(FormInfo info) {
    bool isPass = true;
    // return isPass;

    for (final item in info.children!) {
      if (item.required ?? true) {
        if (!check(item)) {
          isPass = false;
          break;
        }
      }
    }

    return isPass;
  }

  void submit() {
    DemandController().demandApply(
        dataList: dataList,
        code: widget.code,
        success: (value) {
          showDialog(
              context: context,
              builder: (_) => AlertDialogs(
                    view: const Center(
                      child: Text("发布成功"),
                    ),
                    rightAction: () {
                      Navigator.pop(context);
                      Navigator.pop(context);
                      const Navigator()
                          .pushRoute(context, const DemandSuccess());
                    },
                    rightText: "确定",
                  ));
        });
  }

  bool check(FormItem item) {
    bool result = true;
    switch (item.type.toString()) {
      case "input":
      case "area":
      case "radio":
      case "option":
      case "city":
      case "address":
        result = checkData(item);
        if (!result) {
          MToast.show(item.hint.toString());
        }
        break;
      case "interaction":
        result = checkInteraction(item);
        break;
      case "duration":
      case "date":
        final temp = checkDuration(item);
        if (temp == 2) {
          result = true;
        } else if (temp == 1) {
          MToast.show(item.hint2.toString());
          result = false;
        } else if (temp == 0) {
          MToast.show(item.hint1.toString());
          result = false;
        }
        break;
      case "imagePicker":
      case "headImage":
      case "singlePicker":
        result = checkImage(item);
        if (!result) {
          MToast.show(item.hint.toString());
        }
        break;
      case "id":
        result = checkIdCard(item);
        if (!result) {
          MToast.show(item.hint.toString());
        }
        break;
      case "money":
        result = (item.value1 ?? "").isNotEmpty;
        if (!result) {
          MToast.show(item.hint.toString());
        }
        break;
      case "serviceDate":
        result = (item.value2 ?? "").isNotEmpty;
        if (!result) {
          MToast.show(item.hint2.toString());
        }
        break;
    }
    return result;
  }

  bool checkInteraction(FormItem item) {
    bool temp = true;
    if ((item.list ?? []).isNotEmpty) {
      if ((item.value ?? "").isEmpty) {
        temp = false;
        MToast.show(item.hint ?? "请选择${item.title}");
      } else if (item.type == "interaction" && (item.list ?? []).isNotEmpty) {
        if (item.list![item.selectIndex!].child != null) {
          final formItem = item.list![item.selectIndex!].child;
          if (formItem != null) {
            temp = checkInteraction(formItem);
          }
        }
      }
    }
    return temp;
  }

  bool checkImage(FormItem item) {
    if (item.value == null) {
      return false;
    } else {
      return (item.value as List).isNotEmpty;
    }
  }

  bool checkIdCard(FormItem item) {
    if (item.value1 == null || item.value2 == null) {
      return false;
    } else {
      return true;
    }
  }

  bool checkData(FormItem item) {
    return (item.value ?? "").toString().isNotEmpty;
  }

  int checkDuration(FormItem item) {
    if ((item.value1 ?? "").toString().isNotEmpty) {
      if ((item.value2 ?? "").toString().isNotEmpty) {
        return 2;
      } else {
        return 1;
      }
    } else {
      return 0;
    }
  }
}
