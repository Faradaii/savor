import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:savor/data/api/api_service.dart';
import 'package:savor/data/model/restaurant.dart';

part 'detail_restaurant_event.dart';
part 'detail_restaurant_state.dart';

class DetailRestaurantBloc
    extends Bloc<DetailRestaurantEvent, DetailRestaurantState> {
  final ApiService apiService;
  DetailRestaurantBloc({required this.apiService})
      : super(DetailRestaurantInitial()) {
    on<FetchDetailRestaurant>((event, emit) async {
      emit(DetailRestaurantLoading());

      final String id = event.idRestaurant;
      try {
        final res = await apiService.restaurantDetail(id);
        emit(DetailRestaurantLoaded(restaurant: res.restaurant));
      } on SocketException {
        emit(
            DetailRestaurantFailure(message: "There's no internet connection"));
      } catch (e) {
        emit(DetailRestaurantFailure(message: e.toString()));
      }
    });

    on<AddReview>((event, emit) async {
      if (state is DetailRestaurantLoaded) {
        final currentState = state as DetailRestaurantLoaded;
        emit(AddReviewLoading());

        final AddReviewRestaurant review = event.review;

        try {
          final res = await apiService.addReview(review);
          emit(AddReviewSuccess(
            review: res.customerReviews,
          ));

          final updatedReviews = res.customerReviews;

          final RestaurantDetail updatedRestaurant =
              currentState.restaurant.copyWith(customerReviews: updatedReviews);

          emit(DetailRestaurantLoaded(restaurant: updatedRestaurant));
        } on SocketException {
          emit(DetailRestaurantFailure(
              message: "There's no internet connection"));
        } catch (e) {
          emit(AddReviewFailure(message: e.toString()));
          emit(DetailRestaurantLoaded(restaurant: currentState.restaurant));
        }
      }
    });
  }
}