import 'package:care/generated/json/base/json_convert_content.dart';
import 'package:care/model/user_info.dart';

UserInfo $UserInfoFromJson(Map<String, dynamic> json) {
	final UserInfo userInfo = UserInfo();
	final int? id = jsonConvert.convert<int>(json['id']);
	if (id != null) {
		userInfo.id = id;
	}
	final String? userNo = jsonConvert.convert<String>(json['userNo']);
	if (userNo != null) {
		userInfo.userNo = userNo;
	}
	final String? name = jsonConvert.convert<String>(json['name']);
	if (name != null) {
		userInfo.name = name;
	}
	final String? nick = jsonConvert.convert<String>(json['nick']);
	if (nick != null) {
		userInfo.nick = nick;
	}
	final dynamic? tableau = jsonConvert.convert<dynamic>(json['tableau']);
	if (tableau != null) {
		userInfo.tableau = tableau;
	}
	final String? sex = jsonConvert.convert<String>(json['sex']);
	if (sex != null) {
		userInfo.sex = sex;
	}
	final int? age = jsonConvert.convert<int>(json['age']);
	if (age != null) {
		userInfo.age = age;
	}
	final int? experience = jsonConvert.convert<int>(json['experience']);
	if (experience != null) {
		userInfo.experience = experience;
	}
	final dynamic? hasInsuranceFund = jsonConvert.convert<dynamic>(json['hasInsuranceFund']);
	if (hasInsuranceFund != null) {
		userInfo.hasInsuranceFund = hasInsuranceFund;
	}
	final String? birthday = jsonConvert.convert<String>(json['birthday']);
	if (birthday != null) {
		userInfo.birthday = birthday;
	}
	final String? mobile = jsonConvert.convert<String>(json['mobile']);
	if (mobile != null) {
		userInfo.mobile = mobile;
	}
	final String? faceUrl = jsonConvert.convert<String>(json['faceUrl']);
	if (faceUrl != null) {
		userInfo.faceUrl = faceUrl;
	}
	final String? faceVideoUrl = jsonConvert.convert<String>(json['faceVideoUrl']);
	if (faceVideoUrl != null) {
		userInfo.faceVideoUrl = faceVideoUrl;
	}
	final dynamic? skillType = jsonConvert.convert<dynamic>(json['skillType']);
	if (skillType != null) {
		userInfo.skillType = skillType;
	}
	final dynamic? workType = jsonConvert.convert<dynamic>(json['workType']);
	if (workType != null) {
		userInfo.workType = workType;
	}
	final dynamic? hasInHome = jsonConvert.convert<dynamic>(json['hasInHome']);
	if (hasInHome != null) {
		userInfo.hasInHome = hasInHome;
	}
	final dynamic? autograph = jsonConvert.convert<dynamic>(json['autograph']);
	if (autograph != null) {
		userInfo.autograph = autograph;
	}
	final String? certificateNo = jsonConvert.convert<String>(json['certificateNo']);
	if (certificateNo != null) {
		userInfo.certificateNo = certificateNo;
	}
	final String? idCardFront = jsonConvert.convert<String>(json['idCardFront']);
	if (idCardFront != null) {
		userInfo.idCardFront = idCardFront;
	}
	final String? idCardNo = jsonConvert.convert<String>(json['idCardNo']);
	if (idCardNo != null) {
		userInfo.idCardNo = idCardNo;
	}
	final String? idCardBack = jsonConvert.convert<String>(json['idCardBack']);
	if (idCardBack != null) {
		userInfo.idCardBack = idCardBack;
	}
	final dynamic? personalProfile = jsonConvert.convert<dynamic>(json['personalProfile']);
	if (personalProfile != null) {
		userInfo.personalProfile = personalProfile;
	}
	final dynamic? nation = jsonConvert.convert<dynamic>(json['nation']);
	if (nation != null) {
		userInfo.nation = nation;
	}
	final dynamic? nativePlace = jsonConvert.convert<dynamic>(json['nativePlace']);
	if (nativePlace != null) {
		userInfo.nativePlace = nativePlace;
	}
	final String? province = jsonConvert.convert<String>(json['province']);
	if (province != null) {
		userInfo.province = province;
	}
	final String? city = jsonConvert.convert<String>(json['city']);
	if (city != null) {
		userInfo.city = city;
	}
	final String? district = jsonConvert.convert<String>(json['district']);
	if (district != null) {
		userInfo.district = district;
	}
	final String? address = jsonConvert.convert<String>(json['address']);
	if (address != null) {
		userInfo.address = address;
	}
	final dynamic? balance = jsonConvert.convert<dynamic>(json['balance']);
	if (balance != null) {
		userInfo.balance = balance;
	}
	final dynamic? education = jsonConvert.convert<dynamic>(json['education']);
	if (education != null) {
		userInfo.education = education;
	}
	final dynamic? major = jsonConvert.convert<dynamic>(json['major']);
	if (major != null) {
		userInfo.major = major;
	}
	final String? school = jsonConvert.convert<String>(json['school']);
	if (school != null) {
		userInfo.school = school;
	}
	final dynamic? storeNo = jsonConvert.convert<dynamic>(json['storeNo']);
	if (storeNo != null) {
		userInfo.storeNo = storeNo;
	}
	final dynamic? status = jsonConvert.convert<dynamic>(json['status']);
	if (status != null) {
		userInfo.status = status;
	}
	final int? score = jsonConvert.convert<int>(json['score']);
	if (score != null) {
		userInfo.score = score;
	}
	final int? hourAmount = jsonConvert.convert<int>(json['hourAmount']);
	if (hourAmount != null) {
		userInfo.hourAmount = hourAmount;
	}
	final int? monthAmount = jsonConvert.convert<int>(json['monthAmount']);
	if (monthAmount != null) {
		userInfo.monthAmount = monthAmount;
	}
	return userInfo;
}

Map<String, dynamic> $UserInfoToJson(UserInfo entity) {
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