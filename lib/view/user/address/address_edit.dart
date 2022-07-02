import 'package:care/view/user/address/map_picker.dart';
import 'package:care/model/pois_info.dart';
import 'package:care/widget/alert_dialogs.dart';
import 'package:care/widget/key_input_view.dart';
import 'package:care/widget/key_value_view.dart';
import 'package:care/widget/loader.dart';
import 'package:care/widget/main_button.dart';
import 'package:care/widget/navigator_ex.dart';
import 'package:care/widget/page_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../common/colors.dart';
import '../../../controller/address_controller.dart';
import '../../../model/address_info.dart';
import '../../../widget/m_toast.dart';

class AddressEdit extends StatefulWidget {
  const AddressEdit({Key? key, this.info}) : super(key: key);

  final AddressInfo? info;

  @override
  _AddressEditState createState() => _AddressEditState();
}

class _AddressEditState extends State<AddressEdit> {
  final name = TextEditingController();
  final phone = TextEditingController();
  final address = TextEditingController();
  final city = "".obs;
  final isDefault = false.obs;
  final pickerPoint = PoisPois().obs;

  final loaderController = LoaderController();

  String addressNo = "";
  String provinceId = "";
  String cityId = "";
  String areaId = "";
  String lat = "";
  String lng = "";

  @override
  void initState() {
    super.initState();

    if (widget.info != null) {
      Future.delayed(Duration.zero, () {
        refresh();
      });
    }
  }

  Future<void> refresh() async {
    AddressController().getAddressInfo(
        addressNo: widget.info?.addressNo ?? "",
        success: (value) {
          name.text = value?.contacts ?? "";
          phone.text = value?.telephone ?? "";
          address.text = value?.address ?? "";
          city(
              "${value?.province ?? ""}${value?.city ?? ""}${value?.district ?? ""}");
          addressNo = value?.addressNo ?? "";
          isDefault(value?.isDefault == "true");

          pickerPoint(PoisPois()
            ..name = value.addressName ?? ""
            ..address =
                (value.province + value.city + value.district + value.address));

          loaderController.loadFinish();
        });
  }

