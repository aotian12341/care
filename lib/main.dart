import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'controller/user_controller.dart';
import 'view/home_page/home_page.dart';
import 'view/user/login.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // 强制竖屏
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  // ImController();
  // UserController();

  runApp(const App());
}

class App extends StatelessWidget with WidgetsBindingObserver {
  const App({Key? key}) : super(key: key);

  static RouteObserver<ModalRoute> routerObserver = RouteObserver<ModalRoute>();

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: "心巢-雇主端",
      debugShowCheckedModeBanner: false,
      navigatorObservers: [
        routerObserver,
      ],
      theme: ThemeData(primaryColor: const Color(0xffFD3A84)),
      home: const HomePage(),
    );
  }
}
