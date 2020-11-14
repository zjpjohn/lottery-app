import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:lottery_app/commons/constants.dart';
import 'package:lottery_app/commons/mappbar.dart';
import 'package:lottery_app/components/adaptor.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qr_flutter/qr_flutter.dart';

class SharePosterPage extends StatefulWidget {
  ///二维码链接
  String qrUri;

  ///邀请码
  String code;

  SharePosterPage({@required this.qrUri, @required this.code});

  @override
  SharePosterPageState createState() => new SharePosterPageState();
}

class SharePosterPageState extends State<SharePosterPage> {
  ///[_key]
  GlobalKey _key = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: <Widget>[
            NavAppBar(
              title: '邀请海报',
              fontColor: Color(0xFF59575A),
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
              right: GestureDetector(
                onTap: () {
                  savePoster();
                },
                child: Container(
                  height: Adaptor.height(24),
                  alignment: Alignment.centerRight,
                  child: Text(
                    '保存到相册',
                    style: TextStyle(
                      color: Color(0xFF59575A),
                      fontSize: Adaptor.sp(14),
                    ),
                  ),
                ),
              ),
            ),
            _buildPosterWidget(),
          ],
        ),
      ),
    );
  }

  Widget _buildPosterWidget() {
    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(
              left: Adaptor.width(16),
              right: Adaptor.width(16),
            ),
            child: RepaintBoundary(
              key: _key,
              child: Stack(
                children: <Widget>[
                  Image.asset(
                    'assets/images/qrcode_bg.png',
                    fit: BoxFit.contain,
                  ),
                  Positioned(
                    top: Adaptor.width(16),
                    left: Adaptor.width(16),
                    child: Text(
                      '编号 ${widget.code}',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: Adaptor.sp(15),
                      ),
                    ),
                  ),
                  Positioned(
                    top: Adaptor.height(418),
                    left: Adaptor.width(196),
                    child: Container(
                      padding: EdgeInsets.all(Adaptor.width(3)),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Color(0xff1f8dff).withOpacity(0.3),
                          width: Adaptor.width(0.8),
                        ),
                        borderRadius: BorderRadius.circular(
                          Adaptor.width(4),
                        ),
                      ),
                      alignment: Alignment.center,
                      child: QrImage(
                        data: widget.qrUri,
                        padding: EdgeInsets.all(Adaptor.width(6)),
                        size: Adaptor.width(88),
                        backgroundColor: Colors.white,
                        foregroundColor: Color(0xff1f8dff),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<bool> canStoragePermission() async {
    PermissionStatus status = await PermissionHandler()
        .checkPermissionStatus(PermissionGroup.storage);
    if (status == PermissionStatus.granted) {
      return true;
    }
    var result =
        await PermissionHandler().requestPermissions([PermissionGroup.storage]);
    if (result[PermissionGroup.storage] == PermissionStatus.granted) {
      return true;
    }
    return false;
  }

  void savePoster() async {
    try {
      EasyLoading.show();
      RenderRepaintBoundary boundary = _key.currentContext.findRenderObject();
      double dpr = ui.window.devicePixelRatio;
      ui.Image image = await boundary.toImage(pixelRatio: dpr);
      ByteData byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      if (!await canStoragePermission()) {
        EasyLoading.showError('没有权限哟');
        return;
      }
      Uint8List bytes = byteData.buffer.asUint8List();
      String path = await ImageGallerySaver.saveImage(bytes);
      Future.delayed(const Duration(milliseconds: 300), () {
        EasyLoading.showToast('保存成功');
      });
    } catch (e) {
      EasyLoading.showError('保存失败');
    }
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
