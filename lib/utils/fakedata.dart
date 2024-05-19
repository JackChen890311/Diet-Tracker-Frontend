import 'package:diet_tracker/utils/post.dart';
import 'package:diet_tracker/utils/entry.dart';
import 'package:diet_tracker/utils/user.dart';
import 'package:diet_tracker/widgets/food_card.dart';
import 'package:diet_tracker/widgets/post_card.dart';


final User userJack = User(account: 'jack', email: 'jack@gmail.com', password: '1234', userName: 'Jack', userImg: 'assets/headshot.png', gender: 1, postCnt: 0, entryCnt: 0, likeCnt: 0);

final List<EntryBlock> foodList = [
  EntryBlock(entry: Entry(entryID: 1, entryImage: 'assets/ramen.jpg', user: userJack, foodName: 'ramen', restoName: 'ramen shop', date: DateTime.now(), price: 400, calories: 800), imgFirst: true),  
  EntryBlock(entry: Entry(entryID: 2, entryImage: 'assets/chicken.jpg', user: userJack, foodName: 'chicken', restoName: 'chicken shop', date: DateTime.tryParse('2024-05-14'), price: 200, calories: 300), imgFirst: false),
  EntryBlock(entry: Entry(entryID: 3, entryImage: 'assets/donut.jpg', user: userJack, foodName: 'donut', restoName: 'donut shop', date: DateTime.tryParse('2024-05-13'), price: 30, calories: 100), imgFirst: true),
  EntryBlock(entry: Entry(entryID: 4, entryImage: 'assets/dog.jpg', user: userJack, foodName: 'dog', restoName: 'dog shop', date: DateTime.tryParse('2024-05-12'), price: 50, calories: 200), imgFirst: false),
  EntryBlock(entry: Entry(entryID: 5, entryImage: 'assets/paella.jpg', user: userJack, foodName: 'paella', restoName: 'paella shop', date: DateTime.tryParse('2024-05-11'), price: 300, calories: 700), imgFirst: true),
];

List<PostBlock> addPostFromEntryList(List<EntryBlock> foodList){
  List<PostBlock> postList = [];
  for (var food in foodList){
    postList.add(PostBlock(post:
      Post(postID: food.getEntry.entryID, 
        user: userJack, 
        entry: food.getEntry,
        description: 'This is a bowl of ${food.getEntry.foodName}.',
        like: [], likeCnt: 0,
        comment: [], commentCnt: 0,
      )
    ));
  }
  return postList;
}

final List<PostBlock> postList = addPostFromEntryList(foodList);


