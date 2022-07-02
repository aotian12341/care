import 'package:care/generated/json/base/json_convert_content.dart';
import 'package:care/model/demand_info.dart';
import 'package:care/model/demand_page.dart';


DemandInfo $DemandInfoFromJson(Map<String, dynamic> json) {
	final DemandInfo demandInfo = DemandInfo();
	final DemandAddressInfo? addressInfo = jsonConvert.convert<DemandAddressInfo>(json['addressInfo']);
	if (addressInfo != null) {
		demandInfo.addressInfo = addressInfo;
	}
	final String? note = jsonConvert.convert<String>(json['note']);
	if (note != null) {
		demandInfo.note = note;
	}
	final String? isInHome = jsonConvert.convert<String>(json['isInHome']);
	if (isInHome != null) {
		demandInfo.isInHome = isInHome;
	}
	final String? workTimeRange = jsonConvert.convert<String>(json['workTimeRange']);
	if (workTimeRange != null) {
		demandInfo.workTimeRange = workTimeRange;
	}
	final String? workExperience = jsonConvert.convert<String>(json['workExperience']);
	if (workExperience != null) {
		demandInfo.workExperience = workExperience;
	}
	final String? serviceAddress = jsonConvert.convert<String>(json['serviceAddress']);
	if (serviceAddress != null) {
		demandInfo.serviceAddress = serviceAddress;
	}
	final String? amountUnit = jsonConvert.convert<String>(json['amountUnit']);
	if (amountUnit != null) {
		demandInfo.amountUnit = amountUnit;
	}
	final String? employerCount = jsonConvert.convert<String>(json['employerCount']);
	if (employerCount != null) {
		demandInfo.employerCount = employerCount;
	}
	final String? demandType = jsonConvert.convert<String>(json['demandType']);
	if (demandType != null) {
		demandInfo.demandType = demandType;
	}
	final String? timeRangeType = jsonConvert.convert<String>(json['timeRangeType']);
	if (timeRangeType != null) {
		demandInfo.timeRangeType = timeRangeType;
	}
	final int? createTime = jsonConvert.convert<int>(json['createTime']);
	if (createTime != null) {
		demandInfo.createTime = createTime;
	}
	final double? price = jsonConvert.convert<double>(json['price']);
	if (price != null) {
		demandInfo.price = price;
	}
	final String? demandNo = jsonConvert.convert<String>(json['demandNo']);
	if (demandNo != null) {
		demandInfo.demandNo = demandNo;
	}
	final String? workerAgeRange = jsonConvert.convert<String>(json['workerAgeRange']);
	if (workerAgeRange != null) {
		demandInfo.workerAgeRange = workerAgeRange;
	}
	final String? workerSex = jsonConvert.convert<String>(json['workerSex']);
	if (workerSex != null) {
		demandInfo.workerSex = workerSex;
	}
	final String? timeRange = jsonConvert.convert<String>(json['timeRange']);
	if (timeRange != null) {
		demandInfo.timeRange = timeRange;
	}
	final String? status = jsonConvert.convert<String>(json['status']);
	if (status != null) {
		demandInfo.status = status;
	}
	final String? workPlace = jsonConvert.convert<String>(json['workPlace']);
	if (workPlace != null) {
		demandInfo.workPlace = workPlace;
	}
	final String? workDay = jsonConvert.convert<String>(json['workDay']);
	if (workDay != null) {
		demandInfo.workDay = workDay;
	}
	final String? employerAgeRange = jsonConvert.convert<String>(json['employerAgeRange']);
	if (employerAgeRange != null) {
		demandInfo.employerAgeRange = employerAgeRange;
	}
	final String? employerSex = jsonConvert.convert<String>(json['employerSex']);
	if (employerSex != null) {
		demandInfo.employerSex = employerSex;
	}
	final String? physicalCondition = jsonConvert.convert<String>(json['physicalCondition']);
	if (physicalCondition != null) {
		demandInfo.physicalCondition = physicalCondition;
	}
	final String? serviceObj = jsonConvert.convert<String>(json['serviceObj']);
	if (serviceObj != null) {
		demandInfo.serviceObj = serviceObj;
	}
	final String? cleanRegion = jsonConvert.convert<String>(json['cleanRegion']);
	if (cleanRegion != null) {
		demandInfo.cleanRegion = cleanRegion;
	}
	final String? isNeedTool = jsonConvert.convert<String>(json['isNeedTool']);
	if (isNeedTool != null) {
		demandInfo.isNeedTool = isNeedTool;
	}
	final String? cleanType = jsonConvert.convert<String>(json['cleanType']);
	if (cleanType != null) {
		demandInfo.cleanType = cleanType;
	}
	final String? cleanDegree = jsonConvert.convert<String>(json['cleanDegree']);
	if (cleanDegree != null) {
		demandInfo.cleanDegree = cleanDegree;
	}
	final List<DemandPagesListWorkers>? workers = jsonConvert.convertListNotNull<DemandPagesListWorkers>(json['workers']);
	if (workers != null) {
		demandInfo.workers = workers;
	}
	return demandInfo;
}

