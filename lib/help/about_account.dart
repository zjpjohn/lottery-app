import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottery_app/commons/constants.dart';
import 'package:lottery_app/commons/custom_scroll_physics.dart';
import 'package:lottery_app/commons/mappbar.dart';
import 'package:lottery_app/components/adaptor.dart';

final List notices = [
  {
    'question': '用户账户组成要素。',
    'answer': '用户的个人账户主要有两部分组成：'
        '1.用户充值兑换的金币数量：金币主要用户查看收费专家的预测数据；'
        '2.用户通过充值、积分兑换或者邀请好友注册获取的代金券：'
        '代金券可以在查看收费专家预测数据时冲抵部分金币。',
  },
  {
    'question': '充值兑换账户金币是怎样的？',
    'answer': '用户在充值是系统根据1人民币兑换成10金币的汇率兑换成系统金币，'
        '充值成功后会系统自动将充值的金币打入用户的账户，'
        '用户可以查看金币余额或者订单记录查看当次充值信息。',
  },
  {
    'question': '账户的金币和代金券如何使用？',
    'answer': '账户金币主要用于查看收费专家预测数据，代金券能够冲抵部分金币。'
        '例如：账户有金币60金币和12代金券，查看大乐透收费专家数据需38金币且可冲抵6代金券，'
        '那么本次查看用户需消费32金币以及6代金券；账户有60金币和3个代金券，'
        '查看大乐透收费专家预测数据需38金币且可冲抵3代金券，那么本次查看用户需消费35金币且可冲抵3代金券。',
  },
  {
    'question': '账户充值后金币和赠送的代金券长时间没有到账怎么办？',
    'answer': '如果充值完成后长时间金币没有到账，可能是因为网络原因没有及时打入用户账户。'
        '如果充值后30分钟金币还没有到账，请您提交订单编号给系统客服，系统客服会手动帮助您处理。',
  },
  {
    'question': '关于账户充值支付取消问题？',
    'answer': '如果您在支付充值付款是取消，系统仍然会创建订单且订单处于待支付状态，系统会在30分钟后取消该订单。'
        '订单在付款时取消是不会对您的金钱造成任何损失，请您放心使用本系统。'
  },
  {
    'question': '为什么账户充值金币，还有成为VIP会员套餐？',
    'answer': '充值获得的金币仅限于查看收费专家的个人预测数据。'
        'VIP会员套餐适用于系统根据专家预测数据给出的多维度综合分析分析查看，'
        '以及无限查看对应彩种收费专家的预测数据。您在充值和购买VIP会员套餐时，请谨慎考虑。',
  },
];

class AboutAccountPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: <Widget>[
            NavAppBar(
              title: '关于账户',
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
