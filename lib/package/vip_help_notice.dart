import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottery_app/commons/constants.dart';
import 'package:lottery_app/commons/custom_scroll_physics.dart';
import 'package:lottery_app/commons/mappbar.dart';
import 'package:lottery_app/components/adaptor.dart';

final List notices = [
  {
    'question': '开通VIP后有何特权？',
    'answer': '开通相应彩种的VIP会员您将获得：'
        '无限查看相应彩种收费专家预测数据、'
        '查看各指标评判最好的专家预测数据对比特权、'
        '查看VIP收费专家各指标综合统计分析特权、'
        '查看最热门专家预测数据统计信息特权、'
        '查看高命中率专家预测数据统计信息特权、'
        '查看全部专家预测数据整体态势特权。',
  },
  {
    'question': 'VIP会员订购须知',
    'answer': 'VIP会员订购分彩种，分别提供五种彩票类型VIP会员套餐，'
        '您可以分别订购不同彩种的VIP会员套餐。'
        'VIP会员套餐定价解释权归系统平台所有，'
        '系统会根据具体情况适时作出调整。',
  },
  {
    'question': '开通了VIP会员如何使用？',
    'answer': '开通对应彩种的VIP会员，您可以在首页各个彩种栏目下畅通无阻地'
        '查看对应特权给您提供的各种分析统计数据，'
        '无限查看相应彩种收费专家的预测数据，而不用充值金币。',
  },
  {
    'question': '开通VIP时效有多久？',
    'answer': '开通各个彩种VIP会员从开通之日起持续时长30天，30天之后VIP会员特权将自动消失。'
        '您可以选择续约VIP会员，系统自动延长VIP会员的有效时间。',
  },
  {
    'question': '开通VIP会员后，是否查看收费专家预测数据还需要金币充值？',
    'answer': '开通相应彩种的VIP会员套餐后，您将不再需要进行金币充值。'
        '因为，VIP会员既可以无限查看对应彩种收费专家的预测数据，又可以查看系统平台针对预测数据给出的多维度综合分析。',
  },
];

class VipHelpNotice extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: <Widget>[
            NavAppBar(
              title: '业务说明',
              fontColor: Color(0xFF59575A),
              left: Container(
                height: Adaptor.height(32),
                width: Adaptor.width(32),
                alignment: Alignment.centerLeft,
                child: Icon(
                  IconData(Constant.backIcon, fontFamily: 'iconfont'),
                  size: Adaptor.sp(16),
                  color: Color(0xFF59575A),
                ),
              ),
            ),
            _buildNoticeView(),
          ],
        ),
      ),
    );
  }

  Widget _buildNoticeView() {
    return Expanded(
      child: SingleChildScrollView(
        physics: EasyRefreshPhysics(topBouncing: false),
        child: Column(
          children: notices.map((v) {
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
                      '${v['question']}',
                      style: TextStyle(
                        fontSize: Adaptor.sp(14),
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  Text(
                    '${v['answer']}',
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
