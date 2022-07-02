import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_thumbnail/video_thumbnail.dart' as thumbnail;

import '../constants/api_keys.dart';
import '../constants/app_config.dart';
import 'aes_util.dart';

/// 时间单位类型
enum DateUnitType {
  ///
  day,

  ///
  hours,

  ///
  minutes,

  ///
  seconds
}

/// 图片缩放模式
enum OssResizeImageMode {
  /// （默认值）：等比缩放，缩放图限制为指定w与h的矩形内的最大图片
  lfit,

  /// 等比缩放，缩放图为延伸出指定w与h的矩形框外的最小图片
  mfit,

  /// 将原图等比缩放为延伸出指定w与h的矩形框外的最小图片，之后将超出的部分进行居中裁剪
  fill,

  /// 将原图缩放为指定w与h的矩形内的最大图片，之后使用指定颜色居中填充空白部分
  pad,

  /// 固定宽高，强制缩放
  fixed,
}

/// util
class Util {
  ///
  static const String squareImage =
      "https://c-ssl.duitang.com/uploads/item/201907/20/20190720113610_hsthz.thumb.1000_0.jpeg";

  ///
  static const String verticalImage =
      "http://5b0988e595225.cdn.sohucs.com/images/20171020/64a437300a65443993b5dbcc0791d81d.jpeg";

  ///
  static const String horizontalImage =
      "http://5b0988e595225.cdn.sohucs.com/images/20171020/f79ec9f48fe842b2bc133100648c2ac4.jpeg";

  /// 单例
  factory Util() {
    _singleton ??= Util._();
    return _singleton!;
  }

  /// 单例
  static Util? _singleton;

  /// 构造
  Util._();

  /// 实体商品囊括的字段
  static const List<String> entityProduct = ['logistics', 'service', 'baking'];

  /// 虚拟商品囊括的字段
  static const List<String> virtualProduct = ['virtual', 'deposit', 'estate'];

  /// 定金商品囊括的字段
  static const List<String> depositProduct = ['deposit'];

  /// 获取当前商品是什么类型的商品 实体/虚拟/定金
  static String getGoodsTypeText(String typeCode) {
    if (entityProduct.contains(typeCode)) {
      return 'EntityProduct';
    } else if (virtualProduct.contains(typeCode)) {
      return 'VirtualProduct';
    } else if (depositProduct.contains(typeCode)) {
      return 'deposit';
    }

    return 'EntityProduct';
  }

  /// fen2yuan
  static String getPriceInFen2yuan(String paramsPrice, {bool sample = false}) {
    final double tempPrice = double.parse(paramsPrice);
    final double filterYuan = tempPrice / 100;
    final String finalPrice = sample
        ? filterRadixPoint(filterYuan).toString()
        : filterZeroPoint(filterYuan);

    return finalPrice;
  }

  /// 删除掉转化后的小数点
  static int filterRadixPoint(double p) {
    return p.truncate();
  }

  /// 小数点后面只有一位需要补全一个0
  static String filterZeroPoint(double num, [int postion = 2]) {
    String tempNum = '0';
    if ((num.toString().length - num.toString().lastIndexOf(".") - 1) <
        postion) {
      tempNum = num.toStringAsFixed(postion)
          .substring(0, num.toString().lastIndexOf(".") + postion + 1)
          .toString();
    } else {
      tempNum = num.toString()
          .substring(0, num.toString().lastIndexOf(".") + postion + 1)
          .toString();
    }
    return tempNum;
  }

