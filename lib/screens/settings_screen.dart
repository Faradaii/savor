import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:savor/state/preferences/preferences_bloc.dart';

class SettingsScreen extends StatefulWidget {
  static const routeName = '/settings';
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<PreferencesBloc>(context)
        .add(GetDailyRecommendationPreferencesEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
      ),
      body: Column(
        children: [
          ListTile(
              title: const Text('Daily Recomendation'),
              subtitle:
                  const Text('Daily recommendations are sent every 11:00 AM.'),
              trailing: BlocBuilder<PreferencesBloc, PreferencesState>(
                builder: (context, state) {
                  if (state is SchedulePreferences) {
                    return Switch.adaptive(
                      value: state.isDailyRecommendationActive,
                      onChanged: (value) async {
                        if (Platform.isIOS) {
                          Container();
                        } else {
                          context
                              .read<PreferencesBloc>()
                              .add(ToggleDailyRecomendationEvent());
                        }
                      },
                    );
                  }
                  return const SizedBox.shrink();
                },
              )),
        ],
      ),
    );
  }
}
