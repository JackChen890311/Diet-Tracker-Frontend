import 'dart:convert';
import 'package:http/http.dart' as http;

// TODO: Cannot work right now, need to investigate more
class ApiService {
  final String baseUrl = 'https://diet-tracker-backend.vercel.app';

  Future<Map<String, dynamic>> hello() async {
    final response = await http.get(Uri.parse('$baseUrl/hello'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to fetch data');
    }
  }
}