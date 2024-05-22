// import 'package:tuple/tuple.dart';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:diet_tracker/utils/user.dart';
import 'package:diet_tracker/utils/fakedata_lib.dart' as fakedata;


// Run command: flutter run -d chrome --web-browser-flag "--disable-web-security"
// Reference: https://stackoverflow.com/questions/65630743/how-to-solve-flutter-web-api-cors-error-only-with-dart-code
// Error: https://stackoverflow.com/questions/71157863/dart-flutter-http-request-raises-xmlhttprequest-error
class ApiService {
  final String baseUrl = 'https://diet-tracker-backend.vercel.app';

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

  Future<Map<String, dynamic>> loginFakeUser(String account, String password) async {
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
}