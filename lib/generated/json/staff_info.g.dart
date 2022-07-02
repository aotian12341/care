import 'package:care/generated/json/base/json_convert_content.dart';
import 'package:care/model/staff_info.dart';

StaffInfo $StaffInfoFromJson(Map<String, dynamic> json) {
	final StaffInfo staffInfo = StaffInfo();
	final int? id = jsonConvert.convert<int>(json['id']);
	if (id != null) {
		staffInfo.id = id;
	}
	final String? userNo = jsonConvert.convert<String>(json['userNo']);
	if (userNo != null) {
		staffInfo.userNo = userNo;
	}
	final String? name = jsonConvert.convert<String>(json['name']);
	if (name != null) {
		staffInfo.name = name;
	}
	final String? nick = jsonConvert.convert<String>(json['nick']);
	if (nick != null) {
		staffInfo.nick = nick;
	}
	final dynamic? tableau = jsonConvert.convert<dynamic>(json['tableau']);
	if (tableau != null) {
		staffInfo.tableau = tableau;
	}
	final String? sex = jsonConvert.convert<String>(json['sex']);
	if (sex != null) {
		staffInfo.sex = sex;
	}
	final int? age = jsonConvert.convert<int>(json['age']);
	if (age != null) {
		staffInfo.age = age;
	}
	final int? experience = jsonConvert.convert<int>(json['experience']);
	if (experience != null) {
		staffInfo.experience = experience;
	}
	final dynamic? hasInsuranceFund = jsonConvert.convert<dynamic>(json['hasInsuranceFund']);
	if (hasInsuranceFund != null) {
		staffInfo.hasInsuranceFund = hasInsuranceFund;
	}
	final dynamic? birthday = jsonConvert.convert<dynamic>(json['birthday']);
	if (birthday != null) {
		staffInfo.birthday = birthday;
	}
	final String? mobile = jsonConvert.convert<String>(json['mobile']);
	if (mobile != null) {
		staffInfo.mobile = mobile;
	}
	final String? faceUrl = jsonConvert.convert<String>(json['faceUrl']);
	if (faceUrl != null) {
		staffInfo.faceUrl = faceUrl;
	}
	final String? faceVideoUrl = jsonConvert.convert<String>(json['faceVideoUrl']);
	if (faceVideoUrl != null) {
		staffInfo.faceVideoUrl = faceVideoUrl;
	}
	final dynamic? skillType = jsonConvert.convert<dynamic>(json['skillType']);
	if (skillType != null) {
		staffInfo.skillType = skillType;
	}
	final String? workType = jsonConvert.convert<String>(json['workType']);
	if (workType != null) {
		staffInfo.workType = workType;
	}
	final dynamic? hasInHome = jsonConvert.convert<dynamic>(json['hasInHome']);
	if (hasInHome != null) {
		staffInfo.hasInHome = hasInHome;
	}
	final dynamic? autograph = jsonConvert.convert<dynamic>(json['autograph']);
	if (autograph != null) {
		staffInfo.autograph = autograph;
	}
	final dynamic? certificateNo = jsonConvert.convert<dynamic>(json['certificateNo']);
	if (certificateNo != null) {
		staffInfo.certificateNo = certificateNo;
	}
	final String? idCardFront = jsonConvert.convert<String>(json['idCardFront']);
	if (idCardFront != null) {
		staffInfo.idCardFront = idCardFront;
	}
	final String? idCardNo = jsonConvert.convert<String>(json['idCardNo']);
	if (idCardNo != null) {
		staffInfo.idCardNo = idCardNo;
	}
	final String? idCardBack = jsonConvert.convert<String>(json['idCardBack']);
	if (idCardBack != null) {
		staffInfo.idCardBack = idCardBack;
	}
	final dynamic? personalProfile = jsonConvert.convert<dynamic>(json['personalProfile']);
	if (personalProfile != null) {
		staffInfo.personalProfile = personalProfile;
	}
	final dynamic? nation = jsonConvert.convert<dynamic>(json['nation']);
	if (nation != null) {
		staffInfo.nation = nation;
	}
	final dynamic? nativePlace = jsonConvert.convert<dynamic>(json['nativePlace']);
	if (nativePlace != null) {
		staffInfo.nativePlace = nativePlace;
	}
	final String? province = jsonConvert.convert<String>(json['province']);
	if (province != null) {
		staffInfo.province = province;
	}
	final String? city = jsonConvert.convert<String>(json['city']);
	if (city != null) {
		staffInfo.city = city;
	}
	final String? district = jsonConvert.convert<String>(json['district']);
	if (district != null) {
		staffInfo.district = district;
	}
	final String? address = jsonConvert.convert<String>(json['address']);
	if (address != null) {
		staffInfo.address = address;
	}
	final dynamic? balance = jsonConvert.convert<dynamic>(json['balance']);
	if (balance != null) {
		staffInfo.balance = balance;
	}
	final dynamic? education = jsonConvert.convert<dynamic>(json['education']);
	if (education != null) {
		staffInfo.education = education;
	}
	final dynamic? major = jsonConvert.convert<dynamic>(json['major']);
	if (major != null) {
		staffInfo.major = major;
	}
	final dynamic? school = jsonConvert.convert<dynamic>(json['school']);
	if (school != null) {
		staffInfo.school = school;
	}
	final dynamic? storeNo = jsonConvert.convert<dynamic>(json['storeNo']);
	if (storeNo != null) {
		staffInfo.storeNo = storeNo;
	}
	final dynamic? status = jsonConvert.convert<dynamic>(json['status']);
	if (status != null) {
		staffInfo.status = status;
	}
	final int? score = jsonConvert.convert<int>(json['score']);
	if (score != null) {
		staffInfo.score = score;
	}
	final int? hourAmount = jsonConvert.convert<int>(json['hourAmount']);
	if (hourAmount != null) {
		staffInfo.hourAmount = hourAmount;
	}
	final int? monthAmount = jsonConvert.convert<int>(json['monthAmount']);
	if (monthAmount != null) {
		staffInfo.monthAmount = monthAmount;
	}
	return staffInfo;
}

