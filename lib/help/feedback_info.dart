import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottery_app/commons/constants.dart';
import 'package:lottery_app/commons/mappbar.dart';
import 'package:lottery_app/components/adaptor.dart';
import 'package:lottery_app/model/feedback_info.dart';
import 'package:provider/provider.dart';

class FeedbackPage extends StatefulWidget {
  @override
  FeedbackPageState createState() => new FeedbackPageState();
}

const Map<int, String> types = {
  1: '账户充值问题',
  2: '注册登录',
  3: '活动积分签到',
  4: '专家发布预测数据',
  5: '查看预测数据',
  6: '包月会员',
  7: '邀请好友注册',
  8: '订单问题',
  9: '系统缺陷',
};

class FeedbackPageState extends State<FeedbackPage> {
  ///文本控制数据
  final TextEditingController _controller = TextEditingController();

  final ImagePicker _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: ChangeNotifierProvider(
        create: (_) => FeedbackModel(),
        child: Scaffold(
          backgroundColor: Colors.white,
          body: Column(
            children: <Widget>[
              NavAppBar(
                title: '意见反馈',
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
              _buildContainer(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContainer() {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              _buildHeader(),
              _buildTypeView(),
              _buildContentView(),
              _buildImageView(),
              _buildSubmitBtn(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.only(
        left: Adaptor.width(16),
        right: Adaptor.width(16),
        top: Adaptor.width(16),
      ),
      child: Text(
        '所属分类',
        style: TextStyle(
          color: Colors.black87,
          fontSize: Adaptor.sp(16),
        ),
      ),
    );
  }

  ///反馈问题类型
  Widget _buildTypeView() {
    return Consumer(
        builder: (BuildContext context, FeedbackModel model, Widget child) {
      return Container(
        margin: EdgeInsets.only(top: Adaptor.width(16)),
        child: Wrap(
          spacing: Adaptor.width(10),
          runSpacing: Adaptor.width(12),
          children: types.entries
              .map((item) => _buildTypeItem(model, item.key, item.value))
              .toList(),
        ),
      );
    });
  }

  Widget _buildTypeItem(FeedbackModel model, int index, String name) {
    return GestureDetector(
      onTap: () {
        model.type = index;
      },
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: Adaptor.width(12),
          vertical: Adaptor.width(9.5),
        ),
        decoration: BoxDecoration(
          border: Border.all(
            color: Color(0xffdcdcdc),
            width: Adaptor.width(0.6),
          ),
        ),
        child: Text(
          '$name',
          style: TextStyle(
            fontSize: Adaptor.sp(13),
            color: model.type == index ? Colors.redAccent : Colors.black54,
          ),
        ),
      ),
    );
  }

  ///反馈内容
  Widget _buildContentView() {
    return Consumer(
        builder: (BuildContext context, FeedbackModel model, Widget child) {
      return Container(
        padding: EdgeInsets.symmetric(
          horizontal: Adaptor.width(16),
          vertical: Adaptor.width(16),
        ),
        child: TextField(
          controller: _controller,
          maxLines: 6,
          maxLength: 200,
          autofocus: false,
          style: TextStyle(
            fontSize: Adaptor.sp(14),
            color: Colors.black54,
          ),
          decoration: InputDecoration(
            hintText: '请输入您要反馈的问题内容（必填）',
            hintStyle: TextStyle(color: Colors.black26),
            fillColor: Color(0xFFF8F8F8),
            filled: true,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(Adaptor.width(6)), //边角为5
              ),
              borderSide: BorderSide(
                color: Colors.white, //边线颜色为白色
                width: 1, //边线宽度为2
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.white, //边框颜色为白色
                width: 1, //宽度为5
              ),
              borderRadius: BorderRadius.all(
                Radius.circular(Adaptor.width(6)), //边角为30
              ),
            ),
          ),
          onChanged: (value) {
            model.content = value;
          },
        ),
      );
    });
  }

  ///反馈上传图片
  Widget _buildImageView() {
    return Consumer(
        builder: (BuildContext context, FeedbackModel model, Widget child) {
      return Container(
        margin: EdgeInsets.only(
          left: Adaptor.width(16),
          right: Adaptor.width(16),
          bottom: Adaptor.width(16),
        ),
        child: Row(
          children: _buildImageList(model),
        ),
      );
    });
  }

  List<Widget> _buildImageList(FeedbackModel model) {
    List<Widget> views =
        List.from(model.images.map((img) => _buildImageItem(model, img)));
    if (model.images.length < 3) {
      views.add(_buildImageBtn(model));
    }
    return views;
  }

  Widget _buildImageItem(FeedbackModel model, String uri) {
    return Container(
      width: Adaptor.width(90),
      height: Adaptor.width(90),
      margin: EdgeInsets.only(right: Adaptor.width(16)),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(
          Adaptor.width(2),
        ),
      ),
      child: Stack(
        children: <Widget>[
          CachedNetworkImage(
            imageUrl: uri,
            width: Adaptor.width(90),
            height: Adaptor.width(90),
            fit: BoxFit.cover,
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
          Positioned(
            child: GestureDetector(
              onTap: () {
                model.remove(uri);
              },
              child: Container(
                height: Adaptor.width(90),
                width: Adaptor.width(90),
                decoration: BoxDecoration(
                  color: Colors.black26,
                ),
                child: Icon(
                  IconData(0xe61c, fontFamily: 'iconfont'),
                  size: Adaptor.width(16),
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageBtn(FeedbackModel model) {
    return GestureDetector(
      onTap: () {
        if (model.images.length >= 3) {
          EasyLoading.showToast('最多选择3张照片');
          return;
        }
        _picker.getImage(source: ImageSource.gallery).then((file) {
          if (file != null && file.path != null) {
            model.uploadImage(file);
          }
        });
      },
      child: Container(
        width: Adaptor.width(90),
        height: Adaptor.width(90),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Color(0xfff8f8f8),
          borderRadius: BorderRadius.circular(
            Adaptor.width(2),
          ),
        ),
        child: Icon(
          IconData(0xe653, fontFamily: 'iconfont'),
          size: Adaptor.width(30),
          color: Colors.black12,
        ),
      ),
    );
  }

  Widget _buildSubmitBtn() {
    return Consumer(
        builder: (BuildContext context, FeedbackModel model, Widget child) {
      return GestureDetector(
        onTap: () {
          model.submitFeedback(callback: () {
            _controller.clear();
          });
        },
        child: Container(
          alignment: Alignment.center,
          height: Adaptor.width(40),
          width: Adaptor.width(240),
          margin: EdgeInsets.only(top: Adaptor.width(24)),
          decoration: BoxDecoration(
            color: Colors.black38,
            borderRadius: BorderRadius.circular(Adaptor.width(4)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                model.submit ? '提交中' : '提交反馈',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: Adaptor.sp(16),
                ),
              ),
              if (model.submit)
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
      );
    });
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
