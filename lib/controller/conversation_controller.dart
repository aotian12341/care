// import 'package:get/get.dart';
// import 'package:im_flutter_sdk/im_flutter_sdk.dart';
//
// import 'im_controller.dart';
// import 'user_controller.dart';
//
// class ConversationController {
//   ///
//   factory ConversationController() => _getInstance();
//
//   ///
//   static ConversationController get instance => _getInstance();
//
//   /// 静态私有成员，没有初始化
//   static ConversationController? _instance;
//
//   /// 私有构造函数
//   ConversationController._internal();
//
//   final imController = ImController();
//
//   /// 静态、同步、私有访问点
//   static ConversationController _getInstance() {
//     _instance ??= ConversationController._internal();
//     return _instance!;
//   }
//
//   final showEmo = false.obs;
//   final showPanel = false.obs;
//
//   MyGroupInfo? groupInfo;
//
//   RxList<EMMessage> messageList = <EMMessage>[].obs;
//
//   final groupList = <MyGroupInfo>[].obs;
//
//   /// 登录
//   Future<void> login() async {
//     if (ImController().getAccountId() != null && ImController().isLogin()) {
//     } else {
//       // final account = UserController().userInfo.value.imUser?.username;
//       // final password = UserController().userInfo.value.imUser?.password;
//       // if (account != null && password != null) {
//       //   ImController().login(account: account, password: password);
//       // }
//     }
//     messageList = imController.messageList;
//   }
//
//   void loginOut() {
//     ImController().loginOut();
//     ImController().conversation = null;
//     ImController().groupList.clear();
//     ImController().messageList.clear();
//
//     messageList.clear();
//     groupList.clear();
//   }
//
//   /// 获取群组消息列表
//   Future<void> getConversationMessage() async {
//     final temp = await imController.loadGroupMessage(
//         msgId: messageList.isEmpty ? "" : messageList[0].msgId ?? "");
//
//     // messageList.addAll(temp);
//   }
//
//   /// 设置当前群组
//   void setGroup(MyGroupInfo info) {
//     groupInfo = info;
//     imController.conversation = groupInfo?.conversation;
//   }
//
//   /// 获取我的群组列表
//   Future<List<MyGroupInfo>> getMyGroup() async {
//     List<MyGroupInfo> result = await imController.getMyGroupList();
//
//     groupList(result);
//
//     return result;
//   }
//
//   /// 信息发送
//   Future<bool> sendMessage(
//       {String? emId,
//       String? text,
//       String? imagePath,
//       String? videoPath,
//       String? videoThumb,
//       String? audio,
//       Map<String, dynamic>? location,
//       String? action,
//       String? custom}) async {
//     /// 如果发送视频，则一起发送视频缩略图，否则
//
//     return await imController.sendMessage(
//         emId: emId,
//         text: text,
//         imagePath: imagePath,
//         videoThumb: videoThumb,
//         videoPath: videoPath,
//         audio: audio,
//         location: location,
//         action: action,
//         custom: custom);
//   }
//
//   /// 信息重发
//   Future<void> reSendMessage(EMMessage msg) async {
//     await imController.reSendMessage(msg);
//   }
//
//   /// 获取群详情
//   Future<EMGroup?> getGroupDetails({required String groupId}) async {
//     return imController.getGroupDetails(groupId: groupId);
//   }
//
//   /// 加入群组，返回群组详情，为空，则加入失败
//   Future<EMGroup?> joinGroup({required String groupId}) async {
//     return await imController.joinGroup(groupId: groupId);
//   }
//
//   /// 退出群组
//   Future<bool> quitGroup({required String groupId}) async {
//     return await imController.quitGroup(groupId: groupId);
//   }
//
//   /// 踢出群组
//   Future<bool> removeMember(
//       {required groupId, String? memberId, List<String>? memberIds}) async {
//     assert((memberIds != null && memberId == null) ||
//         (memberIds == null && memberId != null));
//
//     final ids = memberIds ?? [memberId ?? ""];
//
//     return await imController.removeMembers(groupId: groupId, memberIds: ids);
//   }
//
//   void dispose() {
//     imController.messageList.clear();
//     imController.conversation = null;
//   }
// }
