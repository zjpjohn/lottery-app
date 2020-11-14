import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottery_app/commons/app_navigator.dart';
import 'package:lottery_app/commons/constants.dart';
import 'package:lottery_app/commons/mappbar.dart';
import 'package:lottery_app/components/adaptor.dart';
import 'package:lottery_app/components/dot_widget.dart';
import 'package:lottery_app/help/about_account.dart';
import 'package:lottery_app/help/about_platform.dart';
import 'package:lottery_app/help/account_help.dart';
import 'package:lottery_app/help/feedback_info.dart';
import 'package:lottery_app/help/lottery_rule.dart';
import 'package:lottery_app/package/vip_help_notice.dart';
import 'package:lottery_app/predict/expert_notice.dart';
import 'package:lottery_app/predict/expert_protocol.dart';

class HelpCenterPage extends StatefulWidget {
  @override
  HelpCenterPageState createState() => new HelpCenterPageState();
}

class HelpCenterPageState extends State<HelpCenterPage> {
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: <Widget>[
            NavAppBar(
              title: '帮助中心',
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
            _buildHelpCenter(),
          ],
        ),
      ),
    );
  }

  Widget _buildHelpCenter() {
    return Expanded(
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            _buildHelpItem(name: '注册登录注意事项', page: AccountHelpPage()),
            _buildHelpItem(name: '充值账户疑问解答', page: AboutAccountPage()),
            _buildHelpItem(name: '预测专家排名公告', page: ExpertNoticePage()),
            _buildHelpItem(name: '预测专家相关事项', page: ExpertProtocolPage()),
            _buildHelpItem(name: '开通会员业务问题解答', page: VipHelpNotice()),
            _buildHelpItem(name: '玩法规则术语介绍', page: LotteryRulePage()),
            _buildHelpItem(name: '意见反馈', page: FeedbackPage()),
            _buildHelpItem(name: '关于嚞彩', page: AboutPlatformPage()),
          ],
        ),
      ),
    );
  }

  Widget _buildHelpItem({String name, Widget page}) {
    return GestureDetector(
      onTap: () {
        AppNavigator.push(context, page);
      },
      child: Container(
        margin: EdgeInsets.only(left: Adaptor.width(16)),
        padding: EdgeInsets.only(
          top: Adaptor.width(22),
          bottom: Adaptor.width(22),
        ),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Colors.grey.withOpacity(0.2),
              width: Adaptor.width(0.3),
            ),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(right: Adaptor.width(8)),
                  child: DotWidget(
                    color: Colors.blueAccent.withOpacity(0.75),
                  ),
                ),
                Text(
                  '$name',
                  style: TextStyle(
                    fontSize: Adaptor.sp(14),
                    color: Colors.black87,
                  ),
                )
              ],
            ),
            Padding(
              padding: EdgeInsets.only(right: Adaptor.width(16)),
              child: Icon(
                IconData(0xe602, fontFamily: 'iconfont'),
                color: Color(0xFFbcbcbc),
                size: Adaptor.sp(14),
              ),
            ),
          ],
        ),
      ),
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
