import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:savor/data/api/api_service.dart';
import 'package:savor/data/model/restaurant.dart';

part 'search_restaurant_event.dart';
part 'search_restaurant_state.dart';

class SearchRestaurantBloc
    extends Bloc<SearchRestaurantEvent, SearchRestaurantState> {
  final ApiService apiService;
  SearchRestaurantBloc({required this.apiService})
      : super(SearchRestaurantInitial()) {
    on<FetchSearchRestaurant>((event, emit) async {
      emit(SearchRestaurantLoading());

      final String query = event.query;

      try {
        final res = await apiService.searchRestaurant(query);
        emit(SearchRestaurantLoaded(
            searchRestaurant: res.restaurants, founded: res.founded));
      } on SocketException {
        emit(
            SearchRestaurantFailure(message: "There's no internet connection"));
      } catch (e) {
        emit(SearchRestaurantFailure(message: e.toString()));
      }
    });

    on<ClearSearchResult>((event, emit) async {
      emit(SearchRestaurantInitial());
    });
  }
}
