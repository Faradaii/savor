import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:savor/screens/home_screen.dart';
import 'package:savor/screens/onboarding_screen.dart';
import 'package:savor/state/preferences/preferences_bloc.dart';

class SplashScreen extends StatefulWidget {
  static const String routeName = '/splash';
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<PreferencesBloc>(context)
        .add(GetFirstTimePreferencesEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PreferencesBloc, PreferencesState>(
      listener: (context, state) {
        if (state is FirstTimePreferences) {
          if (state.isFirstTime) {
            print(state.isFirstTime);
            Future.delayed(const Duration(seconds: 3), () {
              Navigator.pushReplacementNamed(
                  context, OnboardingScreen.routeName);
              return;
            });
          } else {
            Future.delayed(const Duration(seconds: 3), () {
              Navigator.pushReplacementNamed(context, HomeScreen.routeName);
              return;
            });
          }
        }
      },
      builder: (context, state) {
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
      },
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
