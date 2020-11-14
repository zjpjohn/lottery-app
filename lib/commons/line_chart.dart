import 'dart:core';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LineChart extends StatelessWidget {
  ///图表数据
  ///
  LineData data;

  ///padding样式
  ///
  EdgeInsets padding;

  ///宽
  double width;

  ///高
  double height;

  LineChart({
    key,
    @required this.data,
    @required this.padding,
    @required this.width,
    @required this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          data.showTitle
              ? Container(
                  padding: EdgeInsets.fromLTRB(20, 6, 10, 6),
                  alignment: Alignment.centerLeft,
                  child: Row(
                    children: <Widget>[
                      _mark('最小值', Colors.white, Colors.redAccent),
                      _mark('最大值', Colors.white, Colors.blueAccent),
                    ],
                  ),
                )
              : Container(
                  child: null,
                ),
          Expanded(
            child: Container(
              width: width,
              padding: padding,
              child: CustomPaint(
                painter: LineChartView(data: this.data),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _mark(String mark, Color color, Color dot) {
    return Container(
      margin: EdgeInsets.only(right: 35),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            height: 1,
            width: 10,
            color: Colors.white70,
          ),
          Container(
            height: 4.4,
            width: 4.4,
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: dot,
            ),
          ),
          Container(
            height: 1,
            width: 20,
            color: Colors.white70,
            margin: EdgeInsets.only(right: 4),
          ),
          Text(
            mark,
            style: TextStyle(color: color, fontSize: 12),
          )
        ],
      ),
    );
  }
}

class LineChartView extends CustomPainter {
  ///图表数据
  ///
  LineData data;

  ///横坐标画笔
  ///
  Paint axisLine;

  ///横坐标点画笔
  ///
  Paint axisDot;

  ///折线画笔
  ///
  Paint linePaint;

  ///折线点画笔
  ///
  Paint lineDot;

  ///最大值点画笔
  ///
  Paint maxDot;

  ///最小值点画笔
  ///
  Paint minDot;

  ///分段数据高度集合
  ///
  Map<int, double> heights = Map();

  LineChartView({
    @required this.data,
  }) {
    axisLine = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0
      ..strokeCap = StrokeCap.square
      ..color = data.axisColor
      ..isAntiAlias = true;
    axisDot = Paint()
      ..color = data.axisColor
      ..strokeCap = StrokeCap.square
      ..style = PaintingStyle.stroke
      ..isAntiAlias = true
      ..strokeWidth = 1.8;
    linePaint = Paint()
      ..color = data.dotColor
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 1
      ..isAntiAlias = true;
    lineDot = Paint()
      ..color = data.dotColor
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..isAntiAlias = true
      ..strokeWidth = 4.0;
    maxDot = Paint()
      ..color = data.maxColor
      ..style = PaintingStyle.stroke
      ..isAntiAlias = true
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 4.0;
    minDot = Paint()
      ..color = data.minColor
      ..style = PaintingStyle.stroke
      ..isAntiAlias = true
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 4.0;
  }

  @override
  void paint(Canvas canvas, Size size) {
    ///计算画布大小
    ///
    Size chartSize = getUseSize(size);
    canvas.save();

    ///绘制坐标轴
    ///
    drawAxis(canvas, chartSize);

    ///绘制折线
    ///
    for (int i = 0; i < data.datas.length; i++) {
      drawLine(i, canvas, chartSize);
    }
    canvas.restore();
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }

  ///计算横坐标位置
  ///
  double getPixelX(
    int spotX,
    Size chartSize,
  ) {
    return ((chartSize.width - getAxisShrink() * 2) /
                (data.categories.length - 1)) *
            spotX +
        getLeftOffset() +
        getAxisShrink();
  }

  ///计算数据组指定数据的纵坐标
  ///
  double getDeltaPixelY(int index, double spotY, Size chartSize) {
    double height = 0.0;
    if (index > 0) {
      height = calcHeight(index - 1, chartSize);
    }
    double y = (chartSize.height - 2 * data.datas.length * 6) *
            (spotY - data.mins[index].values.first) /
            data.height +
        height;
    return chartSize.height - y + getTopOffset();
  }

  ///计算纵坐标
  ///
  double getPixelY(
    double spotY,
    Size chartSize,
  ) {
    double y = (spotY / data.max) * chartSize.height;
    return chartSize.height - y + getTopOffset();
  }

  ///画横坐标轴
  ///
  void drawAxis(Canvas canvas, Size chartSize) {
    ///绘制横轴
    ///
    Offset start =
        Offset(getLeftOffset(), chartSize.height + getTopOffset() + 16);
    Offset end = Offset(getLeftOffset() + chartSize.width,
        chartSize.height + getTopOffset() + 16);
    canvas.drawPoints(PointMode.polygon, [start, end], axisLine);

    ///绘制横轴坐标点
    ///
    List<Offset> axisDots = [];

    for (int i = 0; i < data.categories.length; i++) {
      double pixelX = getPixelX(i, chartSize);
      Offset start = Offset(pixelX, chartSize.height + getTopOffset() + 16);
      Offset end = Offset(pixelX, chartSize.height + getTopOffset() + 14.6);
      canvas.drawLine(start, end, axisDot);
      axisDots.add(start);
    }

    ///绘制坐标点文字
    ///
    for (int i = 0; i < data.categories.length; i++) {
      String txt = data.categories[i];
      Offset offset = axisDots[i];
      TextPainter txtPainter = TextPainter(
        text: TextSpan(text: txt, style: TextStyle(fontSize: 12)),
        textDirection: TextDirection.ltr,
        maxLines: 1,
      )..layout();
      Offset txtOffset =
          Offset(offset.dx - txtPainter.width / 2, offset.dy + 3);
      txtPainter.paint(canvas, txtOffset);
    }
  }

  ///绘制折线
  ///
  void drawLine(int index, Canvas canvas, Size chartSize) {
    ///1.绘制折线
    ///
    List<double> datas = data.datas[index];

    ///绘制前坐标处理
    List<Offset> offsets = [];
    List<Offset> comDots = [];
    Map<int, Offset> maxDots = Map();
    Map<int, Offset> minDots = Map();

    ///计算当前数据集的坐标
    ///
    for (int i = 0; i < datas.length; i++) {
      double value = datas[i];
      Offset offset = Offset(
          getPixelX(i, chartSize), getDeltaPixelY(index, value, chartSize));
      offsets.add(offset);

      ///最大值坐标
      if (data.maxs[index][i] != null) {
        maxDots[i] = offset;
      } else if (data.mins[index][i] != null) {
        ///最小值坐标
        minDots[i] = offset;
      } else {
        ///普通坐标
        comDots.add(offset);
      }
    }

    ///绘制折线
    ///
    if (data.isCurve) {
      drawCubic(canvas, offsets);
    } else {
      canvas.drawPoints(PointMode.polygon, offsets, linePaint);
    }

    ///绘制普通点
    ///
    canvas.drawPoints(PointMode.points, comDots, lineDot);

    ///绘制最大值点
    ///
    canvas.drawPoints(PointMode.points, List.of(maxDots.values), maxDot);

    ///绘制最小值点
    ///
    canvas.drawPoints(PointMode.points, List.of(minDots.values), minDot);

    ///绘制最值文字
    ///
    if (data.showExtreme) {
      ///绘制最大值
      ///
      for (int key in data.maxs[index].keys) {
        double value = data.maxs[index][key];
        Offset offset = maxDots[key];
        TextPainter painter = TextPainter(
          text: TextSpan(
              text: '$value',
              style: TextStyle(
                fontSize: 12,
                color: data.maxColor,
              )),
          textDirection: TextDirection.ltr,
          maxLines: 1,
        )..layout();
        Offset txtPos = Offset(offset.dx - painter.width / 2, offset.dy - 16);
        painter.paint(canvas, txtPos);
      }

      ///绘制最小值
      ///
      for (int key in data.mins[index].keys) {
        double value = data.mins[index][key];
        Offset offset = minDots[key];
        TextPainter painter = TextPainter(
          text: TextSpan(
              text: '$value',
              style: TextStyle(
                fontSize: 12,
                color: data.minColor,
              )),
          textDirection: TextDirection.ltr,
          maxLines: 1,
        )..layout();
        Offset txtPos = Offset(offset.dx - painter.width / 2, offset.dy + 2);
        painter.paint(canvas, txtPos);
      }
    }
  }

  ///计算数据组整体高度
  ///
  double calcHeight(int index, Size chartSize) {
    double height = heights[index];
    if (height != null) {
      return height;
    }

    ///当前数据组的最大值
    ///
    double max = data.maxs[index].values.first;

    ///当前数据组的最小值
    ///
    double min = data.mins[index].values.first;

    ///当前数据组高度偏移量
    ///
    double delta = (chartSize.height - 2 * data.datas.length * 6) *
            (max - min) /
            data.height +
        18;
    if (index == 0) {
      height = delta;
    } else {
      height = heights[index - 1] + delta;
    }
    heights[index] = height;

    ///返回高度
    return height;
  }

  ///绘制曲线
  ///
  void drawCubic(Canvas canvas, List<Offset> points) {
    Path path = new Path();
    for (int i = 0; i < points.length; i++) {
      Offset point = points[i];
      if (i == 0) {
        path.moveTo(point.dx, point.dy);
        continue;
      }
      Offset pre = points[i - 1];
      path.cubicTo(
        (pre.dx + point.dx) / 2,
        pre.dy,
        (pre.dx + point.dx) / 2,
        point.dy,
        point.dx,
        point.dy,
      );
    }
    canvas.drawPath(path, linePaint);
  }

  ///计算使用画布大小
  ///
  Size getUseSize(Size size) {
    double width = size.width - getLeftOffset() - getRightOffset();
    double height = size.height - getTopOffset() - getBottomOffset();
    return Size(width, height);
  }

  ///画布顶部留白
  ///
  double getTopOffset() => 10.0;

  ///画布底部留白
  ///
  double getBottomOffset() => 30.0;

  ///画布左边留白
  ///
  double getLeftOffset() => 8.0;

  ///画布右边留白
  ///
  double getRightOffset() => 8.0;

  ///横坐标轴坐标点起始收缩
  ///
  double getAxisShrink() => 12.0;
}

class LineData {
  ///数据分类,横坐标
  ///
  List<String> categories;

  ///数据集
  ///
  List<List<double>> datas;

  ///最小值集合
  ///
  List<Map<int, double>> mins = List();

  ///最大值集合
  ///
  List<Map<int, double>> maxs = List();

  ///所有数据集合的最大值
  ///
  double max = 0.0;

  ///所有数据集合最小值
  ///
  double min = 0.0;

  ///坐标轴颜色
  ///
  Color axisColor;

  ///坐标点的颜色
  ///
  Color dotColor;

  ///最大值点颜色
  ///
  Color maxColor;

  ///最小值点颜色
  ///
  Color minColor;

  ///是否显示最大最小值
  ///
  bool showExtreme;

  ///是否曲线
  ///
  bool isCurve;

  ///是否显示标题
  ///
  bool showTitle;

  ///数据累计高度
  ///
  double height = 0.0;

  LineData({
    @required this.categories,
    @required this.datas,
    this.axisColor: Colors.white,
    @required this.dotColor,
    @required this.maxColor,
    @required this.minColor,
    this.showExtreme: false,
    this.isCurve: true,
    this.showTitle: true,
  }) {
    ///默认赋值最小值
    ///
    this.min = datas[0][0];

    ///数据预计算
    ///
    for (int i = 0; i < datas.length; i++) {
      List<double> items = datas[i];

      ///计算最小值
      ///
      Map<int, double> minItem = _minFunction(items);
      mins.add(minItem);

      ///找出最小值
      ///
      double mmin = minItem.values.first;
      if (mmin < this.min) {
        this.min = mmin;
      }

      ///计算最大值
      ///
      Map<int, double> item = _maxFunction(items);
      maxs.add(item);

      ///获取当前最大值
      ///
      double mmax = item.values.first;

      ///找出所有数据的最大值
      ///
      if (mmax > this.max) {
        this.max = mmax;
      }

      ///计算数据累计偏移量
      ///
      this.height = this.height + (mmax - mmin);
    }
  }

  ///计算数据最小值集合
  ///
  /// @param datas数据集
  Map<int, double> _minFunction(List<double> datas) {
    int index = 0;
    double min = datas[index];
    for (int i = 0; i < datas.length; i++) {
      if (min > datas[i]) {
        min = datas[i];
        index = i;
      }
    }
    Map<int, double> mins = Map();
    mins[index] = min;
    for (int i = 0; i < datas.length; i++) {
      if (index != i && datas[i] == min) {
        mins[i] = datas[i];
      }
    }
    return mins;
  }

  ///计算数据最大值集合
  ///
  /// @params datas 数据集
  Map<int, double> _maxFunction(List<double> datas) {
    int index = 0;
    double max = datas[index];
    for (int i = 0; i < datas.length; i++) {
      if (max < datas[i]) {
        max = datas[i];
        index = i;
      }
    }
    Map<int, double> maxs = Map();
    maxs[index] = max;
    for (int i = 0; i < datas.length; i++) {
      if (index != i && datas[i] == max) {
        maxs[i] = datas[i];
      }
    }
    return maxs;
  }
}
