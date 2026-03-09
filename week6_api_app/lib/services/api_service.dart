import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/article.dart';

class ApiService {
  // Base URL for the API
  final String baseUrl = 'newsapi.org';
  
  // IMPORTANT: For development, get a free key from https://newsapi.org/register
  // and replace 'YOUR_API_KEY' with your actual key.
  final String apiKey = '01418de560624dc5ac536780e6310c2e'; 
  
  // Method to fetch news articles
  Future<List<Article>> fetchNewsArticles({String? category}) async {
    // 1. Build the URL properly
    final queryParams = {
      'country': 'us',
      'apiKey': apiKey,
    };
    
    if (category != null && category.toLowerCase() != 'all') {
      queryParams['category'] = category.toLowerCase();
    }

    final uri = Uri.https(
      baseUrl,
      '/v2/top-headlines',
      queryParams,
    );
    
    // 2. Make the network request with a User-Agent header
    // NewsAPI requires a User-Agent header for requests from non-browser environments.
    final response = await http.get(
      uri,
      headers: {
        'User-Agent': 'NovaNews/1.1.0-mobile (Flutter-SDK)',
      },
    );
    
    // 3. Check status code
    if (response.statusCode == 200) {
      // 4. Parse JSON response
      final Map<String, dynamic> jsonData = jsonDecode(response.body);
      
      // 5. Extract articles array
      final List<dynamic> articlesJson = jsonData['articles'];
      
      // 6. Convert each JSON object to Article model
      return articlesJson.map((json) => Article.fromJson(json)).toList();
    } else {
      // 7. Handle errors with more detail
      final errorBody = response.body;
      throw Exception('Failed to load news (HTTP ${response.statusCode}): $errorBody');
    }
  }
}
