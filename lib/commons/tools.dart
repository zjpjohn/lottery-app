class Tools {
  ///字符串分割,params-[data]
  static List<String> split(String data) {
    if (data == null || data.isEmpty) {
      return null;
    }
    return data.trim().split(RegExp(r'\s+'));
  }

  ///字符串匹配分割,参数-[data]
  static List<Model> parse(String data) {
    if (data == null || data.isEmpty) {
      return null;
    }
    List<String> splits = data.trim().split(RegExp(r'\s+'));
    RegExp modeRegex = new RegExp(r'\[\d+\]');
    RegExp regex = new RegExp(r'\[|\]');
    List<Model> results = new List();
    splits.forEach((item) {
      if (modeRegex.hasMatch(item)) {
        String v = item.replaceAll(regex, '');
        results.add(Model(v, 1));
      } else {
        results.add(Model(item, 0));
      }
    });
    return results;
  }

  ///分段字符串匹配分割,参数-[data]
  static List<Model> segParse(String data) {
    if (data == null || data.isEmpty) {
      return null;
    }
    List<String> segs = data.split(RegExp(r'\*'));
    List<Model> results = new List();
    for (int i = 0; i < segs.length; i++) {
      List<Model> items = parse(segs[i]);
      results.addAll(items);
      if (i < segs.length - 1) {
        results.add(Model('*', 0));
      }
    }
    return results;
  }

  static List<String> segSplit(String data) {
    if (data == null || data.isEmpty) {
      return null;
    }
    List<String> segs = data.split(RegExp(r'\*'));
    List<String> results = new List();
    for (int i = 0; i < segs.length; i++) {
      results.addAll(split(segs[i]));
      if (i < segs.length - 1) {
        results.add('*');
      }
    }
    return results;
  }

  ///手机号校验
  static bool phone(String phone) {
    RegExp regex = new RegExp(
        r'^((1[358][0-9])|(14[579])|(166)|(17[0135678])|(19[89]))\d{8}$');
    return regex.hasMatch(phone);
  }

  ///纯数字判断
  static bool number(String source) {
    RegExp regex = RegExp(r'\d{1,}');
    return regex.hasMatch(source);
  }

  static bool password(String password) {
    RegExp regex = new RegExp(r'(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z]{8,16}');
    return regex.hasMatch(password);
  }

  static String encodePhone(String phone) {
    return phone.replaceRange(3, 7, '****');
  }

  static String limitName(String name, int limit) {
    String str;
    if (name.length > limit) {
      str = name.substring(0, limit) + '...';
    } else {
      str = name;
    }
    return str;
  }

  static String limitText(String name, int limit) {
    String str;
    if (name.length > limit) {
      str = name.substring(0, limit);
    } else {
      str = name;
    }
    return str;
  }
}

class Model {
  String k;
  int v;

  Model(this.k, this.v);
}
