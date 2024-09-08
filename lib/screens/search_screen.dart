import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:savor/data/model/restaurant.dart';
import 'package:savor/screens/home_screen.dart';
import 'package:savor/state/search_restaurant/search_restaurant_bloc.dart';
import 'package:savor/widgets/custom_info.dart';
import 'package:skeletonizer/skeletonizer.dart';

class SearchScreen extends StatefulWidget {
  static const routeName = '/search';
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _searchRestaurant() async {
    BlocProvider.of<SearchRestaurantBloc>(context)
        .add(FetchSearchRestaurant(query: _searchController.text));
  }

  void _clearSearchResult() {
    BlocProvider.of<SearchRestaurantBloc>(context).add(ClearSearchResult());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Hero(
            tag: "search",
            child: Material(
              child: TextField(
                controller: _searchController,
                textInputAction: TextInputAction.search,
                onEditingComplete: () {
                  FocusScope.of(context).unfocus();
                  if (_searchController.text.isNotEmpty) {
                    _searchRestaurant();
                  }
                },
                onChanged: (value) {
                  setState(() {});
                },
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          onPressed: () {
                            _searchController.clear();
                            _clearSearchResult();
                            setState(() {});
                          },
                          icon: const Icon(Icons.highlight_remove_rounded))
                      : null,
                  hintText: 'Search Restaurant...',
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(30.0)),
                  ),
                ),
              ),
            ),
          ),
        ),
        body: BlocBuilder<SearchRestaurantBloc, SearchRestaurantState>(
            builder: (context, state) {
          if (state is SearchRestaurantLoaded) {
            final List<Restaurant> restaurants = state.searchRestaurant;

            return state.founded == 0
                ? const Center(
                    child: CustomInfo(
                        message: "No restaurant found!", typeInfo: "empty"),
                  )
                : SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                            margin: const EdgeInsets.symmetric(
                                vertical: 5.0, horizontal: 20.0),
                            child: Text("Found: ${state.founded} result.")),
                        ListRestaurant(
                            restaurants: restaurants, isSkeleton: false),
                      ],
                    ),
                  );
          }

          if (state is SearchRestaurantFailure) {
            return Center(
                child: CustomInfo(message: state.message, typeInfo: "error"));
          }

          if (state is SearchRestaurantLoading) {
            final List<Restaurant> fakeRestaurants = List.filled(
                8,
                Restaurant(
                    id: BoneMock.name,
                    name: BoneMock.name,
                    description: BoneMock.paragraph,
                    pictureId: BoneMock.time,
                    city: BoneMock.city,
                    rating: 5));
            return ListRestaurant(
                restaurants: fakeRestaurants, isSkeleton: true);
          }

          return const Center(
            child: CustomInfo(
                message: "Search Your Fav Restaurant", typeInfo: "search"),
          );
        }));
  }
}
