import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:lottery_app/commons/app_navigator.dart';
import 'package:lottery_app/commons/event_center.dart';
import 'package:lottery_app/forecast/forecast_home.dart';
import 'package:lottery_app/home/home_page.dart';
import 'package:lottery_app/login/login_page.dart';
import 'package:lottery_app/means/lottery_means.dart';
import 'package:lottery_app/user/user_home.dart';

class MainPage extends StatefulWidget {
  @override
  MainPageState createState() => new MainPageState();
}

class MainPageState extends State<MainPage> {
  ///
  ///默认[BottomNavigationBar]下标
  ///
  int _currIndex = 0;

  PageController _controller = PageController(initialPage: 0);

  ///
  /// [_lastTime]上一次点击时间
  DateTime _lastTime;

  ///
  /// [_pages]页面
  final _pages = [
    IndexPage(),
    LotteryMeansPage(),
    ForecastPage(),
    UserHomePage()
  ];

  List<BottomNavigationBarItem> _buildItems() {
    return List()
      ..add(
        BottomNavigationBarItem(
          icon: Image.asset('assets/images/home.png', width: 24, height: 24),
          activeIcon:
              Image.asset('assets/images/home_on.png', width: 24, height: 24),
          title: Padding(
            padding: EdgeInsets.only(top: 2.0),
            child: Text('首页'),
          ),
        ),
      )
      ..add(
        BottomNavigationBarItem(
          icon: Image.asset('assets/images/means.png', width: 24, height: 24),
          activeIcon:
              Image.asset('assets/images/means_on.png', width: 24, height: 24),
          title: Padding(
            padding: EdgeInsets.only(top: 2.0),
            child: Text('工具'),
          ),
        ),
      )
      ..add(
        BottomNavigationBarItem(
          icon:
              Image.asset('assets/images/forecast.png', width: 24, height: 24),
          activeIcon: Image.asset('assets/images/forecast_on.png',
              width: 24, height: 24),
          title: Padding(
            padding: EdgeInsets.only(top: 2.0),
            child: Text('预测'),
          ),
        ),
      )
      ..add(
        BottomNavigationBarItem(
          icon: Image.asset('assets/images/user.png', width: 24, height: 24),
          activeIcon:
              Image.asset('assets/images/user_on.png', width: 24, height: 24),
          title: Padding(
            padding: EdgeInsets.only(top: 2.0),
            child: Text('我的'),
          ),
        ),
      );
  }

  Future<bool> _isExit() {
    if (_lastTime == null ||
        DateTime.now().difference(_lastTime) > Duration(milliseconds: 2000)) {
      _lastTime = DateTime.now();
      EasyLoading.showToast('再次点击退出应用');
      return Future.value(false);
    }
    return Future.value(true);
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: WillPopScope(
        onWillPop: _isExit,
        child: Scaffold(
          backgroundColor: Colors.white,
          body: PageView.builder(
            physics: NeverScrollableScrollPhysics(),
            controller: _controller,
            itemCount: _pages.length,
            onPageChanged: (index) {
              setState(() {
                if (_currIndex != index) {
                  _currIndex = index;
                }
              });
            },
            itemBuilder: (context, index) => _pages[index],
          ),
          bottomNavigationBar: BottomNavigationBar(
            items: _buildItems(),
            type: BottomNavigationBarType.fixed,
            currentIndex: _currIndex,
            selectedItemColor: Color(0xffFF421A),
            unselectedItemColor: Color(0xff616161),
            iconSize: 22.0,
            selectedFontSize: 12,
            unselectedFontSize: 12,
            onTap: (index) {
              _controller.jumpToPage(index);
            },
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    eventBus.on<UnAuthEvent>().listen((UnAuthEvent e) {
      AppNavigator.replace(context, LoginPage());
    });
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }
}
