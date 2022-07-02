import 'package:care/generated/json/base/json_convert_content.dart';
import 'package:care/model/address_info.dart';

AddressInfo $AddressInfoFromJson(Map<String, dynamic> json) {
	final AddressInfo addressInfo = AddressInfo();
	final int? id = jsonConvert.convert<int>(json['id']);
	if (id != null) {
		addressInfo.id = id;
	}
	final String? addressName = jsonConvert.convert<String>(json['addressName']);
	if (addressName != null) {
		addressInfo.addressName = addressName;
	}
	final String? addressNo = jsonConvert.convert<String>(json['addressNo']);
	if (addressNo != null) {
		addressInfo.addressNo = addressNo;
	}
	final String? userNo = jsonConvert.convert<String>(json['userNo']);
	if (userNo != null) {
		addressInfo.userNo = userNo;
	}
	final String? contacts = jsonConvert.convert<String>(json['contacts']);
	if (contacts != null) {
		addressInfo.contacts = contacts;
	}
	final String? telephone = jsonConvert.convert<String>(json['telephone']);
	if (telephone != null) {
		addressInfo.telephone = telephone;
	}
	final String? province = jsonConvert.convert<String>(json['province']);
	if (province != null) {
		addressInfo.province = province;
	}
	final String? city = jsonConvert.convert<String>(json['city']);
	if (city != null) {
		addressInfo.city = city;
	}
	final String? district = jsonConvert.convert<String>(json['district']);
	if (district != null) {
		addressInfo.district = district;
	}
	final String? address = jsonConvert.convert<String>(json['address']);
	if (address != null) {
		addressInfo.address = address;
	}
	final String? isDefault = jsonConvert.convert<String>(json['isDefault']);
	if (isDefault != null) {
		addressInfo.isDefault = isDefault;
	}
	final String? latitude = jsonConvert.convert<String>(json['latitude']);
	if (latitude != null) {
		addressInfo.latitude = latitude;
	}
	final String? longitude = jsonConvert.convert<String>(json['longitude']);
	if (longitude != null) {
		addressInfo.longitude = longitude;
	}
	final String? houseno = jsonConvert.convert<String>(json['houseno']);
	if (houseno != null) {
		addressInfo.houseno = houseno;
	}
	return addressInfo;
}

Map<String, dynamic> $AddressInfoToJson(AddressInfo entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['id'] = entity.id;
	data['addressName'] = entity.addressName;
	data['addressNo'] = entity.addressNo;
	data['userNo'] = entity.userNo;
	data['contacts'] = entity.contacts;
	data['telephone'] = entity.telephone;
	data['province'] = entity.province;
	data['city'] = entity.city;
	data['district'] = entity.district;
	data['address'] = entity.address;
	data['isDefault'] = entity.isDefault;
	data['latitude'] = entity.latitude;
	data['longitude'] = entity.longitude;
	data['houseno'] = entity.houseno;
	return data;
}