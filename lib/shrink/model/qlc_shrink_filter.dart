import 'package:lottery_app/commons/constants.dart';
import 'package:lottery_app/shrink/qlc/ac_shrink_widget.dart';
import 'package:lottery_app/shrink/qlc/dan_shrink_widget.dart';
import 'package:lottery_app/shrink/qlc/kua_shrink_widget.dart';
import 'package:lottery_app/shrink/qlc/pattern_shrink_widget.dart';
import 'package:lottery_app/shrink/qlc/series_shrink_widget.dart';
import 'package:lottery_app/shrink/qlc/sum_shrink_widget.dart';
import 'package:lottery_app/commons/combination.dart';

class QlcShrinkFilter {
  List<int> balls = List.of(Constant.qlc);

  QlcDanShrink danFilter;

  PatternShrink patternFilter;

  SumShrink sumFilter;

  KuaShrink kuaFilter;

  AcShrink acFilter;

  SeriesShrink seriesFilter;

  ///缩水后的号码
  List<List<int>> lotteries = List();

  void resetFilter() {
    danFilter = null;
    patternFilter = null;
    sumFilter = null;
    kuaFilter = null;
    acFilter = null;
    seriesFilter = null;
    lotteries.clear();
  }

  bool nullFilter() {
    return (danFilter == null &&
        patternFilter == null &&
        sumFilter == null &&
        kuaFilter == null &&
        acFilter == null &&
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
        int otherNum = 7 - mem;
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

    ///连号过滤
    if (seriesFilter != null && !seriesFilter.filter(balls)) {
      return false;
    }

    ///全部通过
    return true;
  }
}
