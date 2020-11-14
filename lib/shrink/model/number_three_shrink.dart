import 'dart:core';
import 'dart:core' as prefix0;

import 'package:lottery_app/shrink/number3/dan_shrink_widget.dart';
import 'package:lottery_app/shrink/number3/kua_shrink_widget.dart';
import 'package:lottery_app/shrink/number3/sum_shrink_widget.dart';
import 'package:lottery_app/shrink/number3/even_shrink_widget.dart';
import 'package:lottery_app/shrink/number3/prime_shrink_widget.dart';
import 'package:lottery_app/shrink/number3/road012_shrink_widget.dart';
import 'package:lottery_app/shrink/number3/big_shrink_widget.dart';
import 'package:lottery_app/shrink/number3/pattern_shrink_widget.dart';

class NumberThreeShrink {
  ///当前选择缩水类型:0-直选,1-组选
  int type;

  ///直选选择的数据
  Map<int, List<int>> directs = {
    0: [0, 1, 2, 3, 4, 5, 6, 7, 8, 9],
    1: [0, 1, 2, 3, 4, 5, 6, 7, 8, 9],
    2: [0, 1, 2, 3, 4, 5, 6, 7, 8, 9],
  };

  ///选择的组选数据
  List<int> combines = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9];

  ///胆码过滤
  DanShrink danFilter;

  ///跨度过滤
  KuaShrink kuaFilter;

  ///和值过滤
  SumShrink sumFilter;

  ///奇偶过滤
  EvenOddShrink evenFilter;

  ///质合过滤
  PrimeShrink primeFilter;

  ///012路过滤
  Road012Shrink roadFilter;

  ///大小过滤
  BigShrink bigFilter;

  ///形态过滤
  PatternShrink patternFilter;

  ///过滤后的直选号码
  List<List<int>> direct = List();

  ///过滤后的组选号码
  List<List<int>> combine = List();

  void resetDirect() {
    directs = {
      0: [0, 1, 2, 3, 4, 5, 6, 7, 8, 9],
      1: [0, 1, 2, 3, 4, 5, 6, 7, 8, 9],
      2: [0, 1, 2, 3, 4, 5, 6, 7, 8, 9],
    };
  }

  void resetFilter() {
    danFilter = null;
    sumFilter = null;
    kuaFilter = null;
    evenFilter = null;
    primeFilter = null;
    roadFilter = null;
    bigFilter = null;
    patternFilter = null;
    direct.clear();
    combine.clear();
  }

  bool nullFilter() {
    return (danFilter == null &&
        sumFilter == null &&
        kuaFilter == null &&
        evenFilter == null &&
        primeFilter == null &&
        roadFilter == null &&
        bigFilter == null &&
        patternFilter == null);
  }

  void resetCombine() {
    combines = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9];
  }

  ///清空缩水数据
  void clear() {
    if (type == 0) {
      direct.clear();
      return;
    }
    combine.clear();
  }

  ///缩水计算
  void shrink() {
    if (type == 0) {
      directShrink();
      return;
    }
    combineShrink();
  }

  ///直选筛选
  void directShrink() {
    direct.clear();
    List<int> bai = directs[0];
    List<int> shi = directs[1];
    List<int> ge = directs[2];
    for (int i = 0; i < bai.length; i++) {
      for (int j = 0; j < shi.length; j++) {
        for (int k = 0; k < ge.length; k++) {
          List<int> ball = List.of([bai[i], shi[j], ge[k]]);

          ///如果满足缩水条件
          if (filter(ball)) {
            direct.add(ball);
          }
        }
      }
    }
  }

  ///组选筛选
  void combineShrink() {
    combine.clear();

    ///豹子筛选
    for (int i = 0; i < combines.length; i++) {
      List<int> ball = List.of([combines[i], combines[i], combines[i]]);
      if (filter(ball)) {
        combine.add(ball);
      }
    }

    ///组三筛选
    for (int i = 0; i < combines.length - 1; i++) {
      for (int j = i + 1; j < combines.length; j++) {
        List<int> ball1 = List.of([combines[i], combines[i], combines[j]]);
        if (filter(ball1)) {
          combine.add(ball1);
        }
        List<int> ball2 = List.of([combines[i], combines[j], combines[j]]);
        if (filter(ball2)) {
          combine.add(ball2);
        }
      }
    }

    ///组六筛选
    for (int i = 0; i < combines.length - 2; i++) {
      for (int j = i + 1; j < combines.length - 1; j++) {
        for (int k = j + 1; k < combines.length; k++) {
          List<int> ball = List.of([combines[i], combines[j], combines[k]]);
          if (filter(ball)) {
            combine.add(ball);
          }
        }
      }
    }
  }

  ///整体过滤
  bool filter(List<int> balls) {
    ///胆码过滤
    if (danFilter != null && !danFilter.filter(balls)) {
      return false;
    }

    ///和值过滤
    if (sumFilter != null && !sumFilter.filter(balls)) {
      return false;
    }

    ///跨度过滤
    if (kuaFilter != null && !kuaFilter.filter(balls)) {
      return false;
    }

    ///奇偶过滤
    if (evenFilter != null && !evenFilter.filter(balls)) {
      return false;
    }

    ///质合过滤
    if (primeFilter != null && !primeFilter.filter(balls)) {
      return false;
    }

    ///012路过滤
    if (roadFilter != null && !roadFilter.filter(balls)) {
      return false;
    }

    ///大小过滤
    if (bigFilter != null && !bigFilter.filter(balls)) {
      return false;
    }

    ///形态过滤
    if (patternFilter != null && !patternFilter.filter(balls)) {
      return false;
    }

    ///全部通过返回
    return true;
  }
}
