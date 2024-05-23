import 'dart:core';
import 'package:flutter/material.dart';

import 'package:diet_tracker/utils/style.dart';

class CustomDialog extends StatelessWidget {
  final String? title;
  final List<Widget> content;

  const CustomDialog({Key? key, @required this.title, required this.content})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var tutorialWidth = size.width * 0.2;
    return AlertDialog(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(18.0))),
        content: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
          Stack(alignment: Alignment.center, children: [
            Container(
              width: tutorialWidth,
              alignment: Alignment.center,
            ),
            Column(children: [
              CustomText(
                  label: title!,
                  color: Theme.of(context).primaryColorDark,
                  type: 'title'),
              const SizedBox(
                height: 20,
              ),
              ...content,
              const SizedBox(
                height: 5,
              ),
            ])
          ])
        ]));
  }
}