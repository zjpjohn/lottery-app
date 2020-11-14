import 'package:flutter/cupertino.dart';

enum TextAlignment {
  center,
  top,
  bottom,
}

class TextView extends CustomPainter {
  String text;
  TextStyle style;
  TextAlignment alignment = TextAlignment.center;

  TextView({
    @required this.text,
    @required this.style,
    this.alignment,
  });

  @override
  void paint(Canvas canvas, Size size) {
    double width = size.width;
    double height = size.height;
    TextPainter painter =
        TextPainter(textDirection: TextDirection.ltr, maxLines: 1)
          ..text = TextSpan(text: text, style: style);
    var txtPainter = painter..layout();
    double txtWidth = painter.width;
    double txtHeight = painter.height;
    double left = (width - txtWidth) / 2;
    double top;
    switch (this.alignment) {
      case TextAlignment.center:
        top = (height - txtHeight) / 2;
        break;
      case TextAlignment.top:
        top = 0.0;
        break;
      case TextAlignment.bottom:
        top = height - txtHeight;
        break;
    }
    txtPainter.paint(canvas, Offset(left, top));
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class CustomText extends StatelessWidget {
  String text;

  TextStyle style = TextStyle(fontSize: 14.0);

  double width;

  double height;

  TextAlignment alignment = TextAlignment.center;

  CustomText({
    @required this.text,
    @required this.width,
    @required this.height,
    this.style,
    this.alignment,
  });

  @override
  Widget build(BuildContext context) {
    DefaultTextStyle defaultTextStyle = DefaultTextStyle.of(context);
    TextStyle textStyle = defaultTextStyle.style.merge(this.style);
    return Container(
      height: this.height,
      width: this.width,
      child: CustomPaint(
        painter: TextView(text: text, style: textStyle, alignment: alignment),
      ),
    );
  }
}
