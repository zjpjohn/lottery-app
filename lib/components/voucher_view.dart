import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottery_app/components/animate_number.dart';

class VoucherView extends StatefulWidget {
  int voucher;

  String timestamp;

  VoucherView({@required this.voucher, @required this.timestamp});

  @override
  VoucherViewState createState() => new VoucherViewState();
}

class VoucherViewState extends State<VoucherView> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(bottom: 8, left: 5),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Text(
                '代金券',
                style: TextStyle(
                  color: Color(0xff88644C),
                  fontWeight: FontWeight.w400,
                  fontSize: 13,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 4),
                child: Text(
                  '${widget.timestamp}',
                  style: TextStyle(
                      color: Colors.black26,
                      fontWeight: FontWeight.w400,
                      fontSize: 13,
                      height: 0.85),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.only(bottom: 6, left: 5),
          child: AnimateNumber(
            number: widget.voucher,
            start: widget.voucher - 6 > 0 ? widget.voucher - 6 : 0,
            duration: 600,
            style: TextStyle(
              color: Color(0xffFF421A),
              fontSize: 32,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(bottom: 2),
          child: CustomPaint(
            painter: VoucherPaint(
              voucher: widget.voucher,
              color: Color(0xffFF421A),
              min: 0,
              max: 100,
            ),
            child: SizedBox(
              height: 12,
              width: 150,
            ),
          ),
        )
      ],
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }
}

class VoucherPaint extends CustomPainter {
  ///当前代金券值
  int voucher;

  ///最小值
  int min;

  ///最大值
  int max;

  ///颜色
  Color color;

  VoucherPaint({
    @required this.voucher,
    this.min: 0,
    this.max: 100,
    @required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 4
      ..isAntiAlias = true;

    ///绘制刻度轴
    Offset start = Offset(7.0, 3);
    Offset end = Offset(size.width - 10, 3);

    ///绘制底层
    paint.color = Color(0xfff2f2f2);
    canvas.drawLine(start, end, paint);

    ///绘制前景层
    paint.color = color;
    Offset current =
        Offset((size.width - 25) * (voucher + 3 - min) / (max - min), 3);
    canvas.drawLine(start, current, paint);

    ///绘制最小
    TextPainter minPainter = TextPainter(
      text: TextSpan(
        text: '$min',
        style: TextStyle(color: Colors.black12, fontSize: 11),
      ),
      textDirection: TextDirection.ltr,
      maxLines: 1,
    )..layout();
    Offset minPoint = Offset(5, 5);
    minPainter.paint(canvas, minPoint);

    ///绘制最大值
    TextPainter maxPainter = TextPainter(
      text: TextSpan(
        text: '$max',
        style: TextStyle(color: Colors.black12, fontSize: 11),
      ),
      textDirection: TextDirection.ltr,
      maxLines: 1,
    )..layout();
    Offset maxPoint = Offset(size.width - maxPainter.width - 3, 5);
    maxPainter.paint(canvas, maxPoint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
