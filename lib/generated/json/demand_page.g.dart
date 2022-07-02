import 'package:care/generated/json/base/json_convert_content.dart';
import 'package:care/model/demand_page.dart';

DemandPage $DemandPageFromJson(Map<String, dynamic> json) {
  final DemandPage demandPage = DemandPage();
  final int? totalCount = jsonConvert.convert<int>(json['totalCount']);
  if (totalCount != null) {
    demandPage.totalCount = totalCount;
  }
  final int? pageSize = jsonConvert.convert<int>(json['pageSize']);
  if (pageSize != null) {
    demandPage.pageSize = pageSize;
  }
  final int? totalPage = jsonConvert.convert<int>(json['totalPage']);
  if (totalPage != null) {
    demandPage.totalPage = totalPage;
  }
  final int? currPage = jsonConvert.convert<int>(json['currPage']);
  if (currPage != null) {
    demandPage.currPage = currPage;
  }
  final List<DemandPagesList>? list =
      jsonConvert.convertListNotNull<DemandPagesList>(json['list']);
  if (list != null) {
    demandPage.list = list;
  }
  return demandPage;
}

Map<String, dynamic> $DemandPageToJson(DemandPage entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['totalCount'] = entity.totalCount;
  data['pageSize'] = entity.pageSize;
  data['totalPage'] = entity.totalPage;
  data['currPage'] = entity.currPage;
  data['list'] = entity.list?.map((v) => v.toJson()).toList();
  return data;
}

DemandPagesList $DemandPagesListFromJson(Map<String, dynamic> json) {
  final DemandPagesList demandPagesList = DemandPagesList();
  final String? memberDemandNo =
      jsonConvert.convert<String>(json['memberDemandNo']);
  if (memberDemandNo != null) {
    demandPagesList.memberDemandNo = memberDemandNo;
  }
  final String? userNo = jsonConvert.convert<String>(json['userNo']);
  if (userNo != null) {
    demandPagesList.userNo = userNo;
  }
  final String? demandType = jsonConvert.convert<String>(json['demandType']);
  if (demandType != null) {
    demandPagesList.demandType = demandType;
  }
  final String? demandTypeText =
      jsonConvert.convert<String>(json['demandTypeText']);
  if (demandTypeText != null) {
    demandPagesList.demandTypeText = demandTypeText;
  }
  final String? demandNo = jsonConvert.convert<String>(json['demandNo']);
  if (demandNo != null) {
    demandPagesList.demandNo = demandNo;
  }
  final String? status = jsonConvert.convert<String>(json['status']);
  if (status != null) {
    demandPagesList.status = status;
  }
  final double? budgetAmount =
      jsonConvert.convert<double>(json['budgetAmount']);
  if (budgetAmount != null) {
    demandPagesList.budgetAmount = budgetAmount;
  }
  final double? price = jsonConvert.convert<double>(json['price']);
  if (price != null) {
    demandPagesList.price = price;
  }
  final String? serviceTime = jsonConvert.convert<String>(json['serviceTime']);
  if (serviceTime != null) {
    demandPagesList.serviceTime = serviceTime;
  }
  final int? deployTime = jsonConvert.convert<int>(json['deployTime']);
  if (deployTime != null) {
    demandPagesList.deployTime = deployTime;
  }
  final String? telephone = jsonConvert.convert<String>(json['telephone']);
  if (telephone != null) {
    demandPagesList.telephone = telephone;
  }
  final String? address = jsonConvert.convert<String>(json['address']);
  if (address != null) {
    demandPagesList.address = address;
  }
  final List<DemandPagesListWorkers>? workers =
      jsonConvert.convertListNotNull<DemandPagesListWorkers>(json['workers']);
  if (workers != null) {
    demandPagesList.workers = workers;
  }
  return demandPagesList;
}

Map<String, dynamic> $DemandPagesListToJson(DemandPagesList entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['memberDemandNo'] = entity.memberDemandNo;
  data['userNo'] = entity.userNo;
  data['demandType'] = entity.demandType;
  data['demandTypeText'] = entity.demandTypeText;
  data['demandNo'] = entity.demandNo;
  data['status'] = entity.status;
  data['budgetAmount'] = entity.budgetAmount;
  data['price'] = entity.price;
  data['serviceTime'] = entity.serviceTime;
  data['deployTime'] = entity.deployTime;
  data['telephone'] = entity.telephone;
  data['address'] = entity.address;
  data['workers'] = entity.workers?.map((v) => v.toJson()).toList();
  return data;
}

DemandPagesListWorkers $DemandPagesListWorkersFromJson(
    Map<String, dynamic> json) {
  final DemandPagesListWorkers demandPagesListWorkers =
      DemandPagesListWorkers();
  final String? workerNo = jsonConvert.convert<String>(json['workerNo']);
  if (workerNo != null) {
    demandPagesListWorkers.workerNo = workerNo;
  }
  final String? workerName = jsonConvert.convert<String>(json['workerName']);
  if (workerName != null) {
    demandPagesListWorkers.workerName = workerName;
  }
  final String? tableau = jsonConvert.convert<String>(json['tableau']);
  if (tableau != null) {
    demandPagesListWorkers.tableau = tableau;
  }
  return demandPagesListWorkers;
}

Map<String, dynamic> $DemandPagesListWorkersToJson(
    DemandPagesListWorkers entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['workerNo'] = entity.workerNo;
  data['workerName'] = entity.workerName;
  data['tableau'] = entity.tableau;
  return data;
}
