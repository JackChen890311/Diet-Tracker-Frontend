import 'dart:core';
import 'dart:convert';
import 'package:diet_tracker/utils/user.dart';

Entry entryFromJson(String str) => Entry.fromJson(json.decode(str));
String entryToJson(Entry data) => json.encode(data.toJson());

class Entry {
  // * entryID: int (timestamp)
  // * entryImage: image
  // * user: User
  // * foodName: string
  // * restoName: string
  // * date: date
  // * price: int
  // * calories: int

  final int entryID;
  final String? entryImage;
  final User user;
  final String? foodName;
  final String? restoName;
  final DateTime? date;
  final int? price;
  final int? calories;
  
  Entry(
      {required this.entryID,
      this.entryImage,
      required this.user,
      this.foodName,
      this.restoName,
      this.date,
      this.price,
      this.calories});

  factory Entry.fromJson(Map<String, dynamic> json) => Entry(
        entryID: json['entryID'],
        entryImage: json['entryImage'],
        user: User.fromJson(json['user']),
        foodName: json['foodName'],
        restoName: json['restoName'],
        date: DateTime.parse(json['date']),
        price: json['price'],
        calories: json['calories'],
      );

  Map<String, dynamic> toJson() => {
        'entryID': entryID,
        'entryImage': entryImage,
        'user': user.toJson(),
        'foodName': foodName,
        'restoName': restoName,
        'date': date!.toIso8601String(),
        'price': price,
        'calories': calories,
      };

}