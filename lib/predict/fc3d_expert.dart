import 'dart:core';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_easyrefresh/delivery_header.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_easyrefresh/phoenix_footer.dart';
import 'package:lottery_app/commons/app_navigator.dart';
import 'package:lottery_app/commons/constants.dart';
import 'package:lottery_app/commons/mappbar.dart';
import 'package:lottery_app/components/empty_widget.dart';
import 'package:lottery_app/components/error_widget.dart';
import 'package:lottery_app/components/issue_notice.dart';
import 'package:lottery_app/model/fc3d_expert.dart';
import 'package:lottery_app/predict/fc3d_predict_detail.dart';
import 'package:lottery_app/predict/fc3d_predict_view.dart';
import 'package:provider/provider.dart';
import 'package:lottery_app/components/adaptor.dart';

class ExpertFc3dPage extends StatefulWidget {
  @override
  ExpertFc3dPageState createState() => new ExpertFc3dPageState();
}

class ExpertFc3dPageState extends State<ExpertFc3dPage> {
  EasyRefreshController _controller = EasyRefreshController();

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: ChangeNotifierProvider(
        create: (_) => Fc3dExpertModel.initialize(),
        child: Scaffold(
          body: Column(
            children: <Widget>[
              NavAppBar(
                title: '福彩3D频道',
                fontColor: Color(0xFF59575A),
                color: Color(0xFFF9F9F9),
                left: Container(
                  height: Adaptor.height(32),
                  width: Adaptor.width(32),
                  alignment: Alignment.centerLeft,
                  child: Icon(
                    IconData(Constant.backIcon, fontFamily: 'iconfont'),
                    size: Adaptor.sp(16),
                    color: Color(0xFF59575A),
                  ),
                ),
              ),
              IssueNotice(
                notice: '开奖日19:30~22:30时段不可发布预测',
              ),
              _buildFc3dForecastList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFc3dForecastList() {
    return Consumer<Fc3dExpertModel>(
      builder: (BuildContext context, Fc3dExpertModel model, Widget child) {
        Widget view = null;
        if (model.loaded) {
          if (model.error) {
            view = Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ErrorView(
                    color: Colors.black26,
                    message: '出错啦，点击重试',
                    callback: () {
                      model.loadForecastInfo();
                    }),
              ],
            );
          } else {
            view = EasyRefresh(
              controller: _controller,
              header: DeliveryHeader(),
              footer: PhoenixFooter(),
              emptyWidget: model.list.length == 0
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        EmptyView(
                          icon: 'assets/images/empty.png',
                          message: '没有预测记录',
                          size: 98,
                          margin: EdgeInsets.only(top: 0),
                          callback: () {
                            model.loadForecastInfo();
                          },
                        ),
                      ],
                    )
                  : null,
              child: ListView.builder(
                  itemCount: model.list.length,
                  padding: EdgeInsets.only(
                    bottom: Adaptor.width(32),
                  ),
                  itemBuilder: (BuildContext context, int index) {
                    return _buildForecastItem(model.list[index]);
                  }),
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
            );
          }
        } else {
          view = Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width,
                child: Constant.loading(),
              ),
            ],
          );
        }
        return Expanded(
          child: Stack(
            children: <Widget>[
              view,
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  color: Colors.white,
                  child: GestureDetector(
                    onTap: () {
                      if (model.loaded &&
                          model.issueSwitch != null &&
                          model.issueSwitch.enable == 1 &&
                          model.issueSwitch.predictable == 1) {
                        AppNavigator.push(
                          context,
                          Fc3dPredictPage(
                            period: model.issueSwitch.period,
                          ),
                          login: true,
                        ).then((value) {
                          if (value != null) {
                            model.loadForecastInfo();
                          }
                        });
                        return;
                      }
                      EasyLoading.showToast('暂不可发布预测');
                    },
                    child: Container(
                      height: Adaptor.height(40),
                      margin: EdgeInsets.only(
                        left: Adaptor.width(32),
                        right: Adaptor.width(32),
                        top: Adaptor.width(16),
                        bottom: Adaptor.width(16),
                      ),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(Adaptor.width(2)),
                      ),
                      child: Text(
                        model.hintText(),
                        style: TextStyle(
                          color: (model.loaded &&
                                  model.issueSwitch != null &&
                                  model.issueSwitch.enable == 1 &&
                                  model.issueSwitch.predictable == 1)
                              ? Colors.redAccent
                              : Colors.black38,
                          fontSize: Adaptor.sp(16),
                        ),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }

  Widget _buildForecastItem(ForecastBrief brief) {
    return GestureDetector(
      onTap: () {
        AppNavigator.push(context, Fc3dPredictDetail(period: brief.period));
      },
      child: Container(
        padding: EdgeInsets.only(
          left: Adaptor.width(16),
          right: Adaptor.width(16),
          top: Adaptor.width(12),
          bottom: Adaptor.width(12),
        ),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Colors.grey.withOpacity(0.2),
              width: Adaptor.width(0.4),
            ),
          ),
        ),
        child: Row(
          children: <Widget>[
            Text(
              '福彩3D第${brief.period}期预测',
              style: TextStyle(
                color: Colors.black54,
                height: 1.3,
                fontSize: Adaptor.sp(14),
              ),
            ),
            Icon(
              IconData(0xe602, fontFamily: 'iconfont'),
              size: Adaptor.sp(16),
              color: Colors.black54,
            )
          ],
        ),
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
  void didUpdateWidget(ExpertFc3dPage oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }
}
