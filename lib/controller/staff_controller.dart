import 'package:care/constants/api_keys.dart';
import 'package:care/model/staff_list_info.dart';

import '../common/http_controller.dart';
import '../model/staff_info.dart';

class StaffController {
  ///
  factory StaffController() => _getInstance();

  ///
  static StaffController get instance => _getInstance();

  // 静态私有成员，没有初始化
  static StaffController? _instance;

  // 私有构造函数
  StaffController._internal();

  // 静态、同步、私有访问点
  static StaffController _getInstance() {
    _instance ??= StaffController._internal();
    return _instance!;
  }

  void getStaffDetails(
      {required String staffId, Function? success, Function? fail}) {
    // staffId = "10300120220326000149444288662";
    HttpController().get<StaffInfo>(StaffApi.staffDetails,
        query: {"userNo": staffId}, success: success, fail: fail);
  }

  void getStaffList(
      {required int page,
      String? district,
      String? workType,
      String? status,
      int? pageSize,
      Function? success,
      Function? fail}) {
    HttpController().get<StaffListInfo>(StaffApi.staffList,
        query: {
          "district": district,
          "workType": workType,
          "status": status,
          "pageSize": pageSize ?? 15,
          "currPage": page,
        },
        success: success,
        fail: fail);
  }
}
