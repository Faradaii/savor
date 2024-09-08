import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:savor/data/api/api_service.dart';
import 'package:savor/data/model/restaurant.dart';

part 'restaurant_event.dart';
part 'restaurant_state.dart';

class RestaurantsBloc extends Bloc<RestaurantsEvent, RestaurantsState> {
  final ApiService apiService;

  RestaurantsBloc({required this.apiService}) : super(RestaurantsInitial()) {
    on<FetchRestaurants>((event, emit) async {
      emit(RestaurantsLoading());

      try {
        final res = await apiService.listRestaurant();
        emit(RestaurantsLoaded(restaurants: res.restaurants));
      } on SocketException {
        emit(RestaurantsFailure(message: "There's no internet connection"));
      } catch (e) {
        emit(RestaurantsFailure(message: e.toString()));
      }
    });
  }
}
