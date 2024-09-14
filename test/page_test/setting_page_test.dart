import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:savor/screens/settings_screen.dart';
import 'package:savor/state/preferences/preferences_bloc.dart';
import 'package:bloc_test/bloc_test.dart';

class MockPreferencesBloc extends MockBloc<PreferencesEvent, PreferencesState>
    implements PreferencesBloc {}

void main() {
  group('Settings Screen Widget Test', () {
    late MockPreferencesBloc mockPreferencesBloc;

    setUp(() {
      mockPreferencesBloc = MockPreferencesBloc();

      whenListen(
        mockPreferencesBloc,
        Stream.fromIterable([
          SchedulePreferences(false),
          SchedulePreferences(true),
        ]),
        initialState: SchedulePreferences(false),
      );
    });

    testWidgets('Test Enable Daily Reminder Switch at First Time',
        (tester) async {
      await tester.pumpWidget(
        BlocProvider<PreferencesBloc>(
          create: (_) => mockPreferencesBloc,
          child: const MaterialApp(
            home: SettingsScreen(),
          ),
        ),
      );

      expect(find.byType(Switch), findsOneWidget);

      await tester.tap(find.byType(Switch).first);
      await tester.pumpAndSettle();

      final switchEnabled = tester.widget<Switch>(find.byType(Switch).first);
      expect(switchEnabled.value, true);
    });

    tearDown(() {
      mockPreferencesBloc.close();
    });
  });
}
