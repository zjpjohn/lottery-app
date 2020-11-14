import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:lottery_app/model/auth.dart';
import 'package:lottery_app/register/register_page.dart';
import 'package:lottery_app/login/forget_page.dart';
import 'package:lottery_app/commons/login_background.dart';
import 'package:lottery_app/commons/tools.dart';
import 'package:lottery_app/commons/app_navigator.dart';
import 'package:provider/provider.dart';
import 'package:lottery_app/components/adaptor.dart';

class LoginPage extends StatefulWidget {
  @override
  LoginPageState createState() => new LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  GlobalKey<FormState> _loginKey = new GlobalKey<FormState>();

  String _phone;

  String _password;

  FocusNode _phoneNode = FocusNode();

  FocusNode _passwordNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    var deviceSize = MediaQuery.of(context).size;
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        resizeToAvoidBottomPadding: false,
        backgroundColor: Colors.blue.shade50,
        body: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            LoginBackground('用户登录'),
            Center(
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: Adaptor.height(30),
                    ),
                    _loginCard(deviceSize)
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _loginCard(deviceSize) {
    return SizedBox(
      width: deviceSize.width * 0.88,
      child: _buildView(),
    );
  }

  Widget _buildView() {
    return Container(
      alignment: Alignment.center,
      child: Container(
        padding: EdgeInsets.only(top: Adaptor.width(20)),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(
              Radius.circular(
                Adaptor.width(5.0),
              ),
            ),
            color: Colors.white),
        child: Consumer<AuthModel>(
            builder: (BuildContext context, AuthModel model, Widget child) {
          return GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              FocusScope.of(context).requestFocus(FocusNode());
            },
            child: Form(
              key: _loginKey,
              autovalidate: false,
              child: Column(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(bottom: Adaptor.width(10)),
                    alignment: Alignment.center,
                    child: Image.asset(
                      'assets/images/useravatar.png',
                      width: Adaptor.width(64),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(
                        Adaptor.width(25), 0, Adaptor.width(25), 0),
                    child: TextFormField(
                      focusNode: _phoneNode,
                      cursorWidth: Adaptor.width(1.2),
                      decoration: InputDecoration(
                        hintText: "请输入手机号",
                        helperText: '',
                        focusedErrorBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.red,
                            width: Adaptor.width(0.6),
                          ),
                        ),
                        errorBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.red,
                            width: Adaptor.width(0.6),
                          ),
                        ),
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
                        helperStyle: TextStyle(fontSize: Adaptor.sp(12)),
                        errorStyle: TextStyle(fontSize: Adaptor.sp(12)),
                        hintStyle: TextStyle(
                            color: Colors.black54, fontSize: Adaptor.sp(15)),
                      ),
                      keyboardType: TextInputType.phone,
                      style: TextStyle(letterSpacing: 0.5),
                      onSaved: (value) {
                        this._phone = value;
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return '手机号不允许为空';
                        }
                        if (!Tools.phone(value)) {
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
                    child: TextFormField(
                      focusNode: _passwordNode,
                      keyboardType: TextInputType.text,
                      obscureText: !model.showPass,
                      style: TextStyle(letterSpacing: 1.0),
                      cursorWidth: Adaptor.width(1.2),
                      onSaved: (value) {
                        this._password = value;
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
                        hintText: "请输入密码",
                        helperText: '密码包含8-16位数字、大小写字母',
                        helperStyle: TextStyle(fontSize: Adaptor.sp(12)),
                        errorStyle: TextStyle(fontSize: Adaptor.sp(12)),
                        hintStyle: TextStyle(
                            color: Colors.black54, fontSize: Adaptor.sp(15)),
                        focusedErrorBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.red,
                            width: Adaptor.width(0.6),
                          ),
                        ),
                        errorBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.red,
                            width: Adaptor.width(0.6),
                          ),
                        ),
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
                        suffixIcon: new IconButton(
                            icon: Icon(
                              model.showPass
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: Color.fromARGB(255, 126, 126, 126),
                              size: Adaptor.sp(20),
                            ),
                            onPressed: () {
                              model.showPass = !model.showPass;
                            }),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(
                      0,
                      Adaptor.width(5),
                      0,
                      Adaptor.width(5),
                    ),
                    padding: EdgeInsets.fromLTRB(
                      Adaptor.width(25),
                      0,
                      Adaptor.width(25),
                      0,
                    ),
                    child: InkWell(
                      onTap: () {
                        AppNavigator.push(context, ForgetPage());
                      },
                      child: Container(
                        height: Adaptor.width(40),
                        alignment: Alignment.centerRight,
                        child: Text(
                          '忘记密码？',
                          style: TextStyle(
                            color: Colors.black45,
                            fontSize: Adaptor.sp(14),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    height: Adaptor.height(42),
                    width: Adaptor.width(220),
                    child: RaisedButton(
                      onPressed: () {
                        final form = _loginKey.currentState;
                        if (form.validate()) {
                          form.save();
                          model.login(
                            phone: this._phone,
                            password: this._password,
                            callback: (result, message) {
                              EasyLoading.showToast(message);
                              if (result) {
                                AppNavigator.goBack(context);
                              }
                            },
                          );
                        }
                      },
                      shape: new RoundedRectangleBorder(
                          borderRadius:
                              new BorderRadius.circular(Adaptor.width(42))),
                      color: Colors.blue,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            model.logined ? '登   录' : '正在登录',
                            style: TextStyle(
                                color: Colors.white, fontSize: Adaptor.sp(16)),
                          ),
                          if (!model.logined)
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
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(
                        0, Adaptor.width(8), 0, Adaptor.width(15)),
                    padding: EdgeInsets.fromLTRB(
                        Adaptor.width(60), 0, Adaptor.width(60), 0),
                    child: InkWell(
                      onTap: () {
                        AppNavigator.push(context, RegisterPage());
                      },
                      child: Container(
                        height: Adaptor.height(40),
                        alignment: Alignment.center,
                        child: Text(
                          '没有账户？点此注册',
                          style: TextStyle(
                              color: Colors.black45, fontSize: Adaptor.sp(14)),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        }),
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
