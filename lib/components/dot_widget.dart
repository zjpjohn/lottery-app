import 'package:flutter/material.dart';
import 'package:lottery_app/components/adaptor.dart';

class DotWidget extends StatelessWidget {
  ///[size]:dot 尺寸
  double size;

  ///[color]:dot颜色
  Color color;

  DotWidget({
    this.size = 4,
    this.color = Colors.blueAccent,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Adaptor.width(size),
      height: Adaptor.width(size),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(Adaptor.width(size)),
      ),
      child: null,
    );
  }
}
