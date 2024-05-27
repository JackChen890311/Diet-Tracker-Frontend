// import 'dart:html';
// import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:diet_tracker/utils/style.dart';
import 'package:diet_tracker/utils/post.dart';
import 'package:diet_tracker/utils/user.dart';
import 'package:diet_tracker/utils/entry.dart';
import 'package:diet_tracker/utils/image.dart';
import 'package:diet_tracker/services/global_service.dart';

final _global = GlobalService();
final globalUser = _global.getUserData;

class PostBlock extends StatefulWidget {
  const PostBlock({
    super.key,
    required this.post,
  });

  final Post post;

  Post get getPost => post;
  User get getUser => post.user;
  Entry get getEntry => post.entry;

  @override
  State<PostBlock> createState() => _PostBlockState();
}

class _PostBlockState extends State<PostBlock> {
  // Post get getPost => widget.post;
  // User get getUser => widget.post.user;
  // Entry get getEntry => widget.post.entry;

  late List<dynamic> likeList;
  late int likeCnt;
  late String _comment;
  late List<dynamic> comment;
  late int commentCnt;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final commentController = TextEditingController();
  

  @override
  void initState() {
    super.initState();    
    likeList = widget.post.like!;
    likeCnt = widget.post.likeCnt!;
    comment = widget.post.comment!;
    commentCnt = widget.post.commentCnt!;
  }

  @override
  void dispose() {
    commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    
    var size = MediaQuery.of(context).size;
    var entry = widget.post.entry;

    var photo = entry.entryImage;
    var date = DateFormat('yyyy-MM-dd').format(entry.date!);
    var foodname = entry.foodName;
    var restoName = entry.restoName;
    var price = entry.price;
    var calories = entry.calories;
    var userImg = entry.user.userImg;
    var userGender = entry.user.gender;
    var isLiked = likeList.contains(globalUser);
    if(comment.isEmpty){
      comment = [];
    }
    

    return SizedBox(
      // height: size.height * 0.9,
      child: Card(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 12, 8, 12),
                      child: CircleAvatar(
                        backgroundColor: Colors.black12,
                        radius: size.height * 0.04,
                        child: CircleAvatar(
                          backgroundImage:userImg==null? userGender==0? const AssetImage('assets/headshot_female.jpg'):const AssetImage('assets/headshot_male.jpg'): AssetImage(userImg),
                          radius: size.height * 0.1,
                        ),
                      ),
                    ),
                    Text(entry.user.userName, textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.5, fontSize: 16)),
                ]),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Padding(
                      padding:  EdgeInsets.all(8.0),
                      child:  Icon(Icons.calendar_today),
                    ),
                    CustomText(label: date),
                    SizedBox(width: size.width*0.01),
                    const Padding(
                      padding:  EdgeInsets.all(8.0),
                      child:  Icon(Icons.fastfood),
                    ),
                    CustomText(label: foodname!),
                    SizedBox(width: size.width*0.01),
                    const Padding(
                      padding:  EdgeInsets.all(8.0),
                      child:  Icon(Icons.location_on),
                    ),
                    CustomText(label: '$restoName'),
                    SizedBox(width: size.width*0.01),
                    const Padding(
                      padding:  EdgeInsets.all(8.0),
                      child:  Icon(Icons.attach_money),
                    ),
                    CustomText(label: '$price'),
                    SizedBox(width: size.width*0.01),
                    const Padding(
                      padding:  EdgeInsets.all(8.0),
                      child:  Icon(Icons.local_fire_department),
                    ),
                    CustomText(label: '$calories'),
                    SizedBox(width: size.width*0.01),
                  ],
                ) 
              ],
            ),
            Container(
              color: Colors.white,
              height: size.height * 0.5,
              child: Center(child: photo!.isEmpty ? Image.asset('assets/food_empty.png') : imageFromBase64String(photo, cover: true)),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(width: size.width * 0.04),
                IconButton(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  icon: isLiked? Icon(Icons.favorite, color:Colors.red[300]): const Icon(Icons.favorite),
                  onPressed: () {
                    setState(() {
                      isLiked = !isLiked;
                      if(isLiked){
                        likeList.add(globalUser);
                        likeCnt += 1;
                      }
                      else{
                        likeList.remove(globalUser);
                        likeCnt -= 1;
                      }
                      // TODO: update "like" and "likeCnt" of Post in DB
                    });
                    print('heart');
                  },
                ),
                SizedBox(width: size.width * 0.02),
                CustomText(label: likeCnt.toString()),
                SizedBox(width: size.width * 0.02),
                IconButton(
                  icon: const Icon(Icons.comment),
                  onPressed: () {
                    // Add your comment button logic here
                    print('comment');
                  },
                ),
                SizedBox(width: size.width * 0.02),
                CustomText(label: commentCnt.toString()),
              ],
            ),
            Divider(indent: size.width * 0.02, endIndent: size.width * 0.02, height: 0),
            SizedBox(height: size.height * 0.02),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(width: size.width * 0.04),
                RichText(text: TextSpan(
                  children: [
                    TextSpan(text: '${entry.user.userName}    ', style: const TextStyle(fontWeight: FontWeight.bold)),
                    TextSpan(text: widget.post.description)
                  ])
                ),
              ],
            ),
            Column(
              children: comment.map((e) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(width: size.width * 0.04),
                      RichText(text: TextSpan(
                        children: [
                          TextSpan(text: '${e[0].userName}    ', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black54)),
                          TextSpan(text: e[1].toString(), style: const TextStyle(color: Colors.black54))
                        ])
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
            SizedBox(height: size.height * 0.02),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: size.width * 0.04),
              child: Form(
                key: _formKey,
                child: TextFormField(
                  controller: commentController,
                  decoration: InputDecoration(
                    hintStyle: const TextStyle(fontSize: 14),
                    hintText: 'Add a comment...',
                    focusedBorder:
                        UnderlineInputBorder(
                      borderSide: BorderSide(
                          color: Theme.of(context)
                              .primaryColor,
                          width: 1.0),
                    )
                  ),
                  validator: (String? value) {
                    if (value!.isEmpty) {
                      return 'please enter something';
                    }
                    return null;
                  },
                  onSaved: (String? value) {
                    _comment = value!;
                  },
                  onFieldSubmitted: (value) {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      // print(_comment);
                      setState(() {
                        commentController.clear();
                        commentCnt += 1;
                        List data = [];
                        data.add(globalUser);
                        data.add(_comment);
                        comment.add(data);
                        // TODO: write into DB & update Post in DB
                      });
                    }
                  },
                ),
              ),
            ),
            SizedBox(height: size.height * 0.02),
        ]),
    ));
  }
}