part of 'restaurant_bloc.dart';

sealed class RestaurantsState {}

final class RestaurantsInitial extends RestaurantsState {}

final class RestaurantsLoading extends RestaurantsState {}

final class RestaurantsLoaded extends RestaurantsState {
  final List<Restaurant> restaurants;

  RestaurantsLoaded({required this.restaurants});
}

final class RestaurantsFailure extends RestaurantsState {
  final String message;

  RestaurantsFailure({required this.message});
}
