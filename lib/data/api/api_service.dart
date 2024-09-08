import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:savor/data/model/restaurant.dart';
import 'package:http/http.dart' as http;

class ApiService {
  static final baseURL = dotenv.env['API_BASE_URL'];
  static final endpoint = {
    "list": "list",
    "detail": "detail/",
    "search": "search?q=",
    "addReview": "review",
  };

  Future<RestaurantsResult> listRestaurant() async {
    final response = await http.get(Uri.parse("$baseURL${endpoint['list']}"));
    if (response.statusCode == 200) {
      return RestaurantsResult.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load list of restaurant');
    }
  }

  Future<RestaurantDetailResult> restaurantDetail(String id) async {
    final response =
        await http.get(Uri.parse("$baseURL${endpoint['detail']}$id"));
    if (response.statusCode == 200) {
      return RestaurantDetailResult.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load detail of restaurant');
    }
  }

  Future<SearchRestaurantsResult> searchRestaurant(String q) async {
    final response =
        await http.get(Uri.parse("$baseURL${endpoint['search']}$q"));
    if (response.statusCode == 200) {
      return SearchRestaurantsResult.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to find restaurant');
    }
  }

  Future<ReviewRestaurantResult> addReview(AddReviewRestaurant review) async {
    final response = await http.post(
      Uri.parse("$baseURL${endpoint['addReview']}"),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(review.toJson()),
    );
    if (response.statusCode == 201) {
      return ReviewRestaurantResult.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to add review');
    }
  }
}
