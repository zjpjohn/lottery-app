import 'package:flutter/material.dart';
import 'package:lottery_app/components/clip_button.dart';
import 'package:lottery_app/components/adaptor.dart';
import 'package:lottery_app/model/dlt_master.dart';

class DltAchieveWidget extends StatelessWidget {
  List<DltMasterRecord> record;

  DltAchieveWidget({Key key, @required this.record}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DltAchieveView(
      record: record,
    );
  }
}

class DltAchieveView extends StatefulWidget {
  List<DltMasterRecord> record;

  DltAchieveView({Key key, this.record}) : super(key: key);

  @override
  DltAchieveViewState createState() => new DltAchieveViewState();
}

class DltAchieveViewState extends State<DltAchieveView> {
  int selectIndex = 1;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          height: Adaptor.height(4.0),
          width: Adaptor.width(45.0),
          margin: EdgeInsets.only(
            top: Adaptor.width(14.0),
          ),
          decoration: BoxDecoration(
            color: Color(0xffbcbcbc),
            borderRadius: BorderRadius.all(
              Radius.circular(5),
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.only(top: Adaptor.width(12.0)),
          child: _buildTypeButton(),
        ),
        Expanded(
          child: Container(
            margin: EdgeInsets.only(top: Adaptor.width(12.0)),
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
                  Offstage(
                    offstage: selectIndex != 4,
                    child: _buildBlueAchieve(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
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
            width: Adaptor.width(72),
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
            width: Adaptor.width(72),
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
            width: Adaptor.width(72),
            height: Adaptor.height(28),
            value: 3,
            selected: selectIndex == 3 ? 1 : 0,
            onTap: (selected, value) {
              if (selected == 0) {
                setState(() {
                  selectIndex = value;
                });
              }
            }),
        ClipButton(
            text: '蓝球成绩',
            width: Adaptor.width(72),
            height: Adaptor.height(28),
            margin: 0,
            value: 4,
            selected: selectIndex == 4 ? 1 : 0,
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
            style: TextStyle(
              fontSize: Adaptor.sp(15),
              color: Colors.black54,
            ),
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
            style: TextStyle(
              fontSize: Adaptor.sp(15),
              color: Colors.black54,
            ),
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
      DltMasterRecord row = widget.record[i];
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
          _buildAchieveCell(row.hit2, 1),
        )
        ..add(
          _buildAchieveCell(row.hit3, 1),
        );
      rows.add(TableRow(children: cells));
    }
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(
        Adaptor.width(10),
        0,
        Adaptor.width(10),
        0,
      ),
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
            '10码',
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
            '20码',
            style: TextStyle(fontSize: Adaptor.sp(15), color: Colors.black54),
          ),
        ),
      );
    rows.add(TableRow(children: titleCells));
    for (int i = 0; i < widget.record.length; i++) {
      DltMasterRecord row = widget.record[i];
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
          _buildAchieveCell(row.hit10, 3),
        )
        ..add(
          _buildAchieveCell(row.hit20, 4),
        );
      rows.add(TableRow(children: cells));
    }
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(
        Adaptor.width(10),
        0,
        Adaptor.width(10),
        0,
      ),
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
            '杀三码',
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
            '杀六码',
            style: TextStyle(fontSize: Adaptor.sp(15), color: Colors.black54),
          ),
        ),
      );
    rows.add(TableRow(children: titleCells));
    for (int i = 0; i < widget.record.length; i++) {
      DltMasterRecord row = widget.record[i];
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
          _buildAchieveCell(row.khit3, 1),
        )
        ..add(
          _buildAchieveCell(row.khit6, 1),
        );
      rows.add(TableRow(children: cells));
    }
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(Adaptor.width(10), 0, Adaptor.width(10), 0),
      margin: EdgeInsets.only(
        bottom: Adaptor.width(25),
      ),
      child: Table(
        border: TableBorder(
          horizontalInside: BorderSide(color: Colors.black12, width: 0.2),
        ),
        children: rows,
      ),
    );
  }

  Widget _buildBlueAchieve() {
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
            '篮六',
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
            '杀蓝',
            style: TextStyle(fontSize: Adaptor.sp(15), color: Colors.black54),
          ),
        ),
      );
    rows.add(TableRow(children: titleCells));
    for (int i = 0; i < widget.record.length; i++) {
      DltMasterRecord row = widget.record[i];
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
          _buildAchieveCell(row.bhit6, 2),
        )
        ..add(
          _buildAchieveCell(row.bkhit, 1),
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
      height: Adaptor.width(26),
      alignment: Alignment.center,
      child: Icon(
        IconData(hit >= throttle ? 0xec01 : 0xe62c, fontFamily: 'iconfont'),
        size: Adaptor.sp(13),
        color: hit >= throttle ? Colors.redAccent : Colors.black38,
      ),
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  void didUpdateWidget(DltAchieveView oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }
}
