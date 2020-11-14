import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:lottery_app/commons/http_request.dart';
import 'package:lottery_app/components/adaptor.dart';

class SubScribeWidget extends StatefulWidget {
  ///专家类型
  ///
  String type;

  ///专家id
  ///
  String master;

  ///是否已订阅
  int subscribe;

  SubScribeWidget({
    @required this.type,
    @required this.master,
    @required this.subscribe,
  });

  @override
  SubScribeWidgetState createState() => new SubScribeWidgetState();
}

class SubScribeWidgetState extends State<SubScribeWidget> {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Column(
        children: <Widget>[
          Offstage(
            offstage: widget.subscribe != 0,
            child: Container(
              width: Adaptor.width(76),
              margin: EdgeInsets.only(right: Adaptor.width(15)),
              child: InkWell(
                onTap: () {
                  subscribeMaster(widget.master, widget.type, () {
                    setState(() {
                      widget.subscribe = 1;
                    });
                  });
                },
                child: Container(
                  height: Adaptor.height(28),
                  padding: EdgeInsets.fromLTRB(
                    Adaptor.width(6),
                    Adaptor.width(2),
                    Adaptor.width(6),
                    Adaptor.width(2),
                  ),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: Color(0xffFF421A),
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(3.0)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        '订阅Ta',
                        style: TextStyle(
                            color: Colors.white, fontSize: Adaptor.sp(15)),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: Adaptor.width(2)),
                        child: Icon(
                          IconData(
                            0xe662,
                            fontFamily: 'iconfont',
                          ),
                          size: Adaptor.sp(14),
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Offstage(
            offstage: widget.subscribe != 1,
            child: Container(
              width: Adaptor.width(76),
              margin: EdgeInsets.only(right: Adaptor.width(15)),
              child: InkWell(
                onTap: () {
                  EasyLoading.showToast('您已订阅');
                },
                child: Container(
                  height: Adaptor.height(28),
                  padding: EdgeInsets.fromLTRB(
                    Adaptor.width(6),
                    Adaptor.width(2),
                    Adaptor.width(6),
                    Adaptor.width(2),
                  ),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: Color(0xffFF421A),
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(3.0)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        '已订阅',
                        style: TextStyle(
                            color: Colors.white, fontSize: Adaptor.sp(15)),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: Adaptor.width(2)),
                        child: Icon(
                          IconData(
                            0xe61d,
                            fontFamily: 'iconfont',
                          ),
                          size: Adaptor.sp(14),
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  void subscribeMaster(
    String masterId,
    String type,
    Function success,
  ) {
    HttpRequest request = HttpRequest.instance();
    Map<String, dynamic> params = Map<String, dynamic>();
    params['masterId'] = masterId;
    params['type'] = type;
    request.getJson('/subscribe/', params: params).then((response) {
      Map<String, dynamic> data = response.data;
      if (data['status'] == 200) {
        success();
      }
      EasyLoading.showToast(data['message']);
    }).catchError((error) {
      EasyLoading.showToast('关注失败');
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
