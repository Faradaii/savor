import 'package:flutter/material.dart';
import 'package:savor/screens/bookmark_screen.dart';
import 'package:savor/screens/detail_screen.dart';
import 'package:savor/screens/home_screen.dart';
import 'package:savor/screens/onboarding_screen.dart';
import 'package:savor/screens/search_screen.dart';
import 'package:savor/screens/settings_screen.dart';
import 'package:savor/screens/splash_screen.dart';

var routes = {
  SplashScreen.routeName: (context) => const SplashScreen(),
  HomeScreen.routeName: (context) => const HomeScreen(),
  OnboardingScreen.routeName: (context) => const OnboardingScreen(),
  DetailScreen.routeName: (context) => DetailScreen(
      idRestaurant: ModalRoute.of(context)?.settings.arguments as String),
  SearchScreen.routeName: (context) => const SearchScreen(),
  SettingsScreen.routeName: (context) => const SettingsScreen(),
  BookmarkedScreen.routeName: (context) => const BookmarkedScreen(),
};

var initialRoute = SplashScreen.routeName;
