import 'dart:core';
import 'dart:core' as prefix0;

import 'package:lottery_app/commons/combination.dart';
import 'package:lottery_app/commons/constants.dart';
import 'package:lottery_app/shrink/ssq/ac_shrink_widget.dart';
import 'package:lottery_app/shrink/ssq/dan_shrink_widget.dart';
import 'package:lottery_app/shrink/ssq/kua_shrink_widget.dart';
import 'package:lottery_app/shrink/ssq/pattern_shrink_widget.dart';
import 'package:lottery_app/shrink/ssq/seg_shrink_widget.dart';
import 'package:lottery_app/shrink/ssq/series_shrink_widget.dart';
import 'package:lottery_app/shrink/ssq/sum_shrink_widget.dart';

class SsqShrinkFilter {
  ///选择的号码
  List<int> balls = List.of(Constant.ssq);

  ///胆码过滤
  SsqDanShrink danFilter;

  ///号码形态过滤
  PatternShrink patternFilter;

  ///和值过滤
  SumShrink sumFilter;

  ///跨度过滤
  KuaShrink kuaFilter;

  ///ac过滤
  AcShrink acFilter;

  ///分区出号过滤
  SegmentShrink segFilter;

  ///连号过滤
  SeriesShrink seriesFilter;

  ///缩水后号码
  List<List<int>> lotteries = List();

  void resetFilter() {
    danFilter = null;
    patternFilter = null;
    sumFilter = null;
    kuaFilter = null;
    acFilter = null;
    segFilter = null;
    seriesFilter = null;
    lotteries.clear();
  }

  bool nullFilter() {
    return (danFilter == null &&
        patternFilter == null &&
        sumFilter == null &&
        kuaFilter == null &&
        acFilter == null &&
        segFilter == null &&
        seriesFilter == null);
  }

  ///号码缩水
  void shrink() {
    lotteries.clear();
    List<int> others =
        Set.of(balls).difference(Set.of(danFilter.dans)).toList();

    ///通过胆码进行组码
    danFilter.numbers.forEach((mem) {
      int danCom = CombinationUtils.getCombine(danFilter.dans.length, mem);
      for (int i = 0; i < danCom; i++) {
        List<int> numbers =
            CombinationUtils.getCombineValue(danFilter.dans.toList(), mem, i);
        int otherNum = 6 - mem;
        if (otherNum == 0) {
          if (filter(numbers)) {
            lotteries.add(numbers..sort());
          }
        } else {
          int otherCom = CombinationUtils.getCombine(others.length, otherNum);
          for (int j = 0; j < otherCom; j++) {
            List<int> ballNumbers = List.of(numbers)
              ..addAll(CombinationUtils.getCombineValue(others, otherNum, j));
            if (filter(ballNumbers)) {
              lotteries.add(ballNumbers..sort());
            }
          }
        }
      }
    });
  }

  ///过滤选择号码
  bool filter(List<int> balls) {
    ///号码形态过滤
    if (patternFilter != null && !patternFilter.filter(balls)) {
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

    ///ac值过滤
    if (acFilter != null && !acFilter.filter(balls)) {
      return false;
    }

    ///分区出号过滤
    if (segFilter != null && !segFilter.filter(balls)) {
      return false;
    }

    ///连号过滤
    if (seriesFilter != null && !seriesFilter.filter(balls)) {
      return false;
    }

    ///全部通过
    return true;
  }
}
