import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottery_app/charge/recharge_page.dart';
import 'package:lottery_app/commons/app_navigator.dart';
import 'package:lottery_app/commons/custom_scroll_physics.dart';
import 'package:lottery_app/commons/mappbar.dart';
import 'package:lottery_app/commons/constants.dart';
import 'package:lottery_app/components/adaptor.dart';
import 'package:lottery_app/components/empty_widget.dart';
import 'package:lottery_app/components/error_widget.dart';
import 'package:lottery_app/components/forecast_notice.dart';
import 'package:lottery_app/components/load_state.dart';
import 'package:lottery_app/components/pay_notice.dart';
import 'package:lottery_app/model/pl3_detail.dart';
import 'package:provider/provider.dart';

class Pl3DetailPage extends StatefulWidget {
  String masterId;

  Pl3DetailPage({@required this.masterId});

  @override
  Pl3DetailPageState createState() => new Pl3DetailPageState();
}

class Pl3DetailPageState extends State<Pl3DetailPage> {
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: ChangeNotifierProvider(
          create: (_) => Pl3DetailModel.initialize(masterId: widget.masterId),
          child: Scaffold(
            body: Column(
              children: <Widget>[
                MAppBar('最新预测'),
                _buildList(),
              ],
            ),
          )),
    );
  }

  Widget _buildTitle(Pl3DetailModel model) {
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
              style: TextStyle(
                color: Colors.black54,
                fontSize: Adaptor.sp(16),
              ),
            ),
          ),
          Text(
            '(未开奖)',
            style: TextStyle(
              color: Colors.black38,
              fontSize: Adaptor.sp(15),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildList() {
    return Consumer(
        builder: (BuildContext context, Pl3DetailModel model, Widget child) {
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
      if (model.state == LoadState.pay) {
        return Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              PayNoticeView(
                color: Colors.black38,
                onTap: () {
                  AppNavigator.push(context, RechargePage());
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
            key: new GlobalKey(),
            physics: EasyRefreshPhysics(topBouncing: false),
            padding: EdgeInsets.only(
              bottom: Adaptor.width(25),
            ),
            children: <Widget>[
              _buildTitle(model),
              _buildItem('三胆', model.detail.dan3),
              _buildItem('五码', model.detail.com5),
              _buildItem('六码', model.detail.com6),
              _buildItem('七码', model.detail.com7),
              _buildItem('杀一码', model.detail.kill1),
              _buildItem('杀二码', model.detail.kill2),
              _buildItem('定位', model.detail.comb5),
              _buildItem('双胆', model.detail.dan2),
              _buildItem('独胆', model.detail.dan1),
              ForecastNotice(),
            ],
          ),
        );
      }
    });
  }

  Widget _buildItem(String name, List data) {
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
              v,
              style: TextStyle(
                color: Colors.black54,
                fontSize: Adaptor.sp(16),
              ),
            ),
          );
        }).toList(),
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
