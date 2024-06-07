import 'package:diet_tracker/utils/user.dart';
import 'package:diet_tracker/utils/entry.dart';
import 'package:diet_tracker/utils/post.dart';
import 'package:diet_tracker/utils/comment.dart';
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
  set setSpecificPostLikeCnt(Map info){
    int postID = info['postID'];
    int valueChange = info['valueChange'];
    User likeUsr = info['likeUsr'];
    List<PostBlock> tmp = [];
    for(PostBlock postblock in postList){
      if(postblock.getPost.postID==postID){
        print('before:${postblock.getPost.likeCnt} after:${postblock.getPost.likeCnt !+ valueChange}');
        List likeUsrs = postblock.getPost.like!;
        if(valueChange==1){
          // add usr
          likeUsrs.add(likeUsr);
        }
        else{
          // remove usr
          likeUsrs.remove(likeUsr);
        }
        var modifiedPost = Post(
                postID: postblock.getPost.postID,
                description: postblock.getPost.description,
                entry: postblock.getPost.entry,
                user: postblock.getPost.user,
                like: likeUsrs,
                likeCnt: postblock.getPost.likeCnt !+ valueChange,
                comment: postblock.getPost.comment,
                commentCnt: postblock.getPost.commentCnt);
        tmp.add(
          PostBlock(post: modifiedPost)
        );
      }
      else{
        tmp.add(postblock);
      }
    }
    postList = tmp;
  }
  set setSpecificPostCommentCnt(Map info){
    int postID = info['postID'];
    String content = info['content'];
    User CommentUsr = info['CommentUsr'];
    List<PostBlock> tmp = [];
    for(PostBlock postblock in postList){
      if(postblock.getPost.postID==postID){
        List comments = postblock.getPost.comment!;
        comments.add(Comment(user: CommentUsr, content: content, datetime: DateTime.now().millisecondsSinceEpoch).toJson());
        var modifiedPost = Post(
                postID: postblock.getPost.postID,
                description: postblock.getPost.description,
                entry: postblock.getPost.entry,
                user: postblock.getPost.user,
                like: postblock.getPost.like,
                likeCnt: postblock.getPost.likeCnt,
                comment: comments,
                commentCnt: postblock.getPost.commentCnt!+1);
        tmp.add(
          PostBlock(post: modifiedPost)
        );
      }
      else{
        tmp.add(postblock);
      }
    }
    postList = tmp;
  }

  // set userAchievement(List<String> value) => achievement = value;
}