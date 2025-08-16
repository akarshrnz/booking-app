import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ScreenUtil {
  static void init(BuildContext context) {
    ScreenUtil.init(
      context,
      // designSize: const Size(360, 690),
      // minTextAdapt: true,
      // splitScreenMode: true,
    );
  }

  static double setHeight(double height) => height.h;
  static double setWidth(double width) => width.w;
  static double setSp(double size) => size.sp;
  static double setRadius(double radius) => radius.r;
}