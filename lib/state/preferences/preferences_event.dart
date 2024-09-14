part of 'preferences_bloc.dart';

sealed class PreferencesEvent {}

class ToggleDailyRecomendationEvent extends PreferencesEvent {}

class GetDailyRecommendationPreferencesEvent extends PreferencesEvent {}

class DisableFirstTimeEvent extends PreferencesEvent {}

class GetFirstTimePreferencesEvent extends PreferencesEvent {}