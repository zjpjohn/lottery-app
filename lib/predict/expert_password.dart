import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:lottery_app/commons/app_navigator.dart';
import 'package:lottery_app/commons/constants.dart';
import 'package:lottery_app/commons/mappbar.dart';
import 'package:lottery_app/commons/tools.dart';
import 'package:lottery_app/model/expert_password.dart';
import 'package:provider/provider.dart';
import 'package:lottery_app/components/adaptor.dart';

class ExpertPasswordPage extends StatefulWidget {
  @override
  ExpertPasswordPageState createState() => new ExpertPasswordPageState();
}

class ExpertPasswordPageState extends State<ExpertPasswordPage> {
  GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        body: Container(
          color: Color(0xFFF8F8F8),
          child: Column(
            children: <Widget>[
              NavAppBar(
                title: '重置密码',
                fontColor: Color(0xFF59575A),
                color: Color(0xFFF8F8F8),
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
              ),
              _buildPasswordView(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPasswordView() {
    return ChangeNotifierProvider<ExpertPasswordModel>(
      create: (_) => ExpertPasswordModel(),
      child: Container(
        margin: EdgeInsets.only(top: Adaptor.width(32)),
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: Form(
            key: _formKey,
            autovalidate: false,
            child: Consumer<ExpertPasswordModel>(builder: (BuildContext context,
                ExpertPasswordModel model, Widget child) {
              return Column(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(top: Adaptor.width(16)),
                    padding: EdgeInsets.only(
                      left: Adaptor.width(24),
                      right: Adaptor.width(24),
                    ),
                    child: Column(
                      children: <Widget>[
                        Container(
                          child: Row(
                            children: <Widget>[
                              Text(
                                '提现密码',
                                style: TextStyle(
                                    color: Colors.black87,
                                    fontSize: Adaptor.sp(15)),
                              ),
                              Text(
                                '（提现密码为六位纯数字）',
                                style: TextStyle(
                                    color: Colors.black26,
                                    fontSize: Adaptor.sp(13)),
                              ),
                            ],
                          ),
                        ),
                        TextFormField(
                          keyboardType: TextInputType.number,
                          obscureText: !model.showPwd,
                          cursorWidth: Adaptor.width(1.2),
                          onSaved: (value) {
                            model.password = value;
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return '提现密码为空';
                            }
                            if (!Tools.number(value)) {
                              return '提现密码为纯数字';
                            }
                            if (value.length != 6) {
                              return '提现密码长度为6';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            hintText: "请输入提现密码",
                            helperText: '',
                            errorStyle: TextStyle(fontSize: Adaptor.sp(12)),
                            hintStyle: TextStyle(
                              color: Colors.black26,
                              fontSize: Adaptor.sp(14),
                            ),
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
                                  model.showPwd
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: Color.fromARGB(255, 126, 126, 126),
                                  size: Adaptor.sp(20),
                                ),
                                onPressed: () {
                                  model.showPwd = !model.showPwd;
                                }),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: Adaptor.width(16)),
                    padding: EdgeInsets.only(
                      left: Adaptor.width(24),
                      right: Adaptor.width(24),
                    ),
                    child: Column(
                      children: <Widget>[
                        Container(
                          child: Row(
                            children: <Widget>[
                              Text(
                                '确认密码',
                                style: TextStyle(
                                  color: Colors.black87,
                                  fontSize: Adaptor.sp(15),
                                ),
                              ),
                            ],
                          ),
                        ),
                        TextFormField(
                          keyboardType: TextInputType.number,
                          obscureText: true,
                          cursorWidth: Adaptor.width(1.2),
                          onSaved: (value) {
                            model.confirm = value;
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return '确认密码为空';
                            }
                            if (!Tools.number(value)) {
                              return '确认密码为纯数字';
                            }
                            if (value.length != 6) {
                              return '确认密码长度为6';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            hintText: "请输入确认密码",
                            helperText: '',
                            helperStyle: TextStyle(fontSize: Adaptor.sp(12)),
                            errorStyle: TextStyle(fontSize: Adaptor.sp(12)),
                            hintStyle: TextStyle(
                              color: Colors.black26,
                              fontSize: Adaptor.sp(14),
                            ),
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
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(
                      left: Adaptor.width(24),
                      right: Adaptor.width(24),
                      top: Adaptor.width(32),
                      bottom: Adaptor.width(16),
                    ),
                    child: GestureDetector(
                      onTap: () {
                        FocusScope.of(context).requestFocus(FocusNode());
                        final form = _formKey.currentState;
                        if (form.validate()) {
                          form.save();
                          model.resetPassword(
                            callback: () {
                              EasyLoading.showSuccess('重置成功');
                              Future.delayed(
                                const Duration(milliseconds: 500),
                                () {
                                  AppNavigator.goBack(context);
                                },
                              );
                            },
                          );
                        }
                      },
                      child: Container(
                        height: Adaptor.height(40),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(Adaptor.width(2)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              model.reseting ? '提交中' : '重置密码',
                              style: TextStyle(
                                color: Colors.redAccent,
                                fontSize: Adaptor.sp(16),
                              ),
                            ),
                            if (model.reseting)
                              Padding(
                                padding:
                                    EdgeInsets.only(left: Adaptor.width(6)),
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
                  ),
                ],
              );
            }),
          ),
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

  @override
  void didUpdateWidget(ExpertPasswordPage oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }
}
