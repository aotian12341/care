// import 'package:get/get.dart';
// import 'package:im_flutter_sdk/im_flutter_sdk.dart';
//
//
// class ImController implements EMConnectionListener, EMChatManagerListener {
//   ///
//   factory ImController() => _getInstance();
//
//   ///
//   static ImController get instance => _getInstance();
//
//   // 静态私有成员，没有初始化
//   static ImController? _instance;
//
//   // 私有构造函数
//   ImController._internal() {
//     initIm();
//   }
//
//   // 静态、同步、私有访问点
//   static ImController _getInstance() {
//     _instance ??= ImController._internal();
//     return _instance!;
//   }
//
//   final groupList = <MyGroupInfo>[].obs;
//   final messageList = <EMMessage>[].obs;
//
//   late String account, password, imId;
//
//   ConnectionListener? connectionListener;
//
//   EMConversation? conversation;
//
//   EMUserInfo? userInfo;
//
//   /// 初始化
//   void initIm() async {
//     EMOptions options = EMOptions(appKey: '1138190715085099#wxml');
//     EMPushConfig config = EMPushConfig();
// // 配置推送信息
//     config
//       ..enableAPNs("chatdemoui_dev")
//       ..enableHWPush()
//       ..enableFCM('')
//       ..enableMeiZuPush('', '')
//       ..enableMiPush('', '');
//     options.pushConfig = config;
//     await EMClient.getInstance.init(options);
//
//     EMClient.getInstance.addConnectionListener(this);
//
//     // EMClient.getInstance.chatManager.removeListener(this);
//     EMClient.getInstance.chatManager.addListener(this);
//
//     if (EMClient.getInstance.currentUsername != null) {
//       getMyGroupList();
//     }
//
//     print("Im   initIm:success");
//   }
//
//   /// 登陆
//   Future<void> login(
//       {required String account, required String password}) async {
//     try {
//       final imId = await EMClient.getInstance.login(account, password);
//       if (imId != null) {
//         this.account = account;
//         this.password = password;
//         this.imId = imId;
//
//         userInfo = await EMClient.getInstance.userInfoManager.fetchOwnInfo();
//
//         getMyGroupList();
//
//         print("Im   login:success");
//       }
//     } on EMError catch (e) {
//       print("Im   login:$e");
//     }
//   }
//
//   /// 获取当前用户群组信息
//   Future<List<MyGroupInfo>> getMyGroupList() async {
//     final groups = await getMyGroupListService(); //getMyGroupListCache();
//     groupList.clear();
//     for (final info in groups) {
//       await getGroupMemberListFromServer(groupId: info.groupId ?? "");
//       final conv = await getConversation(emId: info.groupId ?? "");
//       final count = conv!.unreadCount ?? 0;
//       final message = conv.lastReceivedMessage;
//       final group = MyGroupInfo(
//           group: info, conversation: conv, count: count, message: message);
//       groupList.add(group);
//     }
//
//     return groupList;
//   }
//
//   /// 注册
//   Future<String?> register(
//       {required String account, required String password}) async {
//     try {
//       final imId = await EMClient.getInstance.createAccount(account, password);
//       if (imId != null) {
//         this.account = account;
//         this.password = password;
//         this.imId = imId;
//
//         print("Im   login:success");
//         return imId;
//       }
//     } on EMError catch (e) {
//       print("Im   register:$e");
//     }
//
//     return null;
//   }
//
//   /// 获取当前登陆ID
//   String? getAccountId() {
//     return EMClient.getInstance.currentUsername;
//   }
//
//   Future<bool> Function() isLogin() {
//     return EMClient.getInstance.isLoginBefore;
//   }
//
//   /// 登出
//   Future<bool> loginOut() async {
//     try {
//       // true: 是否解除deviceToken绑定。
//       final result = await EMClient.getInstance.logout(true);
//       return result;
//     } on EMError catch (e) {
//       print('Im   操作失败，原因是: $e');
//     }
//     return false;
//   }
//
//   /// 创建群组
//   Future<EMGroup?> createGroup({required String groupName}) async {
//     try {
//       EMGroup group = await EMClient.getInstance.groupManager.createGroup(
//           groupName,
//           settings: EMGroupOptions(style: EMGroupStyle.PublicOpenJoin));
//
//       return group;
//     } catch (e) {
//       print("Im   createGroup:操作失败，原因是$e");
//     }
//
//     return null;
//   }
//
//   /// 加载消息
//   Future<List<EMMessage>> loadGroupMessage({String? msgId}) async {
//     try {
//       /*
//       final msg = await conversation?.loadMessages(
//           startMsgId:
//               messageList.isNotEmpty ? messageList.last.msgId ?? "" : "");
//       messageList.addAll((msg ?? []).reversed);
//
//        */
//
//       final msg = await conversation?.loadMessages(startMsgId: msgId ?? "");
//
//       messageList.addAll((msg ?? []).reversed);
//
//       return msg ?? [];
//     } on EMError catch (e) {
//       print('Im    loadGroupMessage:操作失败，原因是: $e');
//     }
//
//     return [];
//   }
//
//   /// 加入群组
//   Future<EMGroup?> joinGroup({required String groupId}) async {
//     try {
//       final result =
//           await EMClient.getInstance.groupManager.joinPublicGroup(groupId);
//       print(result);
//       return result;
//     } on EMError catch (e) {
//       print('Im   joinGroup:操作失败，原因是: $e');
//     }
//     return null;
//   }
//
//   /// 退出群组
//   Future<bool> quitGroup({required String groupId}) async {
//     try {
//       await EMClient.getInstance.groupManager.leaveGroup(groupId);
//       return true;
//     } on EMError catch (e) {
//       print('Im   quitGroup:操作失败，原因是: $e');
//       return false;
//     }
//   }
//
//   /// 移出群组
//   Future<bool> removeMembers(
//       {required String groupId, required List<String> memberIds}) async {
//     try {
//       await EMClient.getInstance.groupManager.removeMembers(groupId, memberIds);
//       return true;
//     } on EMError catch (e) {
//       print('Im   removeMembers:操作失败，原因是: $e');
//       return false;
//     }
//   }
//
//   /// 解散群
//   Future<bool> destroyGroup({required String groupId}) async {
//     try {
//       await EMClient.getInstance.groupManager.destroyGroup(groupId);
//       return true;
//     } on EMError catch (e) {
//       print('Im   destroyGroup:操作失败，原因是: $e');
//       return false;
//     }
//   }
//
//   /// 获取群组信息
//   Future<EMGroup?> getGroupDetails({required String groupId}) async {
//     try {
//       EMGroup group = await EMClient.getInstance.groupManager
//           .getGroupSpecificationFromServer(groupId);
//       return group;
//     } on EMError catch (e) {
//       print('Im   getGroupDetails 操作失败，原因是: $e');
//     }
//
//     return null;
//   }
//
//   /// 获取群组成员列表
//   Future<EMCursorResult<String>?> getGroupMemberListFromServer(
//       {required String groupId}) async {
//     try {
//       EMCursorResult<String> group = await EMClient.getInstance.groupManager
//           .getGroupMemberListFromServer(groupId);
//       return group;
//     } on EMError catch (e) {
//       print('Im   getGroupMemberListFromServer 操作失败，原因是: $e');
//     }
//
//     return null;
//   }
//
//   /// 从本地缓存获取群组
//   Future<List<EMGroup>> getMyGroupListCache() async {
//     try {
//       List<EMGroup> groupsList =
//           await EMClient.getInstance.groupManager.getJoinedGroups();
//       return groupsList;
//     } catch (e) {
//       print('Im   getMyGroupListCache操作失败，原因是: $e');
//     }
//     return [];
//   }
//
//   /// 从服务器获取群组
//   Future<List<EMGroup>> getMyGroupListService() async {
//     try {
//       List<EMGroup> groupsList =
//           await EMClient.getInstance.groupManager.getJoinedGroupsFromServer();
//       return groupsList;
//     } on EMError catch (e) {
//       print('Im   getMyGroupListService，原因是: $e');
//     }
//     return [];
//   }
//
//   /// 获取用户属性
//   Future<Map<String, EMUserInfo>> fetchUserInfoByUserId(
//       List<String> userIds) async {
//     try {
//       Map<String, EMUserInfo> resultMap = await EMClient
//           .getInstance.userInfoManager
//           .fetchUserInfoByIdWithExpireTime(userIds);
//
//       return resultMap;
//     } on EMError catch (e) {
//       print('Im   fetchUserInfoByUserId，原因是: $e');
//     }
//     return {};
//   }
//
//   /// 设置连接监听
//   void setConnectionListener(ConnectionListener listener) {
//     connectionListener = listener;
//   }
//
//   /// 获取当前连接状态
//   bool getConnectionState() {
//     return EMClient.getInstance.connected;
//   }
//
//   /// 获取会话列表
//   Future<List<EMConversation>> getConversationList() async {
//     try {
//       List<EMConversation> conList =
//           await EMClient.getInstance.chatManager.loadAllConversations();
//       return conList;
//     } on EMError catch (e) {
//       print('Im   getConversationList:操作失败，原因是: $e');
//     }
//     return [];
//   }
//
//   /// 创建会话
//   Future<EMConversation?> createConversation({required String emId}) async {
//     try {
//       // emId: 会话对应环信id, 如果是群组或者聊天室，则为群组id或者聊天室id
//       conversation = await EMClient.getInstance.chatManager
//           .getConversation(emId, EMConversationType.GroupChat);
//
//       return conversation;
//     } on EMError catch (e) {
//       print('Im    createConversation:操作失败，原因是: $e');
//     }
//
//     return null;
//   }
//
//   /// 获取对话
//   Future<EMConversation?> getConversation({required String emId}) async {
//     try {
//       // emId: 会话对应环信id, 如果是群组或者聊天室，则为群组id或者聊天室id
//       final conv = await EMClient.getInstance.chatManager.getConversation(emId);
//       return conv;
//     } on EMError catch (e) {
//       print('操作失败，原因是: $e');
//     }
//     return null;
//   }
//
//   Future<void> setUserInfo() async {
//     try {
//       EMUserInfo info = EMUserInfo(EMClient.getInstance.currentUsername ?? "");
//       info.copyWith(
//         sign: "修改签名",
//         nickName: "用户属性昵称",
//         mail: "xxx@easemob.com",
//         avatarUrl:
//             "https://c-ssl.duitang.com/uploads/item/201506/30/20150630144824_JiutA.jpeg",
//       );
//       await EMClient.getInstance.userInfoManager.updateOwnUserInfo(info);
//     } on EMError catch (e) {
//       print('操作失败，原因是: $e');
//     }
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
//     EMMessage? msg;
//
//     emId ??= conversation!.id;
//
//     if (text != null) {
//       // 文本消息
//       msg = EMMessage.createTxtSendMessage(emId, text);
//     } else if (imagePath != null) {
//       // 图片消息
//       msg =
//           EMMessage.createImageSendMessage(username: emId, filePath: imagePath);
//     } else if (videoPath != null) {
//       // 视频消息
//       msg = EMMessage.createVideoSendMessage(
//           username: emId,
//           filePath: videoPath,
//           thumbnailLocalPath: videoThumb ?? "");
//     } else if (audio != null) {
//       // 音频消息
//       msg = EMMessage.createVoiceSendMessage(username: emId, filePath: audio);
//     } else if (location != null) {
//       // 位置消息
//       msg = EMMessage.createLocationSendMessage(
//           username: emId,
//           latitude: location["lat"] ?? 0,
//           longitude: location["lng"] ?? 0,
//           address: location["address"] ?? "");
//     } else if (action != null) {
//       // cmd消息
//       msg = EMMessage.createCmdSendMessage(username: emId, action: action);
//     } else if (custom != null) {
//       // 自定义消息
//       msg = EMMessage.createCustomSendMessage(username: emId, event: custom);
//     }
//
//     msg?.chatType = EMMessageChatType.GroupChat;
//
//     // msg?.attributes = {
//     //   "nikName": UserController.instance.userInfo.value.phone ?? "",
//     //   "avatarUrl": UserController.instance.userInfo.value.headimg ?? "",
//     // };
//
//     if (msg != null) {
//       try {
//         final result = await EMClient.getInstance.chatManager.sendMessage(msg);
//
//         await conversation!.insertMessage(msg);
//         messageList.insert(0, msg);
//         messageList.refresh();
//
//         MessageStatusListener(
//           emMessage: msg,
//           onMsgStatusChanged: () {},
//           onMsgReadAck: () {},
//           onMsgDeliveryAck: () {},
//           onMsgSuccess: () async {
//             final index = messageList.indexOf(msg);
//
//             messageList[index] = result;
//
//             messageList.refresh();
//           },
//           onMsgError: (EMError error) {
//             final index = messageList.indexOf(msg);
//
//             messageList[index] = result;
//
//             messageList.refresh();
//           },
//           onMsgProgress: (int progress) {},
//         );
//
//         return true;
//       } on EMError catch (e) {
//         print('Im    sendMessage:操作失败，原因是: $e');
//       }
//     }
//
//     return false;
//   }
//
//   /// 信息重发
//   Future<void> reSendMessage(EMMessage msg) async {
//     try {
//       final result = await EMClient.getInstance.chatManager.resendMessage(msg);
//       MessageStatusListener(
//         emMessage: msg,
//         onMsgStatusChanged: () {},
//         onMsgReadAck: () {},
//         onMsgDeliveryAck: () {},
//         onMsgSuccess: () async {
//           final index = messageList.indexOf(msg);
//
//           messageList[index] = result;
//
//           messageList.refresh();
//         },
//         onMsgError: (EMError error) {
//           final index = messageList.indexOf(msg);
//
//           messageList[index] = result;
//
//           messageList.refresh();
//         },
//         onMsgProgress: (int progress) {},
//       );
//     } on EMError catch (e) {
//       print('Im    reSendMessage:操作失败，原因是: $e');
//     }
//   }
//
//   /// 信息已读
//   Future<void> messageRead({required String msgId}) async {
//     try {
//       conversation?.markMessageAsRead(msgId);
//     } on EMError catch (e) {
//       print('Im    messageRead:操作失败，原因是: $e');
//     }
//   }
//
//   /// 所有信息已读
//   Future<void> messageAllRead() async {
//     try {
//       conversation?.markAllMessagesAsRead();
//     } on EMError catch (e) {
//       print('Im    messageRead:操作失败，原因是: $e');
//     }
//   }
//
//   /// 获取组员ID
//   Future<EMCursorResult?> getGroupMember() async {
//     try {
//       EMCursorResult result = await EMClient.getInstance.groupManager
//           .getGroupMemberListFromServer(conversation?.id ?? "");
//       return result;
//     } on EMError catch (e) {
//       print('操作失败，原因是: $e');
//     }
//     return null;
//   }
//
//   @override
//   void onConnected() {
//     if (connectionListener != null) {
//       connectionListener!.onConnected();
//     }
//   }
//
//   @override
//   void onDisconnected(int? errorCode) {
//     if (connectionListener != null) {
//       connectionListener!.onDisconnected(errorCode);
//     }
//   }
//
//   void dispose() {
//     // 移除连接监听
//     EMClient.getInstance.removeConnectionListener(this);
//     EMClient.getInstance.chatManager.removeListener(this);
//   }
//
//   @override
//   void onCmdMessagesReceived(List<EMMessage> messages) {
//     // TODO: implement onCmdMessagesReceived
//   }
//
//   @override
//   void onConversationRead(String? from, String? to) {
//     // TODO: implement onConversationRead
//   }
//
//   @override
//   void onConversationsUpdate() {
//     // TODO: implement onConversationsUpdate
//   }
//
//   @override
//   void onGroupMessageRead(List<EMGroupMessageAck> groupMessageAcks) {
//     // TODO: implement onGroupMessageRead
//   }
//
//   @override
//   void onMessagesDelivered(List<EMMessage> messages) {
//     // TODO: implement onMessagesDelivered
//   }
//
//   @override
//   void onMessagesRead(List<EMMessage> messages) {
//     // TODO: implement onMessagesRead
//   }
//
//   @override
//   void onMessagesRecalled(List<EMMessage> messages) {
//     // TODO: implement onMessagesRecalled
//   }
//
//   @override
//   void onMessagesReceived(List<EMMessage> messages) async {
//     print("Im    onMessagesReceived:$messages");
//
//     for (final msg in messages) {
//       for (final group in groupList) {
//         if (msg.conversationId == group.group.groupId) {
//           group.message = msg;
//           final conv = await getConversation(emId: msg.conversationId ?? "");
//           group.count = conv!.unreadCount ?? 0;
//           continue;
//         }
//       }
//       if (conversation?.id == msg.conversationId) {
//         messageList.insert(0, msg);
//         messageRead(msgId: msg.msgId ?? "");
//       }
//     }
//
//     groupList.refresh();
//     messageList.refresh();
//   }
// }
//
// class ConnectionListener {
//   ConnectionListener({required this.onConnected, required this.onDisconnected});
//
//   final Function() onConnected;
//
//   final Function(int? errorCode) onDisconnected;
// }
//
// class MessageStatusListener implements EMMessageStatusListener {
//   MessageStatusListener({
//     required this.emMessage,
//     required this.onMsgProgress,
//     required this.onMsgError,
//     required this.onMsgSuccess,
//     required this.onMsgReadAck,
//     required this.onMsgDeliveryAck,
//     required this.onMsgStatusChanged,
//   }) {
//     emMessage.setMessageListener(this);
//   }
//
//   final EMMessage emMessage;
//
//   // 消息进度
//   final Function(int progress) onMsgProgress;
//
//   // 消息发送失败
//   final Function(EMError error) onMsgError;
//
//   // 消息发送成功
//   final Function() onMsgSuccess;
//
//   // 消息已读
//   final Function() onMsgReadAck;
//
//   // 消息已送达
//   final Function() onMsgDeliveryAck;
//
//   // 消息状态发生改变
//   final Function() onMsgStatusChanged;
//
//   @override
//   void onDeliveryAck() {
//     onMsgDeliveryAck();
//   }
//
//   @override
//   void onError(EMError error) {
//     onMsgError(error);
//   }
//
//   @override
//   void onProgress(int progress) {
//     onMsgProgress(progress);
//   }
//
//   @override
//   void onReadAck() {
//     onMsgReadAck();
//   }
//
//   @override
//   void onStatusChanged() {
//     onMsgStatusChanged();
//   }
//
//   @override
//   void onSuccess() {
//     onMsgSuccess();
//   }
// }
//
// class MyGroupInfo {
//   MyGroupInfo({
//     required this.group,
//     this.conversation,
//     this.message,
//     this.count,
//   });
//
//   EMGroup group;
//   EMConversation? conversation;
//   EMMessage? message;
//   int? count;
// }
