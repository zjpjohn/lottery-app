import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottery_app/commons/constants.dart';
import 'package:lottery_app/commons/custom_scroll_physics.dart';
import 'package:lottery_app/commons/mappbar.dart';
import 'package:lottery_app/components/adaptor.dart';
import 'package:lottery_app/components/empty_widget.dart';
import 'package:lottery_app/components/error_widget.dart';
import 'package:lottery_app/components/forecast_notice.dart';
import 'package:lottery_app/components/load_state.dart';
import 'package:lottery_app/model/qlc_predict_detail.dart';
import 'package:provider/provider.dart';

class QlcPredictDetail extends StatefulWidget {
  String period;

  QlcPredictDetail({@required this.period});

  @override
  QlcPredictDetailState createState() => new QlcPredictDetailState();
}

class QlcPredictDetailState extends State<QlcPredictDetail> {
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: ChangeNotifierProvider<QlcPredictDetailModel>(
        create: (_) => QlcPredictDetailModel.initialize(period: widget.period),
        child: Scaffold(
          body: Column(
            children: <Widget>[
              MAppBar('预测详情'),
              _buildForecast(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildForecast() {
    return Consumer<QlcPredictDetailModel>(builder:
        (BuildContext context, QlcPredictDetailModel model, Widget child) {
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
                  model.queryForecast();
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
                size: 98,
                message: '预测数据为空',
                callback: () {},
              ),
            ],
          ),
        );
      }
      if (model.state == LoadState.success) {
        return Expanded(
          child: ListView(
            physics: EasyRefreshPhysics(topBouncing: false),
            key: new GlobalKey(),
            padding: EdgeInsets.only(
              bottom: Adaptor.width(32),
            ),
            children: <Widget>[
              _buildTitle(model),
              _buildItem('红球三胆', model.forecast.opened, model.forecast.dan3),
              _buildItem('红球12码', model.forecast.opened, model.forecast.red12),
              _buildItem('红球18码', model.forecast.opened, model.forecast.red18),
              _buildItem('红球22码', model.forecast.opened, model.forecast.red22),
              _buildItem('红球杀三码', model.forecast.opened, model.forecast.kill3),
              _buildItem('红球杀六码', model.forecast.opened, model.forecast.kill6),
              _buildItem('红球双胆', model.forecast.opened, model.forecast.dan2),
              _buildItem('红球独胆', model.forecast.opened, model.forecast.dan1),
              ForecastNotice(),
            ],
          ),
        );
      }
    });
  }

  Widget _buildTitle(QlcPredictDetailModel model) {
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
              '第${model.forecast.period}期预测号码',
              style: TextStyle(
                color: Colors.black54,
                fontSize: Adaptor.sp(16),
              ),
            ),
          ),
          Text(
            '(${model.forecast.opened == 1 ? '已开奖' : '未开奖'})',
            style: TextStyle(
              color: Colors.black38,
              fontSize: Adaptor.sp(15),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildItem(String name, int opened, List data) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        Adaptor.width(15),
        Adaptor.width(10),
        Adaptor.width(10),
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
              margin: EdgeInsets.only(
                bottom: Adaptor.width(5),
              ),
              child: Text(
                name,
                style: TextStyle(
                  color: Colors.black54,
                  fontSize: Adaptor.sp(16),
                ),
              ),
            ),
          ),
          Flexible(
            child: Wrap(
              children: List()
                ..addAll(
                  data.map((v) {
                    return Container(
                      margin: EdgeInsets.only(right: Adaptor.width(8)),
                      child: opened == 0
                          ? Text(
                              v,
                              style: TextStyle(
                                color: Colors.black54,
                                fontSize: Adaptor.sp(16),
                              ),
                            )
                          : Text(
                              v.k,
                              style: TextStyle(
                                color: v.v == 0
                                    ? Colors.black54
                                    : Color(0xffF43F3B),
                                fontSize: Adaptor.sp(17),
                              ),
                            ),
                    );
                  }).toList(),
                ),
            ),
          )
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
