import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:diet_tracker/utils/style.dart';
import 'package:diet_tracker/utils/entry.dart';

class EntryBlock extends StatelessWidget {
  const EntryBlock({
    super.key,
    required this.entry,
    this.imgFirst = false,
  });

  final Entry entry;
  final bool imgFirst;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var photo = entry.entryImage;
    var date = DateFormat('yyyy-MM-dd').format(entry.date!);
    var foodname = entry.foodName;
    var restoName = entry.restoName;
    var price = entry.price;
    var calories = entry.calories;

    return SizedBox(
      height: size.height * 0.4,
      child: Card(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            imgFirst ? Image.asset(photo!) : const SizedBox(width: 0),
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
                CustomText(label: foodname!),
              ]),

              Row(children: [
                const SizedBox(width: 20),
                const Icon(Icons.location_on),
                const SizedBox(width: 20),
                const CustomText(label: '店家名稱'),
                const SizedBox(width: 20),
                CustomText(label: '$restoName'),
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
            imgFirst ? const SizedBox(width: 0) : Image.asset(photo!),
      ]),
    ));
  }
}