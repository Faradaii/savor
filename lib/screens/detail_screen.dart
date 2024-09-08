import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:savor/data/model/restaurant.dart';
import 'package:savor/state/detail_restaurant/detail_restaurant_bloc.dart';
import 'package:savor/widgets/custom_info.dart';
import 'package:skeletonizer/skeletonizer.dart';

class DetailScreen extends StatefulWidget {
  static const routeName = '/detail';
  final String idRestaurant;

  const DetailScreen({super.key, required this.idRestaurant});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  late RestaurantDetail restaurant;
  bool isFav = false;
  bool isExpandedDesc = false;
  final TextEditingController _nameReviewerController = TextEditingController();
  final TextEditingController _textReviewController = TextEditingController();

  @override
  void initState() {
    super.initState();
    BlocProvider.of<DetailRestaurantBloc>(context)
        .add(FetchDetailRestaurant(idRestaurant: widget.idRestaurant));
  }

  void _sendReview(RestaurantDetail restaurant) {
    if (_nameReviewerController.text.isNotEmpty &&
        _textReviewController.text.isNotEmpty) {
      AddReviewRestaurant review = AddReviewRestaurant(
          name: _nameReviewerController.text,
          review: _textReviewController.text,
          id: restaurant.id);

      _nameReviewerController.clear();
      _textReviewController.clear();

      BlocProvider.of<DetailRestaurantBloc>(context)
          .add(AddReview(review: review));
    }
  }

