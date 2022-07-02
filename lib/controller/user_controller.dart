import 'package:city_pickers/city_pickers.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../common/http_controller.dart';
import '../common/pugin_utils.dart';
import '../constants/api_keys.dart';
import '../constants/cache_keys.dart';
import '../generated/json/base/json_convert_content.dart';
import '../model/base_list.dart';
import '../model/dictionary_item.dart';
import '../model/form_info.dart';
import '../model/shop_Info.dart';
import '../model/user_info.dart';

class UserController {
  ///
  factory UserController() => _getInstance();

  ///
  static UserController get instance => _getInstance();

  // 静态私有成员，没有初始化
  static UserController? _instance;

  // 私有构造函数
  UserController._internal() {
    getCacheToken().then((value) {
      getDictionary();
      getItemDictionary();
      demandTemplate();
      getCacheToken().then((value) {
        getUserInfo();
      });
    });
    // getCacheUserInfo();
  }

  /// 用户数据
  final userInfo = UserInfo().obs;

  /// 所有字典项
  final dictionaryAll = <DictionaryItem>[];

  /// 所有选项字典
  final dictionaryOption = <String, List<DictionaryItem>>{};

  /// 所有需求单模板
  final templateData = <String, List<FormInfo>>{};

  /// 令牌
  String? token;

  /// 是否登陆
  bool get isLogin => userInfo.value.id != null;

  /// 当前城市
  final myCity = Result().obs;

  // 静态、同步、私有访问点
  static UserController _getInstance() {
    _instance ??= UserController._internal();
    return _instance!;
  }

  /// 发送验证码
  void sendMsg({required String phone, Function? success}) {
    HttpController().get<ResultInfo>(
      UserApi.sendMsg,
      query: {"mobile": phone},
      showErrorToast: true,
      showLoading: true,
      success: success,
    );
  }

  /// 注册
  void register(
      {required String phone,
      required String psd,
      required String smsCode,
      Function? success}) {
    HttpController().post<String>(UserApi.register,
        query: {
          "account": phone,
          "passwd": psd,
          "mobile": phone,
          "smsCode": smsCode,
          "identity": "103002"
        },
        showErrorToast: true,
        showLoading: true, success: (value) {
      token = value;
      cacheToken();
      getUserInfo(success: success);
    });
  }

  /// 账号登陆
  void accountLogin(
      {required String phone, required String password, Function? success}) {
    const identity = "103002";
    HttpController().post<Map<String, dynamic>>(
      UserApi.login,
      query: {
        "account": phone,
        "passwd": password,
        "identity": identity,
      },
      showLoading: true,
      showErrorToast: true,
      success: (value) {
        if (value != null) {
          token = value["token"].toString();
          cacheToken();
          getUserInfo(success: success);
        }
      },
    );
  }

  /// 验证码登陆
  void smsLogin(
      {required String phone, required String code, Function? success}) {
    const identity = "103002";
    HttpController().post<Map<String, dynamic>>(UserApi.smsLogin,
        query: {"mobile": phone, "smsCode": code, "identity": identity},
        showLoading: true,
        showErrorToast: true, success: (value) {
      if (value != null) {
        token = value["token"].toString();
        cacheToken();
        getUserInfo(success: success);
      }
    });
  }

  /// 获取用户信息
  void getUserInfo({Function? success, Function? fail}) {
    HttpController().get<UserInfo>(UserApi.userInfo,
        showErrorToast: true, showLoading: true, success: (value) {
      userInfo(value);
      if (success != null) {
        success();
      }
    }, fail: (error) {
      if (fail != null) {
        fail(error);
      }
    });
  }

  /// 更新用户信息
  void updateUser({required Map<String, dynamic> data, Function? success}) {
    HttpController().post<ResultInfo>(
      UserApi.updateUser,
      query: data,
      showLoading: true,
      showErrorToast: true,
      success: success,
    );
  }

  /// 获取Ocr CertId
  void getOcrCertId(
      {required String name, required String id, Function? success}) async {
    final data = {
      "sceneId": "1000003519",
      "productCode": "ID_PRO",
      "certName": name,
      "certNo": id,
      "metaInfo": await PluginUtils().getMetaInfo()
    };

    HttpController().post<String>(UserApi.ocrCertid,
        query: data,
        showLoading: true,
        showErrorToast: true, success: (value) async {
      final id = value;
      final res = await PluginUtils().ocr(certifyId: id);
      print(res);
      success!(res);
    });
  }

  void loadImage() async {
    HttpController().get(UserApi.showImage, query: {
      "bucketName": "photos",
      "fileDir": "test",
      "fileId": "photos_test_1648522658756_wmjZIfnGFvtE.jpg"
    });
  }

  /// 获取所有字典
  void getDictionary({
    Function? success,
  }) async {
    HttpController().get<List<DictionaryItem>>(SystemApi.systemDictionaryByCode,
        success: (value) {
      dictionaryAll.clear();
      dictionaryAll.addAll(value);
    }, showErrorToast: true, showLoading: true);
  }

  /// 根据code获取字典
  DictionaryItem? getDictionaryByCode(
      {required String code, List<DictionaryItem>? source}) {
    DictionaryItem? item;

    source ??= dictionaryAll;

    for (final temp in source) {
      if (temp.code == code) {
        item = temp;
        break;
      } else if ((temp.items ?? []).isNotEmpty) {
        item = getDictionaryByCode(code: code, source: temp.items!);
        if (item != null) {
          break;
        }
      }
    }
    return item;
  }

  /// 获取所有选项的字典
  void getItemDictionary({Function? success}) {
    HttpController().get<Map<String, dynamic>>(SystemApi.systemDictonaryChild,
        success: (Map<String, dynamic> value) {
      value.forEach((key, value) {
        List<DictionaryItem>? list =
            JsonConvert.fromJsonAsT<List<DictionaryItem>>(value);
        dictionaryOption[key] = list ?? [];
        if (success != null) {
          success(dictionaryOption);
        }
      });
    });
  }

  /// 获取需求单模板数据
  void demandTemplate({Function? success}) {
    HttpController().get<Map<String, dynamic>>(DemandApi.demandTemplate,
        success: (Map<String, dynamic> value) {
      value.forEach((key, value) {
        List<dynamic> array = value as List;
        List<FormInfo>? temp = [];
        for (Map<String, dynamic> item in array) {
          temp.add(FormInfo.fromJson(item));
        }
        templateData[key] = temp;
      });
    });
  }

  /// 获取门店列表
  void getShopList({
    String? city,
    String? district,
    double? longitude,
    double? latitude,
    int pageSize = 15,
    int currPage = 1,
    String? orderKey,
    String? orderType,
    Function? success,
    Function? fail,
  }) {
    final data = {
      "city": city,
      "district": district,
      "longitude": longitude,
      "latitude": latitude,
      "pageSize": pageSize,
      "currPage": currPage,
      "orderKey": orderKey,
      "orderType": orderType,
    };

    HttpController().get<BaseList<ShopInfo>>(SystemApi.workStoreList,
        query: data, success: success, fail: fail);
  }

  void cacheToken() async {
    final share = await SharedPreferences.getInstance();

    share.setString(CacheKeys.tokenKey, token!);
  }

  Future<String?> getCacheToken() async {
    final share = await SharedPreferences.getInstance();
    token = share.getString(CacheKeys.tokenKey);
    return token;
  }

  void clearCacheToken() async {
    final share = await SharedPreferences.getInstance();
    share.setString(CacheKeys.tokenKey, "");
  }
}
