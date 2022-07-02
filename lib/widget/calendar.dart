import 'package:care/common/time_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_picker/Picker.dart';
import 'package:get/get.dart';

import '../common/colors.dart';
import '../common/my_icon.dart';
import '../common/time_util.dart';

///
class Calendar extends StatefulWidget {
  ///
  const Calendar({
    Key? key,
    this.onChoose,
    this.isSingle = false,
  }) : super(key: key);

  ///
  final Function(String date)? onChoose;
  final bool isSingle;

  @override
  _CalendarState createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  bool isSingle = false;
  final dateList = <CalendarInfo>[].obs;
  final date = DateTime.now().obs;
  List<Color> colorList = [
    Colors.red,
    Colors.deepPurpleAccent,
    Colors.orangeAccent,
    Colors.limeAccent,
  ];

  late double width, height;

  int lastChoose = 0;

  final startDate = "".obs;
  final endDate = "".obs;

  @override
  void initState() {
    date(DateTime.now());
    Future.delayed(const Duration(seconds: 1), () {
      getData();
    });
    isSingle = widget.isSingle;

    super.initState();
  }

  void getData() {
    dateList.clear();

    final dateNow = DateTime.now();

    final year = date.value.year;
    final month = date.value.month;

    final lastYear = month == 1 ? year - 1 : year;
    final lastMonth = month == 1 ? 12 : month - 1;

    final nextYear = month == 12 ? year + 1 : year;
    final nextMonth = month == 12 ? 1 : month + 1;
    final localizations = MaterialLocalizations.of(context);
    final start =
        TimeUtil.numberOfHeadPlaceholderForMonth(year, month, localizations);
    final monthDayLength = TimeUtil.getDaysInMonth(year, month);
    final lastMonthDayLength = TimeUtil.getDaysInMonth(lastYear, lastMonth);
    final end = TimeUtil.getLastRowDaysForMonthYear(year, month, localizations);

    for (int i = start; i > 0; i--) {
      dateList.add(CalendarInfo()
        ..month = lastMonth
        ..year = lastYear
        ..day = lastMonthDayLength - i + 1
        ..type = 0);
    }
    for (int i = 0; i < monthDayLength; i++) {
      bool isContain = false;
      Color color = DSColors.white;
      bool isStart = false;
      bool isEnd = false;
      int type = 1;
      if (dateNow.year >= year) {
        if (month < dateNow.month) {
          type = 0;
        } else if (month == dateNow.month) {
          if (i + 1 < dateNow.day) {
            type = 0;
          }
        }
      }
      dateList.add(CalendarInfo()
        ..month = month
        ..isContain = isContain
        ..color = color
        ..year = year
        ..day = i + 1
        ..isStart = isStart
        ..isEnd = isEnd
        ..type = type);
    }
    for (int i = 0; i < end; i++) {
      dateList.add(CalendarInfo()
        ..month = nextMonth
        ..year = nextYear
        ..day = i + 1
        ..type = 0);
    }
    for (final item in dateList) {
      item.date =
          "${item.year}-${item.month <= 9 ? "0" : ""}${item.month}-${item.day <= 9 ? "0" : ""}${item.day}";
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (isSingle == widget.isSingle) {
    } else {
      isSingle = widget.isSingle;
      startDate("");
      endDate("");
    }
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        width = constraints.maxWidth;
        height = constraints.maxHeight;
        return Container(
          color: DSColors.white,
          child: Column(
            children: [
              getWeek(),
              // getDatePickerView(),
              getMonthView(),
              getCalendar(),
            ],
          ),
        );
      },
    );
  }

  Widget getMonthView() {
    return Obx(() {
      return Container(
        height: 48,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            Expanded(
                child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () {
                    final temp = date.value.month;
                    int year = date.value.year;
                    int month = temp - 1;
                    if (temp == 0) {
                      month = 11;
                      year -= 1;
                    }
                    date(date.value.copyWith(month: month, year: year));
                    getData();
                  },
                  child: Icon(
                    Icons.keyboard_arrow_left,
                    size: 25,
                    color: DSColors.title,
                  ),
                ),
                Container(
                  width: 80,
                  alignment: Alignment.center,
                  child: Text(
                    "${date.value.month}月",
                    style: TextStyle(color: DSColors.title, fontSize: 14),
                  ),
                ),
                InkWell(
                  onTap: () {
                    final temp = date.value.month;
                    int year = date.value.year;
                    int month = temp + 1;
                    if (temp == 11) {
                      month = 0;
                      year += 1;
                    }
                    date(date.value.copyWith(month: month, year: year));
                    getData();
                  },
                  child: Icon(
                    Icons.keyboard_arrow_right,
                    size: 25,
                    color: DSColors.title,
                  ),
                )
              ],
            )),
            Expanded(
                child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () {
                    int year = date.value.year - 1;
                    date(date.value.copyWith(year: year));
                    getData();
                  },
                  child: Icon(
                    Icons.keyboard_arrow_left,
                    size: 25,
                    color: DSColors.title,
                  ),
                ),
                Container(
                  child: Text(
                    "${date.value.year}年",
                    style: TextStyle(color: DSColors.title, fontSize: 14),
                  ),
                  width: 80,
                  alignment: Alignment.center,
                ),
                InkWell(
                  onTap: () {
                    int year = date.value.year + 1;
                    date(date.value.copyWith(year: year));
                    getData();
                  },
                  child: Icon(
                    Icons.keyboard_arrow_right,
                    size: 25,
                    color: DSColors.title,
                  ),
                )
              ],
            ))
          ],
        ),
      );
    });
  }

  Widget getCalendar() {
    final cellWidth = width / 7 - 0.2;
    final cellHeight = cellWidth * 0.9;
    return Obx(() {
      return Wrap(
        runSpacing: 10,
        children: dateList.asMap().keys.map((index) {
          final item = dateList[index];
          final isStart = startDate.value == item.date;
          final isEnd = endDate.value == item.date;
          bool isContainer = false;
          if (startDate.value.isNotEmpty && endDate.value.isNotEmpty) {
            int start = num.parse(startDate.value.replaceAll("-", "")).toInt();
            int end = num.parse(endDate.value.replaceAll("-", "")).toInt();
            int temp = num.parse(item.date.replaceAll("-", "")).toInt();
            if (start <= temp && temp <= end) {
              isContainer = true;
            }
          }
          final style = TextStyle(
            fontSize: 16,
            color: isStart || isEnd
                ? DSColors.white
                : item.type != 0
                    ? DSColors.title
                    : DSColors.describe,
          );
          return InkWell(
            onTap: () {
              final clickDate = DateTime.parse(item.date).copyWith(
                hour: 23,
                minute: 59,
                second: 59,
              );
              final nowDate = DateTime.now()
                  .copyWith(hour: 0, minute: 0, second: 0, millisecond: 0);

              final cha = clickDate.difference(nowDate);
              if (cha.inSeconds > 0) {
                if (widget.isSingle) {
                  startDate(item.date);
                  endDate(item.date);
                  if (widget.onChoose != null) {
                    widget.onChoose!(startDate.value);
                  }
                } else {
                  if (startDate.isEmpty || endDate.isNotEmpty) {
                    startDate(item.date);
                    endDate("");
                  } else if (startDate.isNotEmpty || endDate.isEmpty) {
                    final start = DateTime.parse(startDate.value);
                    final c = clickDate.difference(start);
                    if (c.inDays > 0) {
                      endDate(item.date);
                    } else {
                      startDate(item.date);
                      endDate("");
                    }
                  }

                  if (startDate.isNotEmpty && endDate.isNotEmpty) {
                    if (widget.onChoose != null) {
                      widget.onChoose!("${startDate.value}--${endDate.value}");
                    }
                  }
                }

                dateList.refresh();
              }
            },
            child: SizedBox(
              width: cellWidth,
              height: cellHeight,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.only(
                        right: item.isStart ? 5 : 0, left: item.isEnd ? 5 : 0),
                    margin: EdgeInsets.only(
                        left: item.isStart && index % 7 != 0 ? 5 : 0,
                        right: item.isEnd ? 5 : 0),
                    decoration: BoxDecoration(
                      color: isStart || isEnd
                          ? DSColors.primaryColor
                          : isContainer
                              ? DSColors.primaryColor.withOpacity(0.2)
                              : null,
                      borderRadius: BorderRadius.horizontal(
                          left: Radius.circular(isStart ? 8 : 0),
                          right: Radius.circular(isEnd ? 8 : 0)),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      item.day.toString(),
                      style: style,
                    ),
                  ),
                  if (isStart)
                    Positioned(
                        left: 0,
                        right: 0,
                        top: 2,
                        child: Center(
                          child: Text(
                            "开始",
                            style:
                                TextStyle(color: DSColors.white, fontSize: 10),
                          ),
                        )),
                  if (isEnd)
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: 2,
                      child: Center(
                        child: Text(
                          "结束",
                          style: TextStyle(
                            color: DSColors.white,
                            fontSize: 10,
                          ),
                        ),
                      ),
                    )
                ],
              ),
            ),
          );
        }).toList(),
      );
    });
  }

  Widget getWeek() {
    final titles = ["日", "一", "二", "三", "四", "五", "六"];
    return SizedBox(
      height: 40,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: titles.asMap().keys.map((index) {
          return Expanded(
            child: Center(
              child: Text(
                titles[index],
                style: TextStyle(
                    color: (index == 0 || index == titles.length - 1)
                        ? DSColors.primaryColor
                        : DSColors.title),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget getDatePickerView() {
    return InkWell(
      onTap: showPicker,
      child: SizedBox(
        height: 44,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Obx(() {
              return Text(
                date.value.format(format: "yyyy年MM月"),
                style: TextStyle(fontSize: 17, color: DSColors.title),
              );
            }),
            const SizedBox(width: 8),
            Icon(
              MyIcon.icon_arrow_down,
              size: 12,
              color: DSColors.title,
            ),
          ],
        ),
      ),
    );
  }

  void showPicker() {
    Picker(
        adapter: DateTimePickerAdapter(
          type: PickerDateTimeType.kYM,
          isNumberMonth: true,
          yearSuffix: "年",
          monthSuffix: "月",
          value: date.value,
        ),
        confirmText: "确定",
        cancelText: "取消",
        confirmTextStyle: TextStyle(color: DSColors.primaryColor, fontSize: 14),
        cancelTextStyle: TextStyle(color: DSColors.title, fontSize: 14),
        onConfirm: (picker, selectIndex) {
          // if (widget.onDate != null) {
          //   widget.onDate!((picker.adapter as DateTimePickerAdapter).value!);
          // }
          date((picker.adapter as DateTimePickerAdapter).value);
          getData();
        }).showModal<dynamic>(context);
  }
}

///
class CalendarInfo {
  ///
  late int day;

  ///
  late int month;

  ///
  late int year;

  ///
  late int type; //0:上个月，1:这个月，2:下个月
  ///
  late Color color; // 选中颜色
  ///
  late bool isChoose = false;

  ///
  late bool isContain = false;

  ///
  late bool isStart = false;

  ///
  late bool isEnd = false;

  late String date;
}
