import 'package:flutter/material.dart';

class CustomColor {
  static const Color white = Colors.white;
  static const Color black = Colors.black;
  static const Color darkBlue = Color(0xff0D4A71);
  static const Color lightBlue = Colors.blue;
  static const Color darkRed = Color(0xffB71C1C);
  static const Color lightRed = Colors.red;
}

class CustomText extends StatelessWidget {
  final String label;
  final Color? color;
  final String type;
  final String? align;

  const CustomText(
      {super.key,
      required this.label,
      this.color = Colors.black,
      this.type = 'none',
      this.align = 'center'});

  TextStyle? getTextStyle(String type, BuildContext context) {
    switch (type) {
      case 'displayLarge':
        return Theme.of(context).textTheme.displayLarge;
      case 'displayMedium':
        return Theme.of(context).textTheme.displayMedium;
      case 'displaySmall':
        return Theme.of(context).textTheme.displaySmall;
      case 'titleLarge':
        return Theme.of(context).textTheme.titleLarge;
      case 'titleMedium':
        return Theme.of(context).textTheme.titleMedium;
      case 'titleSmall':
        return Theme.of(context).textTheme.titleSmall;
      case 'bodyLarge':
        return Theme.of(context).textTheme.bodyLarge;
      case 'bodySmall':
        return Theme.of(context).textTheme.bodySmall;
      default:
        return Theme.of(context).textTheme.bodyMedium;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Text(label,
        textAlign: (align == 'left' ? TextAlign.left : TextAlign.center),
        style: getTextStyle(type, context)!.merge(TextStyle(color: color)));
  }
}
