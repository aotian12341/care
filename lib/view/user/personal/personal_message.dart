import 'package:care/widget/key_value_view.dart';
import 'package:care/widget/loader.dart';
import 'package:care/widget/page_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../common/colors.dart';
import '../../../common/util.dart';
import '../../../controller/user_controller.dart';
import 'package:care/widget/view_ex.dart';

import '../../../widget/file_picker/upload_utils.dart';

/// 个人资料
class PersonalMessage extends StatefulWidget {
  const PersonalMessage({Key? key}) : super(key: key);

  @override
  _PersonalMessageState createState() => _PersonalMessageState();
}

class _PersonalMessageState extends State<PersonalMessage> {
  final loaderController = LoaderController();

  Future<bool> refresh() async {
    UserController().getUserInfo();
    return true;
  }

  @override
  void initState() {
    super.initState();

    loaderController.loadFinish();
  }

  @override
  Widget build(BuildContext context) {
    return PageWidget(
        titleLabel: "个人资料",
        isCustom: "short",
        body: Obx(() {
          final user = UserController().userInfo.value;
          return Loader(
              controller: loaderController,
              child: Column(
                children: [
                  Column(
                    children: [
                      KeyValueView(
                        height: 88,
                        titleSize: 16,
                        title: "头像",
                        valueLeft: false,
                        showBorder: true,
                        showIcon: true,
                        valueView: user.faceUrl == null
                            ? Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                    border: Border.all(color: DSColors.title),
                                    shape: BoxShape.circle),
                                child: Icon(
                                  Icons.person_outline,
                                  size: 40,
                                  color: DSColors.subTitle,
                                ),
                              )
                            : Image.network(
                                Util.getImage(id: user.faceUrl!),
                                width: 66,
                                height: 66,
                                fit: BoxFit.cover,
                              ),
                        onTap: () {
                          UploadUtils.pickerFile(
                              context: context,
                              pickBack: (list) async {
                                if (list.isNotEmpty) {
                                  final file = await list[0].file;
                                  if (file != null) {
                                    UploadUtils.uploadFile(
                                        path: file.path,
                                        listener: UploadListener(
                                            onSuccess: (taskId, url) {
                                          UserController.instance.userInfo(
                                              UserController
                                                  .instance.userInfo.value
                                                ..faceUrl = url);
                                        }));
                                  }
                                }
                              });
                        },
                      ),
                      KeyValueView(
                        height: 66,
                        title: "姓名",
                        value: user.name ?? "",
                        valueLeft: false,
                        showBorder: true,
                      ),
                      KeyValueView(
                        title: "昵称",
                        value: user.nick ?? "",
                        valueLeft: false,
                        showBorder: true,
                      ),
                      KeyValueView(
                        title: "性别",
                        value: user.sex ?? "",
                        valueLeft: false,
                        showBorder: true,
                      ),
                      KeyValueView(
                        title: "生日",
                        value: user.birthday ?? "",
                        valueLeft: false,
                        showBorder: true,
                      ),
                      const KeyValueView(
                        title: "手机号码",
                        value: "",
                        valueLeft: false,
                        showBorder: false,
                      ),
                    ],
                  )
                      .padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15))
                      .color(DSColors.white)
                      .borderRadius(radius: 12),
                  12.v,
                  KeyValueView(
                    height: 66,
                    title: "信息认证",
                    showIcon: true,
                    showBorder: false,
                  )
                      .color(DSColors.white)
                      .padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12))
                      .borderRadius(radius: 12)
                ],
              ).marginAll(12));
        }));
  }
}
