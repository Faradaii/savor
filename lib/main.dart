import 'dart:io';

import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:savor/common/navigation.dart';
import 'package:savor/common/styles.dart';
import 'package:savor/config/routes.dart';
import 'package:savor/data/api/api_service.dart';
import 'package:savor/data/db/database_helper.dart';
import 'package:savor/observer.dart';
import 'package:savor/state/database/database_bloc.dart';
import 'package:savor/state/detail_restaurant/detail_restaurant_bloc.dart';
import 'package:savor/state/preferences/preferences_bloc.dart';
import 'package:savor/state/restaurants/restaurant_bloc.dart';
import 'package:savor/state/search_restaurant/search_restaurant_bloc.dart';
import 'package:savor/utils/background_service.dart';
import 'package:savor/utils/notification_helper.dart';
import 'package:savor/utils/preferences_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");

  final ApiService apiService = ApiService();
  final DatabaseHelper databaseHelper = DatabaseHelper();
  final PreferencesHelper preferencesHelper =
      PreferencesHelper(sharedPreferences: SharedPreferences.getInstance());
  final NotificationHelper _notificationHelper = NotificationHelper();
  final BackgroundService _service = BackgroundService();

  _service.initializeIsolate();
  await _notificationHelper.initNotifications(flutterLocalNotificationsPlugin);
  if (Platform.isAndroid) {
    await AndroidAlarmManager.initialize();
  }

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
      BlocProvider(
        create: (context) => DatabaseBloc(databaseHelper: databaseHelper),
      ),
      BlocProvider(
        create: (context) =>
            PreferencesBloc(preferencesHelper: preferencesHelper),
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
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
    );
  }
}
