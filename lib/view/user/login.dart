import 'package:care/widget/key_input_view.dart';
import 'package:care/widget/main_button.dart';
import 'package:care/widget/page_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';

import '../../common/colors.dart';
import '../../common/http_controller.dart';
import '../../controller/user_controller.dart';
import '../../widget/m_toast.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final phone = TextEditingController();
  final password = TextEditingController();

  final count = 0.obs;
  final tabIndex = 0.obs;
  final showPsd = false.obs;
  String code = "";

  @override
  Widget build(BuildContext context) {
    return PageWidget(
      isCustom: "big",
      resizeToAvoidBottomInset: false,
      action: [
        InkWell(
          onTap: () {
            if (tabIndex.value != 2) {
              tabIndex(2);
            } else {
              tabIndex(0);
            }
          },
          child: Obx(() {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  tabIndex.value != 2 ? "密码登录" : "验证码登录",
                  style: TextStyle(color: DSColors.white, fontSize: 14),
                ),
              ],
            );
          }),
        )
      ],
      onWillPop: () async {
        if (tabIndex.value == 1) {
          tabIndex(0);
        } else {
          Navigator.pop(context);
        }
      },
      body: Column(
        children: [
          const SizedBox(height: 20),
          Image.asset(
            "assets/images/icon_logo_r.png",
            width: 50,
          ),
          const SizedBox(height: 20),
          getContent(),
          getOther(),
        ],
      ),
    );
  }

  Widget getContent() {
    return Obx(() {
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 15),
        padding: const EdgeInsets.symmetric(horizontal: 24),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: DSColors.white,
        ),
        child: IndexedStack(
          index: tabIndex.value,
          children: [
            getPhoneView(),
            getCodeView(),
            getPasswordView(),
          ],
        ),
      );
    });
  }

  Widget getPhoneView() {
    return Column(
      children: [
        const SizedBox(height: 64),
        Text(
          "填写手机号码",
          style: TextStyle(color: DSColors.pinkRed, fontSize: 18),
        ),
        const SizedBox(height: 35),
        Container(
          decoration: BoxDecoration(
              border: Border.all(color: DSColors.describe),
              borderRadius: BorderRadius.circular(8)),
          child: KeyInputView(
              title: "",
              titleView: Container(
                width: 72,
                height: 20,
                margin: const EdgeInsets.only(right: 12),
                decoration: BoxDecoration(
                    border: Border(
                        right: BorderSide(width: 1, color: DSColors.describe))),
                alignment: Alignment.center,
                child: Text(
                  "+ 86",
                  style: TextStyle(color: DSColors.title),
                ),
              ),
              hint: "请输入手机号码",
              controller: phone),
        ),
        const SizedBox(height: 75),
        MainButton(
          title: "继续",
          onTap: () {
            if (phone.text.isEmpty || phone.text.length != 11) {
              MToast.show("请输入正确的手机号码");
              return;
            }
            sendCode();
          },
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 1,
              width: 50,
              color: DSColors.divider,
              margin: const EdgeInsets.only(right: 6),
            ),
            Text(
              "首次登录自动注册账户",
              style: TextStyle(color: DSColors.subTitle, fontSize: 12),
            ),
            Container(
              height: 1,
              width: 50,
              color: DSColors.divider,
              margin: const EdgeInsets.only(left: 6),
            ),
          ],
        ),
        const SizedBox(height: 55),
      ],
    );
  }

  Widget getCodeView() {
    return Column(
      children: [
        const SizedBox(height: 50),
        Text(
          "验证码短信已发送至",
          style: TextStyle(color: DSColors.title, fontSize: 14),
        ),
        const SizedBox(height: 20),
        Text(
          "+86 ${phone.text}",
          style: TextStyle(color: DSColors.title, fontSize: 14),
        ),
        Pinput(
          length: 6,
          onChanged: (value) {
            code = value;
          },
          defaultPinTheme: PinTheme(
              width: 40,
              height: 60,
              textStyle: const TextStyle(fontSize: 18),
              decoration: BoxDecoration(
                  border:
                      Border(bottom: BorderSide(color: DSColors.describe)))),
        ),
        const SizedBox(height: 10),
        Obx(() {
          return InkWell(
            onTap: () {
              if (count.value == 0) {
                resendCode();
              }
            },
            child: Text(
              count.value > 0 ? "重新发送（${count.value}）" : "重新发送",
              style: TextStyle(color: DSColors.describe, fontSize: 12),
            ),
          );
        }),
        const SizedBox(height: 30),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("登录即表示您同意",
                style: TextStyle(color: DSColors.subTitle, fontSize: 12)),
            InkWell(
                onTap: toServiceAgreement,
                child: const Text("服务协议",
                    style: TextStyle(color: Colors.blue, fontSize: 12))),
            Text("和", style: TextStyle(color: DSColors.subTitle, fontSize: 12)),
            InkWell(
                onTap: toPrivacyPolicy,
                child: const Text("隐私政策",
                    style: TextStyle(color: Colors.blue, fontSize: 12))),
          ],
        ),
        const SizedBox(height: 6),
        MainButton(
          onTap: msgLogin,
          title: "立即登录",
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 1,
              width: 50,
              color: DSColors.divider,
              margin: const EdgeInsets.only(right: 6),
            ),
            Text(
              "首次登录自动注册账户",
              style: TextStyle(color: DSColors.subTitle, fontSize: 12),
            ),
            Container(
              height: 1,
              width: 50,
              color: DSColors.divider,
              margin: const EdgeInsets.only(left: 6),
            ),
          ],
        ),
      ],
    );
  }

  Widget getPasswordView() {
    return Column(
      children: [
        const SizedBox(height: 60),
        Container(
          decoration: BoxDecoration(
              border: Border.all(color: DSColors.describe),
              borderRadius: BorderRadius.circular(8)),
          child: KeyInputView(
              title: "请输入您的手机号",
              titleColor: DSColors.describe,
              titleWidth: 140,
              controller: phone),
        ),
        const SizedBox(height: 20),
        Obx(() {
          return Container(
            decoration: BoxDecoration(
                border: Border.all(color: DSColors.describe),
                borderRadius: BorderRadius.circular(8)),
            child: KeyInputView(
              title: "请输入密码",
              titleColor: DSColors.describe,
              titleWidth: 140,
              controller: password,
              isPassword: showPsd.value,
              showIcon: true,
              icon: IconButton(
                  onPressed: () {
                    showPsd(!showPsd.value);
                  },
                  icon: Icon(
                    !showPsd.value ? Icons.visibility_off : Icons.visibility,
                    size: 15,
                  )),
            ),
          );
        }),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            InkWell(
              onTap: forgetPassword,
              child: Text(
                "忘记密码",
                style: TextStyle(color: DSColors.title, fontSize: 12),
              ),
            ),
          ],
        ),
        const SizedBox(height: 25),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("登录即表示您同意",
                style: TextStyle(color: DSColors.subTitle, fontSize: 12)),
            InkWell(
                onTap: toServiceAgreement,
                child: const Text("服务协议",
                    style: TextStyle(color: Colors.blue, fontSize: 12))),
            Text("和", style: TextStyle(color: DSColors.subTitle, fontSize: 12)),
            InkWell(
                onTap: toPrivacyPolicy,
                child: const Text("隐私政策",
                    style: TextStyle(color: Colors.blue, fontSize: 12))),
          ],
        ),
        const SizedBox(height: 5),
        MainButton(
          title: "立即登录",
          onTap: accountLogin,
        ),
        const SizedBox(height: 55),
      ],
    );
  }

  Widget getOther() {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.only(top: 40),
          padding: const EdgeInsets.symmetric(horizontal: 35),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  height: 1,
                  color: DSColors.dc,
                  margin: const EdgeInsets.only(right: 5),
                ),
              ),
              Text("第三方快速登录",
                  style: TextStyle(color: DSColors.subTitle, fontSize: 14)),
              Expanded(
                child: Container(
                  height: 1,
                  color: DSColors.dc,
                  margin: const EdgeInsets.only(left: 5),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 40),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            InkWell(
              onTap: qqLogin,
              child: Image.asset(
                "assets/images/icon_login_qq.png",
                width: 40,
              ),
            ),
            const SizedBox(width: 45),
            InkWell(
              onTap: wxLogin,
              child: Image.asset(
                "assets/images/icon_login_wx.png",
                width: 40,
              ),
            )
          ],
        )
      ],
    );
  }

  /// 验证码登录
  void msgLogin() {
    if (phone.text.isEmpty) {
      MToast.show("请输入账号");
      return;
    } else if (code.length < 6) {
      MToast.show("请输入验证码");
    }

    UserController()
        .smsLogin(phone: phone.text, code: code, success: loginBack);
  }

  /// 账号登录
  void accountLogin() {
    if (phone.text.isEmpty || phone.text.length != 11) {
      MToast.show("请输入正确的手机号码");
      return;
    } else if (password.text.isEmpty) {
      MToast.show("请输入密码");
    }

    UserController().accountLogin(
        phone: phone.text, password: password.text, success: loginBack);
  }

  void loginBack() {
    Navigator.pop(context);
  }

  /// qq登录
  void qqLogin() {}

  /// 微信登录
  void wxLogin() {}

  /// 重发
  void resendCode() {
    sendCode();
  }

  /// 发送短信
  void sendCode() {
    UserController().sendMsg(
        phone: phone.text,
        success: (ResultInfo value) {
          if (value.code == 0) {
            MToast.show("发送成功");
            count(60);
            countDown();
            tabIndex(1);
          }
        });
  }

  /// 倒计时
  void countDown() {
    Future.delayed(const Duration(seconds: 1), () {
      if (count.value > 0) {
        count(count.value -= 1);
        countDown();
      }
    });
  }

  /// 忘记密码
  void forgetPassword() {}

  /// 服务协议
  void toServiceAgreement() {}

  /// 隐私政策
  void toPrivacyPolicy() {}
}
