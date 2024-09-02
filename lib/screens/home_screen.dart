import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:savor/model/restaurant.dart';
import 'package:savor/screens/detail_screen.dart';

class HomeScreen extends StatelessWidget {
  static const routeName = "/home";
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(onPressed: () {}, icon: const Icon(Icons.notifications))
          ],
          leading: const Icon(Icons.person),
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
        body: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      child: Text(
                        "Discover Outstanding \nRestaurant !",
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium!
                            .copyWith(
                                color: Theme.of(context).colorScheme.secondary),
                      )),
                ],
              ),
              Container(
                margin:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: const TextField(
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.search),
                    hintText: 'Search Restaurant...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(30.0)),
                    ),
                  ),
                ),
              ),
              Row(
                children: [
                  Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      child: Text(
                        "Recomended Restaurant",
                        style: Theme.of(context).textTheme.titleLarge,
                      )),
                ],
              ),
              FutureBuilder<String>(
                  future: DefaultAssetBundle.of(context)
                      .loadString('assets/local_restaurant.json'),
                  builder: (context, snapshot) {
                    final List<Restaurant> restaurants =
                        parseRestaurants(snapshot.data);
                    final List<Restaurant> bestRestaurants =
                        restaurants.where((r) => r.rating > 4.0).toList();
                    bestRestaurants
                        .sort((a, b) => b.rating.compareTo(a.rating));
                    if (snapshot.hasData && !snapshot.hasError) {
                      return CardRestaurant(bestRestaurants: bestRestaurants);
                    }

                    return const Center(child: CircularProgressIndicator());
                  }),
              Row(
                children: [
                  Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      child: Text(
                        "Explore More!",
                        style: Theme.of(context).textTheme.titleLarge,
                      )),
                ],
              ),
              FutureBuilder<String>(
                  future: DefaultAssetBundle.of(context)
                      .loadString('assets/local_restaurant.json'),
                  builder: (context, snapshot) {
                    final List<Restaurant> restaurants =
                        parseRestaurants(snapshot.data);
                    if (snapshot.hasData && !snapshot.hasError) {
                      return ListRestaurant(restaurants: restaurants);
                    }

                    return const Center(child: CircularProgressIndicator());
                  }),
            ],
          ),
        ));
  }
}

class CardRestaurant extends StatelessWidget {
  const CardRestaurant({
    super.key,
    required this.bestRestaurants,
  });

  final List<Restaurant> bestRestaurants;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.width * 0.7,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: bestRestaurants.length,
          itemBuilder: (context, index) => Card.outlined(
                margin: const EdgeInsets.all(10),
                child: InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, DetailScreen.routeName,
                        arguments: bestRestaurants[index]);
                  },
                  child: Container(
                    padding: const EdgeInsets.all(10.0),
                    width: MediaQuery.of(context).size.width * 0.5,
                    child: Column(children: [
                      Expanded(
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(10.0),
                            child: Image.network(
                              bestRestaurants[index].pictureId,
                              fit: BoxFit.cover,
                            )),
                      ),
                      Row(
                        children: [
                          Text(bestRestaurants[index].name,
                              style: Theme.of(context).textTheme.titleMedium),
                        ],
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(bestRestaurants[index].description,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.bodySmall!),
                      const SizedBox(
                        height: 5,
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.location_on,
                            color: Theme.of(context).colorScheme.secondary,
                            size: Theme.of(context)
                                .textTheme
                                .titleSmall!
                                .fontSize,
                          ),
                          Text(bestRestaurants[index].city,
                              style: Theme.of(context).textTheme.titleSmall),
                        ],
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Row(
                        children: [
                          ...List.generate(
                              bestRestaurants[index].rating.floor(),
                              (index) => Icon(
                                    Icons.star,
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                  )),
                          Text(bestRestaurants[index].rating.toString(),
                              style: Theme.of(context).textTheme.titleSmall),
                        ],
                      )
                    ]),
                  ),
                ),
              )),
    );
  }
}

class ListRestaurant extends StatelessWidget {
  const ListRestaurant({
    super.key,
    required this.restaurants,
  });

  final List<Restaurant> restaurants;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: restaurants.length,
        itemBuilder: (context, index) => Container(
              margin:
                  const EdgeInsets.symmetric(vertical: 5.0, horizontal: 20.0),
              decoration: BoxDecoration(
                border:
                    Border.all(color: Theme.of(context).colorScheme.primary),
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: ListTile(
                onTap: () {
                  Navigator.pushNamed(context, DetailScreen.routeName,
                      arguments: restaurants[index]);
                },
                titleAlignment: ListTileTitleAlignment.top,
                leading: SizedBox(
                  width: 100,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                    child: Image.network(
                      restaurants[index].pictureId,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(restaurants[index].name,
                        style: Theme.of(context).textTheme.titleMedium),
                    Row(
                      children: [
                        Icon(Icons.star,
                            size: Theme.of(context)
                                .textTheme
                                .titleMedium!
                                .fontSize,
                            color: Theme.of(context).colorScheme.primary),
                        Text(restaurants[index].rating.toString(),
                            style: Theme.of(context).textTheme.titleSmall),
                      ],
                    )
                  ],
                ),
                subtitle: Column(
                  children: [
                    Text(restaurants[index].description,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodySmall!),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          color: Theme.of(context).colorScheme.secondary,
                          size:
                              Theme.of(context).textTheme.titleSmall!.fontSize,
                        ),
                        Text(restaurants[index].city,
                            style: Theme.of(context).textTheme.titleSmall),
                      ],
                    ),
                  ],
                ),
              ),
            ));
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
