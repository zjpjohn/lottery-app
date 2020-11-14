import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:lottery_app/commons/app_navigator.dart';
import 'package:lottery_app/commons/login_background.dart';
import 'package:lottery_app/commons/tools.dart';
import 'package:lottery_app/components/adaptor.dart';
import 'package:lottery_app/model/forget_password.dart';
import 'package:provider/provider.dart';

class ForgetPage extends StatefulWidget {
  @override
  ForgetPageState createState() => new ForgetPageState();
}

class ForgetPageState extends State<ForgetPage> {
  ///表单key
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  ///手机输入框key
  GlobalKey<FormFieldState> _phoneKey = GlobalKey<FormFieldState>();

  ///密码输入控制器
  TextEditingController _pwdController = TextEditingController();

  ///手机号输入控制器
  TextEditingController _phoneController = TextEditingController();

  final int _countdown = 60;

  StreamSubscription _timer;

  void _startTimer(ForgetPasswordModel model) {
    setState(() {
      model.available = false;
      model.seconds = _countdown;
      model.inkWellStyle = unavailableStyle;
      model.verify = '已发送${model.seconds}秒';
    });
    _timer = Stream.periodic(Duration(seconds: 1), (i) => i)
        .take(_countdown)
        .listen((i) {
      setState(() {
        model.inkWellStyle = unavailableStyle;
        model.seconds = _countdown - i - 1;
        model.verify = '已发送${model.seconds}秒';
        if (model.seconds < 1) {
          model.seconds = _countdown;
          model.inkWellStyle = availableStyle;
          model.verify = '重新发送';
          model.available = true;
        }
      });
    });
  }

