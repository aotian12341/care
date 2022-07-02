/// 用户
class UserApi {
  /// 注册
  static const String register = "/system/register";

  /// 登陆
  static const String login = "/system/login";

  /// 更新用户信息
  static const String updateUser = "/worker/workerinfo/update";

  /// 短信登陆
  static const String smsLogin = "/system/sms/login";

  /// 发送短信
  static const String sendMsg = "/third/sms/code";

  /// 获取用户信息
  static const String userInfo = "/member/memberinfo/detail";

  /// 实人认证
  static const String ocrCertid = "/third/aliface/certid";

  /// 加载图片
  static const String showImage = "/third/file/showFile";
}

class SystemApi {
  /// 获取所有字典
  static const String systemDictionaryAll = "/system/dictionary/all";

  /// 获取指定所有子项目
  static const String systemDictionaryByCode = "/system/dictionary/items";

  static const String systemDictonaryChild = "/system/dictionary/allchild";

  /// 获取门店列表
  static const String workStoreList = "/worker/store/list";
}

/// 文件
class FileApi {
  /// 上传
  static const String uploadFiles = "/third/file/uploadFiles";

  /// 下载
  static const String downloadFiles = "/third/file/downloadFiles";

  /// 展示图
  static const String showFiles = "/third/file/showFile";
}

/// 地址
class AddressApi {
  /// 列表
  static const String addressList = "/member/address/list";

  /// 新增
  static const String addressSave = "/member/address/save";

  /// 详情
  static const String addressInfo = "/member/address/info/";

  /// 编辑
  static const String addressUpdate = "/member/address/update";

  /// 删除
  static const String addressDelete = "/member/address/delete";
}

/// 需求单
class DemandApi {
  /// 获取雇员对应的需求列表
  static const String demandList = "/member/demand/list";

  /// 雇员投递需求列表
  static const String demandDelivery = "/worker/demand/delivery";

  /// 雇员已投递需求
  static const String demandDelivered = "/worker/demand/delivered";

  static const String demandTemplate = "/system/view/app";

  static const String demandApply = "/member/demand/deploy";

  /// 需求单详情
  static const String demandDetails = "/member/demand/detail/";

  /// 删除需求单
  static const String demandDel = "/member/demand/del/";

  /// 雇主确认雇员
  static const String demandConfirmStaff = "/member/demand/receive";
}

/// 雇员
class StaffApi {
  static const String staffDetails = "/member/worker/info";

  static const String staffList = "/member/worker/page";
}

/// 订单
class OrderApi {
  static const String orderList = "/member/order/list";

  static const String orderDetails = "/member/order/detail";

  static const String orderPay = "/order/wc/prepay";

  static const String orderCancel = "/member/order/cancel";
}
