import 'package:care/generated/json/base/json_convert_content.dart';
import 'package:care/model/dictionary_item.dart';

DictionaryItem $DictionaryItemFromJson(Map<String, dynamic> json) {
	final DictionaryItem dictionaryItem = DictionaryItem();
	final int? id = jsonConvert.convert<int>(json['id']);
	if (id != null) {
		dictionaryItem.id = id;
	}
	final String? code = jsonConvert.convert<String>(json['code']);
	if (code != null) {
		dictionaryItem.code = code;
	}
	final String? name = jsonConvert.convert<String>(json['name']);
	if (name != null) {
		dictionaryItem.name = name;
	}
	final String? value = jsonConvert.convert<String>(json['value']);
	if (value != null) {
		dictionaryItem.value = value;
	}
	final dynamic? icon = jsonConvert.convert<dynamic>(json['icon']);
	if (icon != null) {
		dictionaryItem.icon = icon;
	}
	final dynamic? sketch = jsonConvert.convert<dynamic>(json['sketch']);
	if (sketch != null) {
		dictionaryItem.sketch = sketch;
	}
	final String? parentCode = jsonConvert.convert<String>(json['parentCode']);
	if (parentCode != null) {
		dictionaryItem.parentCode = parentCode;
	}
	final String? codePath = jsonConvert.convert<String>(json['codePath']);
	if (codePath != null) {
		dictionaryItem.codePath = codePath;
	}
	final int? seqNum = jsonConvert.convert<int>(json['seqNum']);
	if (seqNum != null) {
		dictionaryItem.seqNum = seqNum;
	}
	final List<DictionaryItem>? items = jsonConvert.convertListNotNull<DictionaryItem>(json['items']);
	if (items != null) {
		dictionaryItem.items = items;
	}
	return dictionaryItem;
}

Map<String, dynamic> $DictionaryItemToJson(DictionaryItem entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['id'] = entity.id;
	data['code'] = entity.code;
	data['name'] = entity.name;
	data['value'] = entity.value;
	data['icon'] = entity.icon;
	data['sketch'] = entity.sketch;
	data['parentCode'] = entity.parentCode;
	data['codePath'] = entity.codePath;
	data['seqNum'] = entity.seqNum;
	data['items'] =  entity.items?.map((v) => v.toJson()).toList();
	return data;
}