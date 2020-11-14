import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottery_app/commons/constants.dart';
import 'package:lottery_app/commons/custom_scroll_physics.dart';
import 'package:lottery_app/commons/mappbar.dart';
import 'package:lottery_app/components/adaptor.dart';

///
final String remark = '欢迎您成为本平台预测专家！在签约成为本平台预测专家之前，'
    '我们郑重提醒您，请您认真阅读以下条款：';

final List<String> protocols = [
  '本平台近提供福彩3D、排列三、双色球、大乐透以及七乐彩五种常规数字彩的服务。'
      '所以您的预测能力仅限于这五种彩票，请确认您的专长方向。',
  '本平台对于每一种彩票设置有不同的评判指标项，请您严格按照系统提示流程进行预测数据号码选择、最终完成数据发布',
  '由于彩票中心规定每一种彩票都有自己的截止售卖时间，本平台会在开奖日当天19:30~22:30之间关闭发布预测通道，'
      '请您安排好自己的时间发布预测数据。',
  '为了确保彩民的权益，本平台对预测专家有严格的评判标准：系统根据专家历史预测记录，由近及远综合近7天、近15天、近30天'
      '来加权对用户进行评判。所以预测专家要坚持发布预测，才能够获得更高的排名权重、也才能够获得更好的曝光位置。',
  '本平台会对各个彩种的预测专家进行综合排名和各单项指标排名，然后综合各方面权重将优秀的专家臻选出来成为收费专家。'
      '彩民每查看一期收费专家预测数据需付费约2元，预测专家将获得60%的收益（此政策视情况而定，后续会有一定调整）。',
  '专家提现时系统会将提现的收益打入到专家签约时设置的支付宝账号。专家提现流程如下：专家向平台提交提现申请、'
      '经平台审核通过后、系统将自动打款到专家设置的支付宝账户。注意：专家提现时专家在平台的账户中金额不得低于15元人民币。',
  '本平台是彩民与预测专家的聚集地，请严格按照法律法规文明上网，共建一个和谐文明的网络环境。',
];

///
/// [ExpertProtocolPage]:预测专家协议
///
class ExpertProtocolPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: <Widget>[
            NavAppBar(
              title: '专家须知',
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
            _buildProtocol(),
          ],
        ),
      ),
    );
  }

  Widget _buildProtocol() {
    return Expanded(
      child: SingleChildScrollView(
        physics: EasyRefreshPhysics(topBouncing: false),
        child: Padding(
          padding: EdgeInsets.only(bottom: Adaptor.width(16)),
          child: Column(
            children: <Widget>[]
              ..add(
                Container(
                  padding: EdgeInsets.only(
                    top: Adaptor.width(16),
                    left: Adaptor.width(16),
                    right: Adaptor.width(16),
                  ),
                  child: Text(
                    '    $remark',
                    style: TextStyle(
                      height: 1.5,
                      fontSize: Adaptor.sp(15),
                      color: Colors.black87,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              )
              ..addAll(protocols.map((v) {
                return Container(
                  padding: EdgeInsets.only(
                    left: Adaptor.width(16),
                    right: Adaptor.width(16),
                  ),
                  child: Text(
                    '    $v',
                    style: TextStyle(
                      height: 1.5,
                      fontSize: Adaptor.sp(15),
                      color: Colors.black87,
                    ),
                  ),
                );
              })),
          ),
        ),
      ),
    );
  }
}
