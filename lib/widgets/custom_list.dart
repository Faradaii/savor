
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:savor/data/model/restaurant.dart';
import 'package:savor/screens/detail_screen.dart';
import 'package:skeletonizer/skeletonizer.dart';

class CustomList extends StatelessWidget {
  final int index;
  const CustomList({
    super.key,
    required this.restaurants,
    required this.index,
  });

  final List<Restaurant> restaurants;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 20.0),
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).colorScheme.primary),
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: ListTile(
        isThreeLine: true,
        splashColor: Theme.of(context).colorScheme.primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        onTap: () {
          Navigator.pushNamed(context, DetailScreen.routeName,
              arguments: restaurants[index].id);
        },
        titleAlignment: ListTileTitleAlignment.top,
        leading: SizedBox(
          width: 100,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10.0),
            child: Skeleton.replace(
              replacement: Center(
                child: Skeleton.shade(
                    child: Icon(
                  Icons.image,
                  size: Theme.of(context).textTheme.headlineLarge!.fontSize,
                )),
              ),
              child: Image.network(
                "${dotenv.env['IMAGE_API_URL']}${restaurants[index].pictureId}",
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        title: Align(
          alignment: Alignment.centerLeft,
          child: Text(restaurants[index].name,
              style: Theme.of(context).textTheme.titleMedium),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Skeleton.shade(
              child: Icon(Icons.star,
                  size: Theme.of(context).textTheme.titleMedium!.fontSize,
                  color: Theme.of(context).colorScheme.primary),
            ),
            Text(restaurants[index].rating.toString(),
                style: Theme.of(context).textTheme.titleSmall),
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
                Skeleton.shade(
                  child: Icon(
                    Icons.location_on,
                    color: Theme.of(context).colorScheme.secondary,
                    size: Theme.of(context).textTheme.titleSmall!.fontSize,
                  ),
                ),
                Flexible(
                  child: Text(restaurants[index].city,
                      maxLines: 1,
                      overflow: TextOverflow.clip,
                      style: Theme.of(context).textTheme.titleSmall),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
