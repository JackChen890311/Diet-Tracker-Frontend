import 'package:flutter/material.dart';
import 'package:diet_tracker/widgets/app_bar.dart';
import 'package:diet_tracker/utils/style.dart';
import 'package:diet_tracker/widgets/people_card.dart';
import 'package:diet_tracker/widgets/post_card.dart';

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
    const PostBlock(photo: 'assets/ramen.jpg', foodname: "ramen1", date: "2024-05-01"),
    const PostBlock(photo: 'assets/ramen.jpg', foodname: "ramen2", date: "2024-05-01"),
    const PostBlock(photo: 'assets/ramen.jpg', foodname: "ramen3", date: "2024-05-01"),
    const PostBlock(photo: 'assets/ramen.jpg', foodname: "ramen4", date: "2024-05-01"),
    const PostBlock(photo: 'assets/ramen.jpg', foodname: "ramen5", date: "2024-05-01"),
    const PostBlock(photo: 'assets/ramen.jpg', foodname: "ramen6", date: "2024-05-01"),
  ];

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: const MyAppBar(title: 'Account'),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            const PeopleBlock(photo: 'assets/headshot.png', name: "Jack", gender: "Male"),
            SizedBox(height: size.height * 0.02),
            SizedBox(height: size.height * 0.06, child: 
              const CustomText(label: "Posts", type: 'titleLarge')
            ),
            SizedBox(height: size.height * 0.02),
            SizedBox(height: size.height * 0.5, child: 
              CustomScrollView(
                slivers: <Widget>[
                  SliverList(
                    delegate: SliverChildListDelegate(
                      <Widget>[
                        ..._postList.isEmpty 
                          ? [Column(children:[
                                SizedBox(height: size.height * 0.3), 
                                const CustomText(label: "No entries yet.", 
                                            type: 'displaySmall',
                                          )]
                            )]
                          : _postList,
                      ],
                    ),
                  ),
                ],
              ),
            ),
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