  /// 倒计时，精确到秒; params为时间戳,13位
  /// @endTime:截止的时间
  /// @nowTIme:当前时间或者开始时间
  /// @hasUnitType:要返回的时间单位
  static String getEndTimeText(int endTime,
      {int? nowTime, DateUnitType? hasUnitType = DateUnitType.day}) {
    nowTime ??= DateTime.now().millisecondsSinceEpoch;
    // ignore: parameter_assignments
    endTime = endTime.toString().length < 13
        ? int.parse('${endTime.toString()}000')
        : endTime;

    if (nowTime > endTime) return '已结束';

    final int diffTime = endTime - nowTime;

    final double day = diffTime / (24 * 3600 * 1000).floor();
    if (day > 365) {
      return '长期有效';
    }
    // 天数
    final String days = filterSinpleNum(day);
    // 计算小时数
    final leave1 = diffTime % (24 * 3600 * 1000);
    final String hours = filterSinpleNum(leave1 / (3600 * 1000));
    // 计算分钟数
    final leave2 = leave1 % (3600 * 1000);
    final String minutes = filterSinpleNum(leave2 / (60 * 1000));
    // 计算秒数
    final leave3 = leave2 % (60 * 1000);
    final String seconds = filterSinpleNum(leave3 / 1000);

    Map<DateUnitType, String> tempData = {
      DateUnitType.day: '$days:$hours:$minutes:$seconds',
      DateUnitType.hours: '$hours:$minutes:$seconds',
      DateUnitType.minutes: '$minutes:$seconds',
      DateUnitType.seconds: '$seconds',
    };
    return tempData[hasUnitType].toString();
  }

  /// 要显示的的时间类型

  /// 数字没有超过两位数在前面默认加一个0
  static String filterSinpleNum(double? number) {
    if (number!.floor().toString().length < 2) {
      final tempNumber = number.floor();
      return '0$tempNumber';
    }

    return number.floor().toString();
  }

  /// 元 -> 万 -> 百万 -> 千万 -> 亿 以及对应的数字
  static Map<String, String> unitConvert(double watting) {
    final List<String> moneyUnits = ["元", "万元", "亿元", "万亿"];
    const int dividend = 10000;
    double currentNum = watting;
    String currentUnit = moneyUnits[0];

    for (int i = 0; i < 4; i++) {
      currentUnit = moneyUnits[i];

      if (strNumSize(currentNum) < 5) {
        break;
      }

      currentNum = currentNum / dividend;
    }
    final String currentNumString = currentNum.toString();

    List<String> a = currentNumString.split('.');
    final String piToBefore = a[0];
    String piToOver;

    if (a[1].length > 1) {
      piToOver = a[1].substring(0, 2);
    } else {
      piToOver = a[1];
    }

    final String moneyOfYuan = "$piToBefore.$piToOver";
    return {'num': moneyOfYuan, 'unit': currentUnit};
  }

  /// 获取钱的位数
  static int strNumSize(double watting) {
    String filterWatting = watting.toString();
    final int index = filterWatting.indexOf('.');

    if (index != -1) {
      filterWatting = filterWatting.substring(0, index);
    }

    final int length = filterWatting.length;

    return length;
  }

  /// 是视频
  static bool isVideo(String path) {
    String temp = path.split(".")[path.split(".").length - 1];
    bool result = false;
    if (temp == "mp4" ||
        temp == "MP4" ||
        temp == "3gp" ||
        temp == "3GP" ||
        temp == "avi" ||
        temp == "AVI" ||
        temp == "mov" ||
        temp == "Mov" ||
        temp == "MOV" ||
        temp == "RMVB" ||
        temp == "rmvb" ||
        temp == "rm" ||
        temp == "RM" ||
        temp == "flv" ||
        temp == "FLV" ||
        temp == "mov" ||
        temp == "MEPG" ||
        temp == "mepg" ||
        temp == "wmv" ||
        temp == "WMV" ||
        temp == "mkv" ||
        temp == "MKV") {
      result = true;
    }
    return result;
  }

  ///  是图片
  static bool isImage(String path) {
    String temp = path.split(".")[path.split(".").length - 1];
    bool result = false;
    if (temp == "png" ||
        temp == "PNG" ||
        temp == "jpg" ||
        temp == "JPG" ||
        temp == "jpeg" ||
        temp == "JPEG" ||
        temp == "bmp" ||
        temp == "BMP" ||
        temp == "gif" ||
        temp == "GIF") {
      result = true;
    }
    return result;
  }

