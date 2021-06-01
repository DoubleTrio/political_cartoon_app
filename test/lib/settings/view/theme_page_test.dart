import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hawktoons/settings/settings.dart';
import 'package:hawktoons/theme/theme.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/helpers.dart';
import '../../keys.dart';
import '../../mocks.dart';

void main() {
  group('ThemePage', () {
    late PrimaryColorCubit primaryColorCubit;
    late SettingsScreenCubit settingsScreenCubit;
    late ThemeCubit themeCubit;

    setUpAll(() {
      registerFallbackValue<PrimaryColor>(PrimaryColor.red);
      registerFallbackValue<SettingsScreen>(SettingsScreen.main);
      registerFallbackValue<ThemeMode>(ThemeMode.light);
    });

    setUp(() {
      primaryColorCubit = MockPrimaryColorCubit();
      settingsScreenCubit = MockSettingsScreenCubit();
      themeCubit = MockThemeCubit();

      when(() => themeCubit.state).thenReturn(ThemeMode.light);
      when(() => primaryColorCubit.state).thenReturn(PrimaryColor.purple);
    });

    group('semantics', () {
      testWidgets('passes guidelines for light theme', (tester) async {
        await tester.pumpApp(
          const ThemeView(),
          primaryColorCubit: primaryColorCubit,
          themeCubit: themeCubit,
        );
        expect(tester, meetsGuideline(textContrastGuideline));
        expect(tester, meetsGuideline(androidTapTargetGuideline));
      });

      testWidgets('passes guidelines for dark theme', (tester) async {
        await tester.pumpApp(
          const ThemeView(),
          mode: ThemeMode.dark,
          primaryColorCubit: primaryColorCubit,
          themeCubit: themeCubit,
        );
        expect(tester, meetsGuideline(textContrastGuideline));
        expect(tester, meetsGuideline(androidTapTargetGuideline));
      });
    });

    testWidgets('can navigate back to main settings page', (tester) async {
      await tester.pumpApp(
        const ThemeView(),
        settingsScreenCubit: settingsScreenCubit,
        primaryColorCubit: primaryColorCubit,
        themeCubit: themeCubit,
      );
      await tester.tap(find.byIcon(Icons.arrow_back));
      verify(settingsScreenCubit.deselectScreen).called(1);
    });

    testWidgets('can change theme '
      'when change theme button is tapped', (tester) async {
      await tester.pumpApp(
        const ThemeView(),
        primaryColorCubit: primaryColorCubit,
        themeCubit: themeCubit,
      );
      await tester.tap(find.byKey(themePageChangeThemeButtonKey));
      verify(themeCubit.changeTheme).called(1);
    });

    testWidgets('can change color primary '
      'when PrimaryItemColor is tapped', (tester) async {
      const primaryColorItemKey = Key('PrimaryColorItem_Orange');
      await tester.pumpApp(
        const ThemeView(),
        primaryColorCubit: primaryColorCubit,
        themeCubit: themeCubit,
      );
      await tester.tap(find.byKey(primaryColorItemKey));
      verify(() => primaryColorCubit.setColor(PrimaryColor.orange)).called(1);
    });
  });
}