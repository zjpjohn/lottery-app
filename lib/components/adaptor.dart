import 'package:flutter_screenutil/flutter_screenutil.dart';

class Adaptor {
  static double width(double width) {
    return ScreenUtil().setWidth(width);
  }

  static double height(double height) {
    return ScreenUtil().setWidth(height);
  }

  static double sp(double font){
    return ScreenUtil().setSp(font);
  }
}
