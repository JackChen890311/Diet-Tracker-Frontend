import 'package:flutter/material.dart';

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
      width: size.height * 0.8,
      height: size.width * 0.2,
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
                Text('$price'),
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