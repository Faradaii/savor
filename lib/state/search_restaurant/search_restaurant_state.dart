part of 'search_restaurant_bloc.dart';

sealed class SearchRestaurantState {}

final class SearchRestaurantInitial extends SearchRestaurantState {}

final class SearchRestaurantLoading extends SearchRestaurantState {}

final class SearchRestaurantLoaded extends SearchRestaurantState {
  final List<Restaurant> searchRestaurant;
  final int founded;

  SearchRestaurantLoaded(
      {required this.searchRestaurant, required this.founded});
}

final class SearchRestaurantFailure extends SearchRestaurantState {
  final String message;

  SearchRestaurantFailure({required this.message});
}
