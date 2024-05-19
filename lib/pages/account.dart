import 'package:flutter/material.dart';
import 'package:diet_tracker/widgets/app_bar.dart';
import 'package:diet_tracker/utils/style.dart';
import 'package:diet_tracker/utils/post.dart';
import 'package:diet_tracker/utils/entry.dart';
import 'package:diet_tracker/utils/user.dart';
import 'package:diet_tracker/widgets/post_card.dart';
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
  // int _counter = 0;

  // void _incrementCounter() {
  //   setState(() {
  //     _counter++;
  //   });
  // }

  final List<Widget> _postList = [
    PostBlock(post: 
      Post(postID: 1, 
        user:
          User(account: 'jack', email: 'jack@gmail.com', password: '1234', userName: 'Jack'), 
        entry: 
          Entry(entryID: 1, entryImage: 'assets/ramen.jpg', user: null, 
            foodName: 'ramen', restoName: 'ramen shop', date: DateTime.now(), 
            price: 400, calories: 800),
        description: 'This is a bowl of ramen.',
        like: [], likeCnt: 0,
        comment: [], commentCnt: 0,
      )
    ),
    PostBlock(post: 
      Post(postID: 3, 
        user:
          User(account: 'jack', email: 'jack@gmail.com', password: '1234', userName: 'Jack'), 
        entry: 
          Entry(entryID: 1, entryImage: 'assets/chicken.jpg', user: null, 
            foodName: 'chicken', restoName: 'chicken shop', date: DateTime.now(), 
            price: 400, calories: 800),
        description: 'This is a chicken.',
        like: [], likeCnt: 0,
        comment: [], commentCnt: 0,
      )
    ),
    PostBlock(post: 
      Post(postID: 4, 
        user:
          User(account: 'jack', email: 'jack@gmail.com', password: '1234', userName: 'Jack'), 
        entry: 
          Entry(entryID: 1, entryImage: 'assets/paella.jpg', user: null, 
            foodName: 'paella', restoName: 'paella shop', date: DateTime.now(), 
            price: 400, calories: 800),
        description: 'This is a paella.',
        like: [], likeCnt: 0,
        comment: [], commentCnt: 0,
      )
    ),
    PostBlock(post: 
      Post(postID: 5, 
        user:
          User(account: 'jack', email: 'jack@gmail.com', password: '1234', userName: 'Jack'), 
        entry: 
          Entry(entryID: 1, entryImage: 'assets/dog.jpg', user: null, 
            foodName: 'dog', restoName: 'dog shop', date: DateTime.now(), 
            price: 400, calories: 800),
        description: 'This is a dog.',
        like: [], likeCnt: 0,
        comment: [], commentCnt: 0,
      )
    ),
    PostBlock(post: 
      Post(postID: 2, 
        user:
          User(account: 'jack', email: 'jack@gmail.com', password: '1234', userName: 'Jack'), 
        entry: 
          Entry(entryID: 1, entryImage: 'assets/donut.jpg', user: null, 
            foodName: 'donut', restoName: 'donut shop', date: DateTime.now(), 
            price: 400, calories: 800),
        description: 'This is a donut.',
        like: [], likeCnt: 0,
        comment: [], commentCnt: 0,
      )
    ),
  ];

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
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
                                backgroundImage:const AssetImage('assets/headshot.png'),
                                radius: size.height * 0.1,
                              ),
                            ),
                            SizedBox(width: size.width*0.005),
                            const Text("Jack",
                              style: TextStyle(
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
                            const Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "2",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight:FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                SizedBox(height: 5),
                                Text(
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
                            const Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "10",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight:FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                SizedBox(height: 5),
                                Text(
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
                            const Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "1200",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight:FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                SizedBox(height: 5),
                                Text(
                                  "Calories",
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
                  child: CustomText(label: "No entries yet.", 
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
      // floatingActionButton: FloatingActionButton(
      //   onPressed: _incrementCounter,
      //   tooltip: 'Increment',
      //   child: const Icon(Icons.add),
      // ),
    );
  }
}
