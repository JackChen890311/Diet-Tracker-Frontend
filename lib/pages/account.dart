import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:diet_tracker/widgets/app_bar.dart';
import 'package:diet_tracker/utils/style.dart';
import 'package:diet_tracker/utils/user.dart';
import 'package:diet_tracker/utils/image.dart';
import 'package:diet_tracker/utils/entry.dart';
import 'package:diet_tracker/utils/post.dart';
import 'package:diet_tracker/widgets/post_card.dart';
import 'package:diet_tracker/widgets/post_input.dart';
import 'package:diet_tracker/widgets/entry_card.dart';
import 'package:diet_tracker/utils/fakedata_lib.dart' as fakedata;
import 'package:diet_tracker/services/global_service.dart';
import 'package:diet_tracker/services/api.dart';

// import 'package:flutter/cupertino.dart';
// import 'package:diet_tracker/widgets/people_card.dart';
// import 'package:flutter/widgets.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});
  final String title = 'Account';

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  // late int _entryCnt;
  // late int _postCnt;
  // late int _likeCnt;
  // final List<PostBlock> _postList = [];
  // final List<PostBlock> _postList = fakedata.postList;

  int sortComparisonByDate(PostBlock a, PostBlock b){
    return -a.getEntry.date!.compareTo(b.getEntry.date!);
  }

  Future<void> getPostsandCount(User user) async{
    // final Map<String, dynamic>postListString = await ApiService().getPostsAll();
    // List<dynamic> response = jsonDecode(postListString['body']);
    
    // final Map<String, dynamic>entryListStringUser = await ApiService().getEntriesOfUser(user);
    // List<dynamic> response2 = jsonDecode(entryListStringUser['body']);
    // _entryCnt = response2.isEmpty ? 0 : response2.length;

    // final Map<String, dynamic>postListStringUser = await ApiService().getPostsOfUser(user);
    // List<dynamic> response3 = jsonDecode(postListStringUser['body']);
    // _postCnt = response3.isEmpty ? 0 : response3.length;

    // if (response.isEmpty){
    //   return;
    // }
    // // for (var post in response){
    // //   _postList.add(
    // //     PostBlock(post: Post.fromJson(post))
    // //   );
    // // }
    // int likeCnt = 0;
    // for (var post in response){
    //   // Post postObject = Post.fromJson(post);
    //   _postList.add(
    //     PostBlock(post: Post.fromJson(post))
    //   );
    //   if(Post.fromJson(post).user.account == user.account){
    //     likeCnt += Post.fromJson(post).likeCnt!;
    //   }
    // }
    // // print(likeCnt);
    // _likeCnt = likeCnt;
    print('Done');
    // print(_postList.length);


  }

  void _addNewPost () async {
    Post newPost = await showAddPostDialog(context);
    if (newPost.postID == 0) {
      return;
    }
    else{
      // setState(() {
      //   _postList.add(
      //     PostBlock(post: newPost)
      //   );
      //   _postList.sort(sortComparisonByDate);
      // });
      // To Database
      // print(newPost.toJson());
      // TODO add a circle indicator
      var result = await ApiService().createPost(newPost);
      
      // Test
      // Map<String, dynamic> result = {'statusCode': 201, 'body': ''};
      // print(result);

      if (result['statusCode'] == 201){
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('新增成功'),
              content: const Text('貼文新增成功！'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
        print('<LOG> Post added successfully');
      }
      else{
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('新增失敗'),
              content: const Text('貼文新增失敗，請檢查網路狀態或再試一次！'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
        print('<LOG> Failed to add post');
      }

    }
  }
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final global = GlobalService();
    final user = global.getUserData;
    final List<PostBlock> postList = global.getPostData;
    int entryCnt = global.getEntryCnt;
    int postCnt = global.getPostCnt;
    int likeCnt = global.getLikeCnt;    
    
    return FutureBuilder(
      future: getPostsandCount(user),
      builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          postList.sort(sortComparisonByDate);
          return Scaffold(
            appBar: const MyAppBar(title: 'Account'),
            body: Center(
              child: Flex(
                direction: Axis.horizontal,
                children: [
                  Expanded(
                    flex: 1,
                    child: Stack(
                      children: [
                        Container(
                          alignment: Alignment.topCenter,
                          decoration: const BoxDecoration(
                            color: Colors.white12,
                            image: DecorationImage(
                              image: AssetImage('assets/banner.jpg'),
                              fit: BoxFit.cover,
                              alignment: Alignment.topCenter
                            ),
                          ),
                          height: size.height * 0.4,
                        ),
                        Positioned(
                          left: size.width * 0.05,
                          top: size.height * 0.3,
                          child: Column(
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  SizedBox(width: size.width*0.02),
                                  CircleAvatar(
                                    backgroundColor: Colors.black12,
                                    radius: size.height * 0.12,
                                    child: CircleAvatar(
                                      backgroundImage: user.userImg==null? user.gender==0? const AssetImage('assets/headshot_female.jpg'):const AssetImage('assets/headshot_male.jpg'): AssetImage(user.userImg!),
                                      radius: size.height * 0.1,
                                    ),
                                  ),
                                  // TODO add update user img
                                  // I'm not sure if it works (Will AssetImage work with base64 string?)
                                  // IconButton(
                                  //   onPressed: () async {
                                  //     var picked = await FilePicker.platform.pickFiles(
                                  //       // allowMultiple: true, 
                                  //       type: FileType.custom,
                                  //       allowedExtensions: ['jpg', 'png']
                                  //     );
                                  //     if (picked != null) {
                                  //       for (var file in picked.files) {
                                  //         print(file.name);
                                  //         print(file.bytes); //Uint8List
                                  //         String imgString64 = base64String(file.bytes!);
                                  //       }
                                  //       // var result = await ApiService().updateUserImg(user, base64String(picked.files[0].bytes!));
                                  //       // print(result);
                                  //     }
                                  //   }, 
                                  //   icon: const Icon(Icons.camera_alt_rounded
                                  // )),
                                  SizedBox(width: size.width*0.005),
                                  Text(user.userName,
                                    style: const TextStyle(
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 2.0,
                                    ), 
                                  ),
                                  SizedBox(width: size.width*0.01),
                                  
                                  // const Padding(
                                  //   padding: EdgeInsets.only(bottom: 8),
                                  //   child: Icon(Icons.male, color: Colors.black38,),
                                  // ),
                                ],
                              ),
                              SizedBox(height: size.height*0.06),
                              Row(
                                children: [
                                  SizedBox(width: size.width*0.04),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        // '${user.postCnt!}',
                                        '$postCnt',
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontWeight:FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                      const SizedBox(height: 5),
                                      const Text(
                                        "Posts",
                                        style: TextStyle(
                                          color: Colors.grey,
                                          fontWeight:FontWeight.normal,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(width: size.width*0.025),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        // '${user.likeCnt!}',
                                        '$likeCnt',
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontWeight:FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                      const SizedBox(height: 5),
                                      const Text(
                                        "Likes",
                                        style: TextStyle(
                                          color: Colors.grey,
                                          fontWeight:FontWeight.normal,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(width: size.width*0.025),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        // '${user.postCnt!}',
                                        '$entryCnt',
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontWeight:FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                      const SizedBox(height: 5),
                                      const Text(
                                        "Entries",
                                        style: TextStyle(
                                          color: Colors.grey,
                                          fontWeight:FontWeight.normal,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ],
                                  ),
                                
                                ],
                              )
                              
                            ]
                          )
                        ),
                        Container(
                          height: size.height*0.8,
                        )
                      ]
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child:postList.isEmpty ? 
                      const Center(
                          child: CustomText(label: "No posts yet.\n\nClick the button below to add a new post.\n", 
                                        type: 'displaySmall',),
                        )
                      :
                      SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: SizedBox(
                          height: size.height * 0.9, 
                          child: ListView.builder(
                            itemCount: postList.length,
                            itemBuilder: (context, index){
                              return postList[index];
                            }
                          ),
                        )
                      )
                  )
                ],
              ),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: _addNewPost,
              tooltip: 'Add New Post',
              child: const Icon(Icons.add),
            ),
          );
        }
      }
    );
  }
}
