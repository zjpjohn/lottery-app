import 'dart:core';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_easyrefresh/delivery_header.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:lottery_app/commons/app_navigator.dart';
import 'package:lottery_app/commons/constants.dart';
import 'package:lottery_app/commons/mappbar.dart';
import 'package:lottery_app/components/error_widget.dart';
import 'package:lottery_app/model/user_expert.dart';
import 'package:lottery_app/predict/dlt_expert.dart';
import 'package:lottery_app/predict/expert_account.dart';
import 'package:lottery_app/predict/expert_notice.dart';
import 'package:lottery_app/predict/expert_password.dart';
import 'package:lottery_app/predict/expert_protocol.dart';
import 'package:lottery_app/predict/expert_withdraw.dart';
import 'package:lottery_app/predict/fc3d_expert.dart';
import 'package:lottery_app/predict/pl3_expert.dart';
import 'package:lottery_app/predict/qlc_expert.dart';
import 'package:lottery_app/predict/ssq_expert.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';
import 'package:lottery_app/components/adaptor.dart';

class UserPredictPage extends StatefulWidget {
  @override
  UserPredictPageState createState() => new UserPredictPageState();
}

class UserPredictPageState extends State<UserPredictPage> {
  ///refresh 控制器
  EasyRefreshController _controller = EasyRefreshController();

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: ChangeNotifierProvider<UserExpertModel>(
        create: (_) => UserExpertModel.initialize(),
        child: Scaffold(
          body: Column(
            children: <Widget>[
              NavAppBar(
                title: '我要预测',
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
                right: GestureDetector(
                  onTap: () {
                    AppNavigator.push(context, ExpertWithdrawPage());
                  },
                  child: Container(
                    height: Adaptor.height(24),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(right: Adaptor.width(2)),
                          child: Text(
                            '提现详情',
                            style: TextStyle(
                              color: Color(0xFF59575A),
                              fontSize: Adaptor.sp(13),
                            ),
                          ),
                        ),
                        Icon(
                          IconData(0xe600, fontFamily: 'iconfont'),
                          size: Adaptor.sp(14),
                          color: Color(0xFF59575A),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              _buildExpertView(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildExpertView() {
    return Consumer<UserExpertModel>(
        builder: (BuildContext context, UserExpertModel model, Widget child) {
      if (model.loaded) {
        if (model.error) {
          return Flexible(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ErrorView(
                  color: Colors.black26,
                  message: '出错啦，点击重试',
                  callback: () {
                    model.loadExpertInfo();
                  },
                )
              ],
            ),
          );
        }
        return _buildExpertContainer(model);
      }
      return Flexible(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Constant.loading(),
          ],
        ),
      );
    });
  }

  Widget _buildExpertContainer(UserExpertModel model) {
    return Flexible(
      child: EasyRefresh(
        controller: _controller,
        header: DeliveryHeader(),
        onRefresh: () async {
          await Future.delayed(const Duration(milliseconds: 1800), () {
            model.loadExpertInfo();
          });
        },
        child: Column(
          children: <Widget>[
            _buildExpertAcct(model),
            _buildForecastView(model),
            _buildProtocolView(),
          ],
        ),
      ),
    );
  }

  Widget _buildExpertAcct(UserExpertModel model) {
    return Container(
      padding: EdgeInsets.only(
        left: Adaptor.width(32),
        right: Adaptor.width(32),
        top: Adaptor.width(20),
        bottom: Adaptor.width(20),
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(
            color: Colors.grey.withOpacity(0.10),
            width: Adaptor.width(0.4),
          ),
        ),
      ),
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(
              bottom: Adaptor.width(8),
            ),
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                AppNavigator.push(context, ExpertAccountPage());
              },
              child: Row(
                children: <Widget>[
                  Container(
                    width: Adaptor.width(44),
                    height: Adaptor.height(44),
                    margin: EdgeInsets.fromLTRB(0, 0, Adaptor.width(8), 0),
                    alignment: Alignment.center,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(23),
                      child: CachedNetworkImage(
                        width: Adaptor.width(44),
                        height: Adaptor.height(44),
                        fit: BoxFit.cover,
                        imageUrl: model.expert.image,
                        placeholder: (context, uri) => Center(
                          child: SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 1.2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.grey.withOpacity(0.1),
                              ),
                            ),
                          ),
                        ),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(bottom: Adaptor.width(6)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                '${model.expert.name}',
                                style: TextStyle(
                                  color: Colors.black87,
                                  fontSize: Adaptor.sp(16),
                                ),
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Padding(
                                    padding: EdgeInsets.only(
                                        right: Adaptor.width(2)),
                                    child: Icon(
                                      IconData(0xe643, fontFamily: 'iconfont'),
                                      size: Adaptor.sp(13),
                                      color: Colors.black54,
                                    ),
                                  ),
                                  Text(
                                    '账户编辑',
                                    style: TextStyle(
                                      color: Colors.black38,
                                      fontSize: Adaptor.sp(13),
                                      height: 1.4,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Text(
                          '入驻时间：${model.expert.createTime}',
                          style: TextStyle(
                            color: Colors.black38,
                            fontSize: Adaptor.sp(13),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(bottom: Adaptor.width(4)),
                    child: Text(
                      '金币收益',
                      style: TextStyle(
                        color: Colors.black38,
                        fontSize: Adaptor.sp(14),
                      ),
                    ),
                  ),
                  Row(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(right: Adaptor.width(3)),
                        child: Text(
                          '${model.expert.income}',
                          style: TextStyle(
                            color: Color(0xFFFF2933).withOpacity(0.75),
                            fontSize: Adaptor.sp(26),
                          ),
                        ),
                      ),
                      Text(
                        '金币',
                        style: TextStyle(
                          fontSize: Adaptor.sp(14),
                          color: Color(0xFFFF2933).withOpacity(0.75),
                          height: 1.8,
                        ),
                      )
                    ],
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(bottom: Adaptor.width(4)),
                    child: Text(
                      '现金收益',
                      style: TextStyle(
                        color: Colors.black38,
                        fontSize: Adaptor.sp(14),
                      ),
                    ),
                  ),
                  Row(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(right: Adaptor.width(3)),
                        child: Text(
                          '${model.enableMoney()}',
                          style: TextStyle(
                            color: Color(0xFFFF2933).withOpacity(0.75),
                            fontSize: Adaptor.sp(26),
                          ),
                        ),
                      ),
                      Text(
                        '元',
                        style: TextStyle(
                          fontSize: Adaptor.sp(14),
                          color: Color(0xFFFF2933).withOpacity(0.75),
                          height: 1.8,
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ],
          ),
          Container(
            margin: EdgeInsets.only(top: Adaptor.width(6)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      '汇率：${model.expert.ratio}金币=1元',
                      style: TextStyle(
                        color: Colors.black38,
                        fontSize: Adaptor.sp(11),
                      ),
                    ),
                    Text(
                      '金币收益大于${model.expert.throttle}可提现',
                      style: TextStyle(
                        color: Colors.black38,
                        fontSize: Adaptor.sp(11),
                      ),
                    )
                  ],
                ),
                GestureDetector(
                  onTap: () {
                    if (model.hasWithdraw()) {
                      showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (BuildContext context) {
                            return Material(
                              color: Colors.transparent,
                              child: Center(
                                child: Container(
                                  alignment: Alignment.center,
                                  height: Adaptor.height(160),
                                  width: Adaptor.width(280),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius:
                                        BorderRadius.circular(Adaptor.width(4)),
                                  ),
                                  child: Column(
                                    children: <Widget>[
                                      Container(
                                        alignment: Alignment.centerLeft,
                                        padding: EdgeInsets.only(
                                          left: Adaptor.width(12),
                                          top: Adaptor.width(12),
                                          bottom: Adaptor.width(12),
                                          right: Adaptor.width(12),
                                        ),
                                        margin: EdgeInsets.only(
                                            bottom: Adaptor.width(12)),
                                        decoration: BoxDecoration(
                                          border: Border(
                                            bottom: BorderSide(
                                              color: Colors.black12,
                                              width: Adaptor.width(0.4),
                                            ),
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Text(
                                              '请输入提现密码',
                                              style: TextStyle(
                                                color: Colors.black54,
                                                fontSize: Adaptor.sp(17),
                                              ),
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                AppNavigator.goBack(context);
                                              },
                                              child: Padding(
                                                padding: EdgeInsets.only(
                                                  left: Adaptor.width(16),
                                                ),
                                                child: Icon(
                                                  IconData(
                                                    0xe683,
                                                    fontFamily: 'iconfont',
                                                  ),
                                                  size: 18,
                                                  color: Color(0xFFCCCCCC),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        height: Adaptor.height(58),
                                        padding: EdgeInsets.only(
                                          left: Adaptor.width(20),
                                          right: Adaptor.width(20),
                                        ),
                                        child: PinCodeTextField(
                                          length: 6,
                                          obsecureText: true,
                                          autoFocus: true,
                                          animationType: AnimationType.none,
                                          textInputType: TextInputType.number,
                                          textStyle: TextStyle(
                                            color: Colors.black87,
                                            fontSize: Adaptor.sp(12),
                                          ),
                                          pinTheme: PinTheme(
                                            shape: PinCodeFieldShape.box,
                                            borderRadius: BorderRadius.circular(
                                              Adaptor.width(2),
                                            ),
                                            fieldHeight: Adaptor.height(32),
                                            fieldWidth: Adaptor.width(32),
                                            borderWidth: Adaptor.width(0.6),
                                            inactiveColor: Color(0xFFCCCCCC),
                                            activeFillColor: Colors.white,
                                            activeColor: Color(0xFFCCCCCC),
                                          ),
                                          onCompleted: (v) {
                                            model.withdrawAction(
                                                password: v,
                                                success: () {
                                                  EasyLoading.dismiss();
                                                  AppNavigator.replace(context,
                                                      ExpertWithdrawPage());
                                                });
                                          },
                                          onChanged: (v) {},
                                        ),
                                      ),
                                      Container(
                                        padding: EdgeInsets.only(
                                          left: Adaptor.width(16),
                                          right: Adaptor.width(16),
                                          top: Adaptor.width(8),
                                          bottom: Adaptor.width(8),
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: <Widget>[
                                            Text(''),
                                            GestureDetector(
                                              onTap: () {
                                                AppNavigator.push(context,
                                                    ExpertPasswordPage());
                                              },
                                              child: SizedBox(
                                                height: Adaptor.height(24),
                                                child: Text(
                                                  '忘记密码？',
                                                  style: TextStyle(
                                                    color: Colors.blueAccent,
                                                    fontSize: Adaptor.sp(14),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          });
                    }
                  },
                  child: Container(
                    height: Adaptor.height(28),
                    width: Adaptor.width(74),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(
                        Radius.circular(Adaptor.width(15)),
                      ),
                      border: Border.all(
                        color: model.hasWithdraw()
                            ? Color(0xFFFF2933)
                            : Colors.black38,
                        width: Adaptor.width(0.5),
                      ),
                    ),
                    child: Text(
                      '${model.hasWithdraw() ? '去提现' : '加油哟'}',
                      style: TextStyle(
                        fontSize: Adaptor.sp(13),
                        height: 0.99,
                        color: model.hasWithdraw()
                            ? Color(0xFFFF2933)
                            : Colors.black38,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  ///构建预测栏目
  ///
  ///未开通置灰显示
  Widget _buildForecastView(UserExpertModel model) {
    return Container(
      margin: EdgeInsets.only(
        top: Adaptor.width(12),
        bottom: Adaptor.width(12),
      ),
      decoration: BoxDecoration(color: Colors.white),
      child: Column(
        children: <Widget>[
          _buildForecastItem(
              icon: 'assets/images/fc3d.png',
              title: '福彩3D预测',
              subTitle: '发布福彩3D预测，赚取金币',
              enable: model.expert.fc3dEnable,
              border: 1,
              callback: () {
                model.expert.fc3dEnable == 1
                    ? AppNavigator.push(context, ExpertFc3dPage(), login: true)
                    : model.enableExpertItem(
                        params: Map()..['fc3d'] = 1,
                        success: () {
                          model.fc3dEnable = 1;
                        },
                      );
              }),
          _buildForecastItem(
              icon: 'assets/images/pl3.png',
              title: '排列三预测',
              subTitle: '发布排列三预测，赚取金币',
              enable: model.expert.pl3Enable,
              border: 1,
              callback: () {
                model.expert.pl3Enable == 1
                    ? AppNavigator.push(context, ExpertPl3Page(), login: true)
                    : model.enableExpertItem(
                        params: Map()..['pl3'] = 1,
                        success: () {
                          model.pl3Enable = 1;
                        },
                      );
              }),
          _buildForecastItem(
              icon: 'assets/images/ssq.png',
              title: '双色球预测',
              subTitle: '发布双色球预测，赚取金币',
              enable: model.expert.ssqEnable,
              border: 1,
              callback: () {
                model.expert.ssqEnable == 1
                    ? AppNavigator.push(context, ExpertSsqPage(), login: true)
                    : model.enableExpertItem(
                        params: Map()..['ssq'] = 1,
                        success: () {
                          model.ssqEnable = 1;
                        },
                      );
              }),
          _buildForecastItem(
              icon: 'assets/images/dlt.png',
              title: '大乐透预测',
              subTitle: '发布大乐透预测，赚取金币',
              enable: model.expert.dltEnable,
              border: 1,
              callback: () {
                model.expert.dltEnable == 1
                    ? AppNavigator.push(context, ExpertDltPage(), login: true)
                    : model.enableExpertItem(
                        params: Map()..['dlt'] = 1,
                        success: () {
                          model.dltEnable = 1;
                        },
                      );
              }),
          _buildForecastItem(
              icon: 'assets/images/qlc.png',
              title: '七乐彩预测',
              subTitle: '发布七乐彩预测，赚取金币',
              enable: model.expert.qlcEnable,
              border: 0,
              callback: () {
                model.expert.qlcEnable == 1
                    ? AppNavigator.push(context, ExpertQlcPage(), login: true)
                    : model.enableExpertItem(
                        params: Map()..['qlc'] = 1,
                        success: () {
                          model.expert.qlcEnable = 1;
                        },
                      );
              }),
        ],
      ),
    );
  }

  Widget _buildForecastItem({
    String icon,
    String title,
    String subTitle,
    int enable,
    int border,
    Function callback,
  }) {
    return Container(
      margin: EdgeInsets.only(
        left: Adaptor.width(16),
      ),
      height: Adaptor.height(58),
      decoration: BoxDecoration(
        border: border == 1
            ? Border(
                bottom: BorderSide(
                  color: Colors.black12,
                  width: Adaptor.width(0.25),
                ),
              )
            : null,
      ),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          if (callback != null) {
            callback();
          }
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Row(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(right: Adaptor.width(6)),
                  child: Image.asset(
                    icon,
                    width: Adaptor.width(32),
                    height: Adaptor.height(32),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      '${title}',
                      style: TextStyle(
                        color: Colors.black87,
                        fontSize: Adaptor.sp(15),
                      ),
                    ),
                    Text(
                      '${subTitle ?? ''}',
                      style: TextStyle(
                        color: Colors.black38,
                        fontSize: Adaptor.sp(11),
                      ),
                    )
                  ],
                ),
              ],
            ),
            Container(
              padding: EdgeInsets.only(right: Adaptor.width(16)),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    '${enable == 1 ? '发布、详情' : '点击开启'}',
                    style: TextStyle(
                      height: 1.2,
                      color: enable == 1 ? Colors.redAccent : Colors.black38,
                      fontSize: Adaptor.sp(12),
                    ),
                  ),
                  Icon(
                    IconData(0xe602, fontFamily: 'iconfont'),
                    color: Colors.black38,
                    size: Adaptor.sp(14),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProtocolView() {
    return Container(
      decoration: BoxDecoration(color: Colors.white),
      child: Column(
        children: <Widget>[
          _buildProtocolItem(
              title: '专家排名公告',
              border: 1,
              callback: () {
                AppNavigator.push(context, ExpertNoticePage());
              }),
          _buildProtocolItem(
              title: '专家协议',
              border: 0,
              callback: () {
                AppNavigator.push(context, ExpertProtocolPage());
              }),
        ],
      ),
    );
  }

  Widget _buildProtocolItem({String title, int border, Function callback}) {
    return Container(
      margin: EdgeInsets.only(
        left: Adaptor.width(16),
      ),
      height: Adaptor.height(56),
      decoration: BoxDecoration(
        border: border == 1
            ? Border(
                bottom: BorderSide(
                  color: Colors.black12,
                  width: Adaptor.width(0.25),
                ),
              )
            : null,
      ),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          if (callback != null) {
            callback();
          }
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              '${title}',
              style: TextStyle(color: Colors.black54, fontSize: Adaptor.sp(15)),
            ),
            Container(
              padding: EdgeInsets.only(right: Adaptor.width(16)),
              child: Icon(
                IconData(0xe602, fontFamily: 'iconfont'),
                color: Colors.black38,
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

  @override
  void deactivate() {}
}