  @override
  Widget build(BuildContext context) {
    return PageWidget(
        isCustom: "short",
        titleLabel: widget.info != null ? "编辑地址" : "新增地址",
        action: [
          if (widget.info != null)
            InkWell(
              onTap: del,
              child: Row(
                children: [
                  Icon(
                    Icons.delete,
                    size: 20,
                    color: DSColors.white,
                  ),
                  const SizedBox(width: 2),
                  Text(
                    "删除",
                    style: TextStyle(color: DSColors.white, fontSize: 12),
                  ),
                ],
              ),
            )
        ],
        backgroundColor: DSColors.white,
        body: Obx(() {
          return SingleChildScrollView(
            child: Column(
              children: [
                if (pickerPoint.value.name == null)
                  InkWell(
                    onTap: pickMap,
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 24),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        border: Border.all(color: DSColors.primaryColor),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Text(
                          "选择服务地址",
                          style: TextStyle(
                              color: DSColors.primaryColor, fontSize: 16),
                        ),
                      ),
                    ),
                  )
                else
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                        border: Border(
                            bottom: BorderSide(color: DSColors.divider))),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Flexible(
                                      child: Text(
                                    pickerPoint.value.name ?? "",
                                    style: TextStyle(
                                        color: DSColors.title, fontSize: 16),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ))
                                ],
                              ),
                              const SizedBox(height: 2),
                              Row(
                                children: [
                                  Flexible(
                                      child: Text(
                                    "${pickerPoint.value.pname ?? ""}${pickerPoint.value.cityname ?? ""}${pickerPoint.value.adname ?? ""}${pickerPoint.value.address ?? ""}",
                                    style: TextStyle(
                                        color: DSColors.describe, fontSize: 14),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ))
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 6),
                        InkWell(
                          onTap: pickMap,
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: DSColors.primaryColor),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 2),
                            child: Text(
                              "修改地址",
                              style: TextStyle(
                                  color: DSColors.primaryColor, fontSize: 14),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                KeyInputView(
                  showBorder: true,
                  title: "门牌号",
                  controller: address,
                  hint: "请输入门牌号",
                ),
                KeyInputView(
                  title: "联系人",
                  showBorder: true,
                  controller: name,
                  hint: "请输入联系人",
                ),
                KeyInputView(
                  title: "手机号",
                  showBorder: true,
                  controller: phone,
                  hint: "请输入手机号",
                ),
                /*
                KeyValueView(
                  title: "地区",
                  titleSize: 16,
                  value: city.value.isNotEmpty ? city.value : "请选择省市区",
                  valueColor:
                      city.value.isNotEmpty ? DSColors.title : DSColors.dc,
                  valueSize: 16,
                  onTap: () async {
                    print(addressNo);
                    final result = await CityPickers.showCityPicker(
                        context: context,
                        locationCode: addressNo.isEmpty ? "110000" : addressNo);
                    if (result != null) {
                      city(
                          "${result.provinceName ?? ""}${result.cityName ?? ""}${result.areaName ?? ""}");
                      addressNo = result.areaId ?? "";
                      provinceId = result.provinceId ?? "";
                      cityId = result.cityId ?? "";
                      areaId = result.areaId ?? "";
                    }
                  },
                ),

                 */
                // const SizedBox(height: 24),
                KeyValueView(
                  title: "设为默认地址",
                  showIcon: true,
                  icon: CupertinoSwitch(
                    activeColor: DSColors.primaryColor,
                    onChanged: (value) {
                      isDefault(value);
                    },
                    value: isDefault.value,
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: MainButton(
                        margin: const EdgeInsets.symmetric(horizontal: 16),
                        title: "保存",
                        onTap: save,
                      ),
                    )
                  ],
                )
              ],
            ),
          );
        }));
  }

  void pickMap() {
    const Navigator().pushRoute(context, const MapPicker()).then((value) {
      if (value != null) {
        pickerPoint(value);
        if ((pickerPoint.value.adcode ?? "").isNotEmpty) {
          areaId = pickerPoint.value.adcode ?? "";
          final cityCode = areaId.substring(0, areaId.length - 2) + "00";
          cityId = cityCode;
        }
        provinceId = pickerPoint.value.pcode ?? "";

        if ((pickerPoint.value.location ?? "").isNotEmpty) {
          final temp = pickerPoint.value.location!.split(",");
          lat = temp[1];
          lng = temp[0];
        }
      }
    });
  }

  void save() {
    if (name.text.isEmpty) {
      MToast.show("请输入姓名");
      return;
    }
    if (phone.text.isEmpty) {
      MToast.show("请输入电话");
      return;
    }
    if (pickerPoint.value.name == null) {
      MToast.show("请选择服务地址");
      return;
    }
    if (address.text.isEmpty) {
      MToast.show("请输入门牌号");
      return;
    }

    AddressController().editAddress(
        id: widget.info?.id,
        contact: name.text,
        phone: phone.text,
        address: pickerPoint.value.address ?? "",
        addressName: pickerPoint.value.name ?? "",
        houseno: address.text,
        lat: lat,
        lng: lng,
        addressNo: addressNo,
        provinceId: provinceId,
        cityId: cityId,
        areaId: areaId,
        isDefault: isDefault.value,
        success: (value) {
          MToast.show("保存成功");
          Navigator.pop(context, true);
        });
  }

  void del() {
    showDialog(
        context: context,
        builder: (_) {
          return AlertDialogs(
            title: "提示",
            message: "确认删除？",
            rightText: "确认",
            rightAction: () {
              Navigator.pop(context);
              delSubmit();
            },
            onCancel: () {},
          );
        });
  }

  void delSubmit() {
    AddressController().delete(
        addressNo: widget.info?.addressNo ?? "",
        success: (value) {
          showDialog(
              context: context,
              builder: (_) {
                return AlertDialogs(
                  title: "提示",
                  message: "删除成功",
                  rightText: "确认",
                  rightAction: () {
                    Navigator.of(context)
                      ..pop()
                      ..pop(true);
                  },
                  onCancel: () {
                    Navigator.pop(context, true);
                  },
                );
              });
        });
  }
}
