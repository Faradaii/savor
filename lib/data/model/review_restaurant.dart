
import 'package:savor/data/model/restaurant_detail.dart';

class ReviewRestaurantResult {
  bool error;
  String message;
  List<CustomerReview> customerReviews;

  ReviewRestaurantResult({
    required this.error,
    required this.message,
    required this.customerReviews,
  });

  factory ReviewRestaurantResult.fromJson(Map<String, dynamic> json) =>
      ReviewRestaurantResult(
        error: json["error"],
        message: json["message"],
        customerReviews: List<CustomerReview>.from(
            json["customerReviews"].map((x) => CustomerReview.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "error": error,
        "message": message,
        "customerReviews":
            List<dynamic>.from(customerReviews.map((x) => x.toJson())),
      };
}

class AddReviewRestaurant {
  String id;
  String name;
  String review;

  AddReviewRestaurant({
    required this.id,
    required this.name,
    required this.review,
  });

  factory AddReviewRestaurant.fromJson(Map<String, dynamic> json) =>
      AddReviewRestaurant(
        id: json["id"],
        name: json["name"],
        review: json["review"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "review": review,
      };
}