  /// 获取视频首帧缩略图
  static Future<String?> getThumbnail(String path) async {
    final thumbnailImage = await thumbnail.VideoThumbnail.thumbnailFile(
      video: path,
      thumbnailPath: (await getTemporaryDirectory()).path,
      imageFormat: thumbnail.ImageFormat.PNG,
      quality: 100,
    );

    return thumbnailImage;
  }

  /// 获取视频的封面
  static String getVideoShotImg(String uri, int? frame) {
    if (uri == '') {
      return '';
    }
    frame ??= 1;
    final int videoImageFrame = frame * 1000;
    return '$uri?x-oss-process=video/snapshot,t_$videoImageFrame,f_jpg,ar_auto';
  }

  // /// 获取视频首帧缩略图
  // static Future<String?> getThumbnail(String path) async {
  //   final thumbnailImage = await thumbnail.VideoThumbnail.thumbnailFile(
  //     video: path,
  //     thumbnailPath: (await getTemporaryDirectory()).path,
  //     imageFormat: thumbnail.ImageFormat.PNG,
  //     quality: 100,
  //   );
  //
  //   return thumbnailImage;
  // }

  /// 是否身份证号
  static bool isCardId(String cardId) {
    if (cardId.length != 18) {
      return false; // 位数不够
    }
    // 身份证号码正则
    RegExp postalCode = RegExp(
        r'^[1-9]\d{5}[1-9]\d{3}((0\d)|(1[0-2]))(([0|1|2]\d)|3[0-1])\d{3}([0-9]|[Xx])$');
    // 通过验证，说明格式正确，但仍需计算准确性
    if (!postalCode.hasMatch(cardId)) {
      return false;
    }
    //将前17位加权因子保存在数组里
    final List idCardList = <String>[
      "7",
      "9",
      "10",
      "5",
      "8",
      "4",
      "2",
      "1",
      "6",
      "3",
      "7",
      "9",
      "10",
      "5",
      "8",
      "4",
      "2"
    ];
    //这是除以11后，可能产生的11位余数、验证码，也保存成数组
    final List idCardYArray = <String>[
      '1',
      '0',
      '10',
      '9',
      '8',
      '7',
      '6',
      '5',
      '4',
      '3',
      '2'
    ];
    // 前17位各自乖以加权因子后的总和
    int idCardWiSum = 0;

    for (int i = 0; i < 17; i++) {
      int subStrIndex = int.parse(cardId.substring(i, i + 1));
      int idCardWiIndex = int.parse(idCardList[i].toString());
      idCardWiSum += subStrIndex * idCardWiIndex;
    }
    // 计算出校验码所在数组的位置
    int idCardMod = idCardWiSum % 11;
    // 得到最后一位号码
    String idCardLast = cardId.substring(17, 18);
    //如果等于2，则说明校验码是10，身份证号码最后一位应该是X
    if (idCardMod == 2) {
      if (idCardLast != 'x' && idCardLast != 'X') {
        return false;
      }
    } else {
      //用计算出的验证码与最后一位身份证号码匹配，如果一致，说明通过，否则是无效的身份证号码
      if (idCardLast != idCardYArray[idCardMod]) {
        return false;
      }
    }
    return true;
  }

// 根据身份证号获取年龄
  int getAgeFromCardId(String cardId) {
    bool isRight = isCardId(cardId);
    if (!isRight) {
      return 0;
    }
    int len = (cardId + "").length;
    String strBirthday = "";
    if (len == 18) {
      //处理18位的身份证号码从号码中得到生日和性别代码
      strBirthday = cardId.substring(6, 10) +
          "-" +
          cardId.substring(10, 12) +
          "-" +
          cardId.substring(12, 14);
    }
    if (len == 15) {
      strBirthday = "19" +
          cardId.substring(6, 8) +
          "-" +
          cardId.substring(8, 10) +
          "-" +
          cardId.substring(10, 12);
    }
    int age = getAgeFromBirthday(strBirthday);
    return age;
  }

// 根据出生日期获取年龄
  int getAgeFromBirthday(String strBirthday) {
    if (strBirthday.isEmpty) {
      print('生日错误');
      return 0;
    }
    DateTime birth = DateTime.parse(strBirthday);
    DateTime now = DateTime.now();

    int age = now.year - birth.year;
    //再考虑月、天的因素
    if (now.month < birth.month ||
        (now.month == birth.month && now.day < birth.day)) {
      age--;
    }
    return age;
  }

// 根据身份证获取性别
  String getSexFromCardId(String cardId) {
    String sex = "";
    bool isRight = isCardId(cardId);
    if (!isRight) {
      return sex;
    }
    if (cardId.length == 18) {
      if (int.parse(cardId.substring(16, 17)) % 2 == 1) {
        sex = "男";
      } else {
        sex = "女";
      }
    }
    if (cardId.length == 15) {
      if (int.parse(cardId.substring(14, 15)) % 2 == 1) {
        sex = "男";
      } else {
        sex = "女";
      }
    }
    return sex;
  }