  void _cancelTimer() {
    _timer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ForgetPasswordModel(),
      child: Scaffold(
        resizeToAvoidBottomPadding: false,
        backgroundColor: Colors.blue.shade50,
        body: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            LoginBackground('重置密码'),
            Center(
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    _loginCard(),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _loginCard() {
    return Consumer(builder:
        (BuildContext context, ForgetPasswordModel model, Widget child) {
      return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.88,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(5.0)),
              color: Colors.white,
            ),
            child: _buildView(model),
          ),
        ),
      );
    });
  }

  Widget _verifyView(ForgetPasswordModel model) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(bottom: Adaptor.width(20)),
          child: InkWell(
            onTap: () {
              if (model.available) {
                if (_phoneKey.currentState.validate()) {
                  model.sendSms(
                      phone: _phoneController.text,
                      callback: (result, message) {
                        EasyLoading.showToast(message);
                        if (result) {
                          _startTimer(model);
                        }
                      });
                }
              }
            },
            child: Container(
              height: Adaptor.height(28),
              alignment: Alignment.centerRight,
              child: Text(
                model.verify,
                style: model.inkWellStyle,
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget _buildView(ForgetPasswordModel model) {
    return new Center(
      child: new Container(
        margin: EdgeInsets.only(top: Adaptor.width(25)),
        alignment: Alignment.center,
        child: new Form(
            key: _formKey,
            autovalidate: false,
            child: Column(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.fromLTRB(
                      Adaptor.width(25), 0, Adaptor.width(25), 0),
                  child: TextFormField(
                    key: _phoneKey,
                    controller: _phoneController,
                    decoration: InputDecoration(
                      hintText: "请输入手机号",
                      helperText: '',
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.blueAccent,
                          width: Adaptor.width(0.6),
                        ),
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.black87,
                          width: Adaptor.width(0.6),
                        ),
                      ),
                      errorBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.red,
                          width: Adaptor.width(0.6),
                        ),
                      ),
                      focusedErrorBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.red,
                          width: Adaptor.width(0.6),
                        ),
                      ),
                      helperStyle: TextStyle(fontSize: Adaptor.sp(12)),
                      errorStyle: TextStyle(fontSize: Adaptor.sp(12)),
                      hintStyle: TextStyle(
                        color: Colors.black54,
                        fontSize: Adaptor.sp(15),
                      ),
                    ),
                    keyboardType: TextInputType.phone,
                    style: TextStyle(letterSpacing: 1.0),
                    cursorWidth: Adaptor.width(1.2),
                    onSaved: (value) {
                      model.phone = value;
                    },
                    validator: (phone) {
                      if (phone == null || phone.isEmpty) {
                        return '手机号不允许为空';
                      }
                      if (!Tools.phone(phone)) {
                        return '手机号格式错误';
                      }
                      return null;
                    },
                  ),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(
                    Adaptor.width(25),
                    0,
                    Adaptor.width(25),
                    0,
                  ),
                  child: Stack(
                    alignment: Alignment.centerRight,
                    children: <Widget>[
                      TextFormField(
                        keyboardType: TextInputType.phone,
                        style: TextStyle(letterSpacing: 1.0),
                        cursorWidth: Adaptor.width(1.2),
                        onSaved: (value) {
                          model.code = value;
                        },
                        validator: (code) {
                          if (code == null || code.isEmpty) {
                            return '验证码不允许为空';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          hintText: "请输入验证码",
                          helperText: '',
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.blueAccent,
                              width: Adaptor.width(0.6),
                            ),
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.black87,
                              width: Adaptor.width(0.6),
                            ),
                          ),
                          errorBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.red,
                              width: Adaptor.width(0.6),
                            ),
                          ),
                          focusedErrorBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.red,
                              width: Adaptor.width(0.6),
                            ),
                          ),
                          helperStyle: TextStyle(fontSize: Adaptor.sp(12)),
                          errorStyle: TextStyle(fontSize: Adaptor.sp(12)),
                          hintStyle: TextStyle(
                            color: Colors.black54,
                            fontSize: Adaptor.sp(15),
                          ),
                        ),
                      ),
                      _verifyView(model),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(
                    Adaptor.width(25),
                    0,
                    Adaptor.width(25),
                    0,
                  ),
                  child: TextFormField(
                    keyboardType: TextInputType.text,
                    style: TextStyle(letterSpacing: 1.0),
                    cursorWidth: Adaptor.width(1.2),
                    obscureText: true,
                    controller: _pwdController,
                    onSaved: (value) {
                      model.password = value;
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return '密码不允许为空';
                      }
                      if (!Tools.password(value)) {
                        return '密码包含8-16位数字、大小写字母';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      hintText: "请输入新密码",
                      helperText: '密码包含8-16位数字、大小写字母',
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.blueAccent,
                          width: Adaptor.width(0.6),
                        ),
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.black87,
                          width: Adaptor.width(0.6),
                        ),
                      ),
                      errorBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.red,
                          width: Adaptor.width(0.6),
                        ),
                      ),
                      focusedErrorBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.red,
                          width: Adaptor.width(0.6),
                        ),
                      ),
                      helperStyle: TextStyle(fontSize: Adaptor.sp(12)),
                      errorStyle: TextStyle(fontSize: Adaptor.sp(12)),
                      hintStyle: TextStyle(
                        color: Colors.black54,
                        fontSize: Adaptor.sp(15),
                      ),
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(
                    Adaptor.width(25),
                    0,
                    Adaptor.width(25),
                    0,
                  ),
                  child: TextFormField(
                    keyboardType: TextInputType.text,
                    style: TextStyle(letterSpacing: 1.0),
                    cursorWidth: Adaptor.width(1.2),
                    obscureText: true,
                    onSaved: (value) {
                      model.confirm = value;
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return '确认密码不允许为空';
                      }
                      if (value != _pwdController.text) {
                        return '确认密码不正确';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      hintText: "再次输入新密码",
                      helperText: '',
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.blueAccent,
                          width: Adaptor.width(0.6),
                        ),
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.black87,
                          width: Adaptor.width(0.6),
                        ),
                      ),
                      errorBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.red,
                          width: Adaptor.width(0.6),
                        ),
                      ),
                      focusedErrorBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.red,
                          width: Adaptor.width(0.6),
                        ),
                      ),
                      helperStyle: TextStyle(fontSize: Adaptor.sp(12)),
                      errorStyle: TextStyle(fontSize: Adaptor.sp(12)),
                      hintStyle: TextStyle(
                          color: Colors.black54, fontSize: Adaptor.sp(15)),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(
                    0,
                    Adaptor.width(10),
                    0,
                    Adaptor.width(30),
                  ),
                  height: Adaptor.height(42),
                  width: Adaptor.width(220),
                  child: RaisedButton(
                    onPressed: () {
                      if (_formKey.currentState.validate()) {
                        _formKey.currentState.save();
                        model.resetPasswordAction(callback: (result, message) {
                          EasyLoading.showToast(message);
                          if (result) {
                            AppNavigator.goBack(context);
                          }
                        });
                      }
                    },
                    shape: new RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(
                        Adaptor.width(42),
                      ),
                    ),
                    color: Colors.blue,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          model.submitted ? '重     置' : '提交中',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: Adaptor.sp(16),
                          ),
                        ),
                        if (!model.submitted)
                          Padding(
                            padding: EdgeInsets.only(left: Adaptor.width(6)),
                            child: SpinKitRing(
                              color: Colors.white,
                              lineWidth: Adaptor.width(1.2),
                              size: Adaptor.width(16),
                            ),
                          )
                      ],
                    ),
                  ),
                )
              ],
            )),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _cancelTimer();
    super.dispose();
  }
}
