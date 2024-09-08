part of 'detail_restaurant_bloc.dart';

sealed class DetailRestaurantState {}

final class DetailRestaurantInitial extends DetailRestaurantState {}

final class DetailRestaurantLoading extends DetailRestaurantState {}

final class DetailRestaurantLoaded extends DetailRestaurantState {
  final RestaurantDetail restaurant;

  DetailRestaurantLoaded({required this.restaurant});
}

final class DetailRestaurantFailure extends DetailRestaurantState {
  final String message;

  DetailRestaurantFailure({required this.message});
}

final class AddReviewSuccess extends DetailRestaurantState {
  final List<CustomerReview> review;

  AddReviewSuccess({required this.review});
}

final class AddReviewLoading extends DetailRestaurantState {
}

final class AddReviewFailure extends DetailRestaurantState {
  final String message;

  AddReviewFailure({required this.message});
}
