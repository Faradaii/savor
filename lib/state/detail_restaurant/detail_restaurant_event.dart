part of 'detail_restaurant_bloc.dart';

sealed class DetailRestaurantEvent {}

final class FetchDetailRestaurant extends DetailRestaurantEvent {
  final String idRestaurant;

  FetchDetailRestaurant({required this.idRestaurant});
}

final class AddReview extends DetailRestaurantEvent {
  final AddReviewRestaurant review;
  AddReview({required this.review});
}