Map<String, dynamic> $StaffInfoToJson(StaffInfo entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['id'] = entity.id;
	data['userNo'] = entity.userNo;
	data['name'] = entity.name;
	data['nick'] = entity.nick;
	data['tableau'] = entity.tableau;
	data['sex'] = entity.sex;
	data['age'] = entity.age;
	data['experience'] = entity.experience;
	data['hasInsuranceFund'] = entity.hasInsuranceFund;
	data['birthday'] = entity.birthday;
	data['mobile'] = entity.mobile;
	data['faceUrl'] = entity.faceUrl;
	data['faceVideoUrl'] = entity.faceVideoUrl;
	data['skillType'] = entity.skillType;
	data['workType'] = entity.workType;
	data['hasInHome'] = entity.hasInHome;
	data['autograph'] = entity.autograph;
	data['certificateNo'] = entity.certificateNo;
	data['idCardFront'] = entity.idCardFront;
	data['idCardNo'] = entity.idCardNo;
	data['idCardBack'] = entity.idCardBack;
	data['personalProfile'] = entity.personalProfile;
	data['nation'] = entity.nation;
	data['nativePlace'] = entity.nativePlace;
	data['province'] = entity.province;
	data['city'] = entity.city;
	data['district'] = entity.district;
	data['address'] = entity.address;
	data['balance'] = entity.balance;
	data['education'] = entity.education;
	data['major'] = entity.major;
	data['school'] = entity.school;
	data['storeNo'] = entity.storeNo;
	data['status'] = entity.status;
	data['score'] = entity.score;
	data['hourAmount'] = entity.hourAmount;
	data['monthAmount'] = entity.monthAmount;
	return data;
}