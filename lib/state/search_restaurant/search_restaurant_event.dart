part of 'search_restaurant_bloc.dart';

sealed class SearchRestaurantEvent {}

final class FetchSearchRestaurant extends SearchRestaurantEvent {
  final String query;

  FetchSearchRestaurant({required this.query});
}

final class ClearSearchResult extends SearchRestaurantEvent {}
