import 'package:bloc/bloc.dart';
import 'package:savor/utils/preferences_helper.dart';
import 'package:savor/utils/background_service.dart';
import 'package:savor/utils/date_selected_helper.dart';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';

part 'preferences_event.dart';
part 'preferences_state.dart';

class PreferencesBloc extends Bloc<PreferencesEvent, PreferencesState> {
  final PreferencesHelper preferencesHelper;

  PreferencesBloc({required this.preferencesHelper})
      : super(PreferencesInitial()) {
    on<ToggleDailyRecomendationEvent>((event, emit) async {
      if (!(state as SchedulePreferences).isDailyRecommendationActive) {
        preferencesHelper.setDailyRecomendation(true);
        await AndroidAlarmManager.periodic(
          const Duration(hours: 24),
          1,
          BackgroundService.callback,
          startAt: DateHelper.format(),
          exact: true,
          wakeup: true,
        );
      } else {
        preferencesHelper.setDailyRecomendation(false);
        await AndroidAlarmManager.cancel(1);
      }
      emit(SchedulePreferences(
          !((state as SchedulePreferences).isDailyRecommendationActive)));
    });

    on<GetDailyRecommendationPreferencesEvent>((event, emit) async {
      bool isActive = await preferencesHelper.isDailyRecomendationActive;
      emit(SchedulePreferences(isActive));
    });

    on<DisableFirstTimeEvent>((event, emit) async {
      preferencesHelper.setFirstTime(false);
      emit(DisabledFirstTime());
    });

    on<GetFirstTimePreferencesEvent>((event, emit) async {
      bool isFirstTime = await preferencesHelper.isFirstTime;

      print(isFirstTime);
      emit(FirstTimePreferences(isFirstTime));
    });
  }
}
