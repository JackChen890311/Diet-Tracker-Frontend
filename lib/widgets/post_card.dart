import 'package:flutter/material.dart';
import 'package:diet_tracker/utils/style.dart';

class PostBlock extends StatelessWidget {
  const PostBlock({
    super.key,
    required this.photo,
    required this.foodname,
    required this.date,
  });
  final String photo;
  final String foodname;
  final String date;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return SizedBox(
      width: size.width * 0.9,
      height: size.height * 0.4,
      child: Card(
        child: Row(
          children: [
            Image.asset(photo),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
              Row(children: [
                const SizedBox(width: 20),
                const Icon(Icons.fastfood),
                const SizedBox(width: 20),
                const CustomText(label: '餐點名稱'),
                const SizedBox(width: 20),
                CustomText(label: foodname),
              ]),

              Row(children: [
                const SizedBox(width: 20),
                const Icon(Icons.calendar_today),
                const SizedBox(width: 20),
                const CustomText(label: '日期'),
                const SizedBox(width: 20),
                CustomText(label: date),
              ]),
          ],
        ),
      ]),
    ));
  }
}