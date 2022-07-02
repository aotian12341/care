import 'package:care/generated/json/base/json_convert_content.dart';
import 'package:care/model/staff_list_info.dart';

StaffListInfo $StaffListInfoFromJson(Map<String, dynamic> json) {
	final StaffListInfo staffListInfo = StaffListInfo();
	final int? totalCount = jsonConvert.convert<int>(json['totalCount']);
	if (totalCount != null) {
		staffListInfo.totalCount = totalCount;
	}
	final int? pageSize = jsonConvert.convert<int>(json['pageSize']);
	if (pageSize != null) {
		staffListInfo.pageSize = pageSize;
	}
	final int? totalPage = jsonConvert.convert<int>(json['totalPage']);
	if (totalPage != null) {
		staffListInfo.totalPage = totalPage;
	}
	final int? currPage = jsonConvert.convert<int>(json['currPage']);
	if (currPage != null) {
		staffListInfo.currPage = currPage;
	}
	final List<StaffListList>? list = jsonConvert.convertListNotNull<StaffListList>(json['list']);
	if (list != null) {
		staffListInfo.list = list;
	}
	return staffListInfo;
}

Map<String, dynamic> $StaffListInfoToJson(StaffListInfo entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['totalCount'] = entity.totalCount;
	data['pageSize'] = entity.pageSize;
	data['totalPage'] = entity.totalPage;
	data['currPage'] = entity.currPage;
	data['list'] =  entity.list?.map((v) => v.toJson()).toList();
	return data;
}

StaffListList $StaffListListFromJson(Map<String, dynamic> json) {
	final StaffListList staffListList = StaffListList();
	final String? userNo = jsonConvert.convert<String>(json['userNo']);
	if (userNo != null) {
		staffListList.userNo = userNo;
	}
	final String? name = jsonConvert.convert<String>(json['name']);
	if (name != null) {
		staffListList.name = name;
	}
	final dynamic? sex = jsonConvert.convert<dynamic>(json['sex']);
	if (sex != null) {
		staffListList.sex = sex;
	}
	final int? age = jsonConvert.convert<int>(json['age']);
	if (age != null) {
		staffListList.age = age;
	}
	final int? experience = jsonConvert.convert<int>(json['experience']);
	if (experience != null) {
		staffListList.experience = experience;
	}
	final dynamic? skillType = jsonConvert.convert<dynamic>(json['skillType']);
	if (skillType != null) {
		staffListList.skillType = skillType;
	}
	final String? workType = jsonConvert.convert<String>(json['workType']);
	if (workType != null) {
		staffListList.workType = workType;
	}
	final dynamic? hasInHome = jsonConvert.convert<dynamic>(json['hasInHome']);
	if (hasInHome != null) {
		staffListList.hasInHome = hasInHome;
	}
	final dynamic? autograph = jsonConvert.convert<dynamic>(json['autograph']);
	if (autograph != null) {
		staffListList.autograph = autograph;
	}
	final dynamic? personalProfile = jsonConvert.convert<dynamic>(json['personalProfile']);
	if (personalProfile != null) {
		staffListList.personalProfile = personalProfile;
	}
	final dynamic? nation = jsonConvert.convert<dynamic>(json['nation']);
	if (nation != null) {
		staffListList.nation = nation;
	}
	final dynamic? nativePlace = jsonConvert.convert<dynamic>(json['nativePlace']);
	if (nativePlace != null) {
		staffListList.nativePlace = nativePlace;
	}
	final String? province = jsonConvert.convert<String>(json['province']);
	if (province != null) {
		staffListList.province = province;
	}
	final String? city = jsonConvert.convert<String>(json['city']);
	if (city != null) {
		staffListList.city = city;
	}
	final String? district = jsonConvert.convert<String>(json['district']);
	if (district != null) {
		staffListList.district = district;
	}
	final String? address = jsonConvert.convert<String>(json['address']);
	if (address != null) {
		staffListList.address = address;
	}
	final dynamic? storeNo = jsonConvert.convert<dynamic>(json['storeNo']);
	if (storeNo != null) {
		staffListList.storeNo = storeNo;
	}
	final dynamic? status = jsonConvert.convert<dynamic>(json['status']);
	if (status != null) {
		staffListList.status = status;
	}
	final int? score = jsonConvert.convert<int>(json['score']);
	if (score != null) {
		staffListList.score = score;
	}
	final int? hourAmount = jsonConvert.convert<int>(json['hourAmount']);
	if (hourAmount != null) {
		staffListList.hourAmount = hourAmount;
	}
	final int? monthAmount = jsonConvert.convert<int>(json['monthAmount']);
	if (monthAmount != null) {
		staffListList.monthAmount = monthAmount;
	}
	return staffListList;
}

Map<String, dynamic> $StaffListListToJson(StaffListList entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['userNo'] = entity.userNo;
	data['name'] = entity.name;
	data['sex'] = entity.sex;
	data['age'] = entity.age;
	data['experience'] = entity.experience;
	data['skillType'] = entity.skillType;
	data['workType'] = entity.workType;
	data['hasInHome'] = entity.hasInHome;
	data['autograph'] = entity.autograph;
	data['personalProfile'] = entity.personalProfile;
	data['nation'] = entity.nation;
	data['nativePlace'] = entity.nativePlace;
	data['province'] = entity.province;
	data['city'] = entity.city;
	data['district'] = entity.district;
	data['address'] = entity.address;
	data['storeNo'] = entity.storeNo;
	data['status'] = entity.status;
	data['score'] = entity.score;
	data['hourAmount'] = entity.hourAmount;
	data['monthAmount'] = entity.monthAmount;
	return data;
}