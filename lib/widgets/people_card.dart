import 'package:flutter/material.dart';
import 'package:diet_tracker/utils/style.dart';

class PeopleBlock extends StatelessWidget {
  const PeopleBlock({
    super.key,
    required this.photo,
    required this.name,
    required this.gender,
  });
  final String photo;
  final String name;
  final String gender;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return SizedBox(
      width: size.width * 0.9,
      height: size.height * 0.2,
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
                const Icon(Icons.account_circle),
                const SizedBox(width: 20),
                const CustomText(label: '名字'),
                const SizedBox(width: 20),
                CustomText(label: name),
              ]),

              Row(children: [
                const SizedBox(width: 20),
                const Icon(Icons.wc),
                const SizedBox(width: 20),
                const CustomText(label: '性別'),
                const SizedBox(width: 20),
                CustomText(label: gender),
              ]),
          ],
        ),
      ]),
    ));
  }
}