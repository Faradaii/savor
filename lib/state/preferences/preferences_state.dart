part of 'preferences_bloc.dart';

sealed class PreferencesState {}

class PreferencesInitial extends PreferencesState {}

class SchedulePreferences extends PreferencesState {
  final bool isDailyRecommendationActive;

  SchedulePreferences(this.isDailyRecommendationActive);
}

class DisabledFirstTime extends PreferencesState {
}

class FirstTimePreferences extends PreferencesState {
  final bool isFirstTime;
  FirstTimePreferences(this.isFirstTime);
}
