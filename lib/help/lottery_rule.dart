import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottery_app/commons/constants.dart';
import 'package:lottery_app/commons/custom_scroll_physics.dart';
import 'package:lottery_app/commons/mappbar.dart';
import 'package:lottery_app/components/adaptor.dart';

final Map<String, String> rules = {
  '福彩3D规则术语介绍': '本平台福彩3D主要从独胆、双胆、三胆、五码、六码、七码、'
      '杀一码、杀二码、定位三码、定位四码、定位五码指标给出预测数据。独胆、双胆、三胆：本期最有可能出现的号码；'
      '五码、六码、七码：本期组三或做六最可能出现的号码范围；杀一码、杀二码：本期最不可能出现的号码；'
      '定位三码、定位四码、定位五码：本期直选做可能出现的组合号码。',
  '排列三规则术语介绍': '本平台排列三主要从独胆、双胆、三胆、五码、六码、七码、'
      '杀一码、杀二码、定位三码、定位四码、定位五码指标给出预测数据。独胆、双胆、三胆：本期最有可能出现的号码；'
      '五码、六码、七码：本期组三或做六最可能出现的号码范围；杀一码、杀二码：本期最不可能出现的号码；'
      '定位三码、定位四码、定位五码：本期直选做可能出现的组合号码。',
  '双色球规则术语介绍': '本平台双色球主要从红球独胆、红球双胆、红球三胆、红球12码、红球20码、红球25码、'
      '红球杀三码、红球杀六码、蓝球三码、蓝球五码、蓝球杀码指标给出预测数据。红球独胆、红球双胆、红球三胆：'
      '本期红球最有可能出现的号码；红球12码、红球20码、红球25码：本期红球最可能出现的号码范围；'
      '红球杀三码、红球杀六码：本期红球最不可能出现的号码；蓝球三码、蓝球五码：本期蓝球号码最可能出现的号码。'
      '蓝球杀码：本期蓝球号码不可能出现的号码。',
  '大乐透规则术语介绍': '本平台大乐透主要从红球独胆、红球双胆、红球三胆、红球10码、红球20码、'
      '红球杀三码、红球杀六码、蓝球独胆、蓝球双胆、蓝球六码、蓝球杀码指标给出预测数据。'
      '红球独胆、红球双胆、红球三胆：本期红球最有可能出现的号码；红球10码、红球20码：本期红球最可能出现的号码范围；'
      '红球杀三码、红球杀六码：本期红球最不可能出现的号码；蓝球独胆、蓝球双胆：本期蓝球最可能出现的号码；'
      '蓝球六码：本期蓝球号码最可能出现的号码范围；蓝球杀码：本期蓝球号码不可能出现的号码。',
  '七乐彩规则术语介绍': '本平台七乐彩主要从独胆、双胆、三胆、12码、18码、22码、'
      '杀三码、杀六码指标给出预测数据。独胆、双胆、三胆：本期最有可能出现的号码；'
      '12码、18码、22码：本期号码最可能出现的号码范围；杀三码、杀六码：本期最不可能出现的号码。',
};

class LotteryRulePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: <Widget>[
            NavAppBar(
              title: '规则术语',
              fontColor: Color(0xFF59575A),
              left: Container(
                height: Adaptor.width(32),
                width: Adaptor.height(32),
                alignment: Alignment.centerLeft,
                child: Icon(
                  IconData(Constant.backIcon, fontFamily: 'iconfont'),
                  size: Adaptor.sp(16),
                  color: Color(0xFF59575A),
                ),
              ),
            ),
            _buildRulesView(),
          ],
        ),
      ),
    );
  }

  Widget _buildRulesView() {
    return Expanded(
      child: SingleChildScrollView(
        physics: EasyRefreshPhysics(topBouncing: false),
        child: Column(
          children: rules.entries.map((v) {
            return Container(
              padding: EdgeInsets.only(
                top: Adaptor.width(16),
                bottom: Adaptor.width(16),
                left: Adaptor.width(16),
                right: Adaptor.width(16),
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(
                  bottom: BorderSide(
                    color: Colors.grey.withOpacity(0.3),
                    width: Adaptor.width(0.3),
                  ),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(bottom: Adaptor.width(4)),
                    child: Text(
                      '${v.key}',
                      style: TextStyle(
                        fontSize: Adaptor.sp(14),
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  Text(
                    '${v.value}',
                    style: TextStyle(
                      height: 1.5,
                      fontSize: Adaptor.sp(13),
                      color: Colors.black38,
                    ),
                  )
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
