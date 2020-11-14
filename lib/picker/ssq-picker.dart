import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottery_app/commons/app_navigator.dart';
import 'package:lottery_app/commons/custom_scroll_physics.dart';
import 'package:lottery_app/commons/line_chart.dart';
import 'package:lottery_app/commons/mappbar.dart';
import 'package:lottery_app/commons/constants.dart';
import 'package:lottery_app/components/adaptor.dart';
import 'package:lottery_app/components/error_widget.dart';
import 'package:lottery_app/components/load_state.dart';
import 'package:lottery_app/components/pay_notice.dart';
import 'package:lottery_app/model/ssq_picker.dart';
import 'package:lottery_app/package/vip-package.dart';
import 'package:provider/provider.dart';

class SsqPickerPage extends StatefulWidget {
  @override
  SsqPickerPageState createState() => new SsqPickerPageState();
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
  '30',
  '31',
  '32',
  '33'
];
const List<String> _bCategories = [
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
  '16'
];

class SsqPickerPageState extends State<SsqPickerPage> {
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: ChangeNotifierProvider(
        create: (_) => SsqPickerModel.initialize(),
        child: Scaffold(
          body: Column(
            children: <Widget>[
              MAppBar('热门精选'),
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

  Widget _buildTitle() {
    return Consumer(
        builder: (BuildContext context, SsqPickerModel model, Widget child) {
      return Container(
        height: Adaptor.height(80),
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(bottom: Adaptor.width(8)),
              child: Text(
                model.period != null ? '第${model.period}期双色球热门统计' : '',
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

  Widget _buildGridTab() {
    return Consumer(
        builder: (BuildContext context, SsqPickerModel model, Widget child) {
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
                      Color(0xff91be1e),
                      Color(0xffd7e66d),
                    ],
                  ),
                ),
                child: Row(
                  children: <Widget>[
                    _buildGridCell(
                      model: model,
                      title: '20码',
                      index: 4,
                      border: 1,
                    ),
                    _buildGridCell(
                      model: model,
                      title: '25码',
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
                      title: '蓝三',
                      index: 8,
                      border: 1,
                    ),
                    _buildGridCell(
                      model: model,
                      title: '蓝五',
                      index: 9,
                      border: 1,
                      flex: 2,
                    ),
                    _buildGridCell(
                      model: model,
                      title: '杀蓝',
                      index: 10,
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
      {SsqPickerModel model,
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

  ///创建图表
  ///
  Widget _createLineChart() {
    return Consumer(
        builder: (BuildContext context, SsqPickerModel model, Widget child) {
      if (model.state == LoadState.loading) {
        return Card(
          elevation: 0,
          color: Color(0xff81e5cd),
          child: Container(
            width: MediaQuery.of(context).size.width * 0.92,
            height: Adaptor.height(model.selectedIndex <= 7 ? 330 : 200),
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
            height: Adaptor.height(model.selectedIndex <= 7 ? 330 : 200),
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
            height: Adaptor.height(model.selectedIndex <= 7 ? 330 : 200),
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
        List<Widget> charts = List();

        List<double> datas = model.getData();

        if (model.selectedIndex <= 7) {
          int start = 0;
          for (int i = 0; i <= 2; i++) {
            start = i * 11;
            int end = (i + 1) * 11;
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
        } else {
          ///蓝球统计
          ///
          int start = 0;
          for (int i = 0; i <= 1; i++) {
            start = i * 8;
            int end = (i + 1) * 8;
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
        }
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
            '1.热门专家说明：至少连续五期都是收费专家，那么该专家将会被入选热门专家。',
            style: TextStyle(
              fontSize: Adaptor.sp(12),
              color: Colors.black38,
            ),
          ),
          Text(
            '2.热门统计分析是将收费专家预测数据按红球独胆、双胆、三胆、12码、20码、25码、杀三码、杀六码，以及蓝球三码、五码、杀码指标进行的统计分析。',
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

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }
}
