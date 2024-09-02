import 'package:flutter/material.dart';
import 'package:savor/screens/onboarding_screen.dart';

class SplashScreen extends StatelessWidget {
  static const String routeName = '/splash';
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacementNamed(context, OnboardingScreen.routeName);
    });

    return const Scaffold(
      body: Stack(
        alignment: Alignment.bottomCenter,
        fit: StackFit.expand,
        children: [
          SplashMain(),
          SplashFooter(),
        ],
      ),
    );
  }
}

class SplashMain extends StatelessWidget {
  const SplashMain({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        SizedBox(
          height: 200,
          width: 200,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(100),
            child: Image.asset(
              "assets/logo15x.png",
              fit: BoxFit.cover,
            ),
          ),
        ),
        Text('Savor', style: Theme.of(context).textTheme.displaySmall),
      ],
    );
  }
}

class SplashFooter extends StatelessWidget {
  const SplashFooter({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Text('from', style: Theme.of(context).textTheme.labelLarge),
        Text('Faradaii',
            style: Theme.of(context)
                .textTheme
                .headlineSmall!
                .copyWith(color: Theme.of(context).colorScheme.primary)),
        const SizedBox(
          height: 30,
        )
      ],
    );
  }
}
