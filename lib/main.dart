import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:savor/common/styles.dart';
import 'package:savor/config/routes.dart';
import 'package:savor/data/api/api_service.dart';
import 'package:savor/observer.dart';
import 'package:savor/state/detail_restaurant/detail_restaurant_bloc.dart';
import 'package:savor/state/restaurants/restaurant_bloc.dart';
import 'package:savor/state/search_restaurant/search_restaurant_bloc.dart';

Future main() async {
  await dotenv.load(fileName: ".env");

  final ApiService apiService = ApiService();

  Bloc.observer = MyObserver();

  runApp(MultiBlocProvider(
    providers: [
      BlocProvider(
        create: (context) => RestaurantsBloc(apiService: apiService),
      ),
      BlocProvider(
        create: (context) => DetailRestaurantBloc(apiService: apiService),
      ),
      BlocProvider(
        create: (context) => SearchRestaurantBloc(apiService: apiService),
      ),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Savor',
      theme: ThemeData(
        textTheme: textTheme,
        colorScheme: lightColorScheme,
        useMaterial3: true,
      ),
      initialRoute: initialRoute,
      routes: routes,
      debugShowCheckedModeBanner: false,
    );
  }
}
