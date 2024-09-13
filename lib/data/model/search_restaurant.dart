
import 'package:savor/data/model/restaurant.dart';

class SearchRestaurantsResult {
  bool error;
  int founded;
  List<Restaurant> restaurants;

  SearchRestaurantsResult({
    required this.error,
    required this.founded,
    required this.restaurants,
  });

  factory SearchRestaurantsResult.fromJson(Map<String, dynamic> json) =>
      SearchRestaurantsResult(
        error: json["error"],
        founded: json["founded"],
        restaurants: List<Restaurant>.from(
            json["restaurants"].map((x) => Restaurant.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "error": error,
        "founded": founded,
        "restaurants": List<dynamic>.from(restaurants.map((x) => x.toJson())),
      };
}
