import 'dart:core';
import 'dart:convert';
import 'package:diet_tracker/utils/user.dart';

Comment postFromJson(String str) => Comment.fromJson(json.decode(str));
String postToJson(Comment data) => json.encode(data.toJson());

class Comment {
  // * user: User
  // * content: string
  // * datetime: int (timestamp)

  final User user;
  final String content;
  final int datetime;

  Comment(
      {
      required this.user,
      required this.content,
      required this.datetime,
      });

  factory Comment.fromJson(Map<String, dynamic> json) => Comment(
        user: User.fromJson(json['user']),
        content: json['content'],
        datetime: json['datetime'],
      );

  Map<String, dynamic> toJson() => {
        'user': user.toJson(),
        'content': content,
        'datetime': datetime,
      };
}