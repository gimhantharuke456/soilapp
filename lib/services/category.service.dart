import 'dart:convert';
import 'package:http/http.dart' as http;

class CategoryService {
  final String baseUrl = 'https://7894-112-134-139-41.ngrok-free.app';

  Future<String?> predictCategory(String description) async {
    final response = await http.post(
      Uri.parse('$baseUrl/predict'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String, String>{
        'description': description,
      }),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      return data['category'];
    } else {
      throw Exception('Failed to predict category');
    }
  }
}
