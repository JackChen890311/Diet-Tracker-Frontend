import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:diet_tracker/utils/style.dart';
import 'package:diet_tracker/utils/post.dart';
import 'package:diet_tracker/utils/user.dart';
import 'package:diet_tracker/utils/entry.dart';

class PostBlock extends StatelessWidget {
  const PostBlock({
    super.key,
    required this.post,
  });

  final Post post;
  Post get getPost => post;
  User get getUser => post.user;
  Entry get getEntry => post.entry;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var entry = post.entry;

    var photo = entry.entryImage;
    var date = DateFormat('yyyy-MM-dd').format(entry.date!);
    var foodname = entry.foodName;
    var restoName = entry.restoName;
    var price = entry.price;
    var calories = entry.calories;

    return SizedBox(
      height: size.height * 0.9,
      child: Card(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                CircleAvatar(
                  backgroundColor: Colors.black12,
                  radius: size.height * 0.04,
                  child: CircleAvatar(
                    backgroundImage:const AssetImage('assets/headshot.png'),
                    radius: size.height * 0.1,
                  ),
                ),
                const Icon(Icons.account_circle),
                CustomText(label: getUser.account),
                const Icon(Icons.calendar_today),
                CustomText(label: date),
                const Icon(Icons.fastfood),
                CustomText(label: foodname!),
                const Icon(Icons.location_on),
                CustomText(label: '$restoName'),
                const Icon(Icons.attach_money),
                CustomText(label: '$price'),
                const Icon(Icons.local_fire_department),
                CustomText(label: '$calories'),
            ]),
            SizedBox(
              height: size.height * 0.5,
              child: Image.asset(photo!, fit: BoxFit.cover),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(height: size.height * 0.1, width: size.width * 0.1),
                IconButton(
                  icon: const Icon(Icons.favorite),
                  onPressed: () {
                    // Add your favorite button logic here
                    print('heart');
                  },
                ),
                SizedBox(width: size.width * 0.02),
                CustomText(label: post.likeCnt.toString()),
                SizedBox(width: size.width * 0.02),
                IconButton(
                  icon: const Icon(Icons.comment),
                  onPressed: () {
                    // Add your comment button logic here
                    print('comment');
                  },
                ),
                SizedBox(width: size.width * 0.02),
                CustomText(label: post.commentCnt.toString()),
            ],),
            CustomText(label: post.description),
            SizedBox(height: size.height * 0.05),
      ]),
    ));
  }
}