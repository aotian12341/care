import 'package:amap_flutter_base/amap_flutter_base.dart';
import 'package:amap_flutter_map/amap_flutter_map.dart';
import 'package:care/common/location_manager.dart';
import 'package:care/widget/loader.dart';
import 'package:care/widget/page_widget.dart';
import 'package:city_pickers/city_pickers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../common/colors.dart';
import '../../../common/util.dart';
import '../../../constants/app_config.dart';
import 'package:care/widget/view_ex.dart';

import '../../../controller/address_controller.dart';
import '../../../model/pois_info.dart';

/// 地图选点
class MapPicker extends StatefulWidget {
  const MapPicker({Key? key}) : super(key: key);

  @override
  State<MapPicker> createState() => _MapPickerState();
}

class _MapPickerState extends State<MapPicker> {
  static const AMapApiKey amapApiKeys =
      AMapApiKey(androidKey: AppConfig.androidKey, iosKey: AppConfig.iosKey);
  static const AMapPrivacyStatement amapPrivacyStatement =
      AMapPrivacyStatement(hasContains: true, hasShow: true, hasAgree: true);

  /// 地图控制器
  AMapController? _mapController;

  final locCity = "请选择".obs;
  final keyWord = TextEditingController();

  final loaderController = LoaderController();

  final dataList = <PoisPois>[].obs;

  Function(Map<String, dynamic> value)? locationCallBack;

  int page = 1;

  /// 经纬度
  final lat = 0.0.obs, lng = 0.0.obs;

  Set<Marker> markerSet = <Marker>{};

  Widget? aMap;
  Widget? listView;

  BitmapDescriptor? bitmap;

  final isTouch = false.obs;

  Future<void> refresh() async {
    loaderController.loading();
    getData(isRefresh: true);
  }

