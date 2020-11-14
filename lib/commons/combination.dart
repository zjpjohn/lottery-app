import 'dart:math';

class CombinationUtils {
  ///从数据源中获取组合的数据值
  ///
  static List<int> getCombineValue(List<int> source, int m, int index) {
    int n = source.length;
    List<int> temp = List();
    int start = 0;
    while (m > 0) {
      if (m == 1) {
        temp.add(source[start + index]);
        break;
      }
      for (int i = 0; i <= (n - m); i++) {
        int combine = getCombine(n - 1 - i, m - 1);
        if (index <= combine - 1) {
          temp.add(source[start + i]);
          start = start + (i + 1);
          n = n - (i + 1);
          m--;
          break;
        } else {
          index = index - combine;
        }
      }
    }
    return temp;
  }

  ///计算组合数
  ///
  static int getCombine(int n, int m) {
    if (n < 0 || m < 0) {
      throw 'n,m必须大于0';
    }
    if (n == 0 || m == 0) {
      return 1;
    }

    if (n < m) {
      return 0;
    }
    if (m > n / 2.0) {
      m = n - m;
    }
    double result = 0.0;

    for (int i = n; i >= (n - m + 1); i--) {
      result += log(i);
    }
    for (int i = m; i >= 1; i--) {
      result -= log(i);
    }
    result = exp(result);
    return result.round();
  }
}
