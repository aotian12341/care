import 'package:care/common/time_helper.dart';
import 'package:care/controller/user_controller.dart';
import 'package:care/model/demand_info.dart';
import 'package:care/widget/alert_dialogs.dart';
import 'package:care/widget/key_value_view.dart';
import 'package:care/widget/loader.dart';
import 'package:care/widget/navigator_ex.dart';
import 'package:care/widget/page_widget.dart';
import 'package:care/widget/view_ex.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../common/colors.dart';
import '../../controller/demand_controller.dart';
import '../../widget/m_image.dart';
import '../../widget/m_toast.dart';
import '../staff/staff_details.dart';

/// 需求单详情
class DemandDetails extends StatefulWidget {
  const DemandDetails(
      {Key? key, required this.demandNo, required this.memberDemandNo})
      : super(key: key);

  final String demandNo;
  final String memberDemandNo;

  @override
  _DemandDetailsState createState() => _DemandDetailsState();
}

class _DemandDetailsState extends State<DemandDetails> {
  final loadController = LoaderController();
  final info = DemandInfo().obs;

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () {
      refresh();
    });
  }

  Future<bool> refresh() async {
    loadController.loading();
    DemandController().getDemandDetails(
        demandNo: widget.demandNo,
        success: (value) {
          info(value);
          loadController.loadFinish();
        },
        fail: (error) {
          loadController.loadError(msg: error);
        });

    return true;
  }

  @override
  Widget build(BuildContext context) {
    return PageWidget(
        titleLabel: "需求单",
        isCustom: "short",
        backgroundColor: DSColors.white,
        body: Loader(
            controller: loadController,
            onRefresh: refresh,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  getMessage(),
                  getStaffList(),
                ],
              ),
            )));
  }

  Widget getMessage() {
    return Obx(() {
      if (info.value.demandType == null) {
        return Container();
      }

      final dataList = handleData();
      final list = <Widget>[];
      for (final item in dataList) {
        if (item["type"] == "txt") {
          list.add(getTxt(item));
        } else if (item["type"] == "date") {
          list.add(getDate(item));
        } else if (item["type"] == "classify") {
          list.add(getClassify(item));
        } else if (item["type"] == "money") {
          list.add(getMoney(item));
        } else if (item["type"] == "note") {
          list.add(getNote(item));
        }
      }

      return Column(
        children: list,
      );
    });
  }

  Widget getStaffList() {
    const spacing = 10.0;
    const count = 4;
    final width =
        (MediaQuery.of(context).size.width - 24 - spacing * 5) / count;
    return Obx(() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              "已投递的人员".t,
              "点击头像查看人员详情".t,
            ],
          ).size(height: 40),
          Wrap(
            spacing: spacing,
            children: (info.value.workers ?? []).asMap().keys.map((index) {
              final item = info.value.workers![index];
              return Column(
                children: [
                  ClipRRect(
                    child: MImage.network("",
                        width: width, height: width, fit: BoxFit.cover),
                    borderRadius: BorderRadius.circular(width / 2),
                  ),
                  4.v,
                  (item.workerName ?? "").t,
                ],
              ).onTap(() {
                if (info.value.status == "已完成") {
                  MToast.show("该需求单已选择雇员");
                } else {
                  const Navigator().pushRoute(
                      context,
                      StaffDetails(
                        type: 1,
                        staffId: item.workerNo ?? "",
                        memberDemandNo: widget.memberDemandNo,
                      ));
                }
              });
            }).toList(),
          )
        ],
      ).margin(margin: const EdgeInsets.symmetric(horizontal: 12));
    });
  }

  List<Map<String, dynamic>> handleData() {
    List<Map<String, dynamic>> res = <Map<String, dynamic>>[];
    final demandType = info.value.demandType;

    if (demandType == "106001") {
      res = [
        {
          "type": "classify",
          "value": UserController()
                  .getDictionaryByCode(code: demandType ?? "")
                  ?.value ??
              ""
        },
        {
          "type": "txt",
          "key": "发布时间",
          "value":
              DateTime.fromMillisecondsSinceEpoch(info.value.createTime ?? 0)
                  .format(format: "yyyy-MM-dd HH:mm")
        },
        {"type": "txt", "key": "服务类型", "value": info.value.isInHome ?? ""},
        {
          "type": "txt",
          "key": "需照顾儿童数",
          "value": info.value.employerCount ?? "0个"
        },
        {"type": "txt", "key": "儿童年龄", "value": ""},
        {
          "type": "txt",
          "key": "要求照顾者经验",
          "value": info.value.workExperience ?? ""
        },
        {"type": "date", "key": "服务时间", "value": ""},
        {"type": "txt", "key": "保姆性别要求", "value": info.value.workerSex ?? ""},
        {
          "type": "txt",
          "key": "保姆年龄段",
          "value": info.value.workerAgeRange ?? ""
        },
        {
          "type": "txt",
          "key": "联系电话",
          "value": info.value.addressInfo?.telephone ?? ""
        },
        {
          "type": "txt",
          "key": "服务地址",
          "value": info.value.addressInfo?.address ?? ""
        },
        {
          "type": "money",
          "key": "您预计给保姆的工资",
          "value": "${info.value.price}${info.value.amountUnit ?? ""}"
        },
        {"type": "txt", "key": "备注:", "value": info.value.note ?? "无"},
      ];
    } else if (demandType == "106002") {
      res = [
        {
          "type": "classify",
          "value": UserController()
                  .getDictionaryByCode(code: demandType ?? "")
                  ?.value ??
              ""
        },
        {
          "type": "txt",
          "key": "发布时间",
          "value":
              DateTime.fromMillisecondsSinceEpoch(info.value.createTime ?? 0)
                  .format(format: "yyyy-MM-dd HH:mm")
        },
        {"type": "txt", "key": "服务类型", "value": info.value.isInHome ?? ""},
        {
          "type": "txt",
          "key": "需照顾儿童数",
          "value": info.value.employerCount ?? "0个"
        },
        {"type": "txt", "key": "儿童年龄", "value": ""},
        {
          "type": "txt",
          "key": "要求照顾者经验",
          "value": info.value.workExperience ?? ""
        },
        {"type": "date", "key": "您的类型", "value": ""},
        {"type": "date", "key": "服务时间", "value": ""},
        {"type": "txt", "key": "保姆性别要求", "value": info.value.workerSex ?? ""},
        {
          "type": "txt",
          "key": "保姆年龄段",
          "value": info.value.workerAgeRange ?? ""
        },
        {
          "type": "txt",
          "key": "联系电话",
          "value": info.value.addressInfo?.telephone ?? ""
        },
        {
          "type": "txt",
          "key": "服务地址",
          "value": info.value.addressInfo?.address ?? ""
        },
        {
          "type": "money",
          "key": "您预计给保姆的工资",
          "value": "${info.value.price}${info.value.amountUnit ?? ""}"
        },
        {"type": "txt", "key": "备注:", "value": info.value.note ?? "无"},
      ];
    } else if (demandType == "106003") {
      res = [
        {
          "type": "classify",
          "value": UserController()
                  .getDictionaryByCode(code: demandType ?? "")
                  ?.value ??
              ""
        },
        {
          "type": "txt",
          "key": "发布时间",
          "value":
              DateTime.fromMillisecondsSinceEpoch(info.value.createTime ?? 0)
                  .format(format: "yyyy-MM-dd HH:mm")
        },
        {"type": "txt", "key": "服务场合", "value": info.value.workPlace ?? ""},
        {"type": "txt", "key": "服务类型", "value": info.value.workDay ?? ""},
        {
          "type": "txt",
          "key": "护理对象",
          "value": info.value.employerAgeRange ?? ""
        },
        {"type": "txt", "key": "性别", "value": info.value.employerSex ?? ""},
        {"type": "txt", "key": "护理人年龄", "value": info.value.employerSex ?? ""},
        {
          "type": "txt",
          "key": "身体情况",
          "value": info.value.physicalCondition ?? ""
        },
        {
          "type": "txt",
          "key": "身体情况",
          "value": info.value.physicalCondition ?? ""
        },
        {"type": "date", "key": "服务时间", "value": ""},
        {"type": "txt", "key": "护工性别要求", "value": info.value.workerSex ?? ""},
        {
          "type": "txt",
          "key": "护工年龄段",
          "value": info.value.workerAgeRange ?? ""
        },
        {
          "type": "txt",
          "key": "联系电话",
          "value": info.value.addressInfo?.telephone ?? ""
        },
        {
          "type": "txt",
          "key": "服务地址",
          "value": info.value.addressInfo?.address ?? ""
        },
        {
          "type": "money",
          "key": "您预计给保姆的工资",
          "value": "${info.value.price}${info.value.amountUnit ?? ""}"
        },
        {"type": "txt", "key": "备注:", "value": info.value.note ?? "无"},
      ];
    } else if (demandType == "106004") {
      res = [
        {
          "type": "classify",
          "value": UserController()
                  .getDictionaryByCode(code: demandType ?? "")
                  ?.value ??
              ""
        },
        {
          "type": "txt",
          "key": "发布时间",
          "value":
              DateTime.fromMillisecondsSinceEpoch(info.value.createTime ?? 0)
                  .format(format: "yyyy-MM-dd HH:mm")
        },
        {"type": "txt", "key": "服务类型", "value": info.value.isInHome ?? ""},
        {
          "type": "txt",
          "key": "老人状况",
          "value": info.value.physicalCondition ?? ""
        },
        {"type": "txt", "key": "老人年龄", "value": info.value.employerSex ?? ""},
        {"type": "txt", "key": "性别", "value": info.value.employerSex ?? ""},
        {
          "type": "txt",
          "key": "要求照顾者经验",
          "value": info.value.workExperience ?? ""
        },
        {"type": "date", "key": "服务时间", "value": ""},
        {"type": "txt", "key": "护工性别要求", "value": info.value.workerSex ?? ""},
        {
          "type": "txt",
          "key": "护工年龄段",
          "value": info.value.workerAgeRange ?? ""
        },
        {
          "type": "txt",
          "key": "联系电话",
          "value": info.value.addressInfo?.telephone ?? ""
        },
        {
          "type": "txt",
          "key": "服务地址",
          "value": info.value.addressInfo?.address ?? ""
        },
        {
          "type": "money",
          "key": "您预计给保姆的工资",
          "value": "${info.value.price}${info.value.amountUnit ?? ""}"
        },
        {"type": "txt", "key": "备注:", "value": info.value.note ?? "无"},
      ];
    } else if (demandType == "106005") {
      res = [
        {
          "type": "classify",
          "value": UserController()
                  .getDictionaryByCode(code: demandType ?? "")
                  ?.value ??
              ""
        },
        {
          "type": "txt",
          "key": "发布时间",
          "value":
              DateTime.fromMillisecondsSinceEpoch(info.value.createTime ?? 0)
                  .format(format: "yyyy-MM-dd HH:mm")
        },
        {"type": "txt", "key": "服务类型", "value": info.value.serviceObj ?? ""},
        {
          "type": "txt",
          "key": info.value.cleanType,
          "value": info.value.cleanRegion ?? ""
        },
        {
          "type": "txt",
          "key": "是否携带专业工具",
          "value": info.value.isNeedTool ?? ""
        },
        {"type": "date", "key": "服务时间", "value": ""},
        {
          "type": "txt",
          "key": "保洁员年龄段",
          "value": info.value.workerAgeRange ?? ""
        },
        {
          "type": "txt",
          "key": "联系电话",
          "value": info.value.addressInfo?.telephone ?? ""
        },
        {
          "type": "txt",
          "key": "服务地址",
          "value": info.value.addressInfo?.address ?? ""
        },
        {
          "type": "money",
          "key": "您预计给保洁员的工资",
          "value": "${info.value.price}${info.value.amountUnit ?? ""}"
        },
        {"type": "txt", "key": "备注:", "value": info.value.note ?? "无"},
      ];
    } else if (demandType == "106006") {
      res = [
        {
          "type": "classify",
          "value": UserController()
                  .getDictionaryByCode(code: demandType ?? "")
                  ?.value ??
              ""
        },
        {
          "type": "txt",
          "key": "发布时间",
          "value":
              DateTime.fromMillisecondsSinceEpoch(info.value.createTime ?? 0)
                  .format(format: "yyyy-MM-dd HH:mm")
        },
        {"type": "txt", "key": "服务类型", "value": info.value.serviceObj ?? ""},
        {"type": "txt", "key": "保洁区域", "value": info.value.cleanRegion ?? ""},
        {"type": "txt", "key": "清洁程度", "value": info.value.cleanDegree ?? ""},
        {
          "type": "txt",
          "key": "是否携带专业工具",
          "value": info.value.isNeedTool ?? ""
        },
        {"type": "date", "key": "服务时间", "value": ""},
        {
          "type": "txt",
          "key": "保洁员年龄段",
          "value": info.value.workerAgeRange ?? ""
        },
        {
          "type": "txt",
          "key": "联系电话",
          "value": info.value.addressInfo?.telephone ?? ""
        },
        {
          "type": "txt",
          "key": "服务地址",
          "value": info.value.addressInfo?.address ?? ""
        },
        {
          "type": "money",
          "key": "您预计给保洁员的工资",
          "value": "${info.value.price}${info.value.amountUnit ?? ""}"
        },
        {"type": "txt", "key": "备注:", "value": info.value.note ?? "无"},
      ];
    }

    return res;
  }

  Widget getTxt(Map<String, dynamic> item) {
    return KeyValueView(
      height: 30,
      title: item["key"].toString(),
      value: item["value"].toString(),
      valueLeft: false,
    );
  }

  Widget getDate(Map<String, dynamic> item) {
    return KeyValueView(
      title: item["key"].toString(),
      height: 30,
      showIcon: true,
      icon: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          (info.value.timeRange ?? "")
              .replaceAll("--", "至")
              .t
              .s(16)
              .c(DSColors.title),
          8.v,
          (info.value.workTimeRange ?? "")
              .replaceAll("--", "至")
              .t
              .s(16)
              .c(DSColors.title),
        ],
      ),
    );
  }

  Widget getClassify(Map<String, dynamic> item) {
    return KeyValueView(
      title: item["value"].toString(),
      titleSize: 20,
      valueLeft: false,
      valueView: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          (info.value.status == "105091" || info.value.status == "105092"
                  ? "关闭"
                  : "删除")
              .t
              .s(14)
        ],
      ).onTap(() {
        if (info.value.status == "105091" || info.value.status == "105092") {
          closeDemand();
        } else {
          deleteDemand();
        }
      }),
    );
  }

  Widget getMoney(Map<String, dynamic> item) {
    return KeyValueView(
      title: item["key"].toString(),
      value: item["value"].toString(),
      valueColor: DSColors.primaryColor,
      valueSize: 24,
      valueLeft: false,
    );
  }

  Widget getNote(Map<String, dynamic> item) {
    return Container();
  }

  /// 关闭需求单
  void closeDemand() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialogs(
          title: "提示",
          view: const Text("确认关闭？"),
          leftText: "取消",
          leftAction: () {
            Navigator.pop(context);
          },
          rightText: "确认",
          rightAction: () {
            DemandController().demandDel(
                demandNo: widget.demandNo,
                success: (value) {
                  Navigator.pop(context);
                  Navigator.pop(context, true);
                });
          },
        );
      },
    );
  }

  /// 删除需求单
  void deleteDemand() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialogs(
          title: "提示",
          view: const Text("确认删除？"),
          leftText: "取消",
          leftAction: () {
            Navigator.pop(context);
          },
          rightText: "确认",
          rightAction: () {
            DemandController().demandDel(
                demandNo: widget.demandNo,
                success: (value) {
                  Navigator.pop(context);
                  Navigator.pop(context, true);
                });
          },
        );
      },
    );
  }
}
