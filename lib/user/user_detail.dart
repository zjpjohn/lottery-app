import 'dart:core';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottery_app/commons/app_navigator.dart';
import 'package:lottery_app/commons/mappbar.dart';
import 'package:lottery_app/model/auth.dart';
import 'package:provider/provider.dart';
import 'package:lottery_app/components/adaptor.dart';

class UserDetailPage extends StatefulWidget {
  @override
  UserDetailPageState createState() => new UserDetailPageState();
}

class UserDetailPageState extends State<UserDetailPage> {
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        body: Column(
          children: <Widget>[
            MAppBar('个人资料'),
            _buildUser(),
          ],
        ),
      ),
    );
  }

  ///加载用户信息组件
  ///
  Widget _buildUser() {
    return Consumer<AuthModel>(
        builder: (BuildContext context, AuthModel model, Widget child) {
      return Container(
        child: Column(
          children: <Widget>[
            _buildUserAvatar(),
            _buildUserItem('用户名', model.user != null ? model.user.name : '', 0),
            _buildUserItem(
                '手机号', model.user != null ? model.user.phone : '', 0),
            _buildUserItem(
                '注册时间', model.user != null ? model.user.createTime : '', 0),
            _buildLoginOut(model),
          ],
        ),
      );
    });
  }

  Widget _buildUserAvatar() {
    return Container(
      margin: EdgeInsets.fromLTRB(
        Adaptor.width(20),
        Adaptor.width(10),
        Adaptor.width(20),
        0,
      ),
      padding: EdgeInsets.fromLTRB(
        Adaptor.width(2),
        Adaptor.width(10),
        Adaptor.width(10),
        Adaptor.width(10),
      ),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Color(0xffececec),
            width: 0.5,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            '头像',
            style: TextStyle(
              fontSize: Adaptor.sp(15),
              color: Colors.black87,
            ),
          ),
          Image.asset(
            'assets/images/avatar.png',
            width: Adaptor.width(45),
          ),
        ],
      ),
    );
  }

  Widget _buildUserItem(String name, String content, double margin) {
    return Container(
      margin: EdgeInsets.fromLTRB(
        Adaptor.width(20),
        Adaptor.width(11),
        Adaptor.width(20),
        0,
      ),
      padding: EdgeInsets.fromLTRB(
        Adaptor.width(2),
        Adaptor.width(11),
        Adaptor.width(2),
        Adaptor.width(22),
      ),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Color(0xffececec),
            width: Adaptor.width(0.3),
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            '$name',
            style: TextStyle(
              fontSize: Adaptor.sp(15),
              color: Colors.black87,
            ),
          ),
          Text(
            '$content',
            style: TextStyle(
              fontSize: Adaptor.sp(15),
              color: Colors.black87,
            ),
          )
        ],
      ),
    );
  }

  Widget _buildLoginOut(AuthModel model) {
    return GestureDetector(
      onTap: () {
        model.loginOut(() => {AppNavigator.goBack(context)});
      },
      child: Container(
        margin: EdgeInsets.only(top: Adaptor.width(50)),
        height: Adaptor.height(38),
        width: Adaptor.width(260),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.08),
        ),
        child: Text(
          '退       出',
          style: TextStyle(
            color: Colors.redAccent,
            fontSize: Adaptor.sp(16),
          ),
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
