import 'dart:math';
import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' as get_u;
import 'package:permission_handler/permission_handler.dart';
import 'package:uuid/uuid.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';
import 'package:wechat_camera_picker/wechat_camera_picker.dart';

import '../../common/colors.dart';
import '../../common/http_controller.dart';
import '../../common/util.dart';
import '../../constants/app_config.dart';
import '../../controller/user_controller.dart';
import '../m_toast.dart';
import 'file_picker.dart';

/// 上传文件
class UploadUtils {
  ///
  static void pickerFile({
    required BuildContext context,
    FileType fileType = FileType.image,
    PickerType pickerType = PickerType.all,
    int max = 9,
    Function(List<AssetEntity> files)? pickBack,
  }) async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.camera,
      Permission.storage,
    ].request();

    if (statuses[Permission.camera] == PermissionStatus.granted &&
        statuses[Permission.storage] == PermissionStatus.granted) {
      if (fileType == FileType.file || fileType == FileType.sound) {
      } else {
        get_u.Get.bottomSheet<dynamic>(Container(
          height: (pickerType == PickerType.all ? 45 * 3 : 45 * 2) +
              MediaQueryData.fromWindow(window).padding.bottom,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
            color: DSColors.white,
          ),
          child: Column(
            children: [
              if (pickerType == PickerType.camera ||
                  pickerType == PickerType.all)
                InkWell(
                    onTap: () {
                      Navigator.pop(context);
                      _pickerCamera(
                        context: context,
                        fileType: fileType,
                        pickBack: pickBack,
                      );
                    },
                    child: Container(
                      height: 45,
                      decoration: BoxDecoration(
                          border:
                              Border(bottom: BorderSide(color: DSColors.ee))),
                      child: Center(
                        child: Text(
                          "拍摄",
                          style: TextStyle(color: DSColors.title),
                        ),
                      ),
                    )),
              if (pickerType == PickerType.gallery ||
                  pickerType == PickerType.all)
                InkWell(
                    onTap: () {
                      Navigator.pop(context);
                      _pickerGallery(
                        context: context,
                        type: fileType,
                        pickBack: pickBack,
                      );
                    },
                    child: Container(
                      height: 45,
                      decoration: BoxDecoration(
                          border:
                              Border(bottom: BorderSide(color: DSColors.ee))),
                      child: Center(
                        child:
                            Text("相册", style: TextStyle(color: DSColors.title)),
                      ),
                    )),
              InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: SizedBox(
                    height: 45,
                    child: Center(
                      child:
                          Text("取消", style: TextStyle(color: DSColors.title)),
                    ),
                  )),
            ],
          ),
        ));
      }
    }
  }

  ///
  static void _pickerCamera({
    required BuildContext context,
    FileType fileType = FileType.image,
    Function(List<AssetEntity> files)? pickBack,
  }) async {
    AssetEntity? entity;
    if (fileType == FileType.video) {
      entity = await CameraPicker.pickFromCamera(
        context,
        enableRecording: true,
        onlyEnableRecording: true,
      );
      if (entity?.type != AssetType.video) {
        MToast.show("请拍摄视频");
        return;
      }
    } else {
      entity = await CameraPicker.pickFromCamera(context);
    }

    if (entity != null && pickBack != null) {
      pickBack([entity]);
    }
  }

  ///
  static void _pickerGallery({
    required BuildContext context,
    FileType? type,
    int? max,
    Function(List<AssetEntity> files)? pickBack,
  }) async {
    final List<AssetEntity>? assets = await AssetPicker.pickAssets(
      context,
      maxAssets: max ?? 1,
      requestType: type == FileType.image
          ? RequestType.image
          : type == FileType.video
              ? RequestType.video
              : RequestType.all,
      specialPickerType: SpecialPickerType.wechatMoment,
    );

    if (pickBack != null && (assets ?? []).isNotEmpty) {
      pickBack(assets!);
    }
  }

  /// 取消
  void cancel(CancelToken token) {
    token.cancel();
  }

  static Future<String> uploadFile({
    required String path,
    String? rootDir,
    UploadListener? listener,
    String? fileType,
  }) async {
    final url = AppConfig.baseUrl + "/third/file/uploadFiles";

    const bucketName = "photos";
    rootDir ??= "test";

    BaseOptions options = BaseOptions();
    options.responseType = ResponseType.plain;

    //创建dio对象
    Dio dio = HttpController().dio;

    dio.options.headers["Authorization"] = UserController.instance.token;
    dio.options.headers["contentType"] = 'multipart/form-data';
    dio.options.headers["content-type"] = 'multipart/form-data';

    final time = DateTime.now();
    String pathName =
        '$rootDir/${time.year}/${time.month}/${time.day}/${getRandom(12)}.${fileType ?? getFileType(path)}';

    // Map<String, dynamic> params = <String, dynamic>{
    //   'bucketName': bucketName,
    //   'fileDir': rootDir,
    //   'files': MultipartFile.fromFileSync(path),
    // };

    FormData formData = FormData.fromMap({
      'bucketName': bucketName,
      'fileDir': rootDir,
      "files": [
        await MultipartFile.fromFile(path,
            filename: "${getRandom(12)}.${fileType ?? getFileType(path)}"),
      ]
    });

    // // 请求参数的form对象
    // FormData data = FormData.fromMap(params);

    CancelToken uploadCancelToken = CancelToken();

    final uuid = const Uuid().v4().toString();

    if (listener?.onCreate != null) {
      listener?.onCreate!(uuid, uploadCancelToken);
    }

    try {
      // 发送请求
      Response response = await dio
          .post<dynamic>(url, data: formData, cancelToken: uploadCancelToken,
              onSendProgress: (int count, int data) {
        // print("$count    $data      ${count / data}");
        if (listener?.onProgress != null) {
          listener?.onProgress!(uuid, count, data);
        }
      });
      // 成功后返回文件访问路径
      // listener?.onSuccess(uuid, '$pathName', "");

      final data = response.data;
      if (data["code"] == 0) {
        final res = data["data"];
        final ids = res["fileIds"] as List;
        if (ids.isNotEmpty) {
          print(Util.getImage(id: ids[0]));
          if (listener?.onSuccess != null) {
            listener?.onSuccess!(uuid, '${ids[0]}');
          }
        }
      }

      return '$pathName';
    } catch (e) {
      print(e);
      if (listener?.onError != null) {
        listener?.onError!(uuid, e.toString());
      }
    }
    return "";
  }

  /*
  * 生成固定长度的随机字符串
  * */
  static String getRandom(int num) {
    String alphabet = 'qwertyuiopasdfghjklzxcvbnmQWERTYUIOPASDFGHJKLZXCVBNM';
    String left = '';
    for (var i = 0; i < num; i++) {
//    right = right + (min + (Random().nextInt(max - min))).toString();
      left = left + alphabet[Random().nextInt(alphabet.length)];
    }
    return left;
  }

  /*
  * 根据图片本地路径获取图片名称
  * */
  static String getImageNameByPath(String filePath) {
    // ignore: null_aware_before_operator
    return filePath.substring(filePath.lastIndexOf("/") + 1, filePath.length);
  }

  /**
   * 获取文件类型
   */
  static String getFileType(String path) {
    print(path);
    List<String> array = path.split('.');
    return array[array.length - 1];
  }
}

/// 上传回调
class UploadListener {
  /// 创建
  Function(String uploadId, CancelToken token)? onCreate;

  /// 成功
  Function(String uploadId, String url)? onSuccess;

  /// 失败
  Function(String uploadId, String error)? onError;

  /// 进度
  Function(String uploadId, int done, int total)? onProgress;

  ///
  UploadListener({
    this.onCreate,
    this.onSuccess,
    this.onError,
    this.onProgress,
  });
}
