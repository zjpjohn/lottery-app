import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottery_app/commons/constants.dart';
import 'package:lottery_app/commons/custom_scroll_physics.dart';
import 'package:lottery_app/commons/mappbar.dart';
import 'package:lottery_app/components/adaptor.dart';

///
/// [notices]：问题描述
final List notices = [
  {
    'question': '用户登录方式？',
    'answer': '本平台目前仅支持两种登录方式：手机号+密码登录、手机号+验证码的方式进行登录，'
        '所以用户在注册账户时确保手机号的有效性',
  },
  {
    'question': '用户如何注册平台账户？',
    'answer': '用户在登录页面可以通过点击"没有账户？点此注册"进入注册页面，用户输入手机号、'
        '完成短信验证码校验，设置账户登录密码、完成密码校验，提交注册成功后，返回登录页面即可登录平台。',
  },
  {
    'question': '用户忘记登录密码怎么办？',
    'answer': '用户忘记登录密码可以通过手机号+短信验证码重置登录密码，'
        '用户在登录页面上可以通过"忘记密码？"进入重置密码页面，'
        '用户输入账户登录手机号、完成短信验证码校验，设置新的登录密码、'
        '密码校验成功后，提交重置密码成功后，用户即可用新密码进行登录。',
  },
  {
    'question': '用户登录支持的手机号格式？',
    'answer': '本平台用户注册、登录的手机号格式仅支持大陆常用格式的手机号。'
        '目前支持的手机格式如下:13x,145,147,149,166,17x,198,199开头的手机号。'
        '因此，用注册时请确保手机格式正确，避免造成无法注册的问题。',
  },
  {
    'question': '用户账户手机号是否支持更换？',
    'answer': '本平台将注册手机号作为用户注册、登录的唯一标识，目前不允许用户更换手机号。'
        '如有需要更换手机号，可以用新的手机号注册新账户。'
        '因此，用户在注册时应使用自己常用的手机号，确保账户后续长期使用。',
  },
];

///
/// [AccountHelpPage]账户帮助页面：相关问题
///
class AccountHelpPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: <Widget>[
            NavAppBar(
              title: '注册/登录',
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
