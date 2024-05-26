import 'package:flutter/material.dart';
import 'package:diet_tracker/widgets/app_bar.dart';
import 'package:diet_tracker/utils/style.dart';
import 'package:diet_tracker/utils/user.dart';
import 'package:diet_tracker/utils/post.dart';
import 'package:diet_tracker/widgets/post_card.dart';
import 'package:diet_tracker/widgets/post_input.dart';
import 'package:diet_tracker/utils/fakedata_lib.dart' as fakedata;
import 'package:diet_tracker/services/global_service.dart';

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

  int sortComparisonByDate(PostBlock a, PostBlock b){
    return -a.getEntry.date!.compareTo(b.getEntry.date!);
  }
  final List<PostBlock> _postList = fakedata.postList;

  void _addNewPost () async {
    Post newPost = await showAddPostDialog(context);
    if (newPost.postID == 0) {
      return;
    }
    else{
      setState(() {
        _postList.add(
          PostBlock(post: newPost)
        );
        _postList.sort(sortComparisonByDate);
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    _postList.sort(sortComparisonByDate);
    final global = GlobalService();
    final user = global.getUserData;
    
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
                                  '${user.postCnt!}',
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
                                  '${user.likeCnt!}',
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
                                  '${user.entryCnt!}',
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
              child:_postList.isEmpty ? 
                const Center(
                  child: CustomText(label: "No posts yet.", 
                                type: 'displaySmall',)
                  ):
                SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: SizedBox(
                    height: size.height * 0.9, 
                    child: ListView.builder(
                      itemCount: _postList.length,
                      itemBuilder: (context, index){
                        return _postList[index];
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
