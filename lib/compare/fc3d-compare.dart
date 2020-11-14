import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:lottery_app/commons/app_navigator.dart';
import 'package:lottery_app/commons/mappbar.dart';
import 'package:lottery_app/commons/tools.dart';
import 'package:lottery_app/commons/constants.dart';
import 'package:lottery_app/components/adaptor.dart';
import 'package:lottery_app/components/error_widget.dart';
import 'package:lottery_app/components/load_state.dart';
import 'package:lottery_app/components/pay_notice.dart';
import 'package:lottery_app/master/fc3d-master.dart';
import 'package:lottery_app/model/fc3d_compare.dart';
import 'package:lottery_app/package/vip-package.dart';
import 'package:provider/provider.dart';

class Fc3dComparePage extends StatefulWidget {
  @override
  Fc3dComparePageState createState() => new Fc3dComparePageState();
}

class Fc3dComparePageState extends State<Fc3dComparePage> {
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: ChangeNotifierProvider(
        create: (_) => Fc3dCompareModel.initialize(),
        child: Scaffold(
          backgroundColor: Colors.white,
          body: Column(
            children: <Widget>[
              MAppBar('福彩3D专家对比'),
              _buildList(),
              _buildCompare(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildList() {
    return Consumer(
        builder: (BuildContext context, Fc3dCompareModel model, Widget child) {
      return Container(
        margin: EdgeInsets.only(
          top: Adaptor.width(16),
        ),
        child: Column(
          children: <Widget>[
            Constant.header(
              '专家PK类型',
              0xe698,
            ),
            _buildGridTab(model),
            Constant.header(
              '专家排名',
              0xe624,
            ),
            _buildLevelTab(model),
          ],
        ),
      );
    });
  }

  Widget _buildGridTab(Fc3dCompareModel model) {
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
                    title: '五码',
                    index: 3,
                    border: 1,
                  ),
                  _buildGridCell(
                    model: model,
                    title: '六码',
                    index: 4,
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
                    index: 5,
                    border: 1,
                  ),
                  _buildGridCell(
                    model: model,
                    title: '杀一码',
                    index: 6,
                    border: 1,
                    flex: 2,
                  ),
                  _buildGridCell(
                    model: model,
                    title: '杀二码',
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
  }

  Widget _buildGridCell(
      {Fc3dCompareModel model,
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

  Widget _buildLevelTab(Fc3dCompareModel model) {
    return Container(
      margin: EdgeInsets.fromLTRB(0, Adaptor.width(12), 0, Adaptor.width(12)),
      height: Adaptor.height(28),
      child: Container(
        child: ListView(
          padding: EdgeInsets.fromLTRB(0, 0, Adaptor.width(10), 0),
          scrollDirection: Axis.horizontal,
          children: <Widget>[
            _buildLevel(model, '前5', 5, 14),
            _buildLevel(model, '前10', 10, 0),
            _buildLevel(model, '前15', 15, 0),
            _buildLevel(model, '前20', 20, 0),
          ],
        ),
      ),
    );
  }

  Widget _buildLevel(
    Fc3dCompareModel model,
    String name,
    int index,
    double margin,
  ) {
    TextStyle style = new TextStyle(
      color: Colors.black54,
      fontSize: Adaptor.sp(14),
    );
    if (model.level == index) {
      style = new TextStyle(
        color: Color(0xffF43F3B),
        fontSize: Adaptor.sp(14),
      );
    }
    return Container(
      alignment: Alignment.center,
      margin:
          EdgeInsets.fromLTRB(Adaptor.width(margin), 0, Adaptor.width(16), 0),
      child: GestureDetector(
        onTap: () {
          model.level = index;
        },
        child: Container(
          height: Adaptor.height(26),
          alignment: Alignment.center,
          padding:
              EdgeInsets.fromLTRB(Adaptor.width(14), 0, Adaptor.width(14), 0),
          decoration: BoxDecoration(
            color: Color(0xfff7f7f7),
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(Adaptor.width(2.0)),
          ),
          child: Text(
            name,
            style: style,
          ),
        ),
      ),
    );
  }

  List<Widget> _seriesView(var data) {
    List<Widget> views = new List();
    views.add(Container(
      child: Text(
        '${data.rate}/',
        style: TextStyle(color: Colors.black54, fontSize: Adaptor.sp(12)),
      ),
    ));
    if (data.series > 0) {
      views.add(Text(
        '连中',
        style: TextStyle(color: Colors.black54, fontSize: Adaptor.sp(12)),
      ));
      views.add(Text(
        '${data.series}',
        style: TextStyle(color: Color(0xFFFF512F), fontSize: Adaptor.sp(12)),
      ));
      views.add(Text(
        '期',
        style: TextStyle(color: Colors.black54, fontSize: Adaptor.sp(12)),
      ));
    } else {
      views.add(Text(
        '上期未中',
        style: TextStyle(color: Color(0xFFFF512F), fontSize: Adaptor.sp(12)),
      ));
    }
    return views;
  }

  Widget _itemView(Fc3dCompareModel model, var data, double top) {
    return GestureDetector(
      onTap: () {
        AppNavigator.push(
          context,
          Fc3dMasterPage(
            data.masterId,
            index: model.selectedIndex + 1,
          ),
        );
      },
      child: Container(
        padding: EdgeInsets.fromLTRB(
          0,
          Adaptor.width(top),
          0,
          Adaptor.width(8),
        ),
        margin: EdgeInsets.only(
          bottom: Adaptor.width(8),
        ),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Colors.black26,
              width: Adaptor.width(0.2),
            ),
          ),
        ),
        alignment: Alignment.center,
        child: Column(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(
                bottom: Adaptor.width(5),
              ),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Text(
                      '${model.period}期' + Tools.limitName(data.name, 7),
                      style: TextStyle(
                        color: Color(0xff5c5c5c),
                        fontSize: Adaptor.sp(12),
                      ),
                    ),
                    flex: 2,
                  ),
                  Expanded(
                    child: Container(
                      alignment: Alignment.center,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: _seriesView(data),
                      ),
                    ),
                    flex: 1,
                  )
                ],
              ),
            ),
            Container(
              alignment: Alignment.center,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  new Container(
                    margin: EdgeInsets.only(
                      right: Adaptor.width(10),
                    ),
                    child: Text(
                      '预测数据',
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: Adaptor.sp(14),
                        height: 1.2,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      alignment: Alignment.center,
                      child: new Wrap(
                        children: _hitViews(model.open, data.values),
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  List<Widget> _hitViews(int open, List data) {
    List<Widget> views = new List();
    if (open == 1) {
      data.forEach((item) {
        if (item.v == 0) {
          views.add(new Container(
            margin: EdgeInsets.only(right: Adaptor.width(8)),
            child: Text(
              item.k,
              style: TextStyle(color: Colors.black54, fontSize: Adaptor.sp(15)),
            ),
          ));
        } else {
          views.add(new Container(
            margin: EdgeInsets.only(right: Adaptor.width(8)),
            child: Text(
              item.k,
              style:
                  TextStyle(color: Color(0xffF43F3B), fontSize: Adaptor.sp(15)),
            ),
          ));
        }
      });
    } else {
      data.forEach((item) {
        views.add(new Container(
          margin: EdgeInsets.only(right: Adaptor.width(8)),
          child: Text(
            item,
            style: TextStyle(color: Colors.black54, fontSize: Adaptor.sp(15)),
          ),
        ));
      });
    }
    return views;
  }

  Widget _buildCompare() {
    return Consumer(
        builder: (BuildContext context, Fc3dCompareModel model, Widget child) {
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
        return Flexible(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ErrorView(
                  message: '出错啦，点此重试',
                  callback: () {
                    model.loadData(model.selectedIndex);
                  }),
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
                message: '非会员无法查看',
                onTap: () {
                  AppNavigator.push(context, VipPackagesPage());
                },
              ),
            ],
          ),
        );
      }
      if (model.state == LoadState.success) {
        return Flexible(
          child: Container(
            color: Colors.white,
            child: ListView.builder(
                padding: EdgeInsets.fromLTRB(
                  Adaptor.width(14),
                  0,
                  Adaptor.width(14),
                  Adaptor.width(25),
                ),
                itemCount: model.getLevelData().length,
                physics: BouncingScrollPhysics(),
                itemBuilder: (BuildContext context, int index) {
                  return _itemView(
                      model, model.getLevelData()[index], index == 0 ? 8 : 0);
                }),
          ),
        );
      }
    });
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
