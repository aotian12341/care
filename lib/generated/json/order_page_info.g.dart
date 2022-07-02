import 'package:care/generated/json/base/json_convert_content.dart';
import 'package:care/model/order/order_page_info.dart';

OrderPageInfo $OrderPageInfoFromJson(Map<String, dynamic> json) {
  final OrderPageInfo orderPageInfo = OrderPageInfo();
  final List<OrderPageRecords>? records =
      jsonConvert.convertListNotNull<OrderPageRecords>(json['records']);
  if (records != null) {
    orderPageInfo.records = records;
  }
  final int? total = jsonConvert.convert<int>(json['total']);
  if (total != null) {
    orderPageInfo.total = total;
  }
  final int? size = jsonConvert.convert<int>(json['size']);
  if (size != null) {
    orderPageInfo.size = size;
  }
  final int? current = jsonConvert.convert<int>(json['current']);
  if (current != null) {
    orderPageInfo.current = current;
  }
  final List<dynamic>? orders =
      jsonConvert.convertListNotNull<dynamic>(json['orders']);
  if (orders != null) {
    orderPageInfo.orders = orders;
  }
  final bool? searchCount = jsonConvert.convert<bool>(json['searchCount']);
  if (searchCount != null) {
    orderPageInfo.searchCount = searchCount;
  }
  final int? pages = jsonConvert.convert<int>(json['pages']);
  if (pages != null) {
    orderPageInfo.pages = pages;
  }
  return orderPageInfo;
}

Map<String, dynamic> $OrderPageInfoToJson(OrderPageInfo entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['records'] = entity.records?.map((v) => v.toJson()).toList();
  data['total'] = entity.total;
  data['size'] = entity.size;
  data['current'] = entity.current;
  data['orders'] = entity.orders;
  data['searchCount'] = entity.searchCount;
  data['pages'] = entity.pages;
  return data;
}

OrderPageRecords $OrderPageRecordsFromJson(Map<String, dynamic> json) {
  final OrderPageRecords orderPageRecords = OrderPageRecords();
  final String? orderNo = jsonConvert.convert<String>(json['orderNo']);
  if (orderNo != null) {
    orderPageRecords.orderNo = orderNo;
  }
  final String? serviceName = jsonConvert.convert<String>(json['serviceName']);
  if (serviceName != null) {
    orderPageRecords.serviceName = serviceName;
  }
  final String? employerNo = jsonConvert.convert<String>(json['employerNo']);
  if (employerNo != null) {
    orderPageRecords.employerNo = employerNo;
  }
  final String? workerNo = jsonConvert.convert<String>(json['workerNo']);
  if (workerNo != null) {
    orderPageRecords.workerNo = workerNo;
  }
  final String? serviceAddress =
      jsonConvert.convert<String>(json['serviceAddress']);
  if (serviceAddress != null) {
    orderPageRecords.serviceAddress = serviceAddress;
  }
  final String? serviceTimeRange =
      jsonConvert.convert<String>(json['serviceTimeRange']);
  if (serviceTimeRange != null) {
    orderPageRecords.serviceTimeRange = serviceTimeRange;
  }
  final String? status = jsonConvert.convert<String>(json['status']);
  if (status != null) {
    orderPageRecords.status = status;
  }
  final String? statusText = jsonConvert.convert<String>(json['statusText']);
  if (statusText != null) {
    orderPageRecords.statusText = statusText;
  }
  final double? price = jsonConvert.convert<double>(json['price']);
  if (price != null) {
    orderPageRecords.price = price;
  }
  final String? amountUnit = jsonConvert.convert<String>(json['amountUnit']);
  if (amountUnit != null) {
    orderPageRecords.amountUnit = amountUnit;
  }
  final dynamic? totalAmount =
      jsonConvert.convert<dynamic>(json['totalAmount']);
  if (totalAmount != null) {
    orderPageRecords.totalAmount = totalAmount;
  }
  final dynamic? payAmount = jsonConvert.convert<dynamic>(json['payAmount']);
  if (payAmount != null) {
    orderPageRecords.payAmount = payAmount;
  }
  final dynamic? promotionAmount =
      jsonConvert.convert<dynamic>(json['promotionAmount']);
  if (promotionAmount != null) {
    orderPageRecords.promotionAmount = promotionAmount;
  }
  final dynamic? integrationAmount =
      jsonConvert.convert<dynamic>(json['integrationAmount']);
  if (integrationAmount != null) {
    orderPageRecords.integrationAmount = integrationAmount;
  }
  final dynamic? couponAmount =
      jsonConvert.convert<dynamic>(json['couponAmount']);
  if (couponAmount != null) {
    orderPageRecords.couponAmount = couponAmount;
  }
  final dynamic? discountAmount =
      jsonConvert.convert<dynamic>(json['discountAmount']);
  if (discountAmount != null) {
    orderPageRecords.discountAmount = discountAmount;
  }
  final dynamic? payType = jsonConvert.convert<dynamic>(json['payType']);
  if (payType != null) {
    orderPageRecords.payType = payType;
  }
  final dynamic? valid = jsonConvert.convert<dynamic>(json['valid']);
  if (valid != null) {
    orderPageRecords.valid = valid;
  }
  final int? createTime = jsonConvert.convert<int>(json['createTime']);
  if (createTime != null) {
    orderPageRecords.createTime = createTime;
  }
  final int? updateTime = jsonConvert.convert<int>(json['updateTime']);
  if (updateTime != null) {
    orderPageRecords.updateTime = updateTime;
  }
  return orderPageRecords;
}

Map<String, dynamic> $OrderPageRecordsToJson(OrderPageRecords entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['orderNo'] = entity.orderNo;
  data['serviceName'] = entity.serviceName;
  data['employerNo'] = entity.employerNo;
  data['workerNo'] = entity.workerNo;
  data['serviceAddress'] = entity.serviceAddress;
  data['serviceTimeRange'] = entity.serviceTimeRange;
  data['status'] = entity.status;
  data['statusText'] = entity.statusText;
  data['price'] = entity.price;
  data['amountUnit'] = entity.amountUnit;
  data['totalAmount'] = entity.totalAmount;
  data['payAmount'] = entity.payAmount;
  data['promotionAmount'] = entity.promotionAmount;
  data['integrationAmount'] = entity.integrationAmount;
  data['couponAmount'] = entity.couponAmount;
  data['discountAmount'] = entity.discountAmount;
  data['payType'] = entity.payType;
  data['valid'] = entity.valid;
  data['createTime'] = entity.createTime;
  data['updateTime'] = entity.updateTime;
  return data;
}