  void getData({bool isRefresh = false}) {
    if (isRefresh) {
      page = 1;
    } else {
      page++;
    }

    if (keyWord.text.isNotEmpty) {
      AddressController().getLocationByKeyword(
          keyWord: keyWord.text,
          city: locCity.value,
          success: (PoisInfo value) {
            if (page == 1) {
              dataList.clear();
            }
            dataList.addAll(value.pois ?? []);

            loaderController.loadFinish(data: dataList, noMore: false);
          },
          fail: (error) {});
    } else {
      AddressController().getLocationByGps(
          lat: lat.value,
          lng: lng.value,
          success: (value) {
            if (page == 1) {
              dataList.clear();
            }
            dataList.addAll(value.pois ?? []);

            loaderController.loadFinish(data: dataList, noMore: false);
          },
          fail: (error) {});
    }
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 300), () async {
      getLocation();
    });
  }

  void getLocation() {
    LocationManager().getLocation(
        isOnce: true,
        showLoading: true,
        success: locationCallBack = (value) {
          if (value["city"] != null) {
            try {
              locCity(value["city"].toString());
              lat(double.parse(value["latitude"].toString()));
              lng(double.parse(value["longitude"].toString()));
              if (_mapController != null) {
                _mapController!.moveCamera(CameraUpdate.newCameraPosition(
                    CameraPosition(
                        target: LatLng(lat.value, lng.value), zoom: 16)));
              }
              Future.delayed(const Duration(seconds: 1), () {
                getData(isRefresh: true);
              });
            } catch (e) {
              print(e);
            }
          }
        });
  }

  @override
  Widget build(BuildContext context) {
    return PageWidget(
        isCustom: "short",
        titleLabel: "添加地址",
        isTouchHideInput: false,
        body: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            final maxHeight = constraints.maxHeight;
            return Stack(
              alignment: Alignment.bottomCenter,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ClipRect(
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: maxHeight,
                        child: OverflowBox(
                          alignment: Alignment.bottomCenter,
                          maxWidth: MediaQuery.of(context).size.width,
                          maxHeight: maxHeight * 1.3,
                          child: getMap().size(
                              width: MediaQuery.of(context).size.width,
                              height: maxHeight * 1.3),
                        ),
                      ),
                    )
                  ],
                ),
                Image.asset(
                  "assets/images/icon_location.png",
                  width: 40,
                ).margin(
                    margin: EdgeInsets.only(bottom: (maxHeight * 1.3) / 2)),
                Positioned(left: 0, right: 0, top: 0, child: getSearch()),
                Positioned(
                    left: 12,
                    right: 12,
                    bottom: Util.getBottomPadding(),
                    height: MediaQuery.of(context).size.height * 0.35,
                    child: getDataView()),
              ],
            );
          },
        ));
  }

  Widget getSearch() {
    return Obx(() {
      return Row(
        children: [
          Row(
            children: [
              locCity.value.t.s(16).c(DSColors.title),
              2.h,
              Icon(
                Icons.arrow_drop_down,
                size: 15,
                color: DSColors.title,
              )
            ],
          ).size(width: 100).onTap(() async {
            final temp = await CityPickers.showCityPicker(
                context: context, showType: ShowType.pc);
            if (temp != null) {
              locCity(temp.cityName ?? "");
            }
          }),
          Expanded(
              child: Container(
            height: 30,
            padding: const EdgeInsets.only(left: 12),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(15)),
              color: DSColors.f2,
            ),
            child: TextField(
              controller: keyWord,
              style: const TextStyle(fontSize: 12),
              onChanged: (value) {
                Future.delayed(const Duration(seconds: 1), () {
                  if (value == keyWord.text) {
                    refresh();
                  }
                });
              },
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.only(top: 0, bottom: 0),
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.transparent,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.transparent,
                  ),
                ),
                disabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.transparent,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.transparent,
                  ),
                ),
                hintText: "请输入关键字",
              ),
            ),
          ))
          // .padding(padding: const EdgeInsets.symmetric(horizontal: 10))
          // .border(color: DSColors.describe)
          // .borderRadius(radius: 20)
          // .expanded()
        ],
      )
          .size(height: 50)
          .color(DSColors.white)
          .padding(padding: const EdgeInsets.symmetric(horizontal: 12));
    });
  }

  /// 地图创建回调
  void onMapCreated(AMapController controller) {
    _mapController = controller;
    if (lat.value > 0 && lng.value > 0) {
      _mapController!.moveCamera(
          CameraUpdate.newLatLngZoom(LatLng(lat.value, lng.value), 16));
    }
  }

  Widget getMap() {
    return Obx(() {
      final set = <Marker>{};
      if (lat.value > 0 && lng.value > 0) {
        set.add(Marker(position: LatLng(lat.value, lng.value)));
      }
      return AMapWidget(
        initialCameraPosition:
            CameraPosition(target: LatLng(lat.value, lng.value), zoom: 16),
        apiKey: amapApiKeys,
        onMapCreated: onMapCreated,
        privacyStatement: amapPrivacyStatement,
        // markers: set,
        onCameraMoveEnd: (CameraPosition loc) {
          lat(loc.target.latitude);
          lng(loc.target.longitude);
          isTouch(false);
          refresh();
        },
        onCameraMove: (CameraPosition loc) {
          if (!isTouch.value) {
            isTouch(true);
          }
        },
      );
    });
  }

  Widget getDataView() {
    listView ??= Obx(() {
      return Loader(
              onRefresh: refresh,
              onLoad: getData,
              controller: loaderController,
              child: ListView.builder(
                itemCount: dataList.length,
                itemBuilder: (BuildContext context, int index) {
                  final item = dataList[index];
                  return Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          (item.name ?? "").t.s(16).c(DSColors.title),
                          4.v,
                          Row(
                            children: [
                              (item.address ?? "")
                                  .t
                                  .s(14)
                                  .c(DSColors.subTitle)
                                  .flexible()
                            ],
                          )
                        ],
                      ).expanded(),
                      Icon(
                        Icons.chevron_right,
                        size: 20,
                        color: DSColors.describe,
                      ),
                    ],
                  )
                      .color(DSColors.white)
                      .borderOnly(bottom: BorderSide(color: DSColors.divider))
                      .margin(margin: const EdgeInsets.only(bottom: 12))
                      .padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 8))
                      .onTap(() {
                    Navigator.pop(context, item);
                  });
                },
              ))
          .color(DSColors.white)
          .padding(padding: const EdgeInsets.symmetric(vertical: 12))
          .borderRadius(radius: 12);
    });
    return listView!;
  }

  @override
  void dispose() {
    super.dispose();

    LocationManager().removeListener((loc) => locationCallBack);
  }
}
