import 'package:flutter/material.dart';
import 'package:lottery_app/components/clip_button.dart';
import 'package:lottery_app/components/adaptor.dart';
import 'package:lottery_app/model/fc3d_master.dart';

class Fc3dAchieveWidget extends StatelessWidget {
  List<Fc3dMasterRecord> record;

  Fc3dAchieveWidget({Key key, @required this.record})
      : assert(record != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Fc3dAchieveView(record: record);
  }
}

class Fc3dAchieveView extends StatefulWidget {
  List<Fc3dMasterRecord> record;

  Fc3dAchieveView({Key key, @required this.record}) : super(key: key);

  @override
  Fc3dAchieveViewState createState() => new Fc3dAchieveViewState();
}

class Fc3dAchieveViewState extends State<Fc3dAchieveView> {
  ///选择的数据
  ///
  int selectIndex = 1;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          height: Adaptor.height(4.0),
          width: Adaptor.width(45),
          margin: EdgeInsets.only(top: Adaptor.width(14)),
          decoration: BoxDecoration(
            color: Color(0xffbcbcbc),
            borderRadius: BorderRadius.all(
              Radius.circular(5),
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.only(top: Adaptor.width(12)),
          child: _buildTypeButton(),
        ),
        Expanded(
          child: Container(
            margin: EdgeInsets.only(top: Adaptor.width(12)),
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Column(
                children: <Widget>[
                  Offstage(
                    offstage: selectIndex != 1,
                    child: _buildDanAchieve(),
                  ),
                  Offstage(
                    offstage: selectIndex != 2,
                    child: _buildComAchieve(),
                  ),
                  Offstage(
                    offstage: selectIndex != 3,
                    child: _buildKillAchieve(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDanAchieve() {
    List<TableRow> rows = List();
    List<Widget> titleCells = List();
    titleCells
      ..add(
        Container(
          width: Adaptor.width(70),
          height: Adaptor.height(32),
          alignment: Alignment.center,
          child: Text(
            '预测期号',
            style: TextStyle(fontSize: Adaptor.sp(15), color: Colors.black54),
          ),
        ),
      )
      ..add(
        Container(
          width: Adaptor.width(36),
          height: Adaptor.height(32),
          alignment: Alignment.center,
          child: Text(
            '独胆',
            style: TextStyle(fontSize: Adaptor.sp(15), color: Colors.black54),
          ),
        ),
      )
      ..add(
        Container(
          width: Adaptor.width(36),
          height: Adaptor.height(32),
          alignment: Alignment.center,
          child: Text(
            '双胆',
            style: TextStyle(fontSize: Adaptor.sp(15), color: Colors.black54),
          ),
        ),
      )
      ..add(
        Container(
          width: Adaptor.width(36),
          height: Adaptor.height(32),
          alignment: Alignment.center,
          child: Text(
            '三胆',
            style: TextStyle(fontSize: Adaptor.sp(15), color: Colors.black54),
          ),
        ),
      );
    rows.add(TableRow(children: titleCells));
    for (int i = 0; i < widget.record.length; i++) {
      Fc3dMasterRecord row = widget.record[i];
      List<Widget> cells = List();
      cells
        ..add(
          Container(
            width: Adaptor.width(70),
            height: Adaptor.height(32),
            alignment: Alignment.center,
            child: Text(
              '${row.period}期',
              style: TextStyle(fontSize: Adaptor.sp(15), color: Colors.black54),
            ),
          ),
        )
        ..add(
          _buildAchieveCell(row.hit1, 1),
        )
        ..add(
          _buildAchieveCell(row.hit2, 1),
        )
        ..add(
          _buildAchieveCell(row.hit3, 1),
        );
      rows.add(TableRow(children: cells));
    }
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(Adaptor.width(10), 0, Adaptor.width(10), 0),
      margin: EdgeInsets.only(bottom: Adaptor.width(25)),
      child: Table(
        border: TableBorder(
          horizontalInside: BorderSide(color: Colors.black12, width: 0.2),
        ),
        children: rows,
      ),
    );
  }

  Widget _buildComAchieve() {
    List<TableRow> rows = List();
    List<Widget> titleCells = List();
    titleCells
      ..add(
        Container(
          width: Adaptor.width(70),
          height: Adaptor.height(32),
          alignment: Alignment.center,
          child: Text(
            '预测期号',
            style: TextStyle(fontSize: Adaptor.sp(15), color: Colors.black54),
          ),
        ),
      )
      ..add(
        Container(
          width: Adaptor.width(36),
          height: Adaptor.height(32),
          alignment: Alignment.center,
          child: Text(
            '五码',
            style: TextStyle(fontSize: Adaptor.sp(15), color: Colors.black54),
          ),
        ),
      )
      ..add(
        Container(
          width: Adaptor.width(36),
          height: Adaptor.height(32),
          alignment: Alignment.center,
          child: Text(
            '六码',
            style: TextStyle(fontSize: Adaptor.sp(15), color: Colors.black54),
          ),
        ),
      )
      ..add(
        Container(
          width: Adaptor.width(36),
          height: Adaptor.height(32),
          alignment: Alignment.center,
          child: Text(
            '七码',
            style: TextStyle(fontSize: Adaptor.sp(15), color: Colors.black54),
          ),
        ),
      );
    rows.add(TableRow(children: titleCells));
    for (int i = 0; i < widget.record.length; i++) {
      Fc3dMasterRecord row = widget.record[i];
      List<Widget> cells = List();
      cells
        ..add(
          Container(
            width: Adaptor.width(70),
            height: Adaptor.height(32),
            alignment: Alignment.center,
            child: Text(
              '${row.period}期',
              style: TextStyle(fontSize: Adaptor.sp(15), color: Colors.black54),
            ),
          ),
        )
        ..add(
          _buildAchieveCell(row.hit5, 2),
        )
        ..add(
          _buildAchieveCell(row.hit6, 2),
        )
        ..add(
          _buildAchieveCell(row.hit7, 2),
        );
      rows.add(TableRow(children: cells));
    }
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(Adaptor.width(10), 0, Adaptor.width(10), 0),
      margin: EdgeInsets.only(bottom: Adaptor.width(25)),
      child: Table(
        border: TableBorder(
          horizontalInside: BorderSide(color: Colors.black12, width: 0.2),
        ),
        children: rows,
      ),
    );
  }

  Widget _buildKillAchieve() {
    List<TableRow> rows = List();
    List<Widget> titleCells = List();
    titleCells
      ..add(
        Container(
          width: Adaptor.width(70),
          height: Adaptor.height(32),
          alignment: Alignment.center,
          child: Text(
            '预测期号',
            style: TextStyle(fontSize: Adaptor.sp(15), color: Colors.black54),
          ),
        ),
      )
      ..add(
        Container(
          width: Adaptor.width(36),
          height: Adaptor.height(32),
          alignment: Alignment.center,
          child: Text(
            '杀一',
            style: TextStyle(fontSize: Adaptor.sp(15), color: Colors.black54),
          ),
        ),
      )
      ..add(
        Container(
          width: Adaptor.width(36),
          height: Adaptor.height(32),
          alignment: Alignment.center,
          child: Text(
            '杀二',
            style: TextStyle(fontSize: Adaptor.sp(15), color: Colors.black54),
          ),
        ),
      )
      ..add(
        Container(
          width: Adaptor.width(48),
          height: Adaptor.height(32),
          alignment: Alignment.center,
          child: Text(
            '定位码',
            style: TextStyle(fontSize: Adaptor.sp(15), color: Colors.black54),
          ),
        ),
      );
    rows.add(TableRow(children: titleCells));
    for (int i = 0; i < widget.record.length; i++) {
      Fc3dMasterRecord row = widget.record[i];
      List<Widget> cells = List();
      cells
        ..add(
          Container(
            width: Adaptor.width(70),
            height: Adaptor.height(32),
            alignment: Alignment.center,
            child: Text(
              '${row.period}期',
              style: TextStyle(fontSize: Adaptor.sp(15), color: Colors.black54),
            ),
          ),
        )
        ..add(
          _buildAchieveCell(row.khit1, 1),
        )
        ..add(
          _buildAchieveCell(row.khit2, 1),
        )
        ..add(
          _buildAchieveCell(row.chit5, 1),
        );
      rows.add(TableRow(children: cells));
    }
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(Adaptor.width(10), 0, Adaptor.width(10), 0),
      margin: EdgeInsets.only(bottom: Adaptor.width(25)),
      child: Table(
        border: TableBorder(
          horizontalInside: BorderSide(color: Colors.black12, width: 0.2),
        ),
        children: rows,
      ),
    );
  }

  Widget _buildAchieveCell(int hit, int throttle) {
    return Container(
      width: Adaptor.width(36),
      height: Adaptor.height(26),
      alignment: Alignment.center,
      child: Icon(
        IconData(hit >= throttle ? 0xec01 : 0xe62c, fontFamily: 'iconfont'),
        size: Adaptor.sp(13),
        color: hit >= throttle ? Colors.redAccent : Colors.black38,
      ),
    );
  }

  ///构建选择类型的button
  ///
  Widget _buildTypeButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        ClipButton(
            text: '胆码成绩',
            width: Adaptor.width(80),
            height: Adaptor.height(28),
            value: 1,
            selected: selectIndex == 1 ? 1 : 0,
            onTap: (selected, value) {
              if (selected == 0) {
                setState(() {
                  selectIndex = value;
                });
              }
            }),
        ClipButton(
            text: '组选成绩',
            width: Adaptor.width(80),
            height: Adaptor.height(28),
            value: 2,
            selected: selectIndex == 2 ? 1 : 0,
            onTap: (selected, value) {
              if (selected == 0) {
                setState(() {
                  selectIndex = value;
                });
              }
            }),
        ClipButton(
            text: '杀码成绩',
            width: Adaptor.width(80),
            height: Adaptor.height(28),
            value: 3,
            margin: 0,
            selected: selectIndex == 3 ? 1 : 0,
            onTap: (selected, value) {
              if (selected == 0) {
                setState(() {
                  selectIndex = value;
                });
              }
            }),
      ],
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
