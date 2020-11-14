import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyrefresh/delivery_header.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_easyrefresh/phoenix_footer.dart';
import 'package:lottery_app/commons/constants.dart';
import 'package:lottery_app/commons/mappbar.dart';
import 'package:lottery_app/components/adaptor.dart';
import 'package:lottery_app/components/empty_widget.dart';
import 'package:lottery_app/components/error_widget.dart';
import 'package:lottery_app/components/load_state.dart';
import 'package:lottery_app/model/user_order.dart';
import 'package:provider/provider.dart';

class UserOrdersPage extends StatefulWidget {
  @override
  UserOrdersPageState createState() => new UserOrdersPageState();
}

//订单状态消息
final Map<int, String> states = Map()
  ..[0] = '支付失败'
  ..[1] = '待支付'
  ..[2] = '支付完成'
  ..[3] = '订单关闭';

//支付渠道
final Map<int, String> channels = Map()
  ..[1] = '微信购买'
  ..[2] = '支付宝购买';

class UserOrdersPageState extends State<UserOrdersPage> {
  EasyRefreshController _controller = EasyRefreshController();

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: ChangeNotifierProvider<UserOrderModel>(
        create: (_) => UserOrderModel.initialize(),
        child: Scaffold(
          body: Column(
            children: <Widget>[
              MAppBar('我的订单'),
              _buildOrderView(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOrderView() {
    return Consumer<UserOrderModel>(
        builder: (BuildContext context, UserOrderModel model, Widget child) {
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
            emptyWidget: model.orders.length == 0
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      EmptyView(
                        icon: 'assets/images/empty.png',
                        message: '没有订单记录',
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
              itemCount: model.orders.length,
              padding: EdgeInsets.only(
                top: Adaptor.width(12),
                bottom: Adaptor.width(32),
              ),
              itemBuilder: (BuildContext context, int index) {
                return _buildOrderItem(model.orders[index]);
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

  Widget _buildOrderItem(OrderInfo order) {
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
          Container(
            padding: EdgeInsets.only(left: Adaptor.width(16)),
            margin: EdgeInsets.only(
              top: Adaptor.width(12),
              bottom: Adaptor.width(4),
            ),
            alignment: Alignment.centerLeft,
            child: Text(
              '订单号  ${order.orderNo}',
              style: TextStyle(
                color: Colors.black87,
                fontSize: Adaptor.sp(14),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              left: Adaptor.width(16),
              right: Adaptor.width(16),
              top: Adaptor.width(4),
              bottom: Adaptor.width(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Text(
                      '${channels[order.channel]}',
                      style: TextStyle(
                        color: Colors.black38,
                        fontSize: Adaptor.sp(14),
                        height: 1.2,
                      ),
                    ),
                    Text(
                      '${order.desc}',
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: Adaptor.sp(16),
                      ),
                    )
                  ],
                ),
                Text(
                  '实付${order.price}元',
                  style: TextStyle(
                    color: Colors.redAccent,
                    fontSize: Adaptor.sp(14),
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              left: Adaptor.width(16),
              right: Adaptor.width(16),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  '${states[order.status]}',
                  style: TextStyle(
                    color: Colors.redAccent,
                    fontSize: Adaptor.sp(13),
                  ),
                ),
                Text(
                  '${order.updateTime}',
                  style: TextStyle(
                    color: Colors.black38,
                    fontSize: Adaptor.sp(14),
                  ),
                )
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
