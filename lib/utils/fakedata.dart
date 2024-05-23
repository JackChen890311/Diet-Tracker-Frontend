import 'package:diet_tracker/utils/post.dart';
import 'package:diet_tracker/utils/entry.dart';
import 'package:diet_tracker/utils/user.dart';
import 'package:diet_tracker/widgets/entry_card.dart';
import 'package:diet_tracker/widgets/post_card.dart';


final User userJack = User(account: 'jack', /*email: 'jack@gmail.com',*/ password: '1234', userName: 'Jack', userImg: 'assets/headshot.png', gender: 1, postCnt: 0, entryCnt: 0, likeCnt: 0);
final User userIrene = User(account: 'irene', /*email: 'irene@gmail.com',*/ password: '1234', userName: 'Irene', gender: 0, postCnt: 0, entryCnt: 0, likeCnt: 0);
final User userAndy = User(account: 'andy', /*email: 'andy@gmail.com',*/ password: '1234', userName: 'Andy', gender: 1, postCnt: 0, entryCnt: 0, likeCnt: 0);

final List<EntryBlock> entryListJack = [
  EntryBlock(entry: Entry(entryID: 1, entryImage: 'assets/ramen.jpg', user: userJack, foodName: 'ramen', restoName: 'ramen shop', date: DateTime.now(), price: 400, calories: 800), imgFirst: true),  
  EntryBlock(entry: Entry(entryID: 2, entryImage: 'assets/chicken.jpg', user: userJack, foodName: 'chicken', restoName: 'chicken shop', date: DateTime.tryParse('2024-05-14'), price: 200, calories: 300), imgFirst: false),
  EntryBlock(entry: Entry(entryID: 3, entryImage: 'assets/donut.jpg', user: userJack, foodName: 'donut', restoName: 'donut shop', date: DateTime.tryParse('2024-05-13'), price: 30, calories: 100), imgFirst: true),
  EntryBlock(entry: Entry(entryID: 11, entryImage: 'assets/ramen.jpg', user: userJack, foodName: 'ramen', restoName: 'ramen shop', date: DateTime.tryParse('2024-04-15'), price: 400, calories: 800), imgFirst: true),  
  EntryBlock(entry: Entry(entryID: 12, entryImage: 'assets/chicken.jpg', user: userJack, foodName: 'chicken', restoName: 'chicken shop', date: DateTime.tryParse('2024-04-14'), price: 200, calories: 300), imgFirst: false),
  EntryBlock(entry: Entry(entryID: 13, entryImage: 'assets/donut.jpg', user: userJack, foodName: 'donut', restoName: 'donut shop', date: DateTime.tryParse('2024-04-13'), price: 30, calories: 100), imgFirst: true),
];

final List<EntryBlock> entryListIrene = [
  EntryBlock(entry: Entry(entryID: 4, entryImage: 'assets/dog.jpg', user: userIrene, foodName: 'dog', restoName: 'dog shop', date: DateTime.tryParse('2024-05-12'), price: 50, calories: 200), imgFirst: false),
  EntryBlock(entry: Entry(entryID: 5, entryImage: 'assets/paella.jpg', user: userIrene, foodName: 'paella', restoName: 'paella shop', date: DateTime.tryParse('2024-05-11'), price: 300, calories: 700), imgFirst: true),
];

final List<EntryBlock> entryList = entryListJack; // Only post from jack, since we login as jack

List<PostBlock> addPostFromEntryList(List<EntryBlock> entryList, User user){
  List<PostBlock> postList = [];
  for (var food in entryList){
    postList.add(PostBlock(post:
      Post(postID: food.getEntry.entryID, 
        user: user, 
        entry: food.getEntry,
        description: 'This is a bowl of ${food.getEntry.foodName}.',
        like: [], likeCnt: 0,
        comment: [], commentCnt: 0,
      )
    ));
  }
  return postList;
}

final List<PostBlock> postListJack = addPostFromEntryList(entryListJack, userJack);
final List<PostBlock> postListIrene = addPostFromEntryList(entryListIrene, userIrene);
final List<PostBlock> postList = postListJack + postListIrene; // All post from all users

Map<DateTime, int> sumPriceByDate(List<EntryBlock> entryList){
  Map<DateTime, int> priceByDate = {};
  for (var entry in entryList){
    if (priceByDate.containsKey(entry.getEntry.date)){
      priceByDate[entry.getEntry.date!] = priceByDate[entry.getEntry.date]! + entry.getEntry.price!;
    } else {
      priceByDate[entry.getEntry.date!] = entry.getEntry.price!;
    }
  }
  return priceByDate;
}

Map<DateTime, int> sumCaloriesByDate(List<EntryBlock> entryList){
  Map<DateTime, int> caloriesByDate = {};
  for (var entry in entryList){
    if (caloriesByDate.containsKey(entry.getEntry.date)){
      caloriesByDate[entry.getEntry.date!] = caloriesByDate[entry.getEntry.date]! + entry.getEntry.calories!;
    } else {
      caloriesByDate[entry.getEntry.date!] = entry.getEntry.calories!;
    }
  }
  return caloriesByDate;
}

Map<DateTime, int> priceByDate = sumPriceByDate(entryList);
Map<DateTime, int> caloriesByDate = sumCaloriesByDate(entryList);