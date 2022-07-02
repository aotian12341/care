import 'dart:io';
import 'dart:math';
import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

import '../../common/colors.dart';
import '../../common/util.dart';
import '../m_toast.dart';
import 'upload_utils.dart';
import 'photo_view.dart';

/// 选择器文件类型
enum FileType {
  /// 这个文件类型说明打开选图时，可以选择一个视频或者多个图片,如果初始值给出的路径为了判断是否是视频，只能识别常用的mp4,3gp,avi,mov,rmvb,rm,flv,mov,mepg,wmv,mkv,mkv格式
  media,

  /// 图片
  image,

  /// 视频
  video,

  /// 录音
  sound,

  /// 其他
  file
}

/// 组件类型
enum WidgetType {
  /// 选择后不上传
  loc,

  /// 选择后上传阿里云
  net,
}

/// 上传类型
enum PickerType {
  /// 拍照
  camera,

  /// 相册
  gallery,

  /// 全部
  all,
}

/// 文件选择组件
class FilePicker extends StatefulWidget {
  ///
  const FilePicker({
    Key? key,
    this.type = WidgetType.net,
    this.fileList = const <String>[],
    this.fileType = FileType.image,
    this.max = 1,
    this.column = 3,
    this.cellRatio = 1,
    this.cellHeight,
    this.cellWidth,
    this.rowSpacing = 10,
    this.columnSpacing = 10,
    this.showAddView = true,
    this.pickerType = PickerType.all,
    this.itemBuilder,
    this.callBack,
    this.delBack,
    this.addBuilder,
    this.itemClick,
    this.showProgress = true,
    this.showDel = true,
    this.isSingle = false,
    this.maxSize = 0,
    this.rootDir,
    this.extendWidget,
  }) : super(key: key);

  /// 文件上传保存路径
  final String? rootDir;

  /// 初始化文件列表(可本地，可网络，只能同时一种)
  final List<String> fileList;

  /// 组件类型，loc，选择后不上传，net，选择后上传阿里云
  final WidgetType type;

  /// 文件类型
  final FileType fileType;

  /// 上传最大数量
  final int max;

  /// 列
  final int column;

  /// item宽
  final double? cellWidth;

  /// item高
  final double? cellHeight;

  /// 行间距
  final double rowSpacing;

  /// 列间距
  final double columnSpacing;

  /// 方块横纵比
  final double cellRatio;

  /// 是否能添加图片
  final bool showAddView;

  /// 是否显示上传进度
  final bool showProgress;

  /// 选择渠道(只有文件类型为图片或者视频时生效)
  final PickerType pickerType;

  /// 自定义选择后UI
  final Widget Function(BuildContext context, int index, FileInfo info,
      Size size, Function() action)? itemBuilder;

  /// 自定义添加按钮
  final Widget Function(BuildContext context, Size size, Function() action)?
      addBuilder;

  /// 选择回调，若组件类型type
  final Function(List<FileInfo> fileList)? callBack;

  /// 点击选择Item回调
  final Function(int index, FileInfo info)? itemClick;

  /// 删除回调
  final Function(int index, String path)? delBack;

  /// 是否显示删除
  final bool showDel;

  /// 是否单独，此模式下，点击展示图片也会弹窗选择
  final bool isSingle;

  /// 视频大小限制单位M
  final double maxSize;

  /// 弹框选图扩展
  final Widget? extendWidget;

  @override
  _FilePickerState createState() => _FilePickerState();
}

class _FilePickerState extends State<FilePicker> {
  double cellWidth = 0;
  double cellHeight = 0;

  final fileList = <FileInfo>[].obs;

  void initFile() async {
    for (final item in widget.fileList) {
      String? url;
      String? path;
      final exists = await File(item).exists();
      if (!exists) {
        url = item;
      } else {
        path = item;
      }
      final fileInfo = FileInfo(state: 0, url: url, path: path);
      fileList.add(fileInfo);

      String? thumbnail;
      if (Util.isVideo(item)) {
        thumbnail = Util.getVideoShotImg(item, 1);
        // thumbnail = await getThumbnail(item);
        fileInfo.thumbnailImage = thumbnail;
      } else {}
    }
  }

