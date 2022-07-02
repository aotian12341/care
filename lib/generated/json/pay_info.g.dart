import 'package:care/generated/json/base/json_convert_content.dart';
import 'package:care/model/pay_info.dart';

PayInfo $PayInfoFromJson(Map<String, dynamic> json) {
  final PayInfo payInfo = PayInfo();
  final String? appId = jsonConvert.convert<String>(json['appId']);
  if (appId != null) {
    payInfo.appId = appId;
  }
  final String? mchId = jsonConvert.convert<String>(json['mchId']);
  if (mchId != null) {
    payInfo.mchId = mchId;
  }
  final String? prepayId = jsonConvert.convert<String>(json['prepayId']);
  if (prepayId != null) {
    payInfo.prepayId = prepayId;
  }
  final int? timestamp = jsonConvert.convert<int>(json['timestamp']);
  if (timestamp != null) {
    payInfo.timestamp = timestamp;
  }
  final String? nonceStr = jsonConvert.convert<String>(json['nonceStr']);
  if (nonceStr != null) {
    payInfo.nonceStr = nonceStr;
  }
  final String? sign = jsonConvert.convert<String>(json['sign']);
  if (sign != null) {
    payInfo.sign = sign;
  }
  final String? signType = jsonConvert.convert<String>(json['signType']);
  if (signType != null) {
    payInfo.signType = signType;
  }
  return payInfo;
}

Map<String, dynamic> $PayInfoToJson(PayInfo entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['appId'] = entity.appId;
  data['mchId'] = entity.mchId;
  data['prepayId'] = entity.prepayId;
  data['timestamp'] = entity.timestamp;
  data['nonceStr'] = entity.nonceStr;
  data['sign'] = entity.sign;
  data['signType'] = entity.signType;
  return data;
}
