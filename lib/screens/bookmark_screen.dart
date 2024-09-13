import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:savor/data/model/restaurant.dart';
import 'package:savor/state/database/database_bloc.dart';
import 'package:savor/widgets/custom_card.dart';
import 'package:savor/widgets/custom_info.dart';

class BookmarkedScreen extends StatefulWidget {
  static const routeName = '/bookmarked';
  const BookmarkedScreen({super.key});

  @override
  State<BookmarkedScreen> createState() => _BookmarkedScreenState();
}

class _BookmarkedScreenState extends State<BookmarkedScreen> {
  @override
  void initState() {
    super.initState();
    context.read<DatabaseBloc>().add(LoadBookmarks());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Bookmarks"),
      ),
      body: BlocBuilder<DatabaseBloc, DatabaseState>(
        builder: (context, state) {
          if (state is DatabaseLoading) {
            return const CircularProgressIndicator();
          } else if (state is DatabaseLoaded) {
            if (state.bookmarks.isEmpty) {
              return const Center(
                  child:
                      CustomInfo(message: "No Bookmarks", typeInfo: "empty"));
            }
            final List<Restaurant> bookmarks = state.bookmarks;
            return GridView.builder(
                itemCount: state.bookmarks.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    childAspectRatio: 0.8, crossAxisCount: 2),
                itemBuilder: (context, index) {
                  return CustomCard(items: bookmarks, index: index);
                });
          } else if (state is DatabaseError) {
            return Text(state.message);
          } else {
            return const Center(
                child:
                    CustomInfo(message: "No Bookmarks", typeInfo: "empty"));
          }
        },
      ),
    );
  }
}
