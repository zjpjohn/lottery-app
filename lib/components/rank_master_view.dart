import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottery_app/commons/tools.dart';
import 'package:lottery_app/commons/voucher_clipper.dart';
import 'package:lottery_app/components/adaptor.dart';

class RankMasterView extends StatelessWidget {
  String name;

  String avatar;

  Function onTap;

  EdgeInsets margin;

  int rank;

  List<Color> colors;

  RankMasterView(
      {this.name,
      this.avatar,
      this.margin,
      this.rank,
      this.colors,
      this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        onTap();
      },
      child: Container(
        height: Adaptor.height(68),
        margin: margin,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              width: Adaptor.width(52),
              height: Adaptor.height(52),
              margin:
                  EdgeInsets.fromLTRB(0, Adaptor.width(4), Adaptor.width(8), 0),
              child: CachedNetworkImage(
                width: Adaptor.width(52),
                height: Adaptor.height(52),
                fit: BoxFit.cover,
                imageUrl: avatar,
                placeholder: (context, uri) => Center(
                  child: SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 1.2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Colors.grey.withOpacity(0.1),
                      ),
                    ),
                  ),
                ),
                errorWidget: (context, url, error) => Icon(Icons.error),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(bottom: Adaptor.width(4)),
                  width: Adaptor.width(80),
                  height: Adaptor.height(38),
                  child: Text(
                    Tools.limitText(name, 8),
                    textAlign: TextAlign.start,
                    softWrap: true,
                    maxLines: 2,
                    overflow: TextOverflow.clip,
                    style: TextStyle(
                      fontSize: Adaptor.sp(13),
                      color: Colors.black,
                    ),
                  ),
                ),
                ClipPath(
                  clipper: VoucherClipper(),
                  child: Container(
                    width: Adaptor.width(20),
                    height: Adaptor.height(15),
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.only(left: Adaptor.width(4)),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(colors: colors),
                    ),
                    child: Text(
                      '$rank',
                      style: TextStyle(
                          fontSize: Adaptor.sp(12),
                          color: Colors.white,
                          fontWeight: FontWeight.w400),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
