import 'package:care/common/http_controller.dart';
import 'package:care/constants/api_keys.dart';
import 'package:care/controller/user_controller.dart';
import 'package:care/model/order/order_info.dart';
import 'package:care/model/pay_info.dart';

import '../model/order/order_page_info.dart';

class OrderController {
  ///
  factory OrderController() => _getInstance();

  // 静态私有成员，没有初始化
  static OrderController? _instance;

  // 私有构造函数
  OrderController._internal();

  // 静态、同步、私有访问点
  static OrderController _getInstance() {
    _instance ??= OrderController._internal();
    return _instance!;
  }

  void getOrderList(
      {required int page,
      required int status,
      int? pageSize,
      Function? success,
      Function? fail}) {
    // ("105331", "待确认"), ("105332", "待服务"), ("105333", "服务中"), ("105334", "待付款"), ("105335", "待评价");

    String statusStr = "";
    switch (status) {
      case 0:
        break;
      case 1:
        statusStr = "105331";
        break;
      case 2:
        statusStr = "105332";
        break;
      case 3:
        statusStr = "105333";
        break;
      case 4:
        statusStr = "105334";
        break;
      case 5:
        statusStr = "105335";
        break;
    }

    HttpController().get<OrderPageInfo>(OrderApi.orderList,
        query: {
          "userNo": UserController().userInfo.value.userNo ?? "",
          "status": statusStr,
          "pageSize": pageSize ?? 15,
          "currPage": page,
        },
        success: success,
        fail: fail);
  }

  /// 订单详情
  void getOrderDetails(
      {required String orderNo, Function? success, Function? fail}) {
    HttpController().get<OrderInfo>(OrderApi.orderDetails,
        query: {"orderNo": orderNo}, success: success, fail: fail);
  }

  /// 获取订单支付信息
  void getOrderPay({required String orderNo, Function? success}) {
    HttpController().post<PayInfo>(OrderApi.orderPay,
        query: {
          "orderNo": orderNo,
        },
        success: success,
        showLoading: true,
        showErrorToast: true);
  }

  /// 取消订单
  void orderCancel({required String orderNo, Function? success}) {
    HttpController().post(OrderApi.orderCancel,
        query: {"orderNo": orderNo},
        success: success,
        showLoading: true,
        showErrorToast: true);
  }
}
