import 'dart:core';
import 'dart:convert';

User userFromJson(String str) => User.fromJson(json.decode(str));
String userToJson(User data) => json.encode(data.toJson());

class User {
  // * account: string
  // * email: string 
  // * password: string
  // * userName: string
  // * userImg: image
  // * gender: int (1: male, 0: female)
  // * postCnt: int
  // * entryCnt: int
  // * likeCnt: int

  final String account;
  // final String email;
  final String password;
  final String userName;
  final String? userImg;
  final int? gender; // 1 for male, 0 for female
  final int? postCnt;
  final int? entryCnt;
  final int? likeCnt;

  User(
      {required this.account,
      // required this.email,
      required this.password,
      required this.userName,
      this.userImg,
      this.gender,
      this.postCnt,
      this.entryCnt,
      this.likeCnt});
      
  factory User.fromJson(Map<String, dynamic> json) => User(
        account: json['account'],
        // email: json['email'],
        password: json['password'],
        userName: json['userName'],
        userImg: json['userImg'],
        gender: json['gender'],
        postCnt: json['postCnt'],
        entryCnt: json['entryCnt'],
        likeCnt: json['likeCnt'],
      );

  Map<String, dynamic> toJson() => {
        'account': account,
        // 'email': email,
        'password': password,
        'userName': userName,
        'userImg': userImg,
        'gender': gender,
        'postCnt': postCnt,
        'entryCnt': entryCnt,
        'likeCnt': likeCnt,
      };

}