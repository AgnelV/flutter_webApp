import 'package:flutter_webapp/config.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
class ApiService {
  static Future<List<dynamic>> fetchData(String endpoint) async {
    final response = await http.get(Uri.parse(Config.apiUrl + endpoint));

    if (response.statusCode == 200) {
      final dynamic data = json.decode(response.body);
      //print(data); // Add this line to see the structure of the data
      if (data is List<dynamic>) {
        return data;
      } else {
        throw Exception('Invalid data structure received from API');
      }
    } else {
      throw Exception('Failed to load data');
    }
  }
}
