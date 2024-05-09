import 'dart:core';
import 'dart:convert';
import 'package:diet_tracker/utils/entry.dart';
import 'package:diet_tracker/utils/user.dart';

Post postFromJson(String str) => Post.fromJson(json.decode(str));
String postToJson(Post data) => json.encode(data.toJson());

class Post {
  // * postID: int (timestamp)
  // * user: User
  // * entry: Entry
  // * description: string
  // * like: List of User
  // * likeCnt: int
  // * comment: List of (datetime, User, string)
  // * commentCnt: int

  final int postID;
  final User user;
  final Entry entry;
  final String description;
  final List<User>? like;
  final int? likeCnt;
  final List<dynamic>? comment;
  final int? commentCnt;

  Post(
      {required this.postID,
      required this.user,
      required this.entry,
      required this.description,
      this.like,
      this.likeCnt,
      this.comment,
      this.commentCnt});

  factory Post.fromJson(Map<String, dynamic> json) => Post(
        postID: json['_id'],
        user: User.fromJson(json['user']),
        entry: Entry.fromJson(json['entry']),
        description: json['description'],
        like: json['like'],
        likeCnt: json['likeCnt'],
        comment: json['comment'],
        commentCnt: json['commentCnt'],
      );

  Map<String, dynamic> toJson() => {
        '_id': postID,
        'user': user.toJson(),
        'entry': entry.toJson(),
        'description': description,
        'like': like,
        'likeCnt': likeCnt,
        'comment': comment,
        'commentCnt': commentCnt,
      };
}