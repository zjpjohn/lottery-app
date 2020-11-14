import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottery_app/commons/app_navigator.dart';
import 'package:lottery_app/commons/config.dart';
import 'package:lottery_app/commons/tag_clipper.dart';
import 'package:lottery_app/commons/tools.dart';
import 'package:lottery_app/commons/wave.dart';
import 'package:lottery_app/components/avatar_identity.dart';
import 'package:lottery_app/components/adaptor.dart';

class ForecastCard extends StatelessWidget {
  String name;
  String rate;
  int series;
  Widget page;
  EdgeInsets margin;

  ForecastCard({this.name, this.rate, this.series, this.page, this.margin});

  @override
  Widget build(BuildContext context) {
    String avatar = '';
    if (name != null) {
      String s = name.toUpperCase();
      for (int i = 0; i < s.length; i++) {
        String item = s.substring(i, i + 1);
        if (zhcnRegex.hasMatch(item)) {
          avatar = item;
          break;
        }
      }
    }
    return Container(
      margin: margin,
      height: Adaptor.height(56),
      width: Adaptor.width(150),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4.0),
      ),
      child: GestureDetector(
        onTap: () {
          AppNavigator.push(context, page, login: true);
        },
        child: Stack(
          children: <Widget>[
            Positioned(
              left: 0,
              top: Adaptor.height(26),
              child: Container(
                width: Adaptor.width(150),
                height: Adaptor.height(30),
                child: Card(
                  color: Colors.transparent,
                  elevation: 0,
                  margin: EdgeInsets.all(0.0),
                  clipBehavior: Clip.antiAlias,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(4.0),
                    ),
                  ),
                  child: WaveWidget(
                    config: CustomConfig(
                      colors: [
                        const Color(0x02000000),
                        const Color(0x05000000),
                        const Color(0x08000000),
                      ],
                      heightPercentages: [0.20, 0.28, 0.36],
                      blur: MaskFilter.blur(BlurStyle.normal, 0.0),
                    ),
                    backgroundColor: Colors.transparent,
                    size: Size(double.infinity, double.infinity),
                    waveAmplitude: 0,
                  ),
                ),
              ),
            ),
            Container(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  ClipPath(
                    clipper: TagClipper(),
                    child: Container(
                      margin: EdgeInsets.fromLTRB(
                        Adaptor.width(6),
                        Adaptor.width(1),
                        Adaptor.width(6),
                        0,
                      ),
                      padding: EdgeInsets.fromLTRB(
                        Adaptor.width(2),
                        Adaptor.width(3),
                        Adaptor.width(2),
                        Adaptor.width(7),
                      ),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Color(0xFFFF5C01),
                            Color(0xBBFF5C01),
                          ],
                        ),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: series > 0
                            ? <Widget>[
                                Text(
                                  '连中',
                                  style: TextStyle(
                                    fontSize: Adaptor.sp(10),
                                    color: Colors.white,
                                  ),
                                ),
                                Text(
                                  '$series',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: Adaptor.sp(13),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ]
                            : <Widget>[
                                Text(
                                  '上期',
                                  style: TextStyle(
                                    fontSize: Adaptor.sp(10),
                                    color: Colors.white,
                                  ),
                                ),
                                Text(
                                  '未中',
                                  style: TextStyle(
                                    fontSize: Adaptor.sp(10),
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                      ),
                    ),
                  ),
                  Container(
                    height: Adaptor.height(56),
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          Tools.limitText(name, 5),
                          style: TextStyle(
                            color: Colors.black87,
                            fontSize: Adaptor.sp(13),
                          ),
                        ),
                        Text(
                          rate,
                          style: TextStyle(
                            color: Color(0xffFF512F),
                            fontWeight: FontWeight.w400,
                            fontSize: Adaptor.sp(16),
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    height: Adaptor.height(56),
                    alignment: Alignment.center,
                    padding: EdgeInsets.fromLTRB(Adaptor.width(4),
                        Adaptor.width(4), Adaptor.width(12), Adaptor.width(4)),
                    child: ShaderMask(
                      shaderCallback: (bounds) {
                        return LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            const Color(0x40FF4600),
                            const Color(0x15FF4600),
                          ],
                        ).createShader(Offset.zero & bounds.size);
                      },
                      child: Text(
                        avatar,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: Adaptor.sp(26),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