  /// 获取随机字符串
  static String getRandomStr(int length) {
    const _chars =
        'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    Random _rnd = Random();
    return String.fromCharCodes(Iterable.generate(
        length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));
  }

  /// 枚举类型转换为字符值
  static String? enumStringValue(dynamic o) => o?.toString().split('.').last;

  /// 图片缩放
  static String resizeImage(
    String url, {
    // 图片缩放模式
    OssResizeImageMode mode = OssResizeImageMode.lfit,
    int width = 100,
    int height = 100,
    int long = 100,
    int small = 100,
    int limit = 1,
    int absolute = 100,
    Color color = Colors.white,
    bool force = false,
  }) {
    if (url.isEmpty ||
        !(url.startsWith('http://') || url.startsWith('https://'))) {
      return url;
    }
    assert(width >= 1 && width <= 4096);
    assert(height >= 1 && height <= 4096);
    assert(long >= 1 && long <= 4096);
    assert(small >= 1 && small <= 4096);
    assert(absolute >= 1 && absolute <= 100);
    assert(limit == 0 || limit == 1);

    return '$url?x-oss-process=image/resize,m_${enumStringValue(mode)},w_$width,h_$height,l_$long,s_$small,limit_$limit,color_${color.red.toRadixString(16)}${color.green.toRadixString(16)}${color.blue.toRadixString(16)}/quality,q_$absolute';
  }

  static String getImage({required String id}) {
    final temp = id.split("_");
    final bucketName = temp[0];
    final fileDir = temp[1];
    final tk = AesUtil.getTk();
    return AppConfig.baseUrl +
        UserApi.showImage +
        "?contentType=jpg&fileId=" +
        id +
        "&fileDir=" +
        fileDir +
        "&bucketName=" +
        bucketName +
        "&tk=" +
        tk;
  }

  static double getBottomPadding() {
    final temp = MediaQueryData.fromWindow(window).padding.bottom.toDouble();
    return temp == 0 ? 15 : temp;
  }

  static String getOrderStatusText(String status) {
    String res = "";
    if (status == "105331") {
      res = "待确认";
    } else if (status == "105332") {
      res = "待服务";
    } else if (status == "105333") {
      res = "服务中";
    } else if (status == "105334") {
      res = "待付款";
    } else if (status == "105335") {
      res = "待评价";
    } else if (status == "105336") {
      res = "已取消";
    }
    return res;
  }

  static double dp2px(BuildContext context, num dp) {
    final dpr = MediaQuery.of(context).devicePixelRatio;
    return dp * dpr;
  }
}
