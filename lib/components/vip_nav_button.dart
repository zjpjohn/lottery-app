import 'package:flutter/material.dart';
import 'package:lottery_app/components/adaptor.dart';

class VipNavButton extends StatelessWidget {
  String name;

  String icon;

  EdgeInsets margin;

  Function onTap;

  VipNavButton({this.name, this.icon, this.margin, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      child: InkWell(
        onTap: () {
          onTap();
        },
        child: Container(
          padding: EdgeInsets.symmetric(vertical: Adaptor.width(4)),
          alignment: Alignment.center,
          child: Column(
            children: [
              Image.asset(
                icon,
                width: Adaptor.width(34),
                height: Adaptor.height(34),
              ),
              Padding(
                padding: EdgeInsets.only(top: Adaptor.width(4)),
                child: Text(
                  '$name',
                  style: TextStyle(
                      color: Colors.black54, fontSize: Adaptor.sp(12)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
