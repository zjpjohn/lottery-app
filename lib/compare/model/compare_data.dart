import 'package:lottery_app/commons/tools.dart';

class OpenModel {
  String masterId;
  String name;
  String rate;
  int series;
  List<Model> values;

  OpenModel();
}

class UnOpenModel {
  String masterId;
  String name;
  String rate;
  int series;
  List<String> values;

  UnOpenModel();
}
