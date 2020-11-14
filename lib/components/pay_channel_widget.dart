import 'package:flutter/material.dart';
import 'package:lottery_app/components/adaptor.dart';

class PayChannelView extends StatelessWidget {
  PayChannel data;

  Function(PayChannel) onSelected;

  bool selected;

  PayChannelView({
    @required this.data,
    @required this.onSelected,
    this.selected: false,
  });

  @override
  Widget build(BuildContext context) {
    Widget view = Container(
      height: Adaptor.height(46),
      padding: EdgeInsets.fromLTRB(Adaptor.width(20), 0, Adaptor.width(12), 0),
      alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            child: Row(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(right: Adaptor.width(8)),
                  child: Opacity(
                    opacity: data.status == 2 ? 1 : 0.38,
                    child: Image.asset(
                      data.asset,
                      width: Adaptor.width(24),
                      height: Adaptor.height(24),
                    ),
                  ),
                ),
                Text(
                  data.name,
                  style: TextStyle(
                    fontSize: Adaptor.sp(16),
                    color: data.status == 2
                        ? (selected ? Color(0xff1E90FF) : Colors.black87)
                        : Colors.black26,
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(right: Adaptor.width(10)),
            child: Image.asset(
              selected
                  ? 'assets/images/checked.png'
                  : 'assets/images/checked_circle.png',
              width: Adaptor.width(22),
              height: Adaptor.height(22),
            ),
          )
        ],
      ),
    );
    if (data.status == 2) {
      return InkWell(
        onTap: () {
          if (!this.selected) {
            onSelected(data);
          }
        },
        child: view,
      );
    }
    return view;
  }
}

class PayChannel {
  ///支付渠道标识
  String channel;

  ///支付图片
  String asset;

  ///支付名称
  String name;

  int status;

  int priority;
}
