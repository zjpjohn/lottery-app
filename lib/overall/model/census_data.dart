import 'dart:convert';

class CensusData {
  ///统计数据期号
  String period;

  ///类型
  int type;

  ///前150统计
  List level150;

  ///前300统计
  List level300;

  ///前500统计
  List level500;

  ///前750统计
  List level750;

  ///前1050统计
  List level1050;

  CensusData(
    this.period,
    this.type,
    this.level150,
    this.level300,
    this.level500,
    this.level750,
    this.level1050,
  );

  CensusData.fromJson(Map<String, dynamic> data) {
    this.period = data['period'];
    this.type = data['type'];
    this.level150 = json.decode(data['level150']);
    this.level300 = json.decode(data['level300']);
    this.level500 = json.decode(data['level500']);
    this.level750 = json.decode(data['level750']);
    if (data['level1050'] != null) {
      this.level1050 = json.decode(data['level1050']);
    }
  }
}
