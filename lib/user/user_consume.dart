import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyrefresh/delivery_header.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_easyrefresh/phoenix_footer.dart';
import 'package:lottery_app/commons/constants.dart';
import 'package:lottery_app/commons/mappbar.dart';
import 'package:lottery_app/commons/tools.dart';
import 'package:lottery_app/components/adaptor.dart';
import 'package:lottery_app/components/empty_widget.dart';
import 'package:lottery_app/components/error_widget.dart';
import 'package:lottery_app/components/load_state.dart';
import 'package:lottery_app/model/user_consume.dart';
import 'package:provider/provider.dart';

class UserConsumePage extends StatefulWidget {
  @override
  UserConsumePageState createState() => new UserConsumePageState();
}

///彩票类型
final Map<String, String> lotteries = Map()
  ..['fc3d'] = '福彩3D'
  ..['pl3'] = '排列三'
  ..['ssq'] = '双色球'
  ..['dlt'] = '大乐透'
  ..['qlc'] = '七乐彩';

class UserConsumePageState extends State<UserConsumePage> {
  EasyRefreshController _controller = EasyRefreshController();

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: ChangeNotifierProvider<UserConsumeModel>(
        create: (_) => UserConsumeModel.initialize(),
        child: Scaffold(
          backgroundColor: Colors.white,
          body: Column(
            children: <Widget>[
              NavAppBar(
                title: '消费记录',
                fontColor: Color(0xFF59575A),
                left: Container(
                  height: Adaptor.width(32),
                  width: Adaptor.height(32),
                  alignment: Alignment.centerLeft,
                  child: Icon(
                    IconData(Constant.backIcon, fontFamily: 'iconfont'),
                    size: Adaptor.sp(16),
                    color: Color(0xFF59575A),
                  ),
                ),
              ),
              _buildContentView(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContentView() {
    return Consumer(
        builder: (BuildContext context, UserConsumeModel model, Widget child) {
      if (model.state == LoadState.loading) {
        return Flexible(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
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
                  message: '出错啦，点击重试',
                  callback: () {
                    model.initial();
                  }),
            ],
          ),
        );
      }
      if (model.state == LoadState.success) {
        return Expanded(
          child: EasyRefresh(
            controller: _controller,
            header: DeliveryHeader(),
            footer: PhoenixFooter(),
            emptyWidget: model.consumes.length == 0
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      EmptyView(
                        icon: 'assets/images/empty.png',
                        message: '没有消费记录',
                        size: 98,
                        margin: EdgeInsets.only(top: 0),
                        callback: () {
                          model.initial();
                        },
                      ),
                    ],
                  )
                : null,
            child: ListView.builder(
              itemCount: model.consumes.length,
              padding: EdgeInsets.only(
                top: Adaptor.width(12),
                bottom: Adaptor.width(32),
              ),
              itemBuilder: (BuildContext context, int index) {
                return _buildConsumeItem(model.consumes[index]);
              },
            ),
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
          ),
        );
      }
    });
  }

  Widget _buildConsumeItem(LookConsume consume) {
    return Container(
      padding: EdgeInsets.only(bottom: Adaptor.width(16)),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.grey.withOpacity(0.2),
            width: Adaptor.width(0.4),
          ),
        ),
      ),
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(
              top: Adaptor.width(16),
              left: Adaptor.width(16),
              right: Adaptor.width(16),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  '${Tools.limitName(consume.master, 10)}',
                  style: TextStyle(
                    fontSize: Adaptor.sp(16),
                    color: Colors.black87,
                  ),
                ),
                Text(
                  '${lotteries[consume.lottery]}',
                  style: TextStyle(
                    fontSize: Adaptor.sp(16),
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              top: Adaptor.width(8),
              left: Adaptor.width(16),
              right: Adaptor.width(16),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  '第${consume.period}期',
                  style: TextStyle(
                    color: Colors.black38,
                    fontSize: Adaptor.sp(13),
                  ),
                ),
                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        '消费${consume.valence}金币',
                        style: TextStyle(
                          color: Colors.redAccent,
                          fontSize: Adaptor.sp(12),
                        ),
                      ),
                      consume.voucher > 0
                          ? Text(
                              '消费${consume.voucher}代金券',
                              style: TextStyle(
                                color: Colors.redAccent,
                                fontSize: Adaptor.sp(12),
                              ),
                            )
                          : Container(
                              child: null,
                            ),
                    ],
                  ),
                ),
              ],
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
