import 'dart:core';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottery_app/commons/app_navigator.dart';
import 'package:lottery_app/commons/constants.dart';
import 'package:lottery_app/commons/tools.dart';
import 'package:lottery_app/components/empty_widget.dart';
import 'package:lottery_app/components/error_widget.dart';
import 'package:lottery_app/model/share_list.dart';
import 'package:provider/provider.dart';
import 'package:lottery_app/components/adaptor.dart';

class ShareListPage extends StatefulWidget {
  @override
  ShareListPageState createState() => new ShareListPageState();
}

class ShareListPageState extends State<ShareListPage> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ShareListModel>(
      create: (_) => ShareListModel.initialize(),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(Adaptor.width(6.0)),
          topRight: Radius.circular(Adaptor.width(6.0)),
        ),
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 9.0 / 16.0,
          child: Column(
            children: <Widget>[
              Stack(
                children: <Widget>[
                  Container(
                    width: double.infinity,
                    alignment: Alignment.center,
                    padding:
                        EdgeInsets.symmetric(vertical: Adaptor.width(14.0)),
                    child: Text(
                      "邀请历史",
                      style: TextStyle(
                        fontSize: Adaptor.sp(17),
                        color: Colors.black54,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  Positioned(
                    right: Adaptor.width(16),
                    top: Adaptor.height(14),
                    bottom: Adaptor.height(14),
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {
                        AppNavigator.goBack(context);
                      },
                      child: Container(
                        width: Adaptor.width(40),
                        height: Adaptor.height(22),
                        alignment: Alignment.centerRight,
                        child: Icon(
                          IconData(0xe683, fontFamily: 'iconfont'),
                          size: Adaptor.sp(15),
                          color: Colors.black54,
                        ),
                      ),
                    ),
                  )
                ],
              ),
              Constant.line,
              _buildShareList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildShareList() {
    return Consumer<ShareListModel>(
        builder: (BuildContext context, ShareListModel model, Widget child) {
      if (model.loaded) {
        if (model.error) {
          return Flexible(
            child: Column(
              children: <Widget>[
                ErrorView(
                  color: Colors.black26,
                  message: '出错啦，点击重试',
                  callback: () {
                    model.loadShareRecords();
                  },
                ),
              ],
            ),
          );
        }
        if (model.records.length > 0) {
          return Expanded(
            child: SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.only(top: Adaptor.width(16)),
                child: Column(
                  children: _buildListView(model),
                ),
              ),
            ),
          );
        }
        return Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              EmptyView(
                icon: 'assets/images/empty.png',
                message: '没有邀请记录',
                size: 98,
                margin: EdgeInsets.only(top: 0),
                callback: () {},
              ),
            ],
          ),
        );
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

  List<Widget> _buildListView(ShareListModel model) {
    return List()
      ..addAll(
        model.records.map(
          (v) {
            return Container(
              alignment: Alignment.center,
              padding: EdgeInsets.fromLTRB(
                Adaptor.width(10),
                0,
                Adaptor.width(10),
                Adaptor.width(14),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Flexible(
                    flex: 1,
                    child: Container(
                      alignment: Alignment.center,
                      child: Text(
                        '${v.name}',
                        style: TextStyle(
                          color: Colors.black38,
                          fontSize: Adaptor.sp(13),
                        ),
                      ),
                    ),
                  ),
                  Flexible(
                    flex: 1,
                    child: Container(
                      alignment: Alignment.center,
                      child: Text(
                        '${Tools.encodePhone(v.phone)}',
                        style: TextStyle(
                          color: Colors.black38,
                          fontSize: Adaptor.sp(13),
                        ),
                      ),
                    ),
                  ),
                  Flexible(
                    flex: 1,
                    child: Container(
                      alignment: Alignment.center,
                      child: Text(
                        '${v.regTime}',
                        style: TextStyle(
                          color: Colors.black38,
                          fontSize: Adaptor.sp(13),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
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
  void didUpdateWidget(ShareListPage oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }
}
