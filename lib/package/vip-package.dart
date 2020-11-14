import 'dart:core';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:lottery_app/commons/app_navigator.dart';
import 'package:lottery_app/commons/constants.dart';
import 'package:lottery_app/commons/custom_scroll_physics.dart';
import 'package:lottery_app/commons/mappbar.dart';
import 'package:lottery_app/commons/concave_clipper.dart';
import 'package:lottery_app/commons/tools.dart';
import 'package:lottery_app/components/custom_scroll_behavior.dart';
import 'package:lottery_app/components/error_widget.dart';
import 'package:lottery_app/components/flutter_page_indicator.dart';
import 'package:lottery_app/components/vip_privilege_view.dart';
import 'package:lottery_app/master/fc3d-master.dart';
import 'package:lottery_app/master/pl3-master.dart';
import 'package:lottery_app/model/auth.dart';
import 'package:lottery_app/model/vip_package.dart';
import 'package:lottery_app/package/package_buy.dart';
import 'package:provider/provider.dart';
import 'package:lottery_app/components/adaptor.dart';

class VipPackagesPage extends StatefulWidget {
  @override
  VipPackagesPageState createState() => new VipPackagesPageState();
}

class VipPackagesPageState extends State<VipPackagesPage> {
  List<String> images = [
    'assets/images/fc3d_vip_bg.png',
    'assets/images/pl3_vip_bg.png',
    'assets/images/ssq_vip_bg.png',
    'assets/images/dlt_vip_bg.png',
    'assets/images/qlc_vip_bg.png',
  ];

  ///渐变色集合
  final Map<int, List<Color>> colors = Map()
    ..[0] = [Color(0xFFF8D9D7), Color(0xFFD48885)]
    ..[1] = [Color(0xFFF7D6C8), Color(0xFFDC896A)]
    ..[2] = [Color(0xFFBDDAE4), Color(0xFF7CADC9)]
    ..[3] = [Color(0xFFCEDAF1), Color(0xFF959FD1)]
    ..[4] = [Color(0xFFECD5F6), Color(0xFFB693C4)];

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: ChangeNotifierProvider<VipPackageModel>(
        create: (_) => VipPackageModel.initialize(),
        child: Scaffold(
          body: Stack(
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(
                  bottom: Adaptor.width(20),
                ),
                child: ClipPath(
                  clipper: ConcaveClipper(),
                  child: Container(
                    height: Adaptor.height(250),
                    decoration: BoxDecoration(
                        gradient: LinearGradient(colors: [
                      const Color(0xFFFE8C00),
                      const Color(0xFFF83600),
                    ])),
                  ),
                ),
              ),
              Column(
                children: <Widget>[
                  MAppBar('我的会员'),
                  _buildView(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildView() {
    return Consumer2<AuthModel, VipPackageModel>(builder: (BuildContext context,
        AuthModel auth, VipPackageModel model, Widget child) {
      if (model.loaded) {
        if (model.error) {
          return Flexible(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ErrorView(
                  color: Colors.black38,
                  message: '出错啦，点击重试',
                  callback: () {
                    model.loadPackages();
                  },
                ),
              ],
            ),
          );
        }
        return Expanded(
          child: Container(
            child: ScrollConfiguration(
              behavior: CustomScrollBehavior(),
              child: ListView(
                padding: EdgeInsets.only(bottom: Adaptor.width(24)),
                physics: EasyRefreshPhysics(topBouncing: false),
                children: <Widget>[
                  _buildAcct(auth, model),
                  _buildPrivilege(model),
                  _buildMasterView('福彩3D', model.fc3dMasters, 'fc3d'),
                  _buildMasterView('排列三', model.pl3Masters, 'pl3'),
                ],
              ),
            ),
          ),
        );
      }
      return Flexible(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Constant.loading(),
          ],
        ),
      );
    });
  }

  Widget _buildAcct(AuthModel auth, VipPackageModel pack) {
    return Container(
      height: Adaptor.height(160),
      margin:
          EdgeInsets.only(top: Adaptor.width(30), bottom: Adaptor.width(20)),
      child: Swiper(
        index: pack.index,
        itemCount: pack.packs.length,
        viewportFraction: 0.90,
        onIndexChanged: (index) {
          pack.index = index;
        },
        controller: SwiperController(),
        pagination: SwiperCustomPagination(
            builder: (BuildContext context, SwiperPluginConfig config) {
          return Container(
              alignment: Alignment.bottomCenter,
              height: Adaptor.height(156),
              child: PageIndicator(
                layout: PageIndicatorLayout.LINE,
                size: Adaptor.width(5),
                space: 0,
                count: pack.packs.length,
                controller: config.pageController,
                color: Colors.redAccent,
              ));
        }),
        itemBuilder: (BuildContext context, int index) {
          return SizedBox(
            width: MediaQuery.of(context).size.width,
            height: Adaptor.height(140),
            child: Container(
              margin:
                  EdgeInsets.fromLTRB(Adaptor.width(8), 0, Adaptor.width(8), 0),
              padding: EdgeInsets.fromLTRB(0, 0, 0, Adaptor.width(20)),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                image: DecorationImage(
                  image: AssetImage(images[index]),
                  fit: BoxFit.cover,
                ),
              ),
              child: _buildCardInfo(auth, pack, pack.packs[index], index),
            ),
          );
        },
      ),
    );
  }

