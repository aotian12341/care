import 'dart:convert';
import 'package:care/generated/json/base/json_field.dart';
import 'package:care/generated/json/demand_page.g.dart';

@JsonSerializable()
class DemandPage {
  int? totalCount;
  int? pageSize;
  int? totalPage;
  int? currPage;
  List<DemandPagesList>? list;

  DemandPage();

  factory DemandPage.fromJson(Map<String, dynamic> json) =>
      $DemandPageFromJson(json);

  Map<String, dynamic> toJson() => $DemandPageToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class DemandPagesList {
  String? memberDemandNo;
  String? userNo;
  String? demandType;
  String? demandTypeText;
  String? demandNo;
  String? status;
  double? budgetAmount;
  double? price;
  String? serviceTime;
  int? deployTime;
  String? telephone;
  String? address;
  List<DemandPagesListWorkers>? workers;

  DemandPagesList();

  factory DemandPagesList.fromJson(Map<String, dynamic> json) =>
      $DemandPagesListFromJson(json);

  Map<String, dynamic> toJson() => $DemandPagesListToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class DemandPagesListWorkers {
  // {"workerNo":"10300120220326000149444288662","workerName":"莫诗华","tableau":null}
  String? workerNo;
  String? workerName;
  String? tableau;

  DemandPagesListWorkers();

  factory DemandPagesListWorkers.fromJson(Map<String, dynamic> json) =>
      $DemandPagesListWorkersFromJson(json);

  Map<String, dynamic> toJson() => $DemandPagesListWorkersToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}
