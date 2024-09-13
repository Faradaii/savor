import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:savor/data/model/restaurant.dart';
import 'package:savor/screens/bookmark_screen.dart';
import 'package:savor/screens/search_screen.dart';
import 'package:savor/screens/settings_screen.dart';
import 'package:savor/state/restaurants/restaurant_bloc.dart';
import 'package:savor/widgets/custom_card.dart';
import 'package:savor/widgets/custom_info.dart';
import 'package:savor/widgets/custom_list.dart';
import 'package:skeletonizer/skeletonizer.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = "/home";
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<RestaurantsBloc>(context).add(FetchRestaurants());
  }

  void _refreshPage() {
    BlocProvider.of<RestaurantsBloc>(context).add(FetchRestaurants());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: [
            Builder(builder: (context) {
              return IconButton(
                  onPressed: () {
                    Scaffold.of(context).openEndDrawer();
                  },
                  icon: const Icon(Icons.menu));
            })
          ],
          leading: Container(
              margin: const EdgeInsets.fromLTRB(10, 0, 0, 0),
              child: SvgPicture.asset("assets/images/avatar_1.svg", width: 40)),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Halo!",
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const Text("User")
            ],
          ),
        ),
        endDrawer: Drawer(
          backgroundColor: Theme.of(context).colorScheme.onSecondary,
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondary,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                        child: SvgPicture.asset("assets/images/avatar_1.svg",
                            width: 80)),
                    Expanded(
                      flex: 0,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 5,
                          ),
                          Text(
                            'User',
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge!
                                .copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSecondary),
                          ),
                          Text('Food Explorer',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall!
                                  .copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSecondary)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              ListTile(
                title: Row(
                  children: [
                    Container(
                        margin: const EdgeInsets.all(5),
                        child: const Icon(Icons.bookmark)),
                    Text('Bookmarked',
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium!
                            .copyWith(
                                color:
                                    Theme.of(context).colorScheme.onPrimary)),
                  ],
                ),
                onTap: () {
                  Navigator.of(context).pushNamed(BookmarkedScreen.routeName);
                },
              ),
              ListTile(
                title: Row(
                  children: [
                    Container(
                        margin: const EdgeInsets.all(5),
                        child: const Icon(Icons.settings)),
                    Text('Settings',
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium!
                            .copyWith(
                                color:
                                    Theme.of(context).colorScheme.onPrimary)),
                  ],
                ),
                onTap: () {
                  Navigator.of(context).pushNamed(SettingsScreen.routeName);
                },
              ),
            ],
          ),
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            _refreshPage();
            return Future<void>.delayed(const Duration(seconds: 2));
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              children: [
                Container(
                    margin: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Discover Outstanding \nRestaurant !",
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium!
                            .copyWith(
                                color: Theme.of(context).colorScheme.secondary),
                      ),
                    )),
                Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, SearchScreen.routeName);
                    },
                    child: const AbsorbPointer(
                      child: Hero(
                        tag: "search",
                        child: Material(
                          child: TextField(
                            readOnly: true,
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.search),
                              hintText: 'Search Restaurant...',
                              border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(30.0)),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                    margin: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Recomended Restaurant",
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    )),
                BlocBuilder<RestaurantsBloc, RestaurantsState>(
                  builder: (context, state) {
                    if (state is RestaurantsLoaded) {
                      final List<Restaurant> restaurants = state.restaurants;
                      final List<Restaurant> bestRestaurants =
                          restaurants.where((r) => r.rating > 4.0).toList();
                      bestRestaurants
                          .sort((a, b) => b.rating.compareTo(a.rating));
                      return CardRestaurant(
                          bestRestaurants: bestRestaurants, isSkeleton: false);
                    }

                    if (state is RestaurantsFailure) {
                      return CustomInfo(
                          message: state.message, typeInfo: "error");
                    }

                    final List<Restaurant> fakeRestaurants = List.filled(
                        4,
                        Restaurant(
                            id: BoneMock.name,
                            name: BoneMock.name,
                            description: BoneMock.paragraph,
                            pictureId: BoneMock.time,
                            city: BoneMock.city,
                            rating: 5));

                    return CardRestaurant(
                        bestRestaurants: fakeRestaurants, isSkeleton: true);
                  },
                ),
                Container(
                    margin: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Explore More!",
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    )),
                BlocBuilder<RestaurantsBloc, RestaurantsState>(
                  builder: (context, state) {
                    if (state is RestaurantsLoaded) {
                      final List<Restaurant> restaurants = state.restaurants;
                      return ListRestaurant(
                          restaurants: restaurants, isSkeleton: false);
                    }

                    if (state is RestaurantsFailure) {
                      return CustomInfo(
                        message: state.message,
                        typeInfo: "error",
                      );
                    }

                    final List<Restaurant> fakeRestaurants = List.filled(
                        4,
                        Restaurant(
                            id: BoneMock.name,
                            name: BoneMock.name,
                            description: BoneMock.paragraph,
                            pictureId: BoneMock.time,
                            city: BoneMock.city,
                            rating: 5));
                    return ListRestaurant(
                        restaurants: fakeRestaurants, isSkeleton: true);
                  },
                ),
              ],
            ),
          ),
        ));
  }
}

class CardRestaurant extends StatelessWidget {
  final bool isSkeleton;
  const CardRestaurant({
    super.key,
    required this.bestRestaurants,
    required this.isSkeleton,
  });

  final List<Restaurant> bestRestaurants;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AspectRatio(
          aspectRatio: 3 / 2,
          child: Skeletonizer(
            enabled: isSkeleton,
            child: ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: bestRestaurants.length,
                itemBuilder: (context, index) =>
                    CustomCard(items: bestRestaurants, index: index)),
          ),
        ),
      ],
    );
  }
}

class ListRestaurant extends StatelessWidget {
  final bool isSkeleton;
  const ListRestaurant(
      {super.key, required this.restaurants, required this.isSkeleton});

  final List<Restaurant> restaurants;

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: isSkeleton,
      child: ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: restaurants.length,
          itemBuilder: (context, index) =>
              CustomList(restaurants: restaurants, index: index)),
    );
  }
}

List<Restaurant> parseRestaurants(String? json) {
  if (json == null) {
    return [];
  }

  final parsed = jsonDecode(json);
  final List restaurantList = parsed['restaurants'];
  return restaurantList.map((json) => Restaurant.fromJson(json)).toList();
}
