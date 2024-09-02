import 'package:flutter/material.dart';
import 'package:savor/model/restaurant.dart';

class DetailScreen extends StatefulWidget {
  static const routeName = '/detail';
  final Restaurant restaurant;

  const DetailScreen({super.key, required this.restaurant});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  bool isFav = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                children: [
                  AspectRatio(
                    aspectRatio: 1 / 1,
                    child: Image.network(
                      widget.restaurant.pictureId,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(Colors.white),
                          ),
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(Icons.arrow_back),
                        ),
                        IconButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(Colors.white),
                          ),
                          onPressed: () {},
                          icon: const Icon(Icons.share),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Container(
                margin: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          widget.restaurant.name,
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              isFav = !isFav;
                            });
                          },
                          icon: Icon(
                            isFav ? Icons.favorite : Icons.favorite_border,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          color: Theme.of(context).colorScheme.secondary,
                          size: Theme.of(context).textTheme.titleLarge?.fontSize,
                        ),
                        Text(
                          "${widget.restaurant.city}, Indonesia",
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        ...List.generate(
                          widget.restaurant.rating.floor(),
                          (index) => Icon(
                            Icons.star,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        Text(
                          widget.restaurant.rating.toString(),
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildCategoryContainer(
                          context,
                          icon: Icons.food_bank,
                          count: widget.restaurant.menus.foods.length,
                        ),
                        const SizedBox(width: 20),
                        _buildCategoryContainer(
                          context,
                          icon: Icons.local_drink,
                          count: widget.restaurant.menus.drinks.length,
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    _buildDescriptionSection(context),
                    const SizedBox(height: 10),
                    _buildItemsList(
                      context,
                      title: "Foods",
                      items: widget.restaurant.menus.foods,
                      icon: Icons.fastfood_rounded,
                    ),
                    _buildItemsList(
                      context,
                      title: "Drinks",
                      items: widget.restaurant.menus.drinks,
                      icon: Icons.local_drink_sharp,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryContainer(BuildContext context, {required IconData icon, required int count}) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.3,
      height: MediaQuery.of(context).size.width * 0.3,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        border: Border.all(color: Theme.of(context).colorScheme.primary),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Theme.of(context).colorScheme.primary, size: 56),
          Text(count.toString(), style: Theme.of(context).textTheme.titleLarge),
        ],
      ),
    );
  }

  Widget _buildDescriptionSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Description", style: Theme.of(context).textTheme.titleLarge),
        Text(widget.restaurant.description, textAlign: TextAlign.justify),
      ],
    );
  }

  Widget _buildItemsList(BuildContext context, {required String title, required List<dynamic> items, required IconData icon}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: Theme.of(context).textTheme.titleLarge),
        SizedBox(
          height: MediaQuery.of(context).size.width * 0.3,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: items.length,
            itemBuilder: (context, index) => Card.outlined(
              margin: const EdgeInsets.all(10),
              child: InkWell(
                onTap: () {},
                child: Container(
                  padding: const EdgeInsets.all(10.0),
                  width: MediaQuery.of(context).size.width * 0.5,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(icon),
                      Text(
                        items[index].name,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
