import 'package:flutter/material.dart';
import 'package:diet_tracker/utils/style.dart';

class EntryBlock extends StatelessWidget {
  const EntryBlock({
    super.key,
    required this.photo,
    required this.date,
    required this.foodname,
    this.place,
    this.price,
    this.calories,
  });
  final String photo;
  final String date;
  final String foodname;
  final String? place;
  final int? price;
  final int? calories;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return SizedBox(
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
                const Icon(Icons.calendar_today),
                const SizedBox(width: 20),
                const CustomText(label: '日期'),
                const SizedBox(width: 20),
                CustomText(label: date),
              ]),

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
                const Icon(Icons.location_on),
                const SizedBox(width: 20),
                const CustomText(label: '店家名稱'),
                const SizedBox(width: 20),
                CustomText(label: '$place'),
              ]),

              Row(children: [
                const SizedBox(width: 20),
                const Icon(Icons.attach_money),
                const SizedBox(width: 20),
                const CustomText(label: '價格 (NTD)'),
                const SizedBox(width: 20),
                CustomText(label: '$price'),
              ]),

              Row(children: [
                const SizedBox(width: 20),
                const Icon(Icons.local_fire_department),
                const SizedBox(width: 20),
                const CustomText(label: '卡路里'),
                const SizedBox(width: 20),
                CustomText(label: '$calories'),
              ]),
          ],
        ),
      ]),
    ));
  }
}