  Widget _buildCardInfo(
      AuthModel auth, VipPackageModel model, PackageInfo pack, int index) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(top: Adaptor.width(30)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.fromLTRB(
                      Adaptor.width(15),
                      0,
                      Adaptor.width(8),
                      0,
                    ),
                    child: Image.asset(
                      'assets/images/avatar.png',
                      width: Adaptor.width(40),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(bottom: Adaptor.width(3)),
                        child: Text(
                          '${Tools.encodePhone(auth.user.phone)}',
                          style: TextStyle(
                            color: Colors.black54,
                            fontSize: Adaptor.sp(15),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Text(
                        pack.userId == null ? '开通会员，频道畅通无阻' : '截止时间${pack.end}',
                        style: TextStyle(
                          color: Colors.black54,
                          fontSize: Adaptor.sp(12),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(
                Adaptor.width(10),
                Adaptor.width(6),
                Adaptor.width(10),
                Adaptor.width(6),
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(8),
                  topRight: Radius.circular(8),
                ),
              ),
              child: Text(
                pack.userId == null ? '未开通' : '已开通',
                style: TextStyle(
                    color: Color(0xffDA9611), fontSize: Adaptor.sp(13)),
              ),
            )
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(left: Adaptor.width(15)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Text(
                    '${pack.name}',
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: Adaptor.sp(13),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: Adaptor.width(2)),
                    child: Icon(
                      Icons.arrow_forward_ios,
                      size: Adaptor.sp(12),
                      color: Colors.black38,
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(right: Adaptor.width(16)),
              child: GestureDetector(
                onTap: () {
                  model.index = index;
                  AppNavigator.push(
                    context,
                    PackageBuyPage(
                      packId: pack.packId,
                      type: pack.userId == null ? 0 : 1,
                    ),
                  ).then((value) {
                    if (value != null && value) {
                      model.loadPackages();
                    }
                  });
                },
                child: Container(
                  width: Adaptor.width(94),
                  height: Adaptor.height(32),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(Adaptor.height(16)),
                  ),
                  child: Text(
                    pack.userId == null ? '立即开通' : '续约会员',
                    style: TextStyle(
                      color: Color(0xFFDA9611),
                      fontSize: Adaptor.sp(15),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ],
    );
  }

  Widget _buildPrivilege(VipPackageModel model) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.10),
            offset: Offset(4.0, 4.0),
            blurRadius: 16.0,
          ),
        ],
      ),
      child: Column(
        children: <Widget>[
          Container(
            color: Colors.white,
            padding: EdgeInsets.symmetric(horizontal: Adaptor.width(16)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.symmetric(vertical: Adaptor.width(10)),
                  child: Text(
                    '会员特权',
                    style: TextStyle(
                      fontSize: Adaptor.sp(18),
                      color: Color(0xff3f3f3f),
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(bottom: Adaptor.width(10)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        child: VipPrivilege(
                            name: '畅想频道',
                            icon: 0xe799,
                            colors: colors[model.index]),
                        flex: 1,
                      ),
                      Expanded(
                        child: VipPrivilege(
                            name: '整体态势',
                            icon: 0xe79d,
                            colors: colors[model.index]),
                        flex: 1,
                      ),
                      Expanded(
                        child: VipPrivilege(
                            name: '综合分析',
                            icon: 0xe7a0,
                            colors: colors[model.index]),
                        flex: 1,
                      ),
                      Expanded(
                        child: VipPrivilege(
                            name: '专家对比',
                            icon: 0xe79b,
                            colors: colors[model.index]),
                        flex: 1,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            color: Colors.white,
            padding: EdgeInsets.only(
              left: Adaptor.width(16),
              right: Adaptor.width(16),
              bottom: Adaptor.width(16),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: VipPrivilege(
                    name: '无限查看',
                    icon: 0xe79e,
                    colors: colors[model.index],
                  ),
                  flex: 1,
                ),
                Expanded(
                  child: VipPrivilege(
                    name: '热门推荐',
                    icon: 0xe79f,
                    colors: colors[model.index],
                  ),
                  flex: 1,
                ),
                Expanded(
                  child: VipPrivilege(
                    name: '牛人臻选',
                    icon: 0xe79a,
                    colors: colors[model.index],
                  ),
                  flex: 1,
                ),
                Expanded(
                  child: VipPrivilege(
                    name: '尊贵身份',
                    icon: 0xe79c,
                    colors: colors[model.index],
                  ),
                  flex: 1,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  ///构建专家精选专区
  Widget _buildMasterView(String title, List<TopMaster> masters, String type) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: Adaptor.width(16),
        vertical: Adaptor.width(16),
      ),
      margin: EdgeInsets.only(top: Adaptor.width(12)),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.10),
            offset: Offset(4.0, 4.0),
            blurRadius: 16.0,
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(bottom: Adaptor.width(10)),
            child: Text(
              '$title精选',
              style: TextStyle(
                fontSize: Adaptor.sp(18),
                color: Color(0xff3f3f3f),
              ),
            ),
          ),
          Container(
            alignment: Alignment.center,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: masters.sublist(0, 4).map((v) {
                return GestureDetector(
                  onTap: () {
                    switch (type) {
                      case 'fc3d':
                        AppNavigator.push(
                          context,
                          Fc3dMasterPage(
                            v.masterId,
                            index: 6,
                          ),
                        );
                        break;
                      case 'pl3':
                        AppNavigator.push(
                          context,
                          Pl3MasterPage(
                            v.masterId,
                            index: 6,
                          ),
                        );
                        break;
                    }
                  },
                  child: Container(
                    child: Column(
                      children: <Widget>[
                        Container(
                          width: Adaptor.width(66),
                          height: Adaptor.height(72),
                          margin: EdgeInsets.all(Adaptor.width(4)),
                          alignment: Alignment.center,
                          child: Opacity(
                            opacity: 0.75,
                            child: CachedNetworkImage(
                              width: Adaptor.width(66),
                              height: Adaptor.height(72),
                              fit: BoxFit.cover,
                              imageUrl: v.image,
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
                              errorWidget: (context, url, error) =>
                                  Icon(Icons.error),
                            ),
                          ),
                        ),
                        Container(
                          child: Text(
                            Tools.limitName(v.name, 4),
                            style: TextStyle(
                              fontSize: Adaptor.sp(12),
                              color: Colors.black87,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          Container(
            alignment: Alignment.center,
            margin: EdgeInsets.only(top: Adaptor.width(8)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: masters.sublist(4, 8).map((v) {
                return GestureDetector(
                  onTap: () {
                    switch (type) {
                      case 'fc3d':
                        AppNavigator.push(
                          context,
                          Fc3dMasterPage(
                            v.masterId,
                            index: 6,
                          ),
                        );
                        break;
                      case 'pl3':
                        AppNavigator.push(
                          context,
                          Pl3MasterPage(
                            v.masterId,
                            index: 6,
                          ),
                        );
                        break;
                    }
                  },
                  child: Container(
                    child: Column(
                      children: <Widget>[
                        Container(
                          width: Adaptor.width(66),
                          height: Adaptor.height(70),
                          margin: EdgeInsets.all(Adaptor.width(4)),
                          alignment: Alignment.center,
                          child: Opacity(
                            opacity: 0.75,
                            child: CachedNetworkImage(
                              width: Adaptor.width(66),
                              height: Adaptor.height(70),
                              fit: BoxFit.cover,
                              imageUrl: v.image,
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
                              errorWidget: (context, url, error) =>
                                  Icon(Icons.error),
                            ),
                          ),
                        ),
                        Container(
                          child: Text(
                            Tools.limitName(v.name, 4),
                            style: TextStyle(
                              fontSize: Adaptor.sp(12),
                              color: Colors.black87,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                );
              }).toList(),
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
