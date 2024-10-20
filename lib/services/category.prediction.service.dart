import 'dart:convert';
import 'package:http/http.dart' as http;

class CategoryPredictionService {
  final String apiKey =
      'sk-None-0aYzl8VtMfUOcqU2Hb3KT3BlbkFJKuokat03bz7aCHvk55Fk';
  final String apiUrl = 'https://api.openai.com/v1/chat/completions';

  final List<String> categories = [
    "Soil and Plant Nutrition",
    "Fertilizer Application",
    "Disease Identification",
    "Land Use Identification",
    "Dry Rubber Content",
    "Raw Rubber and Chemical Analysis",
    "Rubber Technology and Development",
    "Rubber Economics",
    "Others"
  ];

  Future<String> predictCategory(String text) async {
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $apiKey',
        },
        body: jsonEncode({
          'model': 'gpt-3.5-turbo',
          'messages': [
            {
              'role': 'system',
              'content':
                  'You are a helpful assistant that categorizes text into one of the following categories: ${categories.join(", ")}. Respond only with the category name.'
            },
            {'role': 'user', 'content': 'Categorize the following text: $text'}
          ],
          'temperature': 0.3,
          'max_tokens': 50,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final predictedCategory =
            data['choices'][0]['message']['content'].trim();

        // Validate if the predicted category is in our list
        if (categories.contains(predictedCategory)) {
          return predictedCategory;
        } else {
          return 'Others';
        }
      } else {
        print('Error: ${response.statusCode}');
        print('Response: ${response.body}');
        throw Exception('Failed to predict category');
      }
    } catch (e) {
      print('Error predicting category: $e');
      throw Exception('Failed to predict category');
    }
  }
}