  RestaurantDetail fakeRestaurant = RestaurantDetail(
      id: BoneMock.name,
      name: BoneMock.name,
      description: BoneMock.paragraph,
      city: BoneMock.city,
      address: BoneMock.address,
      pictureId: BoneMock.phone,
      categories: [
        Category(name: BoneMock.name),
        Category(name: BoneMock.name),
      ],
      menus: Menus(
        foods: [
          Category(name: BoneMock.name),
          Category(name: BoneMock.name),
        ],
        drinks: [
          Category(name: BoneMock.name),
          Category(name: BoneMock.name),
        ],
      ),
      rating: 5,
      customerReviews: [
        CustomerReview(
            name: BoneMock.name,
            review: BoneMock.paragraph,
            date: BoneMock.date)
      ]);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: BlocConsumer<DetailRestaurantBloc, DetailRestaurantState>(
            listener: (context, state) {
              if (state is AddReviewSuccess) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Review has been added"),
                  ),
                );
              }
              if (state is AddReviewFailure) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.message),
                  ),
                );
              }
            },
            builder: (context, state) {
              switch (state) {
                case DetailRestaurantLoading():
                  return _buildDetailContent(context, fakeRestaurant,
                      isSkeleton: true);
                case DetailRestaurantLoaded():
                  return _buildDetailContent(context, state.restaurant,
                      isSkeleton: false);
                case DetailRestaurantFailure():
                  return CustomInfo(message: state.message, typeInfo: "error");
                default:
                  return _buildDetailContent(context, fakeRestaurant,
                      isSkeleton: true);
              }
            },
          ),
        ),
      ),
    );
  }

  Widget _buildDetailContent(BuildContext context, RestaurantDetail restaurant,
      {required bool isSkeleton}) {
    return Column(
      children: [
        _buildImageDetail(restaurant, isSkeleton: isSkeleton),
        Container(
          margin: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context, restaurant, isSkeleton: isSkeleton),
              const SizedBox(height: 10),
              _buildLocationRow(context, restaurant, isSkeleton: isSkeleton),
              const SizedBox(height: 10),
              _buildRatingRow(context, restaurant, isSkeleton: isSkeleton),
              const SizedBox(height: 20),
              _buildCategoryContainer(context,
                  categories: restaurant.categories, isSkeleton: isSkeleton),
              const SizedBox(height: 10),
              _buildDescriptionSection(context, restaurant,
                  isSkeleton: isSkeleton),
              const SizedBox(height: 10),
              _buildItemsList(
                context,
                title: "Foods",
                items: restaurant.menus.foods,
                icon: Icons.fastfood_rounded,
                isSkeleton: isSkeleton,
              ),
              _buildItemsList(
                context,
                title: "Drinks",
                items: restaurant.menus.drinks,
                icon: Icons.local_drink_sharp,
                isSkeleton: isSkeleton,
              ),
              const SizedBox(height: 10),
              _buildReviewsSection(context,
                  reviews: restaurant.customerReviews, isSkeleton: isSkeleton),
              const SizedBox(height: 10),
              _buildReviewForm(
                context,
                nameControl: _nameReviewerController,
                reviewControl: _textReviewController,
                onSendReview: () => _sendReview(restaurant),
                isSkeleton: isSkeleton,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildImageDetail(RestaurantDetail restaurant,
      {required bool isSkeleton}) {
    return Skeletonizer(
      enabled: isSkeleton,
      child: Stack(
        children: [
          AspectRatio(
            aspectRatio: 1 / 1,
            child: Skeleton.replace(
              replacement: Skeleton.shade(
                  child: Icon(
                Icons.image,
                size: Theme.of(context).textTheme.headlineLarge!.fontSize,
              )),
              child: Image.network(
                "${dotenv.env['IMAGE_API_URL']}${restaurant.pictureId}",
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all(Colors.white),
                  ),
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.arrow_back),
                ),
                IconButton(
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all(Colors.white),
                  ),
                  onPressed: () {},
                  icon: const Icon(Icons.share),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, RestaurantDetail restaurant,
      {required bool isSkeleton}) {
    return Skeletonizer(
      enabled: isSkeleton,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              restaurant.name,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
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
    );
  }

  Widget _buildLocationRow(BuildContext context, RestaurantDetail restaurant,
      {required bool isSkeleton}) {
    return Skeletonizer(
      enabled: isSkeleton,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.location_on,
            color: Theme.of(context).colorScheme.secondary,
            size: Theme.of(context).textTheme.titleLarge?.fontSize,
          ),
          const SizedBox(width: 10),
          Flexible(
            child: Text(
              "${restaurant.address}, ${restaurant.city}, Indonesia",
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRatingRow(BuildContext context, RestaurantDetail restaurant,
      {required bool isSkeleton}) {
    return Skeletonizer(
      enabled: isSkeleton,
      child: Row(
        children: [
          ...List.generate(
            restaurant.rating.floor(),
            (index) => Icon(
              Icons.star,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          Text(
            restaurant.rating.toString(),
            style: Theme.of(context).textTheme.titleSmall,
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryContainer(BuildContext context,
      {required List categories, required bool isSkeleton}) {
    return Skeletonizer(
      enabled: isSkeleton,
      child: SizedBox(
        height: MediaQuery.of(context).size.width * 0.1,
        child: ListView.separated(
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemCount: categories.length,
          separatorBuilder: (context, index) => const SizedBox(width: 5),
          itemBuilder: (context, index) {
            final Category category = categories[index];
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                border:
                    Border.all(color: Theme.of(context).colorScheme.primary),
              ),
              child: Center(
                child: Text(category.name,
                    style: Theme.of(context).textTheme.titleSmall),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildDescriptionSection(
      BuildContext context, RestaurantDetail restaurant,
      {required bool isSkeleton}) {
    return Skeletonizer(
      enabled: isSkeleton,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Description", style: Theme.of(context).textTheme.titleLarge),
          Text(
            restaurant.description,
            textAlign: TextAlign.justify,
            maxLines: isExpandedDesc ? null : 2,
          ),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
                onPressed: () =>
                    setState(() => isExpandedDesc = !isExpandedDesc),
                child: Text(isExpandedDesc ? "Show Less" : "Show More")),
          ),
        ],
      ),
    );
  }

  Widget _buildItemsList(BuildContext context,
      {required String title,
      required List<Category> items,
      required IconData icon,
      required bool isSkeleton}) {
    return Skeletonizer(
        enabled: isSkeleton,
        child: Column(
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
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.5,
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Flexible(
                          child: Icon(
                            icon,
                            size: 32,
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Flexible(
                          child: Text(
                            items[index].name,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ));
  }

  Widget _buildReviewsSection(BuildContext context,
      {required List<CustomerReview> reviews, required bool isSkeleton}) {
    return Skeletonizer(
        enabled: isSkeleton,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Reviews", style: Theme.of(context).textTheme.titleLarge),
            ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: reviews.length,
                itemBuilder: (context, index) => Container(
                      margin: const EdgeInsets.symmetric(
                          vertical: 5.0, horizontal: 5.0),
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: Theme.of(context).colorScheme.primary),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: ListTile(
                        isThreeLine: true,
                        splashColor: Theme.of(context).colorScheme.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        leading: Skeleton.replace(
                          replacement: Skeleton.shade(
                              child: Icon(
                            Icons.image,
                            size: Theme.of(context)
                                .textTheme
                                .headlineLarge!
                                .fontSize,
                          )),
                          child: SvgPicture.asset(
                            "assets/images/avatar_1.svg",
                            width: 50,
                          ),
                        ),
                        title: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(reviews[index].name,
                              style: Theme.of(context).textTheme.titleMedium),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(reviews[index].date,
                                style: Theme.of(context).textTheme.bodySmall!),
                            Text(reviews[index].review,
                                style: Theme.of(context).textTheme.bodyMedium!),
                          ],
                        ),
                      ),
                    )),
          ],
        ));
  }

  Widget _buildReviewForm(BuildContext context,
      {required TextEditingController nameControl,
      required TextEditingController reviewControl,
      required VoidCallback onSendReview,
      required bool isSkeleton}) {
    return Skeletonizer(
        enabled: isSkeleton,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Add Your Review",
                style: Theme.of(context).textTheme.titleLarge),
            ListTile(
              splashColor: Theme.of(context).colorScheme.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              leading: Skeleton.replace(
                replacement: Skeleton.shade(
                    child: Icon(
                  Icons.image,
                  size: Theme.of(context).textTheme.headlineLarge!.fontSize,
                )),
                child: SvgPicture.asset(
                  "assets/images/avatar_1.svg",
                  width: 50,
                ),
              ),
              titleAlignment: ListTileTitleAlignment.top,
              title: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.only(bottom: 10.0),
                    height: 40,
                    child: TextField(
                      controller: nameControl,
                      onEditingComplete: () =>
                          FocusScope.of(context).nextFocus(),
                      decoration: const InputDecoration(
                        hintText: 'Write your name...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        ),
                      ),
                    ),
                  ),
                  TextField(
                    controller: reviewControl,
                    textInputAction: TextInputAction.send,
                    onEditingComplete: onSendReview,
                    maxLines: 3,
                    decoration: const InputDecoration(
                      hintText: 'Write a review...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        onSendReview();
                      },
                      child: Text(
                        "Submit",
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ));
  }
}
