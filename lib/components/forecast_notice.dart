import 'package:flutter/material.dart';
import 'package:lottery_app/components/adaptor.dart';

class ForecastNotice extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: Adaptor.width(16),
        right: Adaptor.width(16),
        top: Adaptor.width(8),
      ),
      child: Text(
        '声明：预测方案仅为专家个人观点，结果仅供参考。'
        '我们不提供彩票销售，购彩投注请您前往线下彩票站。',
        style: TextStyle(
          color: Colors.black26,
          fontSize: Adaptor.sp(12),
        ),
      ),
    );
  }
}
