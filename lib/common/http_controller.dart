import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:math' as math;

import 'package:care/model/base_list.dart';
import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' as gx;
import '../constants/app_config.dart';
import '../controller/user_controller.dart';
import '../generated/json/base/json_convert_content.dart';
import '../widget/loading/loading.dart';
import '../widget/m_toast.dart';
import 'aes_util.dart';

/// 请求类型
enum HttpMethod {
  ///
  get,

  ///
  post,

  ///
  patch,

  ///
  delete,
}

/// 网络请求
class HttpController {
  static final HttpController _instance = HttpController._internal();

  ///
  late Dio dio;

  ///
  Options? options;

  ///
  Loading? loading;

  /// 请求任务栈
  List<String> taskList = [];

  /// 提供了一个工厂方法来获取该类的实例
  factory HttpController() {
    return _instance;
  }

  /// 通过私有方法_internal()隐藏了构造方法，防止被误创建
  HttpController._internal() {
    // 初始化
    init();
  }
  // Singleton._internal(); // 不需要初始化

  /// 初始化
  void init() {
    dio = Dio();
    dio.options.connectTimeout = 50000;
    dio.options.receiveTimeout = 20000;
    httpLog();
  }

  ///
  Future<T?> get<T>(
    String action, {
    Map<String, Object?>? query,
    Map<dynamic, dynamic>? model,
    bool? showLoading,
    bool? showErrorToast,
    Function? success,
    Function? fail,
  }) async {
    return call<T>(
      action,
      data: query,
      model: model,
      method: HttpMethod.get,
      loading: showLoading,
      showTips: showErrorToast,
      success: success,
      fail: fail,
    );
  }

  /// post
  Future<T?> post<T>(
    String action, {
    Map<String, Object?>? query,
    Map<dynamic, dynamic>? model,
    bool? showLoading,
    bool? showErrorToast,
    Function? success,
    Function? fail,
  }) async {
    return call<T>(
      action,
      data: query,
      model: model,
      method: HttpMethod.post,
      loading: showLoading,
      showTips: showErrorToast,
      success: success,
      fail: fail,
    );
  }

  /// 网络请求
  Future<T?> call<T>(
    String action, {
    Map<String, dynamic>? data,
    Map<dynamic, dynamic>? model,
    HttpMethod method = HttpMethod.get,
    bool? loading,
    bool? showTips,
    Function? success,
    Function? fail,
  }) async {
    String taskId = DateTime.now().millisecondsSinceEpoch.toString() +
        math.Random().nextInt(1000).toString();
    final extra = <String, dynamic>{};
    extra["taskId"] = taskId;
    Options callOptions = Options(extra: extra);

    /// 是否显示loading
    if (loading ?? false) {
      taskList.add(taskId);
      showLoading();
    }

    /// 基础api
    String url = AppConfig.baseUrl;

    /// 若action为方法，则是正常调用，若action为完整url，则认为是访问第三方网站，直接把返回值回调
    bool isNormal = true;

    /// action.startsWith 检测字符串是否为"http"开头
    if (action.startsWith("http")) {
      url = action;
      isNormal = false;
    } else {
      url += action;
    }

    if (UserController.instance.token == null) {
      final tk = AesUtil.getTk();

      url += "?tk=$tk";
    } else {
      dio.options.headers["Authorization"] = UserController.instance.token;
    }
    dio.options.headers["Content-Type"] = "application/json";
    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (client) {
      client.badCertificateCallback = (cert, host, port) {
        return true;
      };
    };

    data ??= <String, dynamic>{};

    if (model != null) {
      model.forEach((dynamic key, dynamic value) {
        if (value != null) {
          data![key.toString()] = value;
        }
      });
    }

    data.removeWhere((key, dynamic value) => value == null || value == "");

    late Response<dynamic> response;

    try {
      if (method == HttpMethod.get) {
        response = await dio.get<dynamic>(url,
            queryParameters: data, options: callOptions);
      } else if (method == HttpMethod.post) {
        response =
            await dio.post<dynamic>(url, data: data, options: callOptions);
      }
    } on DioError catch (error) {
      String errorStr = "";

      if (taskList.contains(error.requestOptions.extra["taskId"].toString())) {
        taskList.remove(error.requestOptions.extra["taskId"].toString());
      }

      hideLoading();
      if (error.toString().contains("400001") ||
          error.toString().contains("403111")) {
        errorStr = "请先登录";
      } else if (error.type == DioErrorType.other) {
        errorStr = "无网络";
      } else if (error.type == DioErrorType.connectTimeout) {
        // 请求超时
        errorStr = "网络请求超时，请稍后重试";
      } else if (error.type == DioErrorType.receiveTimeout) {
        // 请求连接超时
        errorStr = "网络连接超时，请稍后重试";
      } else if (error.type == DioErrorType.response) {
        // 服务器错误
        errorStr = "服务器繁忙，请稍后重试";
      } else {
        errorStr = error.toString();
      }
      onError(msg: errorStr, fail: fail, showTips: showTips);

      hideLoading();

      return null;
    }

    if (taskList.contains(response.requestOptions.extra["taskId"].toString())) {
      taskList.remove(response.requestOptions.extra["taskId"].toString());
    }

    hideLoading();

    if (response.data is DioError) {
      onError(
          msg: response.data['msg'] as String, fail: fail, showTips: showTips);
      return null;
    }

    /// 如果不是咱配置的域名，因为格式不合适，所以不解析，直接就返回了
    if (!isNormal) {
      final _map = Map<String, dynamic>.from(response.data as Map);
      onSuccess<T>(success, _map);
      return _map as T;
    }

    if (response.data is Map) {
      final int code = response.data["code"] as int;
      if (code == 0) {
        dynamic temp;
        try {
          if (response.data["data"] == null) {
            if (T.toString() == (ResultInfo).toString()) {
              ResultInfo info = ResultInfo();
              info.code = response.data["code"] as int;
              info.msg = response.data['msg'] as String;
              temp = info as T;
            } else {
              temp = null;
            }
          } else if (<T>[] is List<int>) {
            temp = response.data["data"] as int;
          } else if (<T>[] is List<double>) {
            temp = response.data["data"] as double;
          } else if (<T>[] is List<String>) {
            temp = response.data["data"] as String;
          } else if (<T>[] is List<bool>) {
            temp = response.data["data"] as bool;
          } else if (<T>[] is List<Map>) {
            temp = Map<String, dynamic>.from(response.data["data"] as Map);
          } else if (T.toString() == (ResultInfo).toString()) {
            ResultInfo info = ResultInfo();
            info.data = response.data["data"];
            info.code = response.data["code"] as int;
            info.msg = response.data['msg'] as String;
            temp = info as T;
          } else {
            temp = JsonConvert.fromJsonAsT<T>(response.data["data"]);
          }
          onSuccess<T>(success, temp);
        } catch (error) {
          onError(msg: "数据解析失败", fail: fail, showTips: showTips);
          return null;
        }

        return temp as T;
      } else {
        onError(
            msg: response.data['msg'] as String,
            fail: fail,
            showTips: showTips);
        return null;
      }
    } else {
      return response.data;
    }
  }

