import 'package:diet_tracker/utils/style.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final Color textColor;
  final Color buttonColor;
  final double padding;

  final void Function() onClick;

  const CustomButton(
      {Key? key,
      required this.text,
      required this.textColor,
      required this.buttonColor,
      required this.onClick,
      this.padding = 30.0})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ButtonTheme(
      child: TextButton(
        onPressed: () {
          onClick();
        },
        style: ButtonStyle(
            padding: MaterialStateProperty.all<EdgeInsets>(
                EdgeInsets.fromLTRB(padding, 12.0, padding, 12.0)),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0),
            )),
            backgroundColor: MaterialStateProperty.all(buttonColor)),
        child: CustomText(label: '$text', color: textColor, type: 'subtitle'),
      ),
    );
  }
}

class LoadingButton extends StatelessWidget {
  const LoadingButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ButtonTheme(
      minWidth: 210,
      height: 50.0,
      child: TextButton(
        style: ButtonStyle(
            padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.all(15)),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0),
            )),
            backgroundColor: MaterialStateProperty.all(Color(0xFfF6F6F6))),
        onPressed: null,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              width: 20,
              height: 20,
              // padding: const EdgeInsets.only(right: 12, top: 12, bottom:12),
              child: CircularProgressIndicator(
                backgroundColor: Colors.white,
                valueColor: AlwaysStoppedAnimation<Color>(
                    Theme.of(context).colorScheme.secondary),
                strokeWidth: 2,
              ),
            ),
            const SizedBox(width: 10),
            CustomText(
                label: 'loading',
                color: Theme.of(context).colorScheme.secondary,
                type: 'body'),
          ],
        ),
      ),
    );
  }
}

class CustomOutlinedButton extends StatelessWidget {
  final String text;
  final Color borderColor;

  final void Function() onClick;

  const CustomOutlinedButton(
      {Key? key,
      required this.text,
      required this.borderColor,
      required this.onClick})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ButtonTheme(
      height: 50.0,
      child: TextButton(
        onPressed: () {
          onClick();
        },
        style: ButtonStyle(
            padding: MaterialStateProperty.all<EdgeInsets>(
                EdgeInsets.fromLTRB(30.0, 12.0, 30.0, 12.0)),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
              side: BorderSide(width: 1.0, color: borderColor),
              borderRadius: BorderRadius.circular(30.0),
            )),
            backgroundColor: MaterialStateProperty.all(Colors.transparent)),
        child: CustomText(label: text, color: borderColor, type: 'subtitle'),
      ),
    );
  }
}