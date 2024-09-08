import 'package:flutter/material.dart';
import 'package:savor/data/model/restaurant.dart';
import 'package:savor/screens/detail_screen.dart';
import 'package:savor/screens/home_screen.dart';
import 'package:savor/screens/onboarding_screen.dart';
import 'package:savor/screens/splash_screen.dart';

var routes = {
  SplashScreen.routeName: (context) => const SplashScreen(),
  HomeScreen.routeName: (context) => const HomeScreen(),
  OnboardingScreen.routeName: (context) => const OnboardingScreen(),
  DetailScreen.routeName: (context) => DetailScreen(restaurant: ModalRoute.of(context)?.settings.arguments as Restaurant ),
};
