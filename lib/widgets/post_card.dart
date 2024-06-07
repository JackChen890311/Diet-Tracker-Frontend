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
import 'package:diet_tracker/services/api.dart';
import 'package:diet_tracker/utils/comment.dart';



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
  final global = GlobalService();
  final globalUser = GlobalService().getUserData;
  late String _comment;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final commentController = TextEditingController();
  List likeUserList = [];
  List commentList = [];


  @override
  void dispose() {
    commentController.dispose();
    super.dispose();
  }

  Future<void> likePost(int postID, User postUser, User globalUser) async{
    var response = await ApiService().likePost(postID, globalUser);
    if(response['statusCode']==200){
      Map info = {
        'postID':postID,
        'valueChange':1,
        'likeUsr':globalUser, 
      };
      global.setSpecificPostLikeCnt = info;
      if(postUser.account==globalUser.account){
        global.setLikeCnt = global.getLikeCnt + 1;
      }
      Navigator.pushNamed(context, '/account');
    }
  }

  Future<void> dislikePost(int postID, User postUser, User globalUser) async{
    var response = await ApiService().dislikePost(postID, globalUser);
    if(response['statusCode']==200){
      Map info = {
        'postID':postID,
        'valueChange':-1,
        'likeUsr':globalUser, 
      };
      global.setSpecificPostLikeCnt = info;
      if(postUser.account==globalUser.account){
        global.setLikeCnt = global.getLikeCnt - 1;
      }
      Navigator.pushNamed(context, '/account');
    }
  }

  Future<void> commentPost(int postID, String comment, User globalUser) async{
    Comment commentInfo = Comment(user: globalUser, content: comment, datetime: DateTime.now().millisecondsSinceEpoch);
    var response1 = await ApiService().commentPost(postID, commentInfo);
    if(response1['statusCode']==200){
      Map info = {
        'postID':postID,
        'content':comment,
        'CommentUsr':globalUser, 
      };
      global.setSpecificPostCommentCnt = info;
      Navigator.pushNamed(context, '/account');
    }
  }
  

  @override
  Widget build(BuildContext context) {
    // var _global = GlobalService();
    // var globalUser = _global.getUserData;

    for(var comment in widget.post.comment!){
      Comment commentInfo = Comment.fromJson(comment);
      commentList.add([commentInfo.user, commentInfo.content]);
    }
    
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
                  icon: widget.getPost.like!.contains(globalUser)? Icon(Icons.favorite, color:Colors.red[300]): const Icon(Icons.favorite),
                  onPressed: () {
                    if(! widget.getPost.like!.contains(globalUser)){
                      likePost(widget.post.postID, widget.post.user, globalUser);
                    }
                    else{
                      dislikePost(widget.post.postID, widget.post.user, globalUser);
                    }
                    
                    // setState(() {
                    //   isLiked = !isLiked;
                    //   if(isLiked){
                    //     likeList.add(globalUser);
                    //     likeCnt += 1;
                    //   }
                    //   else{
                    //     likeList.remove(globalUser);
                    //     likeCnt -= 1;
                    //   }
                    //   // TODO: update "like" and "likeCnt" of Post in DB
                    // });
                    print('heart');
                  },
                ),
                SizedBox(width: size.width * 0.02),
                CustomText(label: widget.getPost.likeCnt.toString()),
                SizedBox(width: size.width * 0.02),
                IconButton(
                  icon: const Icon(Icons.comment),
                  onPressed: () {
                    // Add your comment button logic here
                    print('comment');
                  },
                ),
                SizedBox(width: size.width * 0.02),
                CustomText(label: commentList.length.toString()),
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
              children:  commentList.map((e) {
                return Padding(
                  padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
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
                      commentPost(widget.post.postID, _comment, globalUser);
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