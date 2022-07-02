import 'package:flutter/material.dart';

import '../../common/colors.dart';

/// 加载
class Loading extends Dialog {
  ///
  const Loading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
        //创建透明层
        type: MaterialType.transparency, //透明类型
        child: GestureDetector(
          onTap: () => hide(context),
          child: SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Center(
                // child: Image.asset(
                //   "assets/images/icon_loadings.gif",
                //   width: 100,
                // ),
                child: Center(
                  child: CircularProgressIndicator(
                    color: DSColors.primaryColor,
                  ),
                ),
              )),
        ));
  }

  ///
  void hide(BuildContext context) {
    Navigator.pop(context);
  }
}
