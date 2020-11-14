import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:lottery_app/commons/app_navigator.dart';
import 'package:lottery_app/commons/custom_scroll_physics.dart';
import 'package:lottery_app/commons/mappbar.dart';
import 'package:lottery_app/commons/constants.dart';
import 'package:lottery_app/commons/line_chart.dart';
import 'package:lottery_app/components/error_widget.dart';
import 'package:lottery_app/components/load_state.dart';
import 'package:lottery_app/components/pay_notice.dart';
import 'package:lottery_app/components/adaptor.dart';
import 'package:lottery_app/model/qlc_chart.dart';
import 'package:lottery_app/package/vip-package.dart';
import 'package:provider/provider.dart';

class QlcComprehensivePage extends StatefulWidget {
  @override
  QlcComprehensivePageState createState() => new QlcComprehensivePageState();
}

const List<String> _categories = [
  '1',
  '2',
  '3',
  '4',
  '5',
  '6',
  '7',
  '8',
  '9',
  '10',
  '11',
  '12',
  '13',
  '14',
  '15',
  '16',
  '17',
  '18',
  '19',
  '20',
  '21',
  '22',
  '23',
  '24',
  '25',
  '26',
  '27',
  '28',
  '29',
  '30'
];

class QlcComprehensivePageState extends State<QlcComprehensivePage> {
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: ChangeNotifierProvider<QlcChartModel>(
        create: (_) => QlcChartModel.initialize(),
        child: Scaffold(
          body: Column(
            children: <Widget>[
              MAppBar('综合统计'),
              _buildContainer(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContainer() {
    return Expanded(
      child: SingleChildScrollView(
        physics: EasyRefreshPhysics(topBouncing: false),
        child: Container(
          margin: EdgeInsets.only(bottom: Adaptor.width(38)),
          child: Column(
            children: <Widget>[
              _buildList(),
              _buildCensus(),
              Constant.header(
                '使用说明',
                0xe648,
              ),
              _buildHelpInfo(),
            ],
          ),
        ),
      ),
    );
  }

  ///构建统计图表组件
  ///
  Widget _buildCensus() {
    return Consumer(
        builder: (BuildContext context, QlcChartModel model, Widget child) {
      if (model.state == LoadState.loading) {
        return Card(
          elevation: 0,
          color: Color(0xff81e5cd),
          child: Container(
            width: MediaQuery.of(context).size.width * 0.92,
            height: Adaptor.height(510),
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
            height: Adaptor.height(510),
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
            height: Adaptor.height(510),
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
          child: Column(
            children: _createChart(model),
          ),
        );
      }
    });
  }

  Widget _buildList() {
    return Consumer(
        builder: (BuildContext context, QlcChartModel model, Widget child) {
      return Container(
        child: Column(
          children: <Widget>[
            _buildTitle(model),
            Constant.header(
              '选项类别',
              0xe698,
            ),
            _buildGridTab(model),
            Constant.header(
              '热度综合统计',
              0xe611,
            ),
          ],
        ),
      );
    });
  }

  Widget _buildTitle(QlcChartModel model) {
    String title = '';
    if (model.period != null) {
      title = '第${model.period}期七乐彩综合统计';
    }
    return Container(
      height: Adaptor.height(26),
      margin: EdgeInsets.fromLTRB(
        0,
        Adaptor.width(20),
        0,
        Adaptor.width(15),
      ),
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

  Widget _buildGridTab(QlcChartModel model) {
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
                    title: '12码',
                    index: 4,
                    border: 1,
                  ),
                  _buildGridCell(
                    model: model,
                    title: '18码',
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
                    title: '22码',
                    index: 6,
                    border: 1,
                  ),
                  _buildGridCell(
                    model: model,
                    title: '杀三码',
                    index: 7,
                    border: 1,
                    flex: 2,
                  ),
                  _buildGridCell(
                    model: model,
                    title: '杀六码',
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
      {QlcChartModel model,
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

  List<double> _parseData(List data) {
    return List.of(data.map((item) => double.parse(item.toString())));
  }

  ///创建综合分析图表
  ///
  List<Widget> _createChart(QlcChartModel model) {
    List<Widget> charts = List();
    int start = 0;
    for (int i = 0; i <= 2; i++) {
      start = i * 10;
      int end = (i + 1) * 10;
      List<double> level10 =
          _parseData(model.getData().level10.sublist(start, end));
      List<double> level20 =
          _parseData(model.getData().level20.sublist(start, end));
      List<double> level50 =
          _parseData(model.getData().level50.sublist(start, end));
      List<double> level100 =
          _parseData(model.getData().level100.sublist(start, end));
      List<String> axis = _categories.sublist(start, end);
      LineChart chart = LineChart(
        data: LineData(
          categories: axis,
          datas: [level10, level20, level50, level100],
          dotColor: Colors.white,
          maxColor: Colors.blueAccent,
          minColor: Colors.redAccent,
          showExtreme: false,
          isCurve: false,
          showTitle: i == 0,
        ),
        padding: EdgeInsets.symmetric(vertical: Adaptor.width(10)),
        width: MediaQuery.of(context).size.width * 0.92,
        height: Adaptor.height(i == 0 ? 190 : 160),
      );
      charts.add(chart);
    }
    return charts;
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
            '1.综合分析是将收费专家预测数据按红球双胆、三胆、12码、18码、22码、杀三码、杀六码指标进行的统计分析。'
            '统计图中四条统计曲线(由下到上)分别对应：排名前10、排名前20、排名前50、排名前100的收费专家统计信息。',
            style: TextStyle(
              fontSize: Adaptor.sp(12),
              color: Colors.black38,
            ),
          ),
          Text(
            '2.这些指标根据评判标准主要分为两大类，一类是统计数值越大越好，如：18码、22码指标；另一类是统计值越小越好，如：杀三码指标。',
            style: TextStyle(
              fontSize: Adaptor.sp(12),
              color: Colors.black38,
            ),
          ),
          Text(
            '3.如何通过综合统计选出1~2胆码？'
            '首先，我们可以通过杀码等指标选出统计值较小的号码；'
            '其次，通过18码、22码指标选出统计值较大的号码；'
            '再次，在综合其他指标相互印证，确定1~2个号码。',
            style: TextStyle(
              fontSize: Adaptor.sp(12),
              color: Colors.black38,
            ),
          ),
          Text(
            '4.关于综合统计指标的使用，由于预测数据存在波动性，需要您在使用过程中多观察、多总结，相信一定能为您带来意想不到的收获。',
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
