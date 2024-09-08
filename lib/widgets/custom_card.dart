import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:savor/data/model/restaurant.dart';
import 'package:savor/screens/detail_screen.dart';
import 'package:skeletonizer/skeletonizer.dart';

class CustomCard extends StatelessWidget {
  final int index;
  const CustomCard({
    super.key,
    required this.bestRestaurants,
    required this.index,
  });

  final List<Restaurant> bestRestaurants;

  @override
  Widget build(BuildContext context) {
    return Card.filled(
      color: Colors.white,
      borderOnForeground: true,
      shadowColor: Colors.transparent,
      margin: const EdgeInsets.all(10),
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(context, DetailScreen.routeName,
              arguments: bestRestaurants[index].id);
        },
        borderRadius: BorderRadius.circular(20.0),
        splashColor: Theme.of(context).colorScheme.primary,
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: Theme.of(context).colorScheme.secondary,
            ),
            borderRadius: BorderRadius.circular(20.0),
          ),
          width: MediaQuery.of(context).size.width * 0.6,
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: SizedBox.expand(
                    child: Skeleton.replace(
                      replacement: Skeleton.shade(
                        child: Icon(
                          Icons.image,
                          size: Theme.of(context)
                              .textTheme
                              .headlineLarge!
                              .fontSize,
                        ),
                      ),
                      child: Image.network(
                        "${dotenv.env['IMAGE_API_URL']}${bestRestaurants[index].pictureId}",
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),
              Column(children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(bestRestaurants[index].name,
                      style: Theme.of(context).textTheme.titleMedium),
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
                    Skeleton.shade(
                      child: Icon(
                        Icons.location_on,
                        color: Theme.of(context).colorScheme.secondary,
                        size: Theme.of(context).textTheme.titleSmall!.fontSize,
                      ),
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
                        (index) => Skeleton.shade(
                              child: Icon(
                                Icons.star,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            )),
                    Text(bestRestaurants[index].rating.toString(),
                        style: Theme.of(context).textTheme.titleSmall),
                  ],
                )
              ]),
            ],
          ),
        ),
      ),
    );
  }
}