  ///
  void onSuccess<T>(Function? success, dynamic t) {
    if (success != null) {
      success(t as T);
    }
  }

  ///
  void onError({required String msg, Function? fail, bool? showTips}) {
    if ((showTips ?? false) && fail == null) {
      MToast.show(msg);
    }
    if (fail != null) {
      fail(msg);
    }
  }

  /// 显示loading
  void showLoading() {
    if (gx.Get.context != null) {
      if (loading == null) {
        loading = const Loading();
        showDialog<dynamic>(
          context: gx.Get.context!,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return loading!;
          },
        );
      }
    }
  }

  /// 隐藏loading
  void hideLoading() {
    if (gx.Get.context != null && loading != null && taskList.isEmpty) {
      loading!.hide(gx.Get.context!);
      loading = null;
    }
  }

  /// 拦截器
  void httpLog() {
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (RequestOptions options, RequestInterceptorHandler handler) {
          log("\n================================= 请求数据 =================================");
          log("method = ${options.method.toString()}");
          log("url = ${options.uri.toString()}");
          log("headers = ${options.headers}");
          log("requestTime = ${DateTime.now()}");
          if (options.method.toString() == "GET") {
            log("data = ${options.queryParameters}");
          } else {
            log("data = ${options.data}");
          }
          return handler.next(options);
        },
        onResponse: (
          Response response,
          ResponseInterceptorHandler handler,
        ) {
          log("================================= 响应数据开始 =================================");
          log("code = ${response.statusCode}");
          log("responseTime = ${DateTime.now()}");
          log("url = ${response.requestOptions.path}");
          log("header = ${response.requestOptions.headers}");
          log("params = ${response.requestOptions.queryParameters}");
          log("data = ${json.encode(response.data)}");
          if (response.requestOptions.method.toString() == "GET") {
            log("data = ${json.encode(response.requestOptions.queryParameters)}");
          } else {
            log("data = ${json.encode(response.requestOptions.data)}");
          }
          log("================================= 响应数据结束 =================================\n");
          return handler.next(response);
        },
        onError: (DioError e, ErrorInterceptorHandler handler) {
          log("\n=================================错误响应数据 =================================");
          log("type = ${e.type}");
          log("url = ${e.requestOptions.path}");
          log("header = ${e.requestOptions.headers}");
          log("params = ${e.requestOptions.queryParameters}");
          log("message = ${e.message}");
          log("stackTrace = ${e.error}");
          log("\n");
          return handler.next(e);
        },
      ),
    );
  }

  /// 单纯的Json格式输出打印
  void printJson(Object object) {
    const encoder = JsonEncoder.withIndent('  ');
    try {
      final encoderString = encoder.convert(object);
      debugPrint(encoderString);
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> download({
    required String url,
    required String path,
    DownloadListener? listener,
  }) async {
    try {
      File file = File(path);
      if (!file.existsSync()) {
        file.createSync();
      }

      if (listener != null) {
        listener.onStart();
      }
      final response =
          await Dio().get(url, onReceiveProgress: (int count, int total) {
        double radio = count / total;
        if (listener != null) {
          listener.onProgress(total, radio);
        }
      },
              options: Options(
                responseType: ResponseType.bytes,
                followRedirects: false,
              ));
      file.writeAsBytesSync(response.data);

      if (listener != null) {
        listener.onFinish();
      }
    } catch (e) {
      if (listener != null) {
        listener.onError(e.toString());
      }
    }
  }
}

class DownloadListener {
  DownloadListener({
    required this.onStart,
    required this.onProgress,
    required this.onFinish,
    required this.onError,
  });

  final Function onStart;

  final Function(int total, double progress) onProgress;

  final Function onFinish;

  final Function(String error) onError;
}

class ResultInfo {
  int? code;
  String? msg;
  Object? data;
}
