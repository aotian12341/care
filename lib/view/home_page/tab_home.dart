import 'dart:ui';

import 'package:card_swiper/card_swiper.dart';
import 'package:care/constants/app_config.dart';
import 'package:care/widget/main_button.dart';
import 'package:care/widget/navigator_ex.dart';
import 'package:flutter/material.dart';

import '../../common/colors.dart';
import '../../widget/page_widget.dart';
import '../demand/demand_classify.dart';
import 'second_classify.dart';

class TabHome extends StatefulWidget {
  const TabHome({Key? key}) : super(key: key);

  @override
  _TabHomeState createState() => _TabHomeState();
}

class _TabHomeState extends State<TabHome> {
  final titles = [
    {"title": "儿童保育", "icon": "assets/images/icon_baby.png", "code": "0"},
    {"title": "高级护理", "icon": "assets/images/icon_carer.png", "code": "1"},
    {"title": "家务", "icon": "assets/images/icon_cleaning.png", "code": "2"},
    {"title": "健康服务", "icon": "assets/images/icon_healthy.png", "code": "3"},
  ];

  @override
  Widget build(BuildContext context) {
    return PageWidget(
        showAppBar: false,
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                height: 227,
                child: Swiper(
                  itemCount: 2,
                  itemBuilder: (BuildContext context, int index) {
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(18),
                      child: Image.network(
                        AppConfig.image,
                        fit: BoxFit.cover,
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 30),
              Wrap(
                spacing: 35,
                runSpacing: 20,
                children: titles.asMap().keys.map((index) {
                  final item = titles[index];
                  return InkWell(
                    onTap: () {
                      const Navigator().pushRoute(
                          context,
                          SecondClassify(
                            code: item["code"].toString(),
                            title: item["title"].toString(),
                          ));
                    },
                    child: Container(
                      width: 128,
                      height: 128,
                      decoration: BoxDecoration(
                          color: DSColors.white,
                          borderRadius: BorderRadius.circular(22),
                          boxShadow: [
                            BoxShadow(
                                color: DSColors.divider,
                                spreadRadius: 5,
                                blurRadius: 5),
                          ]),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            item["icon"].toString(),
                            width: 50,
                          ),
                          const SizedBox(height: 15),
                          Text(
                            item["title"].toString(),
                            style:
                                TextStyle(color: DSColors.title, fontSize: 14),
                          )
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),
              MainButton(
                onTap: () {
                  const Navigator().pushRoute(context, const DemandClassify());
                },
                width: 180,
                title: "发布护理需求",
              ),
              const SizedBox(height: 24),
            ],
          ),
        ));
  }
}
