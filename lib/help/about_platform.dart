import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottery_app/commons/constants.dart';
import 'package:lottery_app/commons/mappbar.dart';
import 'package:lottery_app/components/adaptor.dart';
import 'package:lottery_app/components/error_widget.dart';
import 'package:lottery_app/components/load_state.dart';
import 'package:lottery_app/model/app_info.dart';
import 'package:provider/provider.dart';

class AboutPlatformPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: <Widget>[
            NavAppBar(
              title: '关于嚞彩',
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
            _buildContent(),
          ],
        ),
      ),
    );
  }

  Widget _buildContent() {
    return Consumer(
        builder: (BuildContext context, AppInfoModel model, Widget child) {
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
                  message: '出错啦，点此重试',
                  callback: () {
                    model.loadData();
                  }),
            ],
          ),
        );
      }
      if (model.state == LoadState.success) {
        return Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                _buildPlatform(model),
                _buildTelphone(model),
                _buildUpgrade(model),
              ],
            ),
          ),
        );
      }
    });
  }

  ///
  /// [_buildPlatform]平台详细信息介绍
  ///
  Widget _buildPlatform(AppInfoModel model) {
    return Container(
      padding: EdgeInsets.only(
        top: Adaptor.width(32),
        left: Adaptor.width(16),
        right: Adaptor.width(16),
      ),
      child: Text(
        '      ${model.appInfo.remark}',
        style: TextStyle(
          height: 1.5,
          fontSize: Adaptor.sp(14),
          color: Colors.black54,
        ),
      ),
    );
  }

  Widget _buildTelphone(AppInfoModel model) {
    return Container(
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.only(
        top: Adaptor.width(6),
        left: Adaptor.width(16),
        right: Adaptor.width(16),
      ),
      child: Text(
        '客服热线：${model.appInfo.telephone}',
        style: TextStyle(
          fontSize: Adaptor.sp(14),
          color: Colors.black54,
        ),
      ),
    );
  }

  Widget _buildUpgrade(AppInfoModel model) {
    return Container(
      margin: EdgeInsets.only(top: Adaptor.width(40)),
      child: Column(
        children: <Widget>[
          Image.asset(
            'assets/images/logo.png',
            width: Adaptor.width(80),
            height: Adaptor.width(80),
          ),
          Padding(
            padding: EdgeInsets.only(
              top: Adaptor.width(12),
              bottom: Adaptor.width(12),
            ),
            child: Text(
              'v${model.appInfo.version}',
              style: TextStyle(color: Colors.black26, fontSize: Adaptor.sp(13)),
            ),
          ),
          GestureDetector(
            onTap: () {
              model.checkUpgrade();
            },
            child: Container(
              width: Adaptor.width(88),
              height: Adaptor.width(38),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(3),
                border: Border.all(
                  color: Colors.grey.withOpacity(0.3),
                  width: Adaptor.width(0.5),
                ),
              ),
              child: Text(
                '检查更新',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