  @override
  Widget build(BuildContext context) {
    fileList.clear();

    initFile();

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        if (widget.cellWidth != null) {
          cellWidth = widget.cellWidth!;
        } else {
          cellWidth = (constraints.maxWidth -
                  (widget.column - 1) * widget.columnSpacing) /
              widget.column;
        }
        if (widget.cellHeight != null) {
          cellHeight = widget.cellHeight!;
        } else {
          cellHeight = cellWidth * widget.cellRatio;
        }

        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              child: getContent(),
            )
          ],
        );

        // return getGridView();
      },
    );
  }

  Widget getContent() {
    return Obx(() {
      List<Widget> list = [];
      for (int i = 0; i < fileList.length; i++) {
        list.add(Obx(() {
          final item = fileList[i];
          return Container(
            width: cellWidth,
            height: cellHeight,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: DSColors.white,
            ),
            child: Stack(
              children: [
                if (widget.itemBuilder != null)
                  widget.itemBuilder!(
                      context, i, item, Size(cellWidth, cellHeight), _action)
                else
                  getFileView(i, item),
                if (item.state != 0 && widget.showProgress) getItemMask(item),
                if (widget.showDel)
                  Positioned(
                    top: 0,
                    right: 0,
                    child: InkWell(
                      onTap: () {
                        if (widget.delBack != null) {
                          widget.delBack!(i, item.url ?? item.path ?? "");
                        }
                        fileList.remove(item);
                        if (widget.callBack != null) {
                          widget.callBack!(fileList);
                        }
                        if (item.uploadId != null) {
                          /*
                        AliyunController().cancel(item.uploadId!);

                         */
                        }
                      },
                      child: Container(
                        width: 25,
                        height: 25,
                        decoration: BoxDecoration(
                            color: DSColors.black.withOpacity(0.3),
                            borderRadius: const BorderRadius.only(
                                topRight: Radius.circular(8),
                                bottomLeft: Radius.circular(8))),
                        child: Center(
                          child: Icon(
                            Icons.close,
                            size: 15,
                            color: DSColors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          );
        }));
      }

      if (fileList.length < widget.max) {
        // if (fileList.isNotEmpty && fileList[0].type == "video") {
        // } else
        if (widget.showAddView) {
          list.add(getAddView());
        }
      }

      return Wrap(
        spacing: widget.columnSpacing,
        runSpacing: widget.rowSpacing,
        children: list,
      );
    });
  }

  Widget getFileView(int index, FileInfo item) {
    if (widget.fileType == FileType.image ||
        widget.fileType == FileType.video ||
        widget.fileType == FileType.media) {
      String url = "";
      if (item.url != null) {
        url = Util.getImage(id: item.url!);
      }
      return InkWell(
        onTap: () {
          if (widget.isSingle) {
            _action();
          }

          if (widget.itemClick != null) {
            widget.itemClick!(index, item);
            return;
          }

          if (item.thumbnailImage == null) {
            List<String> imageList = [];
            for (final info in fileList) {
              imageList.add(info.path ?? info.url!);
            }
            Get.dialog<dynamic>(
              DSPhotoView(index: index, images: imageList),
            );
          }
        },
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: SizedBox(
            width: cellWidth,
            height: cellHeight,
            child: Stack(
              children: [
                item.thumbnailImage != null
                    ? item.thumbnailImage!.startsWith("http")
                        ? Image.network(
                            item.thumbnailImage!,
                            width: cellWidth,
                            height: cellHeight,
                            fit: BoxFit.cover,
                          )
                        : Image.file(
                            File(item.thumbnailImage!),
                            width: cellWidth,
                            height: cellHeight,
                            fit: BoxFit.cover,
                          )
                    : url.isNotEmpty
                        ? Image.network(
                            url,
                            width: cellWidth,
                            height: cellHeight,
                            fit: BoxFit.cover,
                          )
                        : Image.file(
                            File(item.path!),
                            width: cellWidth,
                            height: cellHeight,
                            fit: BoxFit.cover,
                          ),
                if (item.thumbnailImage != null && item.state == 0)
                  Center(
                    child: Icon(
                      Icons.play_circle_outline,
                      size: min(cellWidth, cellHeight) / 4,
                      color: DSColors.white,
                    ),
                  ),
              ],
            ),
          ),
        ),
      );
    } else {
      return Icon(
        Icons.file_copy_outlined,
        size: min(cellWidth, cellHeight) / 4,
        color: DSColors.subTitle,
      );
    }
  }

  Widget getItemMask(FileInfo item) {
    return InkWell(
      onTap: () {
        if (item.state == 2) {
          upload(item, item.path!);
        }
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: DSColors.black.withOpacity(0.2),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (item.state == 1)
                CircularProgressIndicator(
                  value: (item.progress ?? 0) / 100,
                  valueColor: AlwaysStoppedAnimation<Color>(DSColors.white),
                  backgroundColor: DSColors.black.withOpacity(0.2),
                  strokeWidth: 2,
                ),
              if (item.state == 1)
                Text(
                  "${(item.progress ?? 0).toStringAsFixed(2)}%",
                  style: TextStyle(color: DSColors.white, fontSize: 12),
                ),
              if (item.state == 2)
                Icon(
                  Icons.error_outline,
                  size: min(cellWidth, cellHeight) / 4,
                  color: DSColors.white,
                ),
              if (item.state == 2)
                Text(
                  "上传失败",
                  style: TextStyle(color: DSColors.white, fontSize: 12),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget getAddView() {
    if (widget.addBuilder != null) {
      return widget.addBuilder!(
        context,
        Size(cellWidth, cellHeight),
        _action,
      );
    }
    String title = widget.fileType == FileType.image
        ? "上传图片"
        : widget.fileType == FileType.video
            ? "上传视频"
            : widget.fileType == FileType.sound
                ? "上传录音"
                : "上传文件";
    return InkWell(
      onTap: _action,
      child: Container(
        width: cellWidth,
        height: cellHeight,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: DSColors.white,
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.image_outlined,
                size: min(cellWidth, cellHeight) / 4,
                color: DSColors.subTitle,
              ),
              const SizedBox(height: 5),
              Text(title,
                  style: TextStyle(fontSize: 14, color: DSColors.subTitle)),
            ],
          ),
        ),
      ),
    );
  }

  void _action() async {
    UploadUtils.pickerFile(
        context: context,
        fileType: widget.fileType,
        pickerType: widget.pickerType,
        max: widget.max,
        pickBack: (files) {
          uploadFile(files);
        });
  }

  ///
  void _pickAudio() async {
    final List<AssetEntity>? assets = await AssetPicker.pickAssets(
      context,
      maxAssets: widget.max - fileList.length,
      requestType: RequestType.audio,
    );

    uploadFile(assets ?? <AssetEntity>[]);
  }

  ///
  void _pickFile() async {
    final List<AssetEntity>? assets = await AssetPicker.pickAssets(
      context,
      maxAssets: widget.max - fileList.length,
      requestType: RequestType.all,
    );

    uploadFile(assets ?? <AssetEntity>[]);
  }

  void uploadFile(List<AssetEntity> assets) async {
    if (widget.isSingle) {
      fileList.clear();
      fileList.refresh();
      if (widget.callBack != null) {
        widget.callBack!(fileList);
      }
    }
    for (final element in assets) {
      final file = await element.file;
      if (file != null) {
        final info = FileInfo(state: 0);
        if ((element.mimeType ?? "").startsWith("video") ||
            Util.isVideo(file.path) ||
            element.type == AssetType.video) {
          info.thumbnailImage = await Util.getThumbnail(file.path);
          info.type = "video";
        } else if ((element.mimeType ?? "").startsWith("image") ||
            Util.isImage(file.path) ||
            element.type == AssetType.image) {
          info.type = "image";
        }
        info.path = file.path;
        fileList.add(info);
        if (widget.callBack != null) {
          widget.callBack!(fileList);
        }
      }
    }
    if (widget.type == WidgetType.net) {
      for (final file in fileList) {
        upload(file, file.path!);
      }
    }
  }

  void upload(FileInfo info, String path) {
    UploadUtils.uploadFile(
        rootDir: widget.rootDir,
        path: path,
        listener: UploadListener(onCreate: (String taskId, token) {
          info.uploadId = taskId;
          info.token = token;
        }, onProgress: (String uploadId, int done, int total) {
          for (final temp in fileList) {
            if (temp.uploadId == uploadId) {
              temp.state = 1;
              temp.progress = done.toDouble() / total.toDouble() * 100;
              fileList.refresh();
            }
          }
        }, onSuccess: (String uploadId, String url) {
          for (final temp in fileList) {
            if (temp.uploadId == uploadId) {
              temp.state = 0;
              temp.url = url;
              fileList.refresh();
              if (widget.callBack != null) {
                widget.callBack!(fileList);
              }
            }
          }
        }, onError: (String uploadId, String error) {
          if (!widget.showProgress) {
            MToast.show("上传失败");
          }
          for (final temp in fileList) {
            if (temp.uploadId == uploadId) {
              temp.state = 2;
              fileList.refresh();
              if (widget.callBack != null) {
                widget.callBack!(fileList);
              }
            }
          }
        }));
  }
}

/// 文件模型
class FileInfo {
  /// 本地路径
  String? path;

  /// 视频缩略图
  String? thumbnailImage;

  /// 网络路径
  String? url;

  /// 状态，0，正常显示，1，上传中，2，上传失败
  int state;

  /// 上传进度
  double? progress;

  /// 上传ID
  String? uploadId;

  /// 上传token
  CancelToken? token;

  /// 文件类型 video,image
  String? type;

  ///
  FileInfo({
    required this.state,
    this.path,
    this.thumbnailImage,
    this.url,
    this.uploadId,
    this.progress,
    this.token,
    this.type,
  });
}
