import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:lottery_app/commons/app_navigator.dart';
import 'package:lottery_app/commons/constants.dart';
import 'package:lottery_app/commons/mappbar.dart';
import 'package:lottery_app/model/expert_account.dart';
import 'package:provider/provider.dart';
import 'package:lottery_app/components/adaptor.dart';

class ExpertAccountPage extends StatefulWidget {
  @override
  ExpertAccountPageState createState() => new ExpertAccountPageState();
}

class ExpertAccountPageState extends State<ExpertAccountPage> {
  ///表单Key
  GlobalKey<FormState> _formKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        body: Column(
          children: <Widget>[
            NavAppBar(
              title: '重置账户',
              fontColor: Color(0xFF59575A),
              color: Color(0xFFF9F9F9),
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
            _buildAccountView(),
          ],
        ),
      ),
    );
  }

  Widget _buildAccountView() {
    return ChangeNotifierProvider(
      create: (_) => ExpertAccountModel(),
      child: Container(
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: Form(
            key: _formKey,
            autovalidate: false,
            child: Consumer(builder:
                (BuildContext context, ExpertAccountModel model, Widget child) {
              return Column(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(top: Adaptor.width(32)),
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
                                '支付宝账号',
                                style: TextStyle(
                                    color: Colors.black87,
                                    fontSize: Adaptor.sp(15)),
                              ),
                              Text(
                                '（请务必确保支付宝账号正确）',
                                style: TextStyle(
                                    color: Colors.black26,
                                    fontSize: Adaptor.sp(13)),
                              ),
                            ],
                          ),
                        ),
                        TextFormField(
                          cursorWidth: Adaptor.width(1.2),
                          keyboardType: TextInputType.text,
                          onSaved: (value) {
                            model.aliAccount = value;
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return '支付宝账号为空';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            hintText: '请输入提现支付宝账号',
                            helperText: '',
                            hasFloatingPlaceholder: false,
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
                            errorStyle: TextStyle(
                              fontSize: Adaptor.sp(12),
                            ),
                            hintStyle: TextStyle(
                              color: Colors.black26,
                              fontSize: Adaptor.sp(14),
                            ),
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
                                '真实姓名',
                                style: TextStyle(
                                  color: Colors.black87,
                                  fontSize: Adaptor.sp(15),
                                ),
                              ),
                              Text(
                                '（请务必确保真实姓名正确）',
                                style: TextStyle(
                                  color: Colors.black26,
                                  fontSize: Adaptor.sp(13),
                                ),
                              ),
                            ],
                          ),
                        ),
                        TextFormField(
                          cursorWidth: Adaptor.width(1.2),
                          keyboardType: TextInputType.text,
                          onSaved: (value) {
                            model.aliName = value;
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return '支付宝真实姓名为空';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            hintText: '请输入支付宝账号一致的真实姓名',
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
                            errorStyle: TextStyle(fontSize: Adaptor.sp(12)),
                            hintStyle: TextStyle(
                              color: Colors.black26,
                              fontSize: Adaptor.sp(14),
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
                          model.editAccountAction(
                            success: () {
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
                              model.editing ? '提交中' : '重置账户',
                              style: TextStyle(
                                color: Colors.redAccent,
                                fontSize: Adaptor.sp(16),
                              ),
                            ),
                            if (model.editing)
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
  void didUpdateWidget(ExpertAccountPage oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }
}
