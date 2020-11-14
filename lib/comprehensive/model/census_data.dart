import 'dart:convert';

class CensusData {
  ///统计数据期号
  String period;

  ///类型
  int type;

  ///前10统计
  List level10;

  ///前20统计
  List level20;

  ///前50统计
  List level50;

  ///前100统计
  List level100;

  CensusData(
    this.period,
    this.type,
    this.level10,
    this.level20,
    this.level50,
    this.level100,
  );

  CensusData.fromJson(Map<String, dynamic> data) {
    this.period = data['period'];
    this.type = data['type'];
    this.level10 = json.decode(data['level10']);
    this.level20 = json.decode(data['level20']);
    this.level50 = json.decode(data['level50']);
    this.level100 = json.decode(data['level100']);
  }
}
