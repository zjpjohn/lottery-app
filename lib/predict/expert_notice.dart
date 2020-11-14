import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottery_app/commons/constants.dart';
import 'package:lottery_app/commons/mappbar.dart';
import 'package:lottery_app/components/adaptor.dart';

final String remark = '嚞彩APP平台为了保护彩民权益以及保证预测专家质量，将预测专家分为收费专家和免费专家：';

///
/// [notices]:专家排名问题集合
///
final List notices = [
  {
    'question': '如何成为收费预测专家？',
    'answer': '专家通过发布预测，预测综合成绩达到前100名或者单项'
        '成绩达到前50名的专家，系统自动将其设置为收费专家。',
  },
  {
    'question': '如何被降级为免费专家？',
    'answer': '当专家成绩排名跌出排名阈值后，系统将取消其收费专家的资格。',
  },
  {
    'question': '如何在首页专区展示曝光？',
    'answer': '对于预测综合成绩排名前6名的专家系统将其设置到首页专区展示曝光，'
        '以及各单项预测成绩排名前6名的专家在个单项专区展示曝光,望各位专家发挥自己经验，努力预测。',
  },
];

///
/// [ExpertNoticePage]:专家排名公告
///
class ExpertNoticePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: <Widget>[
            NavAppBar(
              title: '专家公告',
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
            _buildNoticeView(),
          ],
        ),
      ),
    );
  }

  Widget _buildNoticeView() {
    return Expanded(
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[]
            ..add(Container(
              padding: EdgeInsets.only(
                top: Adaptor.width(32),
                left: Adaptor.width(16),
                right: Adaptor.width(16),
              ),
              child: Text(
                '$remark',
                style: TextStyle(
                  fontSize: Adaptor.sp(15),
                  color: Colors.black87,
                ),
              ),
            ))
            ..addAll(
              notices.map((v) {
                return Container(
                  padding: EdgeInsets.only(
                    top: Adaptor.width(24),
                    left: Adaptor.width(16),
                    right: Adaptor.width(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(bottom: Adaptor.width(6)),
                        child: Text(
                          '${v['question']}',
                          style: TextStyle(
                            fontSize: Adaptor.sp(15),
                            color: Colors.black87,
                          ),
                        ),
                      ),
                      Text(
                        '${v['answer']}',
                        style: TextStyle(
                          height: 1.5,
                          fontSize: Adaptor.sp(14),
                          color: Colors.black87,
                        ),
                      )
                    ],
                  ),
                );
              }),
            ),
        ),
      ),
    );
  }
}
