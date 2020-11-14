import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:lottery_app/commons/app_navigator.dart';
import 'package:lottery_app/commons/constants.dart';
import 'package:lottery_app/commons/custom_scroll_physics.dart';
import 'package:lottery_app/commons/mappbar.dart';
import 'package:lottery_app/components/custom_scroll_behavior.dart';
import 'package:lottery_app/components/error_widget.dart';
import 'package:lottery_app/components/loading_widget.dart';
import 'package:lottery_app/model/user_share.dart';
import 'package:lottery_app/share/share_list.dart';
import 'package:lottery_app/share/share_poster.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:lottery_app/components/adaptor.dart';

class UserSharePage extends StatefulWidget {
  @override
  UserSharePageState createState() => new UserSharePageState();
}

class UserSharePageState extends State<UserSharePage> {
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: ChangeNotifierProvider<UserShareModel>(
        create: (_) => UserShareModel.initialize(),
        child: Scaffold(
          body: Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage(
                  'assets/images/share_bg.png',
                ),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                NavAppBar(
                  title: '邀请好友',
                  color: Colors.white.withOpacity(0),
                  left: Container(
                    height: Adaptor.height(32),
                    width: Adaptor.width(32),
                    alignment: Alignment.centerLeft,
                    child: Icon(
                      IconData(Constant.backIcon, fontFamily: 'iconfont'),
                      size: Adaptor.sp(16),
                      color: Colors.white,
                    ),
                  ),
                  right: GestureDetector(
                    onTap: () {
                      showModalBottomSheet(
                          context: context,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(Adaptor.width(6.0)),
                              topRight: Radius.circular(Adaptor.width(6.0)),
                            ),
                          ),
                          builder: (BuildContext bc) {
                            return ShareListPage();
                          });
                    },
                    child: Container(
                      height: Adaptor.height(24),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Text(
                            '邀请历史',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: Adaptor.sp(13),
                            ),
                          ),
                          Icon(
                            IconData(0xe638, fontFamily: 'iconfont'),
                            size: Adaptor.sp(16),
                            color: Colors.white,
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                Consumer<UserShareModel>(builder:
                    (BuildContext context, UserShareModel model, Widget child) {
                  return _buildShareContainer(model);
                })
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildShareContainer(UserShareModel model) {
    if (model.loaded) {
      if (model.error) {
        return Flexible(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ErrorView(
                message: '出错啦，点击重试',
                callback: () {
                  model.loadShareInfo();
                },
              ),
            ],
          ),
        );
      }
      return Expanded(
        child: ScrollConfiguration(
          behavior: CustomScrollBehavior(),
          child: ListView(
            physics: EasyRefreshPhysics(topBouncing: false),
            children: <Widget>[
              _buildShareInfo(model),
              _buildShareRule(model),
            ],
          ),
        ),
      );
    }
    return Flexible(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Loading(
            radiusL: 4,
            radiusR: 4,
            maxRadius: 5,
            minRadius: 2.5,
            colorL: Colors.white,
            colorR: Colors.lightGreenAccent,
            gap: 8,
          ),
        ],
      ),
    );
  }

  Widget _buildShareInfo(UserShareModel model) {
    return Container(
      height: Adaptor.height(78),
      margin: EdgeInsets.all(Adaptor.width(16)),
      padding: EdgeInsets.symmetric(horizontal: Adaptor.width(36)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(Adaptor.width(6)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              RichText(
                textDirection: TextDirection.ltr,
                text: TextSpan(
                  style: TextStyle(
                    textBaseline: TextBaseline.ideographic,
                  ),
                  children: [
                    TextSpan(
                      text: '${model.share.invites ?? 0}',
                      style: TextStyle(
                        fontSize: Adaptor.sp(20),
                        color: Color(0xFFFF2933).withOpacity(0.90),
                      ),
                    ),
                    TextSpan(
                      text: '人',
                      style: TextStyle(
                        fontSize: Adaptor.sp(14),
                        height: 1.5,
                        color: Color(0xFFFF2933).withOpacity(0.90),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                alignment: Alignment.center,
                margin: EdgeInsets.only(top: Adaptor.width(4)),
                padding: EdgeInsets.only(
                  left: Adaptor.width(8),
                  right: Adaptor.width(8),
                  top: Adaptor.width(2),
                  bottom: Adaptor.width(3),
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [
                    Color(0xFFFF25BA).withOpacity(0.80),
                    Color(0xFFFF2933).withOpacity(0.90),
                  ]),
                  borderRadius: BorderRadius.circular(Adaptor.width(12)),
                ),
                child: Text(
                  '我的邀请',
                  style: TextStyle(
                    fontSize: Adaptor.sp(12),
                    color: Colors.white,
                  ),
                ),
              )
            ],
          ),
          Constant.verticleLine(
            width: Adaptor.width(0.4),
            height: Adaptor.height(32),
            color: Colors.grey.withOpacity(0.5),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              RichText(
                textDirection: TextDirection.ltr,
                text: TextSpan(
                  style: TextStyle(
                    textBaseline: TextBaseline.ideographic,
                  ),
                  children: [
                    TextSpan(
                      text: '${model.share.vouchers ?? 0}',
                      style: TextStyle(
                        fontSize: Adaptor.sp(20),
                        color: Color(0xFFFF2933).withOpacity(0.90),
                      ),
                    ),
                    TextSpan(
                      text: '元',
                      style: TextStyle(
                        fontSize: Adaptor.sp(14),
                        height: 1.5,
                        color: Color(0xFFFF2933).withOpacity(0.90),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                alignment: Alignment.center,
                margin: EdgeInsets.only(top: Adaptor.width(4)),
                padding: EdgeInsets.only(
                  left: Adaptor.width(8),
                  right: Adaptor.width(8),
                  top: Adaptor.width(2),
                  bottom: Adaptor.width(3),
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [
                    Color(0xFFFF25BA).withOpacity(0.80),
                    Color(0xFFFF2933).withOpacity(0.90),
                  ]),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '累计奖励',
                  style: TextStyle(
                    fontSize: Adaptor.sp(12),
                    color: Colors.white,
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildShareRule(UserShareModel model) {
    return Container(
      width: double.infinity,
      padding:
          EdgeInsets.only(top: Adaptor.width(16), bottom: Adaptor.width(98)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(Adaptor.width(6)),
          topRight: Radius.circular(Adaptor.width(6)),
        ),
      ),
      child: Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(
              left: Adaptor.width(16),
              right: Adaptor.width(16),
            ),
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(bottom: Adaptor.width(6)),
                  child: Text(
                    '邀请二维码',
                    style: TextStyle(
                      color: Color(0xFFFF2933).withOpacity(0.90),
                      fontSize: Adaptor.sp(16),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    AppNavigator.push(
                      context,
                      SharePosterPage(
                        qrUri: model.share.inviteUri,
                        code: model.share.code,
                      ),
                    );
                  },
                  child: QrImage(
                    data: '${model.share.inviteUri}',
                    size: Adaptor.width(160),
                    padding: EdgeInsets.all(Adaptor.width(6)),
                  ),
                ),
                Text(
                  '点击设置海报',
                  style: TextStyle(
                    color: Colors.black26,
                    fontSize: Adaptor.sp(12),
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(
                left: Adaptor.width(16),
                right: Adaptor.width(16),
                top: Adaptor.width(16)),
            padding: EdgeInsets.all(Adaptor.width(16)),
            decoration: BoxDecoration(
              color: Color(0xFFFFF7F5),
              borderRadius: BorderRadius.circular(Adaptor.width(6)),
            ),
            child: Column(
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(bottom: Adaptor.width(4)),
                      child: Text(
                        '邀请流程',
                        style: TextStyle(
                          color: Color(0xFFFF2933).withOpacity(0.90),
                          fontSize: Adaptor.sp(16),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Column(
                          children: <Widget>[
                            Image.asset(
                              'assets/images/share_scan.png',
                              width: Adaptor.width(78),
                              height: Adaptor.width(78),
                            ),
                            Text(
                              '1.邀请扫码',
                              style: TextStyle(
                                color: Colors.black54,
                              ),
                            )
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.only(right: Adaptor.width(16)),
                          child: Column(
                            children: <Widget>[
                              Image.asset(
                                'assets/images/share_register.png',
                                width: Adaptor.width(78),
                                height: Adaptor.width(78),
                              ),
                              Text(
                                '2.下载注册',
                                style: TextStyle(
                                  color: Colors.black54,
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(
                        bottom: Adaptor.width(6),
                        top: Adaptor.width(12),
                      ),
                      child: Text(
                        '邀请说明',
                        style: TextStyle(
                          color: Color(0xFFFF2933).withOpacity(0.90),
                          fontSize: Adaptor.sp(16),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        bottom: Adaptor.width(6),
                      ),
                      child: RichText(
                        textDirection: TextDirection.ltr,
                        text: TextSpan(
                          style: TextStyle(
                            fontSize: Adaptor.sp(14),
                            color: Colors.black87,
                          ),
                          children: [
                            TextSpan(text: '1.每邀请一个有效好友，您将获得'),
                            TextSpan(
                              text: '${model.share.voucher}元',
                              style: TextStyle(
                                color: Color(0xFFFF2933),
                              ),
                            ),
                            TextSpan(text: '代金券'),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        bottom: Adaptor.width(6),
                      ),
                      child: Text(
                        '2.邀请好友获得的代金券发放至我的代金券账户中，您可以在查看专家预测数据时使用。',
                        style: TextStyle(
                          fontSize: Adaptor.sp(14),
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    Text(
                      '3.点击二维码可以进入邀请海报页面，用户可以保存海报至本地相册。',
                      style: TextStyle(
                        fontSize: Adaptor.sp(14),
                        color: Colors.black87,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
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