Map<String, dynamic> $DemandInfoToJson(DemandInfo entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['addressInfo'] = entity.addressInfo?.toJson();
	data['note'] = entity.note;
	data['isInHome'] = entity.isInHome;
	data['workTimeRange'] = entity.workTimeRange;
	data['workExperience'] = entity.workExperience;
	data['serviceAddress'] = entity.serviceAddress;
	data['amountUnit'] = entity.amountUnit;
	data['employerCount'] = entity.employerCount;
	data['demandType'] = entity.demandType;
	data['timeRangeType'] = entity.timeRangeType;
	data['createTime'] = entity.createTime;
	data['price'] = entity.price;
	data['demandNo'] = entity.demandNo;
	data['workerAgeRange'] = entity.workerAgeRange;
	data['workerSex'] = entity.workerSex;
	data['timeRange'] = entity.timeRange;
	data['status'] = entity.status;
	data['workPlace'] = entity.workPlace;
	data['workDay'] = entity.workDay;
	data['employerAgeRange'] = entity.employerAgeRange;
	data['employerSex'] = entity.employerSex;
	data['physicalCondition'] = entity.physicalCondition;
	data['serviceObj'] = entity.serviceObj;
	data['cleanRegion'] = entity.cleanRegion;
	data['isNeedTool'] = entity.isNeedTool;
	data['cleanType'] = entity.cleanType;
	data['cleanDegree'] = entity.cleanDegree;
	data['workers'] =  entity.workers?.map((v) => v.toJson()).toList();
	return data;
}

DemandAddressInfo $DemandAddressInfoFromJson(Map<String, dynamic> json) {
	final DemandAddressInfo demandAddressInfo = DemandAddressInfo();
	final int? id = jsonConvert.convert<int>(json['id']);
	if (id != null) {
		demandAddressInfo.id = id;
	}
	final String? addressNo = jsonConvert.convert<String>(json['addressNo']);
	if (addressNo != null) {
		demandAddressInfo.addressNo = addressNo;
	}
	final String? userNo = jsonConvert.convert<String>(json['userNo']);
	if (userNo != null) {
		demandAddressInfo.userNo = userNo;
	}
	final String? contacts = jsonConvert.convert<String>(json['contacts']);
	if (contacts != null) {
		demandAddressInfo.contacts = contacts;
	}
	final String? telephone = jsonConvert.convert<String>(json['telephone']);
	if (telephone != null) {
		demandAddressInfo.telephone = telephone;
	}
	final String? province = jsonConvert.convert<String>(json['province']);
	if (province != null) {
		demandAddressInfo.province = province;
	}
	final String? city = jsonConvert.convert<String>(json['city']);
	if (city != null) {
		demandAddressInfo.city = city;
	}
	final String? district = jsonConvert.convert<String>(json['district']);
	if (district != null) {
		demandAddressInfo.district = district;
	}
	final String? address = jsonConvert.convert<String>(json['address']);
	if (address != null) {
		demandAddressInfo.address = address;
	}
	final String? isDefalut = jsonConvert.convert<String>(json['isDefalut']);
	if (isDefalut != null) {
		demandAddressInfo.isDefalut = isDefalut;
	}
	return demandAddressInfo;
}

Map<String, dynamic> $DemandAddressInfoToJson(DemandAddressInfo entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['id'] = entity.id;
	data['addressNo'] = entity.addressNo;
	data['userNo'] = entity.userNo;
	data['contacts'] = entity.contacts;
	data['telephone'] = entity.telephone;
	data['province'] = entity.province;
	data['city'] = entity.city;
	data['district'] = entity.district;
	data['address'] = entity.address;
	data['isDefalut'] = entity.isDefalut;
	return data;
}