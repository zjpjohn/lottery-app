import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottery_app/commons/constants.dart';
import 'package:lottery_app/commons/custom_scroll_physics.dart';
import 'package:lottery_app/commons/mappbar.dart';
import 'package:lottery_app/commons/tools.dart';
import 'package:lottery_app/components/adaptor.dart';
import 'package:lottery_app/components/empty_widget.dart';
import 'package:lottery_app/components/error_widget.dart';
import 'package:lottery_app/components/forecast_notice.dart';
import 'package:lottery_app/components/load_state.dart';
import 'package:lottery_app/model/fc3d_history_detail.dart';
import 'package:provider/provider.dart';

class Fc3dHistoryDetailPage extends StatefulWidget {
  String masterId;

  Fc3dHistoryDetailPage({@required this.masterId});

  @override
  Fc3dHistoryDetailPageState createState() => new Fc3dHistoryDetailPageState();
}

class Fc3dHistoryDetailPageState extends State<Fc3dHistoryDetailPage> {
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: ChangeNotifierProvider(
        create: (_) =>
            Fc3dHistoryDetailModel.initialize(masterId: widget.masterId),
        child: Scaffold(
          body: Column(
            children: <Widget>[
              MAppBar('上期历史'),
              _buildHistoryDetail(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHistoryDetail() {
    return Consumer(builder:
        (BuildContext context, Fc3dHistoryDetailModel model, Widget child) {
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
            physics: EasyRefreshPhysics(topBouncing: false),
            key: new GlobalKey(),
            padding: EdgeInsets.only(
              bottom: Adaptor.width(32),
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

  Widget _buildTitle(Fc3dHistoryDetailModel model) {
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

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void didUpdateWidget(Fc3dHistoryDetailPage oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }
}
