import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottery_app/model/package_buy.dart';
import 'package:lottery_app/components/adaptor.dart';

class VipPackageView extends StatefulWidget {
  Function(VipPackage) onSelected;

  VipPackage data;

  bool selected;

  EdgeInsets margin;

  double height;

  VipPackageView({
    @required this.onSelected,
    @required this.data,
    @required this.selected,
    @required this.margin,
    @required this.height,
  });

  @override
  VipPackageViewState createState() => new VipPackageViewState();
}

class VipPackageViewState extends State<VipPackageView> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.onSelected(widget.data);
      },
      child: Container(
        margin: widget.margin,
        child: Stack(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(top: Adaptor.width(8)),
              child: Container(
                padding: EdgeInsets.only(
                  left: Adaptor.width(5),
                  right: Adaptor.width(5),
                  top: 0,
                  bottom: Adaptor.width(6),
                ),
                height: widget.height,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: widget.selected ? Color(0xffFDF1D9) : Colors.white,
                  border: Border.all(
                    color:
                        widget.selected ? Color(0xffD9C483) : Color(0xffEFF1EE),
                    width: Adaptor.width(1.5),
                  ),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.only(left: Adaptor.width(8)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(bottom: Adaptor.width(4)),
                            child: Text(
                              '${widget.data.name}',
                              style: TextStyle(
                                color: Colors.black.withOpacity(0.60),
                                fontSize: Adaptor.sp(15),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          Text(
                            '${widget.data.desc}',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Colors.black38,
                              fontSize: Adaptor.sp(12),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        right: Adaptor.width(8),
                        top: Adaptor.width(6),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            '¥',
                            style: TextStyle(
                              color: Color(0xffF1CA61),
                              fontSize: Adaptor.sp(20),
                              fontWeight: FontWeight.w500,
                              height: 1.5,
                            ),
                          ),
                          Text(
                            '${widget.data.discount}',
                            style: TextStyle(
                              color: Color(0xffF1CA61),
                              fontSize: Adaptor.sp(26),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              top: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(
                      left: Adaptor.width(8),
                      right: Adaptor.width(8),
                      top: Adaptor.width(2),
                      bottom: Adaptor.width(2),
                    ),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [
                        Color(0xffCA13E7).withOpacity(0.68),
                        Color(0xff6D17E8).withOpacity(0.68)
                      ]),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(6),
                        topRight: Radius.circular(6),
                      ),
                    ),
                    child: Text(
                      '原价${widget.data.price}元',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: Adaptor.sp(12),
                      ),
                    ),
                  )
                ],
              ),
            ),
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
}
