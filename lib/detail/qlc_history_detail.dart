import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottery_app/commons/constants.dart';
import 'package:lottery_app/commons/mappbar.dart';
import 'package:lottery_app/commons/tools.dart';
import 'package:lottery_app/components/adaptor.dart';
import 'package:lottery_app/components/empty_widget.dart';
import 'package:lottery_app/components/error_widget.dart';
import 'package:lottery_app/components/forecast_notice.dart';
import 'package:lottery_app/components/load_state.dart';
import 'package:lottery_app/model/qlc_history_detail.dart';
import 'package:provider/provider.dart';

class QlcHistoryDetailPage extends StatelessWidget {
  String masterId;

  QlcHistoryDetailPage({@required this.masterId});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: ChangeNotifierProvider<QlcHistoryDetailModel>(
        create: (_) => QlcHistoryDetailModel.initialize(masterId: masterId),
        child: Scaffold(
          body: Column(
            children: <Widget>[
              MAppBar('上期历史'),
              _buildHistoryView(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHistoryView() {
    return Consumer(builder:
        (BuildContext context, QlcHistoryDetailModel model, Widget child) {
      if (model.state == LoadState.loading) {
        return Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Constant.loading(),
            ],
          ),
        );
      }
      if (model.state == LoadState.error) {
        return Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ErrorView(
                color: Colors.black38,
                message: '出错啦，点击重试',
                callback: () {
                  model.loadData();
                },
              ),
            ],
          ),
        );
      }
      if (model.state == LoadState.empty) {
        return Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              EmptyView(
                icon: 'assets/images/empty.png',
                size: Adaptor.width(98),
                message: '预测历史为空',
                callback: () {},
              ),
            ],
          ),
        );
      }
      if (model.state == LoadState.success) {
        return Expanded(
          child: ListView(
            key: new GlobalKey(),
            padding: EdgeInsets.only(bottom: Adaptor.sp(25)),
            children: <Widget>[
              _buildTitle(model),
              _buildItem('三胆', model.detail.dan3),
              _buildItem('12码', model.detail.red12),
              _buildItem('18码', model.detail.red18),
              _buildItem('22码', model.detail.red22),
              _buildItem('杀三码', model.detail.kill3),
              _buildItem('杀六码', model.detail.kill6),
              _buildItem('独胆', model.detail.dan1),
              _buildItem('双胆', model.detail.dan2),
              ForecastNotice(),
            ],
          ),
        );
      }
    });
  }

  Widget _buildTitle(QlcHistoryDetailModel model) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        Adaptor.width(15),
        Adaptor.width(10),
        Adaptor.width(10),
        0,
      ),
      child: Row(
        children: <Widget>[
          Container(
            child: Text(
              '第${model.detail.period}期预测号码',
              style: TextStyle(color: Colors.black54, fontSize: Adaptor.sp(16)),
            ),
          ),
          Text(
            '(已开奖)',
            style: TextStyle(color: Colors.black38, fontSize: Adaptor.sp(15)),
          ),
        ],
      ),
    );
  }

  Widget _buildItem(String name, List<Model> data) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        Adaptor.width(16),
        Adaptor.width(10),
        Adaptor.width(16),
        Adaptor.width(10),
      ),
      alignment: Alignment.centerLeft,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Flexible(
            child: Container(
              margin: EdgeInsets.only(bottom: Adaptor.width(5)),
              child: Text(
                name,
                style:
                    TextStyle(color: Colors.black54, fontSize: Adaptor.sp(16)),
              ),
            ),
          ),
          Flexible(
              child: Wrap(
            children: _buildViews(data),
          ))
        ],
      ),
    );
  }

  List<Widget> _buildViews(List data) {
    return List()
      ..addAll(
        data.map((v) {
          return Container(
            margin: EdgeInsets.only(right: Adaptor.width(8)),
            child: Text(
              v.k,
              style: TextStyle(
                color: v.v == 0 ? Colors.black54 : Color(0xffF43F3B),
                fontSize: Adaptor.sp(17),
              ),
            ),
          );
        }),
      );
  }
}
