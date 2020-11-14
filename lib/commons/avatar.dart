import 'package:flutter/material.dart';

class Avatar extends StatelessWidget {
  static final List<Color> bgColors = <Color>[
    Color(0xfff48f7b),
    Color(0xfff6ab72),
    Color(0xffedca81),
    Color(0xffb0c8a5),
    Color(0xffbab0b0),
    Color(0xffadbbd4),
    Color(0xffd4b4e8),
    Color(0xffd2aeae),
    Color(0xffe4c4cd),
    Color(0xff88c898),
    Color(0xff8495b1),
    Color(0xff877aa3),
    Color(0xffc479a2)
  ];

  final RegExp zhcnRegex = new RegExp(r"(\w|[\u4E00-\u9FA5])");

  String name;
  double fontSize;
  double size;
  Color background;
  Color color;

  Avatar(
    this.name, {
    this.fontSize = 32,
    this.size = 50,
    this.color,
    this.background,
  });

  @override
  Widget build(BuildContext context) {
    String avatar = _initial();
    Color bgColor;
    Color txtColor;
    if (this.background != null) {
      bgColor = this.background;
      txtColor = this.color == null ? _color(this.name) : this.color;
    } else {
      bgColor = _color(this.name);
      txtColor = this.color == null ? Colors.white : this.color;
    }

    return Container(
      height: size,
      width: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: bgColor,
      ),
      child: Text(
        avatar,
        style: TextStyle(
          color: txtColor,
          fontSize: fontSize,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Color _color(String seed) {
    return bgColors[seed.hashCode % bgColors.length];
  }

  String _initial() {
    String text = '';
    if (name != null) {
      String s = name.toUpperCase();
      for (int i = 0; i < s.length; i++) {
        String item = s.substring(i, i + 1);
        if (zhcnRegex.hasMatch(item)) {
          text = item;
          break;
        }
      }
    }
    return text.trim();
  }
}
