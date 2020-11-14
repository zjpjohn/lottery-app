import 'package:flutter/material.dart';
import 'package:lottery_app/components/adaptor.dart';

typedef TapCallback = void Function(String);

class BallButton extends StatelessWidget {
  //button传入的值
  String value;

  ///button的尺寸
  double size;

  //字体
  double fontSize;

  //点击事件
  TapCallback onTap;

  ///当前button状态:-1-不可用,0-未选中,1-选中
  int status;

  ///激活的颜色
  Color active;

  ///未激活的颜色
  Color unActive;

  ///不可用的颜色
  Color disable;

  BallButton({
    @required this.value,
    @required this.onTap,
    this.size = 26,
    this.fontSize = 14,
    this.status = 0,
    this.active = Colors.redAccent,
    this.unActive = const Color(0xFFfedcbd),
    this.disable = const Color(0xFFF1F1F1),
  });

  @override
  Widget build(BuildContext context) {
    Color bgColor = unActive;
    if (status == -1) {
      bgColor = disable;
    } else if (status == 0) {
      bgColor = unActive;
    } else {
      bgColor = active;
    }
    return GestureDetector(
      onTap: () {
        if (status == -1) {
          return;
        }
        onTap(value);
      },
      child: Container(
        margin: EdgeInsets.only(right: Adaptor.width(8)),
        alignment: Alignment.center,
        width: Adaptor.width(size),
        height: Adaptor.width(size),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(Adaptor.width(size)),
        ),
        child: Text(
          '${value}',
          style: TextStyle(
            fontSize: Adaptor.sp(fontSize),
            color: status == -1 ? Colors.black38 : Colors.white,
          ),
        ),
      ),
    );
  }
}

//class BallButton extends StatefulWidget {
//  //button传入的值
//  String value;
//
//  ///button的尺寸
//  double size;
//
//  //字体
//  double fontSize;
//
//  //点击事件
//  TapCallback onTap;
//
//  ///是否不可用
//  bool disabled;
//
//  ///激活的颜色
//  Color active;
//
//  ///未激活的颜色
//  Color unActive;
//
//  ///不可用的颜色
//  Color disable;
//
//  BallButton({
//    @required this.value,
//    @required this.onTap,
//    this.size = 26,
//    this.fontSize = 14,
//    this.disabled = false,
//    this.active = Colors.redAccent,
//    this.unActive = const Color(0xFFFF9797),
//    this.disable = const Color(0xFFF1F1F1),
//  });
//
//  @override
//  BallButtonState createState() => new BallButtonState();
//}
//
//class BallButtonState extends State<BallButton> {
//  ///选中的值
//  String value;
//
//  @override
//  Widget build(BuildContext context) {
//    Color bgColor = widget.unActive;
//    if (widget.disabled) {
//      bgColor = widget.disable;
//    }
//    if (widget.value == value) {
//      bgColor = widget.active;
//    }
//    return GestureDetector(
//      onTap: () {
//        if (widget.disabled) {
//          return;
//        }
//        setState(() {
//          value = widget.onTap(widget.value) ? widget.value : null;
//        });
//      },
//      child: Container(
//        margin: EdgeInsets.only(right: Adaptor.sp(8)),
//        alignment: Alignment.center,
//        width: Adaptor.width(widget.size),
//        height: Adaptor.width(widget.size),
//        decoration: BoxDecoration(
//          color: bgColor,
//          borderRadius: BorderRadius.circular(Adaptor.width(widget.size)),
//        ),
//        child: Text(
//          '${widget.value}',
//          style: TextStyle(
//            fontSize: Adaptor.sp(widget.fontSize),
//            color: widget.disabled ? Colors.black38 : Colors.white,
//          ),
//        ),
//      ),
//    );
//  }
//
//  @override
//  void initState() {
//    super.initState();
//  }
//
//  @override
//  void dispose() {
//    super.dispose();
//  }
//
//  @override
//  void didUpdateWidget(BallButton oldWidget) {
//    super.didUpdateWidget(oldWidget);
//  }
//
//  @override
//  void didChangeDependencies() {
//    super.didChangeDependencies();
//  }
//}
