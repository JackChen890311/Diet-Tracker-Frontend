import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:diet_tracker/utils/entry.dart';
import 'package:diet_tracker/utils/post.dart';
import 'package:diet_tracker/utils/user.dart';
import 'package:diet_tracker/utils/comment.dart';
import 'package:diet_tracker/utils/fakedata_lib.dart' as fakedata;
// import 'package:tuple/tuple.dart';

// Run command: flutter run -d chrome --web-browser-flag "--disable-web-security"
// Reference: https://stackoverflow.com/questions/65630743/how-to-solve-flutter-web-api-cors-error-only-with-dart-code
// Error: https://stackoverflow.com/questions/71157863/dart-flutter-http-request-raises-xmlhttprequest-error
class ApiService {
  final String baseUrl = 'https://diet-tracker-backend.vercel.app';

  // Test API
  Future<Map<String, dynamic>> hello() async {
    final response = await http.get(Uri.parse('$baseUrl/hello'));
    if (response.statusCode == 200) {
      return {'statusCode': response.statusCode, 'body': response.body};
    } else {
      print('Failed to fetch data');
      return {'statusCode': response.statusCode, 'body': response.body};
    }
  }

  Future<Map<String, dynamic>> createFakeUser() async {
    User userJack = fakedata.userJack;
    print(userJack.toJson());
    final response = await http.post(Uri.parse('$baseUrl/user'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(userJack.toJson())
    );
    if (response.statusCode == 201) {
      return {'statusCode': response.statusCode, 'body': response.body};
    } else {
      print('Failed to fetch data');
      return {'statusCode': response.statusCode, 'body': response.body};
    }
  }
  // ========================================================================

  // Login and Register API
  Future<Map<String, dynamic>> login(String account, String password) async {
    final response = await http.post(Uri.parse('$baseUrl/login'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'account': account,
          'password': password,
        })
    );
    if (response.statusCode == 200) {
      return {'statusCode': response.statusCode, 'body': response.body};
    } else {
      print('Failed to fetch data');
      return {'statusCode': response.statusCode, 'body': response.body};
    }
  }

