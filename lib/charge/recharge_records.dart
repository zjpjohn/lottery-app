import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyrefresh/delivery_header.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_easyrefresh/phoenix_footer.dart';
import 'package:lottery_app/commons/constants.dart';
import 'package:lottery_app/commons/mappbar.dart';
import 'package:lottery_app/components/adaptor.dart';
import 'package:lottery_app/components/empty_widget.dart';
import 'package:lottery_app/components/error_widget.dart';
import 'package:lottery_app/components/load_state.dart';
import 'package:lottery_app/model/recharge_record.dart';
import 'package:provider/provider.dart';

class RechargeRecords extends StatefulWidget {
  @override
  RechargeRecordsState createState() => new RechargeRecordsState();
}

class RechargeRecordsState extends State<RechargeRecords> {
  EasyRefreshController _controller = EasyRefreshController();

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: ChangeNotifierProvider<RechargeRecordModel>(
        create: (_) => RechargeRecordModel.initialize(),
        child: Scaffold(
          backgroundColor: Colors.white,
          body: Column(
            children: <Widget>[
              NavAppBar(
                title: '充值记录',
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
              _buildContentView(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContentView() {
    return Consumer(builder:
        (BuildContext context, RechargeRecordModel model, Widget child) {
      if (model.state == LoadState.loading) {
        return Flexible(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Constant.loading(),
            ],
          ),
        );
      }
      if (model.state == LoadState.error) {
        return Flexible(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ErrorView(
                  message: '出错啦，点击重试',
                  callback: () {
                    model.initial();
                  }),
            ],
          ),
        );
      }
      if (model.state == LoadState.success) {
        return Expanded(
          child: EasyRefresh(
            controller: _controller,
            header: DeliveryHeader(),
            footer: PhoenixFooter(),
            emptyWidget: model.records.length == 0
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      EmptyView(
                        icon: 'assets/images/empty.png',
                        message: '没有充值记录',
                        size: 98,
                        margin: EdgeInsets.only(top: 0),
                        callback: () {
                          model.initial();
                        },
                      ),
                    ],
                  )
                : null,
            child: ListView.builder(
              itemCount: model.records.length,
              padding: EdgeInsets.only(
                top: Adaptor.width(12),
                bottom: Adaptor.width(32),
              ),
              itemBuilder: (BuildContext context, int index) {
                return _buildRecordItem(model.records[index]);
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
    });
  }

  Widget _buildRecordItem(RechargeRecord record) {
    return Container(
      padding: EdgeInsets.only(bottom: Adaptor.width(16)),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.grey.withOpacity(0.2),
            width: Adaptor.width(0.4),
          ),
        ),
      ),
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(
              top: Adaptor.width(16),
              left: Adaptor.width(16),
              right: Adaptor.width(16),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  '充值金额${record.amount}元',
                  style: TextStyle(
                    fontSize: Adaptor.sp(16),
                    color: Colors.black87,
                  ),
                ),
                Text(
                  '${record.valence}金币',
                  style: TextStyle(
                    fontSize: Adaptor.sp(16),
                    color: Colors.redAccent,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              top: Adaptor.width(8),
              left: Adaptor.width(16),
              right: Adaptor.width(16),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  '${record.timestamp}',
                  style: TextStyle(
                    color: Colors.black38,
                    fontSize: Adaptor.sp(13),
                  ),
                ),
                Container(
                  child: record.voucher != 0
                      ? Text(
                          '赠送${record.voucher}代金券',
                          style: TextStyle(
                            color: Colors.redAccent,
                            fontSize: Adaptor.sp(13),
                          ),
                        )
                      : null,
                ),
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
  void didUpdateWidget(RechargeRecords oldWidget) {
    super.didUpdateWidget(oldWidget);
  }
}
