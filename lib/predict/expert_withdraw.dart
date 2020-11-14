import 'dart:core';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyrefresh/delivery_header.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_easyrefresh/phoenix_footer.dart';
import 'package:lottery_app/commons/constants.dart';
import 'package:lottery_app/commons/mappbar.dart';
import 'package:lottery_app/components/empty_widget.dart';
import 'package:lottery_app/components/error_widget.dart';
import 'package:lottery_app/model/expert_withdraw.dart';
import 'package:provider/provider.dart';
import 'package:lottery_app/components/adaptor.dart';

class ExpertWithdrawPage extends StatefulWidget {
  @override
  ExpertWithdrawPageState createState() => new ExpertWithdrawPageState();
}

class ExpertWithdrawPageState extends State<ExpertWithdrawPage> {
  EasyRefreshController _controller = EasyRefreshController();

  final Map<int, Color> colors = Map()
    ..[0] = Colors.redAccent
    ..[1] = Colors.black38
    ..[2] = Colors.blueAccent
    ..[3] = Colors.deepOrangeAccent
    ..[4] = Colors.green;

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: ChangeNotifierProvider<WithDrawModel>(
        create: (_) => WithDrawModel.initialize(),
        child: Scaffold(
          body: Column(
            children: <Widget>[
              NavAppBar(
                title: '我的提现',
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
              _buildWithdrawView(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWithdrawView() {
    return Consumer<WithDrawModel>(
        builder: (BuildContext context, WithDrawModel model, Widget child) {
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
                      model.loadWithdrawList();
                    }),
              ],
            ),
          );
        }
        return Expanded(
          child: EasyRefresh(
            controller: _controller,
            header: DeliveryHeader(),
            footer: PhoenixFooter(),
            emptyWidget: model.list.length == 0
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      EmptyView(
                        icon: 'assets/images/empty.png',
                        message: '没有提现记录',
                        size: 98,
                        margin: EdgeInsets.only(top: 0),
                        callback: () {
                          model.loadWithdrawList();
                        },
                      ),
                    ],
                  )
                : null,
            child: ListView.builder(
              itemCount: model.list.length,
              padding: EdgeInsets.only(
                top: Adaptor.width(8),
                bottom: Adaptor.width(32),
              ),
              itemBuilder: (BuildContext context, int index) {
                return _builWithdraw(model.list[index]);
              },
            ),
            onRefresh: () async {
              await Future.delayed(const Duration(milliseconds: 1500), () {
                model.refresh();
              });
            },
            onLoad: () async {
              await Future.delayed(const Duration(milliseconds: 1500), () {
                model.loadMore();
              });
            },
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

  Widget _builWithdraw(WithdrawInfo withdraw) {
    return Container(
      padding: EdgeInsets.only(bottom: Adaptor.width(18)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            height: Adaptor.height(36),
            padding: EdgeInsets.only(left: Adaptor.width(16)),
            margin: EdgeInsets.only(bottom: Adaptor.width(8)),
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.05),
            ),
            alignment: Alignment.centerLeft,
            child: Text(
              '流水号  ${withdraw.seqNo}',
              style: TextStyle(
                color: Colors.black87,
                fontSize: Adaptor.sp(14),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              left: Adaptor.width(16),
              right: Adaptor.width(16),
              bottom: Adaptor.width(6),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  '${withdraw.state == 1 ? '提现已申请，等待审核' : withdraw.message ?? ''}',
                  style: TextStyle(
                    color: colors[withdraw.state],
                    fontSize: Adaptor.sp(13),
                  ),
                ),
                Text(
                  '+${withdraw.money}元',
                  style: TextStyle(
                    color: Colors.redAccent,
                    fontSize: Adaptor.sp(14),
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              left: Adaptor.width(16),
              right: Adaptor.width(16),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  '${withdraw.gmtCreate}',
                  style: TextStyle(
                    color: Colors.black38,
                    fontSize: Adaptor.sp(13),
                  ),
                ),
                Text(
                  '-${withdraw.withdraw}金币',
                  style: TextStyle(
                    color: Colors.redAccent,
                    fontSize: Adaptor.sp(14),
                  ),
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

  @override
  void didUpdateWidget(ExpertWithdrawPage oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }
}