  Future<Map<String, dynamic>> register(User newUser) async {
    final response = await http.post(Uri.parse('$baseUrl/user'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(newUser.toJson()),
    );
    if (response.statusCode == 201) {
      return {'statusCode': response.statusCode, 'body': response.body};
    } else {
      print('Failed to fetch data');
      return {'statusCode': response.statusCode, 'body': response.body};
    }
  }
  // ========================================================================

  // User API
  Future<Map<String, dynamic>> getUser(String account) async{
    final response = await http.get(Uri.parse('$baseUrl/user/$account'));
    if (response.statusCode == 200) {
      return {'statusCode': response.statusCode, 'body': response.body};
    } else {
      print('Failed to get user data');
      return {'statusCode': response.statusCode, 'body': response.body};
    }
  }

  Future<Map<String, dynamic>> deleteUser(String account) async {
    final response = await http.delete(Uri.parse('$baseUrl/user/$account'));
    if (response.statusCode == 200) {
      print('User deleted successfully');
      return {'statusCode': response.statusCode, 'body': response.body};
    } else {
      print('Error deleting user');
      return {'statusCode': response.statusCode, 'body': response.body};
    }
  }
  Future<Map<String, dynamic>> updateUser(User newUser) async{
    final response = await http.put(Uri.parse('$baseUrl/user/${newUser.account}'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(newUser.toJson()));
    print(response);
    if (response.statusCode == 200) {
      return {'statusCode': response.statusCode, 'body': response.body};
    } else {
      print('Failed to update user data');
      return {'statusCode': response.statusCode, 'body': response.body};
    }
  }

  Future<Map<String, dynamic>> updateUserImg(User user, String imgString64) async{
    User newUser = User(
      account: user.account,
      password: user.password,
      userName: user.userName,
      userImg: imgString64,
      gender: user.gender,
      postCnt: user.postCnt,
      entryCnt: user.entryCnt,
      likeCnt: user.likeCnt);
    final respone = await updateUser(newUser);
    return respone;
  }

  Future<Map<String, dynamic>> updateUserLikeCnt(User user, int diff) async{
    User newUser = User(
      account: user.account,
      password: user.password,
      userName: user.userName,
      userImg: user.userImg,
      gender: user.gender,
      postCnt: user.postCnt,
      entryCnt: user.entryCnt,
      likeCnt: user.likeCnt!+diff);
    final respone = await updateUser(newUser);
    return respone;
  }
  // ========================================================================

  // Entry API
  Future<Map<String, dynamic>> getEntriesOfUser(User user) async {
    final response = await http.get(Uri.parse('$baseUrl/entry/${user.account}'));
    if (response.statusCode == 200) {
      print('Getting entries successfully');
      return {'statusCode': response.statusCode, 'body': response.body};
    } else {
      print('Failed to get entries');
      return {'statusCode': response.statusCode, 'body': response.body};
    }
  }

  Future<Map<String, dynamic>> createEntry(Entry entry) async {
    final response = await http.post(Uri.parse('$baseUrl/entry'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(entry.toJson()),
    );
    if (response.statusCode == 201) {
      print('Entry created successfully');
      return {'statusCode': response.statusCode, 'body': response.body};
    } else {
      print('Failed to create entry');
      return {'statusCode': response.statusCode, 'body': response.body};
    }
  }
  // ========================================================================

  // Post API
  Future<Map<String, dynamic>> getPostsAll() async {
    final response = await http.get(Uri.parse('$baseUrl/post'));
    if (response.statusCode == 200) {
      print('Getting all posts successfully');
      return {'statusCode': response.statusCode, 'body': response.body};
    } else {
      print('Failed to get posts');
      return {'statusCode': response.statusCode, 'body': response.body};
    }
  }

  Future<Map<String, dynamic>> getPostsOfUser(User user) async {
    final response = await http.get(Uri.parse('$baseUrl/post/${user.account}'));
    if (response.statusCode == 200) {
      print('Getting user posts successfully');
      return {'statusCode': response.statusCode, 'body': response.body};
    } else {
      print('Failed to get posts');
      return {'statusCode': response.statusCode, 'body': response.body};
    }
  }

  Future<Map<String, dynamic>> createPost(Post post) async {
    final response = await http.post(Uri.parse('$baseUrl/post'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(post.toJson()),
    );
    if (response.statusCode == 201) {
      print('Post created successfully');
      return {'statusCode': response.statusCode, 'body': response.body};
    } else {
      print('Failed to create post');
      return {'statusCode': response.statusCode, 'body': response.body};
    }
  }

  Future<Map<String, dynamic>> likePost(int postID, User user) async {
    final response = await http.post(Uri.parse('$baseUrl/post/like'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
          'postId': postID,
          'user': user,
        }),
    );
    final response2 = await updateUserLikeCnt(user, 1);
    if (response.statusCode == 200 && response2['statusCode'] == 200) {
      print('Like a post successfully');
      return {'statusCode': response.statusCode, 'body': response.body};
    }
    else {
      print('Failed to like a post (${response.statusCode})');
      return {'statusCode': response.statusCode, 'body': response.body};
    }
  }

  Future<Map<String, dynamic>> dislikePost(int postID, User user) async {
    final response = await http.post(Uri.parse('$baseUrl/post/dislike'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
          'postId': postID,
          'user': user,
        }),
    );
    final response2 = await updateUserLikeCnt(user, -1);
    if (response.statusCode == 200 && response2['statusCode'] == 200) {
      print('Dislike a post successfully');
      return {'statusCode': response.statusCode, 'body': response.body};
    }
    else {
      print('Failed to like a post (${response.statusCode})');
      return {'statusCode': response.statusCode, 'body': response.body};
    }
  }
  
  Future<Map<String, dynamic>> commentPost(int postID, Comment commentInfo) async {
    final response = await http.post(Uri.parse('$baseUrl/post/comment'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
          'postId': postID,
          'comment': commentInfo,
        }),
    );
    if (response.statusCode == 200) {
      print('Comment a post successfully');
      return {'statusCode': response.statusCode, 'body': response.body};
    }
    else{
      print('Failed to comment a post (${response.statusCode})');
      return {'statusCode': response.statusCode, 'body': response.body};
    }
  
  }

  Future<Map<String, dynamic>> deletePost(int postID) async {
    final response = await http.delete(Uri.parse('$baseUrl/post/$postID'));
    if (response.statusCode == 200) {
      print('Post deleted successfully');
      return {'statusCode': response.statusCode, 'body': response.body};
    } else {
      print('Error deleting post');
      return {'statusCode': response.statusCode, 'body': response.body};
    }
  }
}