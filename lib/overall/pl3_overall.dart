import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottery_app/commons/app_navigator.dart';
import 'package:lottery_app/commons/custom_scroll_physics.dart';
import 'package:lottery_app/commons/mappbar.dart';
import 'package:lottery_app/components/error_widget.dart';
import 'package:lottery_app/components/load_state.dart';
import 'package:lottery_app/components/pay_notice.dart';
import 'package:lottery_app/model/pl3_overall.dart';
import 'package:lottery_app/commons/constants.dart';
import 'package:lottery_app/commons/line_chart.dart';
import 'package:lottery_app/components/adaptor.dart';
import 'package:lottery_app/package/vip-package.dart';
import 'package:provider/provider.dart';

class Pl3OverallPage extends StatefulWidget {
  @override
  Pl3OverallPageState createState() => new Pl3OverallPageState();
}

const List<String> _categories = <String>[
  '0',
  '1',
  '2',
  '3',
  '4',
  '5',
  '6',
  '7',
  '8',
  '9'
];

class Pl3OverallPageState extends State<Pl3OverallPage> {
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: ChangeNotifierProvider(
        create: (_) => Pl3OverallModel.initialize(),
        child: Scaffold(
          body: Column(
            children: <Widget>[
              MAppBar('整体态势'),
              Expanded(
                child: SingleChildScrollView(
                  physics: EasyRefreshPhysics(topBouncing: false),
                  child: Container(
                    margin: EdgeInsets.only(bottom: Adaptor.width(38)),
                    child: Column(
                      children: <Widget>[
                        _buildList(),
                        _buildChart(),
                        Constant.header(
                          '使用说明',
                          0xe648,
                        ),
                        _buildHelpInfo(),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildList() {
    return Consumer(
        builder: (BuildContext context, Pl3OverallModel model, Widget child) {
      return Container(
        child: Column(
          children: <Widget>[
            _buildTitle(model),
            Constant.header(
              '选项类型',
              0xe698,
            ),
            _buildGridTab(model),
            Constant.header(
              '0-9热度统计',
              0xe611,
            ),
          ],
        ),
      );
    });
  }

  Widget _buildTitle(Pl3OverallModel model) {
    String title = '';
    if (model.period != null) {
      title = '第${model.period}期排列三整体态势';
    }
    return Container(
      margin: EdgeInsets.fromLTRB(
        0,
        Adaptor.width(20),
        0,
        Adaptor.width(15),
      ),
      height: Adaptor.height(26),
      alignment: Alignment.center,
      child: Text(
        title,
        style: TextStyle(
          color: Colors.black87,
          fontSize: Adaptor.sp(18),
        ),
      ),
    );
  }

  Widget _buildGridTab(Pl3OverallModel model) {
    return Padding(
      padding: EdgeInsets.only(
        left: Adaptor.width(16),
        right: Adaptor.width(16),
        top: Adaptor.width(8),
        bottom: Adaptor.width(8),
      ),
      child: PhysicalModel(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(Adaptor.width(4)),
        clipBehavior: Clip.antiAlias,
        child: Column(
          children: <Widget>[
            Container(
              height: Adaptor.width(40),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xfffd7164),
                    Color(0xfffcb58f),
                  ],
                ),
              ),
              child: Row(
                children: <Widget>[
                  _buildGridCell(
                    model: model,
                    title: '双胆',
                    index: 2,
                    border: 1,
                  ),
                  _buildGridCell(
                    model: model,
                    title: '三胆',
                    index: 3,
                    border: 1,
                  ),
                  _buildGridCell(
                    model: model,
                    title: '五码',
                    index: 4,
                    border: 1,
                  ),
                  _buildGridCell(
                    model: model,
                    title: '六码',
                    index: 5,
                    border: 0,
                  ),
                ],
              ),
            ),
            Padding(padding: EdgeInsets.only(top: Adaptor.width(0.6))),
            Container(
              height: Adaptor.width(40),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xff717efb),
                    Color(0xff9DC9FA),
                  ],
                ),
              ),
              child: Row(
                children: <Widget>[
                  _buildGridCell(
                    model: model,
                    title: '七码',
                    index: 6,
                    border: 1,
                  ),
                  _buildGridCell(
                    model: model,
                    title: '杀一码',
                    index: 7,
                    border: 1,
                    flex: 2,
                  ),
                  _buildGridCell(
                    model: model,
                    title: '杀二码',
                    index: 8,
                    border: 0,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGridCell(
      {Pl3OverallModel model,
      String title,
      int index,
      int border = 0,
      int flex = 1}) {
    return Expanded(
      flex: flex,
      child: GestureDetector(
        onTap: () {
          model.switchType(index);
        },
        child: Container(
          decoration: BoxDecoration(
            border: border == 1
                ? Border(
                    right: BorderSide(
                      color: Colors.white,
                      width: Adaptor.width(0.6),
                    ),
                  )
                : null,
          ),
          child: Stack(
            children: <Widget>[
              Container(
                alignment: AlignmentDirectional.center,
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: Adaptor.sp(14),
                    color: model.type == index ? Colors.white : Colors.black26,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChart() {
    return Consumer(
        builder: (BuildContext context, Pl3OverallModel model, Widget child) {
      if (model.state == LoadState.loading) {
        return Card(
          elevation: 0,
          color: Color(0xff81e5cd),
          child: Container(
            width: MediaQuery.of(context).size.width * 0.92,
            height: Adaptor.height(240),
            child: Center(
              child: Constant.loading(),
            ),
          ),
        );
      }
      if (model.state == LoadState.error) {
        return Card(
          elevation: 0,
          color: Color(0xff81e5cd),
          child: Container(
            width: MediaQuery.of(context).size.width * 0.92,
            height: Adaptor.height(240),
            child: Center(
              child: ErrorView(
                  message: model.message,
                  callback: () {
                    model.loadData(model.type);
                  }),
            ),
          ),
        );
      }
      if (model.state == LoadState.pay) {
        return Card(
          elevation: 0,
          color: Color(0xff81e5cd),
          child: Container(
            width: MediaQuery.of(context).size.width * 0.92,
            height: Adaptor.height(240),
            child: Center(
              child: PayNoticeView(
                color: Colors.black38,
                message: model.message,
                onTap: () {
                  AppNavigator.push(context, VipPackagesPage());
                },
              ),
            ),
          ),
        );
      }
      if (model.state == LoadState.success) {
        return Card(
          elevation: 0,
          color: Color(0xff81e5cd),
          child: LineChart(
            data: LineData(
              categories: _categories,
              datas: [
                _parseData(model.getData().level150),
                _parseData(model.getData().level300),
                _parseData(model.getData().level500),
                _parseData(model.getData().level750),
                _parseData(model.getData().level1050),
              ],
              dotColor: Colors.white,
              maxColor: Colors.blueAccent,
              minColor: Colors.redAccent,
              isCurve: false,
            ),
            padding: EdgeInsets.symmetric(vertical: Adaptor.width(10)),
            width: MediaQuery.of(context).size.width * 0.92,
            height: Adaptor.height(240),
          ),
        );
      }
    });
  }

  List<double> _parseData(List data) {
    return List.of(data.map((item) => double.parse(item.toString())));
  }

  Widget _buildHelpInfo() {
    return Container(
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.only(
        left: Adaptor.width(14),
        right: Adaptor.width(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            '1.整体态势分析是将平台专家预测数据按双胆、三胆、五码、六码、七码、杀一码、杀二码指标进行的统计分析。统计图中四条统计曲线(由下到上)分别对应：排名前150、排名前300、排名前500、排名前750、排名前1050的收费专家统计信息。',
            style: TextStyle(
              fontSize: Adaptor.sp(12),
              color: Colors.black38,
            ),
          ),
          Text(
            '2.这些指标根据评判标准主要分为两大类，一类是统计数值越大越好，如：七码、六码、五码指标；另一类是统计值越小越好，如：杀一码、杀二码、双胆、三胆指标。',
            style: TextStyle(
              fontSize: Adaptor.sp(12),
              color: Colors.black38,
            ),
          ),
          Text(
            '3.如何通过整体态势分析选出1~2胆码？'
                '首先，我们可以通过杀一码、杀二码等指标选出统计值最小的号码；'
                '其次，通过七码、六码、五码指标选出统计值最大的号码；'
                '再次，综合最小统计值和最大统计值选出的号码，'
                '如果两方面指标选出的号码重复次数越多说明改号码在本次开奖中，出现的可能性越大，可以最为胆码使用',
            style: TextStyle(
              fontSize: Adaptor.sp(12),
              color: Colors.black38,
            ),
          ),
          Text(
            '4.关于整体态势分析使用，需要您在使用过程中多观察、多总结，相信一定能为您带来意想不到的收获。',
            style: TextStyle(
              fontSize: Adaptor.sp(12),
              color: Colors.black38,
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
}
