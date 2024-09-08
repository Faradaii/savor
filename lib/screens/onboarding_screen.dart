import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:savor/data/onboarding.dart';
import 'package:savor/screens/home_screen.dart';

class OnboardingScreen extends StatefulWidget {
  static const String routeName = '/onboarding';
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  late PageController _controller;
  int currentIndex = 0;

  @override
  void initState() {
    _controller = PageController(initialPage: 0);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Expanded(
                child: PageView.builder(
                  controller: _controller,
                  itemCount: 3,
                  onPageChanged: (value) =>
                      setState(() => currentIndex = value),
                  itemBuilder: (context, index) =>
                      OnboardingSection(index: index),
                ),
              ),
              const SizedBox(height: 20),
              _buildIndicator(context),
              const SizedBox(height: 20),
              _buildActionButton(context),
              _buildSkipButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIndicator(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 10,
      child: Center(
        child: ListView.builder(
          itemCount: 3,
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemBuilder: (_, index) => Container(
            margin: const EdgeInsets.symmetric(horizontal: 5),
            width: currentIndex == index ? 20 : 10,
            height: 5,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: TextButton(
        onPressed: () {
          if (currentIndex < 2) {
            _controller.nextPage(
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInOut,
            );
          }
        },
        style: currentIndex == 2
            ? TextButton.styleFrom(
                overlayColor: Colors.transparent,
              )
            : TextButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
              ),
        child: Text(
          currentIndex == 2 ? '' : 'Next',
          style: Theme.of(context).textTheme.labelLarge,
        ),
      ),
    );
  }

  Widget _buildSkipButton() {
    return SizedBox(
      width: double.infinity,
      child: TextButton(
        onPressed: () {
          if (currentIndex == 2) {
            Navigator.pushReplacementNamed(context, HomeScreen.routeName);
            return;
          }
          _controller.animateToPage(
            2,
            duration: const Duration(milliseconds: 100),
            curve: Curves.easeInOut,
          );
        },
        style: currentIndex == 2
            ? TextButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
              )
            : null,
        child: Text(currentIndex == 2 ? 'Start Exploring!' : 'Skip',
            style: currentIndex == 2
                ? Theme.of(context).textTheme.labelLarge
                : null),
      ),
    );
  }
}

class OnboardingSection extends StatelessWidget {
  final int index;
  const OnboardingSection({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  onboardingData[index]['title']!,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 40),
                Flexible(
                  child: SvgPicture.asset(
                    onboardingData[index]['image']!,
                  ),
                ),
                const SizedBox(height: 40),
                Text(
                  onboardingData[index]['desc']!,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
