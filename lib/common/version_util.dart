// import 'dart:io';
//
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:package_info/package_info.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:url_launcher/url_launcher.dart';
//
// class VersionUtil {
//   ///
//   factory VersionUtil() => _getInstance();
//
//   ///
//   static VersionUtil get instance => _getInstance();
//
//   // 静态私有成员，没有初始化
//   static VersionUtil? _instance;
//
//   // 私有构造函数
//   VersionUtil._internal();
//
//   // 静态、同步、私有访问点
//   static VersionUtil _getInstance() {
//     _instance ??= VersionUtil._internal();
//     return _instance!;
//   }
//
//   void check({BuildContext? context}) async {
//     /*
//     final version = await UserController().getVersion();
//
//     if (version != null) {
//       final versionLoc = await PackageInfo.fromPlatform();
//
//       final array = (version.version ?? "").split("+");
//
//       final serviceStr = array[0].replaceAll(".", "");
//       final serviceCode = int.parse(serviceStr);
//
//       final locStr = versionLoc.version.replaceAll(".", "");
//       final locCode = int.parse(locStr);
//
//       if (serviceCode >= locCode) {
//         showDialog(
//             context: context!,
//             builder: (_) => AlertDialogs(
//                   title: "更新",
//                   view: Column(
//                     children: [
//                       Text("当前版本:${versionLoc.version}"),
//                       Text("服务器版本:${version.version ?? ""}"),
//                       if (version.description != null)
//                         Text("更新内容:${version.description ?? ""}"),
//                     ],
//                   ),
//                   leftText: "更新",
//                   leftAction: () {
//                     Navigator.pop(context);
//                     upgrade(context, version);
//                   },
//                   rightAction: () {
//                     Navigator.pop(context);
//                   },
//                   rightText: "下次",
//                 ));
//       } else {
//         if (context != null) {
//           DSToast.show("当前已是最新版");
//         }
//       }
//     }
//
//      */
//   }
//
//   final progress = 0.0.obs;
//   void upgrade(BuildContext context, VersionInfo info) async {
//     if (Platform.isIOS) {
//       String url = 'itms-apps://itunes.apple.com/cn/app/id${info.appId}?mt=8';
//       if (await canLaunch(url)) {
//         await launch(url);
//       } else {
//         throw 'Could not launch $url';
//       }
//     } else {
//       final directory = await getExternalStorageDirectory();
//       String _localPath = directory?.path ?? "";
//
//       String path = '$_localPath/app-release.apk';
//
//       HttpController().download(
//         url: info.url ?? "",
//         path: path,
//         listener: DownloadListener(
//           onStart: () {
//             showDialog<dynamic>(
//                 context: context,
//                 builder: (_) {
//                   return AlertDialogs(
//                     view: Obx(
//                       () {
//                         return Container(
//                           height: 200,
//                           child: DSSlider(
//                             value: progress.value,
//                           ),
//                         );
//                       },
//                     ),
//                     rightText: "取消",
//                     rightAction: () {},
//                   );
//                 });
//           },
//           onProgress: (total, pro) {
//             progress(pro);
//           },
//           onFinish: () {
//             OpenFile.open(path);
//           },
//           onError: (error) {},
//         ),
//       );
//
//       /*
//
//       await FlutterDownloader.enqueue(
//         // 远程的APK地址（注意：安卓9.0以上后要求用https）
//         url: info.url ?? "",
//         // 下载保存的路径
//         savedDir: _localPath,
//         // 是否在手机顶部显示下载进度（仅限安卓）
//         showNotification: false,
//         // 是否允许下载完成点击打开文件（仅限安卓）
//         openFileFromNotification: true,
//       );
//
//
//        */
//     }
//   }
// }
