import 'package:diet_tracker/utils/user.dart';
import 'package:diet_tracker/utils/entry.dart';
import 'package:diet_tracker/widgets/entry_card.dart';
import 'package:diet_tracker/widgets/post_card.dart';


class GlobalService {
  static final GlobalService _instance = GlobalService._internal();

  // passes the instantiation to the _instance object
  factory GlobalService() => _instance;

  //initialize variables in here
  GlobalService._internal() {
    user = null;
    entryList = [];
    entryListWithEmpty = [];
    postList = [];
    entryCnt = 0;
    postCnt = 0;
    likeCnt = 0;
  }

  User? user;
  List<EntryBlock> entryList = [];
  List<EntryBlock> entryListWithEmpty = [];
  List<PostBlock> postList = [];
  int? entryCnt;
  int? postCnt;
  int? likeCnt;

  //short getter for my variable
  User get getUserData => user!;
  List<EntryBlock> get getEntryData => entryList;
  List<EntryBlock> get getEntryDataWithEmpty => entryListWithEmpty;
  List<PostBlock> get getPostData => postList;
  int get getEntryCnt => entryCnt!;
  int get getPostCnt => postCnt!;
  int get getLikeCnt => likeCnt!;

  // List<String> get userAchievement => achievement;

  //short setter for my variable
  set setUserData(User value) => user = value;
  set setEntryData(List<EntryBlock> value) => entryList = value;
  set setEntryDataWithEmpty(List<EntryBlock> value) => entryListWithEmpty = value;
  set setPostData(List<PostBlock> value) => postList = value;
  set setEntryCnt(int value) => entryCnt = value;
  set setPostCnt(int value) => postCnt = value;
  set setLikeCnt(int value) => likeCnt = value;

  // set userAchievement(List<String> value) => achievement = value;
}