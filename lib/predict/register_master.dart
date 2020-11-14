import 'dart:core';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:lottery_app/commons/app_navigator.dart';
import 'package:lottery_app/commons/constants.dart';
import 'package:lottery_app/commons/custom_scroll_physics.dart';
import 'package:lottery_app/commons/mappbar.dart';
import 'package:lottery_app/commons/tools.dart';
import 'package:lottery_app/components/custom_scroll_behavior.dart';
import 'package:lottery_app/components/error_widget.dart';
import 'package:lottery_app/model/auth.dart';
import 'package:lottery_app/model/register_master.dart';
import 'package:lottery_app/predict/expert_protocol.dart';
import 'package:lottery_app/predict/user-predict.dart';
import 'package:provider/provider.dart';
import 'package:lottery_app/components/adaptor.dart';

class RegisterMasterPage extends StatefulWidget {
  @override
  RegisterMasterPageState createState() => new RegisterMasterPageState();
}

class RegisterMasterPageState extends State<RegisterMasterPage> {
  GlobalKey<FormState> _registerKey = new GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: ChangeNotifierProvider(
        create: (_) => RegisterMasterModel.initialize(),
        child: Scaffold(
          body: Container(
            child: Column(
              children: <Widget>[
                NavAppBar(
                  title: '专家签约',
                  fontColor: Color(0xFF59575A),
                  color: Color(0xFFF9F9F9),
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
                _buildRegisterView(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRegisterView() {
    return Consumer2<RegisterMasterModel, AuthModel>(
      builder: (BuildContext context, RegisterMasterModel model, AuthModel auth,
          Widget child) {
        if (model.loaded) {
          if (model.error) {
            return Flexible(
              child: Column(
                children: <Widget>[
                  ErrorView(
                      color: Colors.black26,
                      message: '出错啦，点击重试',
                      callback: () {
                        model.loadAvatars();
                      }),
                ],
              ),
            );
          }
          //签约表单
          return _buildFormView(model, auth);
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
      },
    );
  }

  Widget _buildFormView(RegisterMasterModel model, AuthModel auth) {
    return Flexible(
      child: Stack(
        children: <Widget>[
          ScrollConfiguration(
            behavior: CustomScrollBehavior(),
            child: SingleChildScrollView(
              physics: EasyRefreshPhysics(topBouncing: false),
              child: Container(
                padding: EdgeInsets.only(
                  top: Adaptor.width(16),
                  bottom: Adaptor.width(130),
                ),
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    FocusScope.of(context).requestFocus(FocusNode());
                  },
                  child: Form(
                    key: _registerKey,
                    autovalidate: false,
                    child: Column(
                      children: <Widget>[
                        GestureDetector(
                          onTap: () {
                            showModalBottomSheet(
                                context: context,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                    topLeft:
                                        Radius.circular(Adaptor.width(6.0)),
                                    topRight:
                                        Radius.circular(Adaptor.width(6.0)),
                                  ),
                                ),
                                builder: (BuildContext context) {
                                  return Material(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.only(
                                      topLeft:
                                          Radius.circular(Adaptor.width(6.0)),
                                      topRight:
                                          Radius.circular(Adaptor.width(6.0)),
                                    ),
                                    child: SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              5.2 /
                                              16.0,
                                      child: Container(
                                        alignment: Alignment.center,
                                        child: Wrap(
                                          spacing: Adaptor.width(16),
                                          runSpacing: Adaptor.width(24),
                                          alignment: WrapAlignment.center,
                                          crossAxisAlignment:
                                              WrapCrossAlignment.center,
                                          children: <Widget>[]..addAll(
                                              model.images.map((v) {
                                                return GestureDetector(
                                                  onTap: () {
                                                    model.image = v;
                                                  },
                                                  child: SizedBox(
                                                    width: Adaptor.width(64),
                                                    height: Adaptor.height(64),
                                                    child: Stack(
                                                      children: <Widget>[
                                                        CachedNetworkImage(
                                                          width:
                                                              Adaptor.width(64),
                                                          height:
                                                              Adaptor.height(
                                                                  64),
                                                          fit: BoxFit.cover,
                                                          imageUrl: '${v}',
                                                          placeholder:
                                                              (context, uri) =>
                                                                  Center(
                                                            child: SizedBox(
                                                              width: 18,
                                                              height: 18,
                                                              child:
                                                                  CircularProgressIndicator(
                                                                strokeWidth:
                                                                    1.2,
                                                                valueColor:
                                                                    AlwaysStoppedAnimation<
                                                                        Color>(
                                                                  Colors.grey
                                                                      .withOpacity(
                                                                          0.1),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          errorWidget: (context,
                                                                  url, error) =>
                                                              Icon(Icons.error),
                                                        ),
                                                        Container(
                                                          width:
                                                              Adaptor.width(64),
                                                          height:
                                                              Adaptor.height(
                                                                  64),
                                                          decoration:
                                                              BoxDecoration(
                                                            color: v ==
                                                                    model.image
                                                                ? Colors.white
                                                                    .withOpacity(
                                                                        0.6)
                                                                : Colors.white
                                                                    .withOpacity(
                                                                        0),
                                                          ),
                                                          child:
                                                              v == model.image
                                                                  ? Icon(
                                                                      IconData(
                                                                        0xe636,
                                                                        fontFamily:
                                                                            'iconfont',
                                                                      ),
                                                                      size: Adaptor
                                                                          .sp(16),
                                                                      color: Colors
                                                                          .white
                                                                          .withOpacity(
                                                                              1),
                                                                    )
                                                                  : null,
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                );
                                              }),
                                            ),
                                        ),
                                      ),
                                    ),
                                  );
                                });
                          },
                          child: Column(
                            children: <Widget>[
                              Container(
                                width: Adaptor.width(64),
                                height: Adaptor.height(64),
                                margin:
                                    EdgeInsets.only(bottom: Adaptor.width(2)),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                    image: model.image == null
                                        ? AssetImage(
                                            'assets/images/default_avatar.png')
                                        : NetworkImage('${model.image}'),
                                  ),
                                ),
                              ),
                              Text(
                                '点击设置',
                                style: TextStyle(
                                  color: Colors.orangeAccent,
                                  fontSize: Adaptor.sp(14),
                                ),
                              )
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: Adaptor.width(16)),
                          padding: EdgeInsets.only(
                            left: Adaptor.width(24),
                            right: Adaptor.width(24),
                          ),
                          child: Column(
                            children: <Widget>[
                              Container(
                                child: Row(
                                  children: <Widget>[
                                    Text(
                                      '专家名称',
                                      style: TextStyle(
                                        color: Colors.black87,
                                        fontSize: Adaptor.sp(15),
                                      ),
                                    ),
                                    Text(
                                      '（给自己取一个幸运的名字）',
                                      style: TextStyle(
                                        color: Colors.black26,
                                        fontSize: Adaptor.sp(13),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              TextFormField(
                                cursorWidth: Adaptor.width(1.2),
                                keyboardType: TextInputType.text,
                                onSaved: (value) {
                                  model.name = value;
                                },
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return '专家名称为空';
                                  }
                                  if (value.length > 10) {
                                    return '专家名称长度小于10';
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                  hintText: '请输入专家名称',
                                  helperText: '',
                                  focusedErrorBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.red,
                                      width: Adaptor.width(0.6),
                                    ),
                                  ),
                                  errorBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.red,
                                      width: Adaptor.width(0.6),
                                    ),
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.blueAccent,
                                      width: Adaptor.width(0.6),
                                    ),
                                  ),
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.black87,
                                      width: Adaptor.width(0.6),
                                    ),
                                  ),
                                  errorStyle:
                                      TextStyle(fontSize: Adaptor.sp(12)),
                                  hintStyle: TextStyle(
                                    color: Colors.black26,
                                    fontSize: Adaptor.sp(14),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: Adaptor.width(16)),
                          padding: EdgeInsets.only(
                            left: Adaptor.width(24),
                            right: Adaptor.width(24),
                          ),
                          child: Column(
                            children: <Widget>[
                              Container(
                                child: Row(
                                  children: <Widget>[
                                    Text(
                                      '提现密码',
                                      style: TextStyle(
                                        color: Colors.black87,
                                        fontSize: Adaptor.sp(15),
                                      ),
                                    ),
                                    Text(
                                      '（提现密码为六位纯数字）',
                                      style: TextStyle(
                                        color: Colors.black26,
                                        fontSize: Adaptor.sp(13),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              TextFormField(
                                keyboardType: TextInputType.number,
                                obscureText: !model.showPwd,
                                cursorWidth: Adaptor.width(1.2),
                                onSaved: (value) {
                                  model.password = value;
                                },
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return '提现密码为空';
                                  }
                                  if (!Tools.number(value)) {
                                    return '提现密码为纯数字';
                                  }
                                  if (value.length != 6) {
                                    return '提现密码长度为6';
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                  hintText: "请输入提现密码",
                                  helperText: '',
                                  errorStyle:
                                      TextStyle(fontSize: Adaptor.sp(12)),
                                  hintStyle: TextStyle(
                                    color: Colors.black26,
                                    fontSize: Adaptor.sp(14),
                                  ),
                                  focusedErrorBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.red,
                                      width: Adaptor.width(0.6),
                                    ),
                                  ),
                                  errorBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.red,
                                      width: Adaptor.width(0.6),
                                    ),
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.blueAccent,
                                      width: Adaptor.width(0.6),
                                    ),
                                  ),
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.black87,
                                      width: Adaptor.width(0.6),
                                    ),
                                  ),
                                  suffixIcon: new IconButton(
                                      icon: Icon(
                                        model.showPwd
                                            ? Icons.visibility
                                            : Icons.visibility_off,
                                        color:
                                            Color.fromARGB(255, 126, 126, 126),
                                        size: Adaptor.sp(20),
                                      ),
                                      onPressed: () {
                                        model.showPwd = !model.showPwd;
                                      }),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: Adaptor.width(16)),
                          padding: EdgeInsets.only(
                            left: Adaptor.width(24),
                            right: Adaptor.width(24),
                          ),
                          child: Column(
                            children: <Widget>[
                              Container(
                                child: Row(
                                  children: <Widget>[
                                    Text(
                                      '确认密码',
                                      style: TextStyle(
                                        color: Colors.black87,
                                        fontSize: Adaptor.sp(15),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              TextFormField(
                                keyboardType: TextInputType.number,
                                obscureText: true,
                                cursorWidth: Adaptor.width(1.2),
                                onSaved: (value) {
                                  model.confirm = value;
                                },
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return '确认密码为空';
                                  }
                                  if (!Tools.number(value)) {
                                    return '确认密码为纯数字';
                                  }
                                  if (value.length != 6) {
                                    return '确认密码长度为6';
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                  hintText: "请输入确认密码",
                                  helperText: '',
                                  helperStyle:
                                      TextStyle(fontSize: Adaptor.sp(12)),
                                  errorStyle:
                                      TextStyle(fontSize: Adaptor.sp(12)),
                                  hintStyle: TextStyle(
                                    color: Colors.black26,
                                    fontSize: Adaptor.sp(14),
                                  ),
                                  focusedErrorBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.red,
                                      width: Adaptor.width(0.6),
                                    ),
                                  ),
                                  errorBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.red,
                                      width: Adaptor.width(0.6),
                                    ),
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.blueAccent,
                                      width: Adaptor.width(0.6),
                                    ),
                                  ),
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.black87,
                                      width: Adaptor.width(0.6),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: Adaptor.width(16)),
                          padding: EdgeInsets.only(
                            left: Adaptor.width(24),
                            right: Adaptor.width(24),
                          ),
                          child: Column(
                            children: <Widget>[
                              Container(
                                child: Row(
                                  children: <Widget>[
                                    Text(
                                      '支付宝账号',
                                      style: TextStyle(
                                        color: Colors.black87,
                                        fontSize: Adaptor.sp(15),
                                      ),
                                    ),
                                    Text(
                                      '（请务必确保支付宝账号正确）',
                                      style: TextStyle(
                                        color: Colors.black26,
                                        fontSize: Adaptor.sp(13),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              TextFormField(
                                cursorWidth: Adaptor.width(1.2),
                                keyboardType: TextInputType.text,
                                onSaved: (value) {
                                  model.aliAccount = value;
                                },
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return '支付宝账号为空';
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                  hintText: '请输入提现支付宝账号',
                                  helperText: '',
                                  hasFloatingPlaceholder: false,
                                  focusedErrorBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.red,
                                      width: Adaptor.width(0.6),
                                    ),
                                  ),
                                  errorBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.red,
                                      width: Adaptor.width(0.6),
                                    ),
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.blueAccent,
                                      width: Adaptor.width(0.6),
                                    ),
                                  ),
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.black87,
                                      width: Adaptor.width(0.6),
                                    ),
                                  ),
                                  errorStyle:
                                      TextStyle(fontSize: Adaptor.sp(12)),
                                  hintStyle: TextStyle(
                                    color: Colors.black26,
                                    fontSize: Adaptor.sp(14),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: Adaptor.width(16)),
                          padding: EdgeInsets.only(
                            left: Adaptor.width(24),
                            right: Adaptor.width(24),
                          ),
                          child: Column(
                            children: <Widget>[
                              Container(
                                child: Row(
                                  children: <Widget>[
                                    Text(
                                      '真实姓名',
                                      style: TextStyle(
                                        color: Colors.black87,
                                        fontSize: Adaptor.sp(15),
                                      ),
                                    ),
                                    Text(
                                      '（请务必确保真实姓名正确）',
                                      style: TextStyle(
                                        color: Colors.black26,
                                        fontSize: Adaptor.sp(13),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              TextFormField(
                                cursorWidth: Adaptor.width(1.2),
                                keyboardType: TextInputType.text,
                                onSaved: (value) {
                                  model.aliName = value;
                                },
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return '支付宝真实姓名为空';
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                  hintText: '请输入支付宝账号一致的真实姓名',
                                  helperText: '',
                                  focusedErrorBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.red,
                                      width: Adaptor.width(0.6),
                                    ),
                                  ),
                                  errorBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.red,
                                      width: Adaptor.width(0.6),
                                    ),
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.blueAccent,
                                      width: Adaptor.width(0.6),
                                    ),
                                  ),
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.black87,
                                      width: Adaptor.width(0.6),
                                    ),
                                  ),
                                  errorStyle:
                                      TextStyle(fontSize: Adaptor.sp(12)),
                                  hintStyle: TextStyle(
                                    color: Colors.black26,
                                    fontSize: Adaptor.sp(14),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          height: Adaptor.height(42),
                          alignment: Alignment.centerLeft,
                          margin: EdgeInsets.only(top: Adaptor.width(16)),
                          padding: EdgeInsets.only(left: Adaptor.width(24)),
                          decoration: BoxDecoration(
                            color: Colors.grey.withOpacity(0.06),
                          ),
                          child: Text(
                            '签约频道',
                            style: TextStyle(
                              color: Colors.black87,
                              fontSize: Adaptor.sp(16),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(
                            left: Adaptor.width(24),
                            right: Adaptor.width(24),
                          ),
                          child: GestureDetector(
                            onTap: () {
                              model.fc3d = (model.fc3d == 0 ? 1 : 0);
                            },
                            child: Container(
                              height: Adaptor.height(58),
                              alignment: Alignment.centerLeft,
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    color: model.fc3d == 0
                                        ? Colors.black87
                                        : Colors.blueAccent,
                                    width: Adaptor.width(0.6),
                                  ),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Container(
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: <Widget>[
                                        Text(
                                          '福彩3D频道',
                                          style: TextStyle(
                                            fontSize: Adaptor.sp(14),
                                            color: Colors.black87,
                                          ),
                                        ),
                                        Text(
                                          '点击开启预测',
                                          style: TextStyle(
                                            color: Colors.black26,
                                            fontSize: Adaptor.sp(12),
                                            height: 1.2,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        right: Adaptor.width(8)),
                                    child: Icon(
                                      IconData(
                                          model.fc3d == 1 ? 0xe60a : 0xe631,
                                          fontFamily: 'iconfont'),
                                      size: Adaptor.sp(18),
                                      color: model.fc3d == 1
                                          ? Colors.blueAccent
                                          : Colors.black12,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(
                            left: Adaptor.width(24),
                            right: Adaptor.width(24),
                          ),
                          child: GestureDetector(
                            onTap: () {
                              model.pl3 = (model.pl3 == 0 ? 1 : 0);
                            },
                            child: Container(
                                height: Adaptor.height(58),
                                alignment: Alignment.centerLeft,
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                      color: model.pl3 == 0
                                          ? Colors.black87
                                          : Colors.blueAccent,
                                      width: Adaptor.width(0.6),
                                    ),
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Container(
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: <Widget>[
                                          Text(
                                            '排列三频道',
                                            style: TextStyle(
                                              fontSize: Adaptor.sp(14),
                                              color: Colors.black87,
                                            ),
                                          ),
                                          Text(
                                            '点击开启预测',
                                            style: TextStyle(
                                              color: Colors.black26,
                                              fontSize: Adaptor.sp(12),
                                              height: 1.2,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(
                                          right: Adaptor.width(8)),
                                      child: Icon(
                                        IconData(
                                            model.pl3 == 1 ? 0xe60a : 0xe631,
                                            fontFamily: 'iconfont'),
                                        size: Adaptor.sp(18),
                                        color: model.pl3 == 1
                                            ? Colors.blueAccent
                                            : Colors.black12,
                                      ),
                                    )
                                  ],
                                )),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(
                            left: Adaptor.width(24),
                            right: Adaptor.width(24),
                          ),
                          child: GestureDetector(
                            onTap: () {
                              model.ssq = (model.ssq == 0 ? 1 : 0);
                            },
                            child: Container(
                              height: Adaptor.height(58),
                              alignment: Alignment.centerLeft,
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    color: model.ssq == 0
                                        ? Colors.black87
                                        : Colors.blueAccent,
                                    width: Adaptor.width(0.6),
                                  ),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Container(
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: <Widget>[
                                        Text(
                                          '双色球频道',
                                          style: TextStyle(
                                            fontSize: Adaptor.sp(14),
                                            color: Colors.black87,
                                          ),
                                        ),
                                        Text(
                                          '点击开启预测',
                                          style: TextStyle(
                                            color: Colors.black26,
                                            fontSize: Adaptor.sp(12),
                                            height: 1.2,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        right: Adaptor.width(8)),
                                    child: Icon(
                                      IconData(model.ssq == 1 ? 0xe60a : 0xe631,
                                          fontFamily: 'iconfont'),
                                      size: Adaptor.sp(18),
                                      color: model.ssq == 1
                                          ? Colors.blueAccent
                                          : Colors.black12,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(
                            left: Adaptor.width(24),
                            right: Adaptor.width(24),
                          ),
                          child: GestureDetector(
                            onTap: () {
                              model.dlt = (model.dlt == 0 ? 1 : 0);
                            },
                            child: Container(
                              height: Adaptor.height(58),
                              alignment: Alignment.centerLeft,
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    color: model.dlt == 0
                                        ? Colors.black87
                                        : Colors.blueAccent,
                                    width: Adaptor.width(0.6),
                                  ),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Container(
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: <Widget>[
                                        Text(
                                          '大乐透频道',
                                          style: TextStyle(
                                            fontSize: Adaptor.sp(14),
                                            color: Colors.black87,
                                          ),
                                        ),
                                        Text(
                                          '点击开启预测',
                                          style: TextStyle(
                                            color: Colors.black26,
                                            fontSize: Adaptor.sp(12),
                                            height: 1.2,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        right: Adaptor.width(8)),
                                    child: Icon(
                                      IconData(model.dlt == 1 ? 0xe60a : 0xe631,
                                          fontFamily: 'iconfont'),
                                      size: Adaptor.sp(18),
                                      color: model.dlt == 1
                                          ? Colors.blueAccent
                                          : Colors.black12,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(
                            left: Adaptor.width(24),
                            right: Adaptor.width(24),
                          ),
                          child: GestureDetector(
                            onTap: () {
                              model.qlc = (model.qlc == 0 ? 1 : 0);
                            },
                            child: Container(
                              height: Adaptor.height(58),
                              alignment: Alignment.centerLeft,
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    color: model.qlc == 0
                                        ? Colors.black87
                                        : Colors.blueAccent,
                                    width: Adaptor.width(0.6),
                                  ),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Container(
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: <Widget>[
                                        Text(
                                          '七乐彩频道',
                                          style: TextStyle(
                                            fontSize: Adaptor.sp(14),
                                            color: Colors.black87,
                                          ),
                                        ),
                                        Text(
                                          '点击开启预测',
                                          style: TextStyle(
                                            color: Colors.black26,
                                            fontSize: Adaptor.sp(12),
                                            height: 1.2,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        right: Adaptor.width(8)),
                                    child: Icon(
                                      IconData(model.qlc == 1 ? 0xe60a : 0xe631,
                                          fontFamily: 'iconfont'),
                                      size: Adaptor.sp(18),
                                      color: model.qlc == 1
                                          ? Colors.blueAccent
                                          : Colors.black12,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            child: Container(
              color: Colors.white,
              width: MediaQuery.of(context).size.width,
              alignment: Alignment.center,
              child: Column(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(
                      left: Adaptor.width(24),
                      right: Adaptor.width(24),
                      top: Adaptor.width(12),
                    ),
                    alignment: Alignment.centerLeft,
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {
                        model.agree = !model.agree;
                      },
                      child: Container(
                        height: Adaptor.height(30),
                        alignment: Alignment.centerLeft,
                        child: Row(
                          children: <Widget>[
                            Container(
                              height: Adaptor.width(15),
                              width: Adaptor.width(15),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.circular(Adaptor.width(2.6)),
                                border: Border.all(
                                  color: model.agree
                                      ? Colors.blueAccent
                                      : Colors.black26,
                                  width: Adaptor.width(0.8),
                                ),
                              ),
                              child: model.agree
                                  ? Container(
                                      height: Adaptor.height(9),
                                      width: Adaptor.width(9),
                                      decoration: BoxDecoration(
                                        color: Colors.blueAccent,
                                        borderRadius: BorderRadius.circular(
                                            Adaptor.width(2)),
                                      ),
                                    )
                                  : null,
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: Adaptor.width(6)),
                              child: GestureDetector(
                                onTap: () {
                                  AppNavigator.push(
                                      context, ExpertProtocolPage());
                                },
                                child: Text(
                                  '同意平台关于签约专家协议',
                                  style: TextStyle(
                                    fontSize: Adaptor.sp(12),
                                    color: model.agree
                                        ? Colors.blueAccent
                                        : Colors.redAccent,
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(
                      left: Adaptor.width(24),
                      right: Adaptor.width(24),
                      top: Adaptor.width(12),
                      bottom: Adaptor.width(16),
                    ),
                    child: GestureDetector(
                      onTap: () {
                        if (model.image == null) {
                          EasyLoading.showToast('请设置用户头像');
                          return;
                        }
                        if (!model.agree) {
                          EasyLoading.showToast('请确认签约协议');
                          return;
                        }
                        if (!model.hasEnableChannel()) {
                          EasyLoading.showToast('请选择开通频道');
                          return;
                        }
                        final form = _registerKey.currentState;
                        if (form.validate()) {
                          form.save();
                          model.registerAction(
                            callback: (bool state, String message) {
                              if (!state) {
                                EasyLoading.showError(message);
                                return;
                              }
                              EasyLoading.showSuccess(message);
                              Future.delayed(
                                const Duration(milliseconds: 500),
                                () {
                                  auth.vipMaster();
                                  AppNavigator.replace(
                                      context, UserPredictPage());
                                },
                              );
                            },
                          );
                        }
                      },
                      child: Container(
                        height: Adaptor.height(40),
                        width: Adaptor.width(200),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.redAccent,
                          borderRadius: BorderRadius.circular(Adaptor.width(2)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              model.register ? '提交中' : '提交签约',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: Adaptor.sp(16),
                              ),
                            ),
                            if (model.register)
                              Padding(
                                padding:
                                    EdgeInsets.only(left: Adaptor.width(6)),
                                child: SpinKitRing(
                                  color: Colors.white,
                                  lineWidth: Adaptor.width(1.2),
                                  size: Adaptor.width(16),
                                ),
                              )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
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

  @override
  void didUpdateWidget(RegisterMasterPage oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }
}
