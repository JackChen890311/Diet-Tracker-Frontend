import 'package:flutter/material.dart';

class EntryBlock extends StatelessWidget {
  const EntryBlock({
    super.key,
    required this.date,
    required this.photo,
    required this.foodname,
    this.place,
    this.money,
    this.calories,
  });
  final String date;
  final String photo;
  final String foodname;
  final String? place;
  final int? money;
  final int? calories;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 1200,
      height: 250,
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
                const Text('日期', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(width: 20),
                Text(date),
              ]),

              Row(children: [
                const SizedBox(width: 20),
                const Icon(Icons.fastfood),
                const SizedBox(width: 20),
                const Text('餐點名稱', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(width: 20),
                Text(foodname),
              ]),

              Row(children: [
                const SizedBox(width: 20),
                const Icon(Icons.location_on),
                const SizedBox(width: 20),
                const Text('店家名稱', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(width: 20),
                Text('$place'),
              ]),

              Row(children: [
                const SizedBox(width: 20),
                const Icon(Icons.attach_money),
                const SizedBox(width: 20),
                const Text('價格 (NTD)', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(width: 20),
                Text('$money'),
              ]),

              Row(children: [
                const SizedBox(width: 20),
                const Icon(Icons.local_fire_department),
                const SizedBox(width: 20),
                const Text('卡路里', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(width: 20),
                Text('$calories'),
              ]),
          ],
        ),
      ]),
    ));
  }
}