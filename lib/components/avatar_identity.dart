import 'dart:core';

import 'package:flutter/material.dart';
import 'dart:math';

const List<Color> _bgColors = <Color>[
  Color(0xfff48f7b),
  Color(0xfff6ab72),
  Color(0xffedca81),
  Color(0xffb0c8a5),
  Color(0xffbab0b0),
  Color(0xffadbbd4),
  Color(0xffd4b4e8),
  Color(0xffd2aeae),
  Color(0xffe4c4cd),
  Color(0xff88c898),
  Color(0xff8495b1),
  Color(0xff877aa3),
  Color(0xffc479a2)
];

///中文正则
///
final RegExp zhcnRegex = RegExp(r"(\w|[\u4E00-\u9FA5])");

class Avatar extends StatelessWidget {
  ///用户名
  final String name;

  ///方块个数
  final int cell;

  ///头像大小
  final double size;

  ///绘制字体大小
  final double font;

  ///头像边距
  final EdgeInsets padding;

  Avatar({
    @required this.name,
    this.cell: 5,
    this.size: 48,
    this.font: 16,
    this.padding: const EdgeInsets.all(4.0),
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Container(
        padding: padding,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(2.0),
          boxShadow: [
            BoxShadow(
              color: Color(0x1f000000),
              offset: Offset(1.5, 3.0),
              blurRadius: 4.0,
              spreadRadius: 0.0,
            ),
          ],
        ),
        child: CustomPaint(
          size: Size(size - padding.left - padding.right,
              size - padding.top - padding.bottom),
          painter: AvatarView(
            cell: cell,
            color: avatarColor(),
            alpha: firstAlpha(),
            fontSize: font,
          ),
        ),
      ),
    );
  }

  ///获取中文首字母
  ///
  String firstAlpha() {
    String avatar = '';
    String s = name.toUpperCase();
    for (int i = 0; i < s.length; i++) {
      String item = s.substring(i, i + 1);
      if (zhcnRegex.hasMatch(item)) {
        avatar = item;
        break;
      }
    }
    if (avatar == '') {
      avatar = name.substring(0, 1);
    }
    return avatar;
  }

  ///创建颜色
  ///
  Color avatarColor() {
    return _bgColors[name.hashCode % _bgColors.length];
  }
}

class AvatarView extends CustomPainter {
  ///中文字符
  String alpha;

  ///颜色
  Color color;

  ///绘制单元格数量
  int cell;

  ///字体大小
  double fontSize;

  ///矩阵
  Map<int, List<List<int>>> cells = Map();

  AvatarView({
    this.cell,
    this.color,
    this.alpha,
    this.fontSize,
  }) {
    for (int i = 0; i < 9; i++) {
      if (i == 4) continue;
      List<List<int>> cell = createIdent();
      cells[i] = cell;
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    ///画布大小
    double width = size.width;
    double height = size.height;

    ///分成九宫格大小
    double cw = width / 3;
    double ch = height / 3;

    ///首先绘制文字
    ///
    TextPainter txtPainter = TextPainter(
      text: TextSpan(
        text: alpha,
        style:
            TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: color),
      ),
      textDirection: TextDirection.ltr,
      textScaleFactor: 0.90,
      maxLines: 1,
    )..layout();
    double tw = txtPainter.width;
    double th = txtPainter.height;
    Offset txtOffset = Offset(cw + (cw - tw) / 2, ch + (ch - th) / 2);
    txtPainter.paint(canvas, txtOffset);

    ///绘制二维码
    ///
    Paint paint = Paint()
      ..style = PaintingStyle.fill
      ..color = color;
    double offsetX = cw / cell;
    double offsetY = ch / cell;
    canvas.save();
    for (int k = 0; k < 9; k++) {
      if (k == 4) {
        continue;
      }
      int xDelta = k % 3;
      int yDelta = k ~/ 3;
      double startX = cw * xDelta;
      double startY = ch * yDelta;
      List<List<int>> data = cells[k];
      for (int i = 0; i < cell; i++) {
        for (int j = 0; j < cell; j++) {
          if (data[i][j] == 0) {
            continue;
          }
          Rect rect = Rect.fromLTWH(
              startX + i * offsetX, startY + j * offsetY, offsetX, offsetY);
          canvas.drawRect(rect, paint);
        }
      }
    }
    canvas.restore();
  }

  ///创建矩阵
  ///
  List<List<int>> createIdent() {
    int half = (cell ~/ 2) * cell;
    int min = (0.3 * half).floor();
    int max = (0.8 * half).ceil();
    int count = 0;
    List<List<int>> data = List(cell);
    Random random = Random();
    do {
      count = 0;
      for (int i = 0; i < (cell + 1) ~/ 2; i++) {
        List<int> rows = List(cell);
        for (int j = 0; j < cell; j++) {
          count += rows[j] = random.nextInt(cell * cell ~/ 2) % 2;
        }
        data[i] = data[cell - 1 - i] = rows;
      }
    } while (count < min || count > max);
    return data;
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
