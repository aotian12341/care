import 'package:care/generated/json/base/json_convert_content.dart';
import 'package:care/model/order/order_info.dart';

OrderInfo $OrderInfoFromJson(Map<String, dynamic> json) {
  final OrderInfo orderInfo = OrderInfo();
  final OrderAddressInfo? addressInfo =
      jsonConvert.convert<OrderAddressInfo>(json['addressInfo']);
  if (addressInfo != null) {
    orderInfo.addressInfo = addressInfo;
  }
  final String? cleanRegion = jsonConvert.convert<String>(json['cleanRegion']);
  if (cleanRegion != null) {
    orderInfo.cleanRegion = cleanRegion;
  }
  final String? cleanType = jsonConvert.convert<String>(json['cleanType']);
  if (cleanType != null) {
    orderInfo.cleanType = cleanType;
  }
  final String? isNeedTool = jsonConvert.convert<String>(json['isNeedTool']);
  if (isNeedTool != null) {
    orderInfo.isNeedTool = isNeedTool;
  }
  final String? serviceAddress =
      jsonConvert.convert<String>(json['serviceAddress']);
  if (serviceAddress != null) {
    orderInfo.serviceAddress = serviceAddress;
  }
  final String? amountUnit = jsonConvert.convert<String>(json['amountUnit']);
  if (amountUnit != null) {
    orderInfo.amountUnit = amountUnit;
  }
  final String? demandType = jsonConvert.convert<String>(json['demandType']);
  if (demandType != null) {
    orderInfo.demandType = demandType;
  }
  final String? timeRangeType =
      jsonConvert.convert<String>(json['timeRangeType']);
  if (timeRangeType != null) {
    orderInfo.timeRangeType = timeRangeType;
  }
  final String? serviceObj = jsonConvert.convert<String>(json['serviceObj']);
  if (serviceObj != null) {
    orderInfo.serviceObj = serviceObj;
  }
  final double? price = jsonConvert.convert<double>(json['price']);
  if (price != null) {
    orderInfo.price = price;
  }
  final String? demandNo = jsonConvert.convert<String>(json['demandNo']);
  if (demandNo != null) {
    orderInfo.demandNo = demandNo;
  }
  final String? workerAgeRange =
      jsonConvert.convert<String>(json['workerAgeRange']);
  if (workerAgeRange != null) {
    orderInfo.workerAgeRange = workerAgeRange;
  }
  final List<OrderWorkers>? workers =
      jsonConvert.convertListNotNull<OrderWorkers>(json['workers']);
  if (workers != null) {
    orderInfo.workers = workers;
  }
  final String? timeRange = jsonConvert.convert<String>(json['timeRange']);
  if (timeRange != null) {
    orderInfo.timeRange = timeRange;
  }
  final String? status = jsonConvert.convert<String>(json['status']);
  if (status != null) {
    orderInfo.status = status;
  }
  return orderInfo;
}

Map<String, dynamic> $OrderInfoToJson(OrderInfo entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['addressInfo'] = entity.addressInfo?.toJson();
  data['cleanRegion'] = entity.cleanRegion;
  data['cleanType'] = entity.cleanType;
  data['isNeedTool'] = entity.isNeedTool;
  data['serviceAddress'] = entity.serviceAddress;
  data['amountUnit'] = entity.amountUnit;
  data['demandType'] = entity.demandType;
  data['timeRangeType'] = entity.timeRangeType;
  data['serviceObj'] = entity.serviceObj;
  data['price'] = entity.price;
  data['demandNo'] = entity.demandNo;
  data['workerAgeRange'] = entity.workerAgeRange;
  data['workers'] = entity.workers?.map((v) => v.toJson()).toList();
  data['timeRange'] = entity.timeRange;
  data['status'] = entity.status;
  return data;
}

OrderAddressInfo $OrderAddressInfoFromJson(Map<String, dynamic> json) {
  final OrderAddressInfo orderAddressInfo = OrderAddressInfo();
  final String? isDefalut = jsonConvert.convert<String>(json['isDefalut']);
  if (isDefalut != null) {
    orderAddressInfo.isDefalut = isDefalut;
  }
  final String? address = jsonConvert.convert<String>(json['address']);
  if (address != null) {
    orderAddressInfo.address = address;
  }
  final String? addressName = jsonConvert.convert<String>(json['addressName']);
  if (addressName != null) {
    orderAddressInfo.addressName = addressName;
  }
  final String? province = jsonConvert.convert<String>(json['province']);
  if (province != null) {
    orderAddressInfo.province = province;
  }
  final String? addressNo = jsonConvert.convert<String>(json['addressNo']);
  if (addressNo != null) {
    orderAddressInfo.addressNo = addressNo;
  }
  final String? city = jsonConvert.convert<String>(json['city']);
  if (city != null) {
    orderAddressInfo.city = city;
  }
  final String? district = jsonConvert.convert<String>(json['district']);
  if (district != null) {
    orderAddressInfo.district = district;
  }
  final String? userNo = jsonConvert.convert<String>(json['userNo']);
  if (userNo != null) {
    orderAddressInfo.userNo = userNo;
  }
  final String? telephone = jsonConvert.convert<String>(json['telephone']);
  if (telephone != null) {
    orderAddressInfo.telephone = telephone;
  }
  final int? id = jsonConvert.convert<int>(json['id']);
  if (id != null) {
    orderAddressInfo.id = id;
  }
  final String? contacts = jsonConvert.convert<String>(json['contacts']);
  if (contacts != null) {
    orderAddressInfo.contacts = contacts;
  }
  return orderAddressInfo;
}

Map<String, dynamic> $OrderAddressInfoToJson(OrderAddressInfo entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['isDefalut'] = entity.isDefalut;
  data['address'] = entity.address;
  data['addressName'] = entity.addressName;
  data['province'] = entity.province;
  data['addressNo'] = entity.addressNo;
  data['city'] = entity.city;
  data['district'] = entity.district;
  data['userNo'] = entity.userNo;
  data['telephone'] = entity.telephone;
  data['id'] = entity.id;
  data['contacts'] = entity.contacts;
  return data;
}

OrderWorkers $OrderWorkersFromJson(Map<String, dynamic> json) {
  final OrderWorkers orderWorkers = OrderWorkers();
  final String? workerNo = jsonConvert.convert<String>(json['workerNo']);
  if (workerNo != null) {
    orderWorkers.workerNo = workerNo;
  }
  final String? workerName = jsonConvert.convert<String>(json['workerName']);
  if (workerName != null) {
    orderWorkers.workerName = workerName;
  }
  return orderWorkers;
}

Map<String, dynamic> $OrderWorkersToJson(OrderWorkers entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['workerNo'] = entity.workerNo;
  data['workerName'] = entity.workerName;
  return data;
}
