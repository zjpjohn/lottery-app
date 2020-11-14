import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottery_app/commons/app_navigator.dart';
import 'package:lottery_app/commons/constants.dart';
import 'package:lottery_app/commons/custom_scroll_physics.dart';
import 'package:lottery_app/commons/line_chart.dart';
import 'package:lottery_app/commons/mappbar.dart';
import 'package:lottery_app/components/adaptor.dart';
import 'package:lottery_app/components/error_widget.dart';
import 'package:lottery_app/components/load_state.dart';
import 'package:lottery_app/components/pay_notice.dart';
import 'package:lottery_app/model/qlc_bigshot.dart';
import 'package:lottery_app/package/vip-package.dart';
import 'package:provider/provider.dart';

class QlcBigshotPage extends StatefulWidget {
  @override
  QlcBigshotPageState createState() => new QlcBigshotPageState();
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

class QlcBigshotPageState extends State<QlcBigshotPage> {
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: ChangeNotifierProvider(
        create: (_) => QlcBigshotModel.initialize(),
        child: Scaffold(
          body: Column(
            children: <Widget>[
              MAppBar('牛人臻选'),
              _buildContent(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContent() {
    return Expanded(
      child: SingleChildScrollView(
        physics: EasyRefreshPhysics(topBouncing: false),
        child: Column(
          children: <Widget>[
            _buildTitle(),
            Constant.header(
              '选项类型',
              0xe698,
            ),
            _buildGridTab(),
            Constant.header(
              '热度统计',
              0xe611,
            ),
            _createLineChart(),
            Constant.header(
              '使用说明',
              0xe648,
            ),
            _buildHelpInfo(),
          ],
        ),
      ),
    );
  }

  Widget _buildGridTab() {
    return Consumer(
        builder: (BuildContext context, QlcBigshotModel model, Widget child) {
      return Padding(
        padding: EdgeInsets.only(
          left: Adaptor.width(14),
          right: Adaptor.width(14),
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
                      title: '独胆',
                      index: 0,
                      border: 1,
                    ),
                    _buildGridCell(
                      model: model,
                      title: '双胆',
                      index: 1,
                      border: 1,
                    ),
                    _buildGridCell(
                      model: model,
                      title: '三胆',
                      index: 2,
                      border: 1,
                    ),
                    _buildGridCell(
                      model: model,
                      title: '12码',
                      index: 3,
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
                      title: '18码',
                      index: 4,
                      border: 1,
                    ),
                    _buildGridCell(
                      model: model,
                      title: '22码',
                      index: 5,
                      border: 1,
                    ),
                    _buildGridCell(
                      model: model,
                      title: '杀三码',
                      index: 6,
                      border: 1,
                      flex: 1,
                    ),
                    _buildGridCell(
                      model: model,
                      title: '杀六码',
                      index: 7,
                      border: 0,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildGridCell(
      {QlcBigshotModel model,
      String title,
      int index,
      int border = 0,
      int flex = 1}) {
    return Expanded(
      flex: flex,
      child: GestureDetector(
        onTap: () {
          model.selectedIndex = index;
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
                    color: model.selectedIndex == index
                        ? Colors.white
                        : Colors.black26,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return Consumer(
        builder: (BuildContext context, QlcBigshotModel model, Widget child) {
      return Container(
        height: Adaptor.height(80),
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(bottom: Adaptor.width(10)),
              child: Text(
                model.period != null ? '第${model.period}期七乐彩牛人统计' : '',
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: Adaptor.sp(18),
                ),
              ),
            ),
            Container(
              child: Text(
                model.time != null ? '时间：${model.time}' : '',
                style: TextStyle(
                  color: Colors.black38,
                  fontSize: Adaptor.sp(13),
                ),
              ),
            )
          ],
        ),
      );
    });
  }

  ///创建图表
  ///
  Widget _createLineChart() {
    return Consumer(
        builder: (BuildContext context, QlcBigshotModel model, Widget child) {
      if (model.state == LoadState.loading) {
        return Card(
          elevation: 0,
          color: Color(0xff81e5cd),
          child: Container(
            width: MediaQuery.of(context).size.width * 0.92,
            height: Adaptor.height(330),
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
            height: Adaptor.height(330),
            child: Center(
              child: ErrorView(
                  message: model.message,
                  callback: () {
                    model.loadData();
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
            height: Adaptor.height(330),
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
        ///图表集合
        List<Widget> charts = List();

        ///数据
        List<double> datas = model.getData();

        int start = 0;
        for (int i = 0; i <= 2; i++) {
          start = i * 10;
          int end = (i + 1) * 10;
          List<double> data = datas.sublist(start, end);
          List<String> _category = _categories.sublist(start, end);
          LineChart chart = LineChart(
            data: LineData(
              categories: _category,
              datas: [data],
              dotColor: Colors.white,
              maxColor: Colors.blueAccent,
              minColor: Colors.redAccent,
              showExtreme: true,
              isCurve: false,
              showTitle: i == 0,
            ),
            padding: EdgeInsets.symmetric(vertical: Adaptor.width(10)),
            width: MediaQuery.of(context).size.width * 0.92,
            height: Adaptor.height(i == 0 ? 130 : 100),
          );
          charts.add(chart);
        }

        ///构建图表
        ///
        return Card(
          elevation: 0,
          color: Color(0xff81e5cd),
          child: Column(
            children: charts,
          ),
        );
      }
    });
  }

  Widget _buildHelpInfo() {
    return Container(
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.only(
        left: Adaptor.width(14),
        right: Adaptor.width(14),
        bottom: Adaptor.width(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            '1.七乐彩牛人专家说明：平台认为预测命中率最高的一部分专家，认为这部分具有丰富的经验的专家为牛人。',
            style: TextStyle(
              fontSize: Adaptor.sp(12),
              color: Colors.black38,
            ),
          ),
          Text(
            '2.热门统计分析是将收费专家预测数据按照独胆、双胆、三胆、12码、18码、22码、杀三码、杀六码指标进行的统计分析。',
            style: TextStyle(
              fontSize: Adaptor.sp(12),
              color: Colors.black38,
            ),
          ),
          Text(
            '3.关于热门统计指标，需要您在使用过程中多观察、多总结，相信一定能为您带来意想不到的收获。',
            style: TextStyle(
              fontSize: Adaptor.sp(12),
              color: Colors.black38,
            ),
          ),
        ],
      ),
    );
  }
}
