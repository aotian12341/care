import 'package:care/generated/json/base/json_convert_content.dart';
import 'package:care/model/pois_info.dart';

PoisInfo $PoisInfoFromJson(Map<String, dynamic> json) {
  final PoisInfo poisInfo = PoisInfo();
  final String? status = jsonConvert.convert<String>(json['status']);
  if (status != null) {
    poisInfo.status = status;
  }
  final String? info = jsonConvert.convert<String>(json['info']);
  if (info != null) {
    poisInfo.info = info;
  }
  final String? infocode = jsonConvert.convert<String>(json['infocode']);
  if (infocode != null) {
    poisInfo.infocode = infocode;
  }
  final List<PoisPois>? pois =
      jsonConvert.convertListNotNull<PoisPois>(json['pois']);
  if (pois != null) {
    poisInfo.pois = pois;
  }
  final String? count = jsonConvert.convert<String>(json['count']);
  if (count != null) {
    poisInfo.count = count;
  }
  return poisInfo;
}

Map<String, dynamic> $PoisInfoToJson(PoisInfo entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['status'] = entity.status;
  data['info'] = entity.info;
  data['infocode'] = entity.infocode;
  data['pois'] = entity.pois?.map((v) => v.toJson()).toList();
  data['count'] = entity.count;
  return data;
}

PoisPois $PoisPoisFromJson(Map<String, dynamic> json) {
  final PoisPois poisPois = PoisPois();
  final String? name = jsonConvert.convert<String>(json['name']);
  if (name != null) {
    poisPois.name = name;
  }
  final String? id = jsonConvert.convert<String>(json['id']);
  if (id != null) {
    poisPois.id = id;
  }
  final String? location = jsonConvert.convert<String>(json['location']);
  if (location != null) {
    poisPois.location = location;
  }
  final String? type = jsonConvert.convert<String>(json['type']);
  if (type != null) {
    poisPois.type = type;
  }
  final String? typecode = jsonConvert.convert<String>(json['typecode']);
  if (typecode != null) {
    poisPois.typecode = typecode;
  }
  final String? pname = jsonConvert.convert<String>(json['pname']);
  if (pname != null) {
    poisPois.pname = pname;
  }
  final String? cityname = jsonConvert.convert<String>(json['cityname']);
  if (cityname != null) {
    poisPois.cityname = cityname;
  }
  final String? adname = jsonConvert.convert<String>(json['adname']);
  if (adname != null) {
    poisPois.adname = adname;
  }
  final String? address = jsonConvert.convert<String>(json['address']);
  if (address != null) {
    poisPois.address = address;
  }
  final String? pcode = jsonConvert.convert<String>(json['pcode']);
  if (pcode != null) {
    poisPois.pcode = pcode;
  }
  final String? citycode = jsonConvert.convert<String>(json['citycode']);
  if (citycode != null) {
    poisPois.citycode = citycode;
  }
  final String? adcode = jsonConvert.convert<String>(json['adcode']);
  if (adcode != null) {
    poisPois.adcode = adcode;
  }
  return poisPois;
}

Map<String, dynamic> $PoisPoisToJson(PoisPois entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['name'] = entity.name;
  data['id'] = entity.id;
  data['location'] = entity.location;
  data['type'] = entity.type;
  data['typecode'] = entity.typecode;
  data['pname'] = entity.pname;
  data['cityname'] = entity.cityname;
  data['adname'] = entity.adname;
  data['address'] = entity.address;
  data['pcode'] = entity.pcode;
  data['citycode'] = entity.citycode;
  data['adcode'] = entity.adcode;
  return data;
}
